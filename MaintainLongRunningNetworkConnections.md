## "client_loop: send disconnect: Broken pipe" 

### Stop MacOS From Dropping SSH (Network) Connections

Irritating, no? If your SSH connections are [*dropping like flies*](https://idioms.thefreedictionary.com/drop+like+flies), you can stop that - at least under some circumstances. The following approach will maintain viable SSH connections (and other network connections and processes) for hours, days, weeks, etc... even when the lid on your MacBook is closed. Here's how to do it : 

***Caveats***: This is a work-in-process. The process here is the best one I've found so far, but not without its *quirks*. There are many things going on in macOS that can affect the reliability of an SSH connection (or any network connection), and in the absence of good documentation from Apple these must be learned through trial-and-error. Using `caffeinate` as described below has definitely made a significant improvement - in my usage at least, but used alone, it may not completely solve *"the problem"*. 

Let me also suggest this: Don't bother with the myriad suggestions posted on the Internet that counsel making changes to your Mac's Power Management settings with the `pmset` command-line utility, connecting external monitors & keyboards, etc. Don't get me wrong - `pmset` has some useful features, but Apple has provided only [*sparse*](https://idioms.thefreedictionary.com/piss-poor) documentation on it (`man pmset`). And even that is sadly out-of-date: as of 1Q 2020 `man pmset` shows it was last updated in 2012! And after repeated failed attempts to find any Apple-sourced documentation on their websites, I've been forced to conclude Apple simply refuses to disclose how `pmset` works. Consequently - I feel that using `pmset` is unreliable at best, risky at worst. But get over it - it's just another way in which Apple [*respects*](https://idioms.thefreedictionary.com/screw+over) their customers. 

Here's what you **should** do to keep your SSH network connections viable: 

```zsh
% man caffeinate    # Read it! Don't worry - it's Apple docs, so it's skimpy.
% 
% caffeinate -i ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=10 userid@host
% 
% # Alternatively, edit your ~/.ssh/config file to add these options (-o), and then:
% 
% caffeinate -i ssh userid@host 
```

Let's break this down: 

* `caffeinate -i` tells macOS that it should **not sleep** while the process which follows (an `ssh` connection in this case) is running. Sleep mode stops most network activity, so it should be avoided to maintain our network connections. 

* the `ssh` options `ServerAliveInterval` & `ServerAliveCountMax` instruct your `ssh` client to send *"keep-alive"* messages to the server at 60 second intervals, and not to *"give up"* until 10 messages go un-answered. These values (60, 10) are not hard-and-fast settings, but merely guides - so feel free to  change them if you're motivated. 

* Both `caffeinate` and *"keep-alives"* are needed to maintain a viable SSH connection: `caffeinate` prevents macOS from squashing he connection when it goes to sleep, and the *"keep-alives"* maintain the SSH client-to-server connection when there is little or no activity. 

* NOTE: SSH *"keep-alive"* messages may be configured in the **SSH server** (which you may or may not have control over), **or** they may be configured in the **SSH client** (which presumably you do have control over). As long as client or server (or both) are configured to send *"keep-alives"*, your connection should be reliable (assuming your OS doesn't shut down networking to save power). Further, you can apply these options to all of your client connections by placing them in your `~/.ssh/config` file as follows: 

  ```zsh
  Host *
      ServerAliveInterval 60
      ServerAliveCountMax 10
  
  # Note: There may be other items in ~/.ssh/config; they should probably remain
  ```

Using this method, when your Mac is running from mains power (charger), your SSH connection will remain viable even after the lid is closed for hours, days, etc. No 3rd party software is required for this method, and it has been verified to work on the following MacBook Pros:

- 2019, 16-inch MacBook Pro, Catalina, 10.15.4
- 2016, 15-inch MacBook Pro, Mojave, 10.14.6
- Late 2011, 17-inch MacBook Pro, High Sierra, 10.13.6

It may work on other models also; please share feedback if you try it. Once again, you should have your MacBook connected to the charger for extended sessions. Running on battery power alone, at some point the system may override `caffeinate` and force it into sleep mode. It's impossible to say what will happen on the various makes and models as Apple may have Power Management features that will vary from one make and model to another.  

And the Power Management (aka *Energy Saver*) GUI in *System Preferences* should not be neglected. Here's a *screen shot* showing how you may wish to set yours. I haven't tried all the possibilities in the GUI, so perhaps don't stray too far until after you've experimented a bit.

<img src="/pix/EnergySaverSettings.png" alt="EnergySaverSettings" style="zoom:50%;" />

 Once you've initiated your SSH connection with `caffeinate -i`, you can verify its status using the *Activity Monitor*. You should see something like the following: 



<img src="/pix/ActivityMonitorOnCaffeinate.png" alt="ActivityMonitorOnCaffeinate" style="zoom:50%;" />

Two items to note: *Activity Monitor* is showing a filtered search on **caffeinate**, and the `caffeinate` process shown in the list is reported to be **Preventing Sleep** - exactly what we want! You can look under the other tabs to see more information about the selected process (e.g. the *Network* tab). Note also that this display has *optional columns* displayed: *Ports*, and *Preventing Sleep*. You can add these simply by 'right-clicking' in the label bar, and checking the labels you want to add or remove.

<hr>



