### Using `screen` as a terminal multiplexer in MacOS

`screen` is sometimes called a *terminal multiplexer*. It's incredibly useful, but arcane. However, as is usually the case, diligent research usually reveals enough secrets to (at least) construct a useful & rational configuration. That's what we'll try to do here!

We'll cover the *native* version of `screen`here - the one that comes as part of `macos`. Before investing time & effort, you should know there are alternatives to the *native* Apple version of `screen`. As of this writing, Apple packages a 16 year-old version of GNU `screen` (ver 4.00.03) with `macos` 10.15.6 (Catalina). The latest version of `screen` (ver 4.9 as of today) can be installed through [MacPorts](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/MacPorts.md). There are also  [alternatives to `screen`](https://alternativeto.net/software/screen/), one being [tmux](https://github.com/tmux/tmux/wiki). Again, we're going to stick with the *native* version for this exercise. 

Due to the age of Apple's chosen release of `screen`, some of the information available for `screen` online may not be relevant here. This shouldn't be a problem if we stick to "basics". We will have some example configuration files (`screenrc`) to guide us - that, according to `man screen`: 

> When  screen  is  invoked,  it  executes  initialization  commands  from  the files  "/usr/local/etc/screenrc" and ".screenrc" in the user's home directory.    

This is out-of-date and/or incorrect. The folder `/usr/local/etc/` does not exist in `macos`. The manual goes on to say:

> Two configuration files are shipped as examples with your screen distribution: "etc/screenrc" and "etc/etcscreenrc". They contain a number of useful examples for various commands.

As I learned, these configuration files are not included in the `macos` distribution; i.e. they are not on your mac. But you can find them in [Apple's open-source archives.](https://opensource.apple.com/source/screen/screen-22/) 

After perusing the massive `man screen` document, I elected to end the research, and move to the trial-and-error phase! With no `screenrc` file installled (yet), let's start `screen`, and connect to a couple of Raspberry Pi's: 

```bash
$ screen -S Pi4 ssh -Y pi@raspberrypi4b.local
```

This starts a terminal session via SSH with for the designated user@host (`pi@raspberrypi4b.local`), and applies a `session name` of **Pi4** using the `-S` option. This `session name`will make moving between sessions easier.  If this command executes successfully, you will now be looking at the command line of the host you connected. Once you've explored this new `screen`, let's `detach` it, and return to the terminal app. At the command line, press & hold the `control`key, then hit the `a` key, release both keys, then hit the `d` key: 

```bash
ctrl-a d
```

The `ctrl-a` sequence signals that what follows is a `screen` command instead of a shell command. Once this sequence is entered, we will now be `detached` from this `screen`, and back at the terminal. But you are still connected to your host in the `screen` with `session name` `Pi4`. You may want to do some things in terminal, and then `attach` to session `Pi4`again. From the command line in `terminal`:

```bash
$ screen -r
```

Which will toggle you back to screen session `Pi4`. Now, `detach` from `Pi4` again, and start a second `screen`in `terminal` to connect to host `raspberrypi3b.local` : 

```bash
$ screen -S Pi3 ssh -Y pi@raspberrypi3b.local
```

Explore `screen session Pi3`, and `detach` using `ctrl-a d`

Now, from the `terminal` command line: 

```
$ screen -r
There are several suitable screens on:
	3124.Pi4	(Detached)
	3143.Pi3	(Detached)
Type "screen [-d] -r [pid.]tty.host" to resume one of them.
```

This command now lists the two `screen` sessions, and explains how to `resume` either of them. From here we can switch between two `screen sessions`and the `macos` shell in the same 



You may want to "split" your terminal window, and display a `screen` session in each one. There are several options here; let's go over (some of) them: 

- Use `tabs` in the `terminal`menu: `View, Show Tab bar` and then add tabs for each `screen`
- Split the terminal window using `screen`
- Install `iTerm2`which has the ability to split its window with different shell sessions



Quitting `screen`: 

At some point, you will want to end your `screen` session completely. Perhaps you are finished, or perhaps you have made an error:

```bash
$ screen -ls        # retrieves list of all screen sessions; for example:
There is a screen on:
	1172.ttys001.MyMacbookPro	(Attached)
1 Socket in /var/folders/9t/_1d0fdt969x5s97bnfz40jdw0000gp/T/.screen.
$ screen -XS 1172.ttys001.MyMacbookPro quit
$
```



 



### References:

1. Apple maintains a central [repository for the open-source software](https://opensource.apple.com/) included in `macos`
2. Michael Levin has written an [overview on `screen`, and why it's useful](http://www.kinnetica.com/2011/05/29/using-screen-on-mac-os-x/). 
3. When using `screen` in macos, the [problem described in this Q&A](https://unix.stackexchange.com/questions/43229/is-there-a-way-to-make-screen-scroll-like-a-normal-terminal) may be the first issue you encounter.
4. Softpanorama covers most of the details in his [`.screenrc examples` webpage](http://www.softpanorama.org/Utilities/Screen/screenrc_examples.shtml). 
5. Salty Crane's blog has some [tips for using GNU `screen`](https://www.saltycrane.com/blog/2008/01/how-to-scroll-in-gnu-screen/) that might be useful. 
6. [Alain Francois' post on LinOxide](https://linoxide.com/linux-command/15-examples-screen-command-linux-terminal/) offers a well-organized overview of `screen` commands.
7. This was a productive [search term for information on `~/.screenrc`](https://duckduckgo.com/?q=comments+in+.screenrc). 
8. There are [**alternatives to `screen`**](https://alternativeto.net/software/screen/) for macos... [tmux](https://github.com/tmux/tmux/wiki) seems to be popular and well-maintained. 
9.  [How to scroll up and down in sliced “screen” terminal](https://stackoverflow.com/questions/18489216/how-to-scroll-up-and-down-in-sliced-screen-terminal), a Q&A on StackExchange.  
10. [How to split the terminal into more than one “view”?](https://unix.stackexchange.com/questions/7453/how-to-split-the-terminal-into-more-than-one-view), a Q&A on StackExchange. 