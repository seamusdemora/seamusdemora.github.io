## "client_loop: send disconnect: Broken pipe" 

### Stop MacOS From Dropping SSH (Network) Connections

Irritating, no? If your SSH connections are [*dropping like flies*](https://idioms.thefreedictionary.com/drop+like+flies), you can stop that. The following approach will maintain viable SSH connections (and other network connections and processes) for hours, days, weeks, etc... even when the lid on your MacBook is closed. Here's how to do it : 

But first, let me suggest what **not** to do: Don't bother with the myriad suggestions posted all over the Internet that counsel making changes to your Mac's Power Management settings with the `pmset` command-line utility, connecting external monitors & keyboards, etc. Don't get me wrong - `pmset` has some useful features, but Apple has provided sparse, [*piss-poor*](https://idioms.thefreedictionary.com/piss-poor) documentation on it (`man pmset`), and as of 1Q 2020 it was last updated in 2012! But get over it - it's just another way in which Apple [*respects*](https://idioms.thefreedictionary.com/screw+over) their customers. 

Here's what you **should** do to keep your SSH network connections viable: 

```zsh
% man caffeinate    # Read it! Don't worry - it's Apple docs, so it's skimpy.
% 
% caffeinate -i ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=10 userid@host
% 
% # Alternatively, edit your ~/ssh/config file to add these options (-o), and then:
% 
% caffeinate -i ssh userid@host 
```

Let's break this down: 

* `caffeinate -i` tells macOS that it should **not sleep** while the process which follows (an `ssh` connection in this case) is running. Sleep mode stops most network activity.

* the `ssh` options `ServerAliveInterval` & `ServerAliveCountMax` instruct your `ssh` client to send *"keep-alive"* messages to the server at 60 second intervals, and not to *"give up"* until 10 messages go un-answered. 

* Both are needed to ensure the SSH connection remains alive: `caffeinate` prevents macOS from squashing he connection when it goes to sleep, and the *"keep-alives"* maintain the SSH client-to-server connection when there is little or no activity. 

* NOTE: The SSH *"keep-alive"* messages may be configured in the **SSH server** (which you may or may not have control over), **or** they may be configured in the **SSH client** (which presumably you do have control over). As long as client or server (or both) are configured to send *"keep-alives"*, your connection should be reliable (assuming your OS doesn't shut down networking to save power). Further, you can apply these options to all of your client connections by placing them in your `~/.ssh/config` file as follows: 

  ```zsh
  Host *
      ServerAliveInterval 60
      ServerAliveCountMax 10
  
  # Note: There may be other items in ~/.ssh/config; they should probably remain
  ```

Using this method, your SSH connection will remain viable even after the lid is closed for hours, days, etc. It requires no 3rd party software. This recipe has been confirmed on the following MacBook Pros:

- 2019, 16-inch MacBook Pro, Catalina, 10.15.4
- 2016, 15-inch MacBook Pro, Mojave, 10.14.6
- Late 2011, 17-inch MacBook Pro, High Sierra, 10.13.6

It may work on other models also; I'd like some feedback if you try it. Of course you should have your MacBook connected to the charger for extended sessions. Running on battery power alone, at some point the system may override `caffeinate` and force it into sleep mode. It's impossible to say what will happen on the various makes and models as Apple has chosen to provide only bare minimal documentation of their Power Management features.  

Of course the Power Management (aka *Energy Saver*) GUI in *System Preferences* should not be neglected. Here's a screen shot showing how you may wish to set yours. I haven't tried all the possibilities in the GUI, so perhaps don't stray too far until after you've experimented a bit.

<img src="/pix/EnergySaverSettings.png" alt="EnergySaverSettings" style="zoom:50%;" />

 Once you've initiated your SSH connection with `caffeinate -i`, you can verify its status using the *Activity Monitor*. You should see something like the following: 



<img src="/Users/jmoore/Documents/GitHub/seamus.github.io/pix/ActivityMonitorOnCaffeinate.png" alt="ActivityMonitorOnCaffeinate" style="zoom:50%;" />

Two items to note: *Activity Monitor* is showing a filtered search on **caffeinate**, and the `caffeinate` process shown in the list is reported to be **Preventing Sleep** - exactly what we want! You can look under the other tabs to see more information about the selected process (e.g. the *Network* tab). Note also that this display has *optional columns* displayed: *Ports*, and *Preventing Sleep*. You can add these simply by 'right-clicking' in the label bar, and checking the labels you want to add or remove.

