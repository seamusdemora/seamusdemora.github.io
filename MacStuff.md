# Eclectic Tips & Tricks for Mac OS

#### Table of contents

[1. How to Change Where My Screenshots Are Saved?](#1-how-to-change-where-my-screenshots-are-saved)

[2. How to Prevent My Mac From Sleeping? ](#2-how-to-prevent-my-mac-from-sleeping-)

[3. How to Start (`open`) an App From the macOS Command Line?](#3-how-to-start-open-an-app-from-the-macos-command-line)

[4. How to Schedule an App to Run At a Specified Time?](#4-how-to-schedule-an-app-to-run-at-a-specified-time)

[5. How to Check the Size of a Directory?](#5-how-to-check-the-size-of-a-directory)

[6. How to Check Battery Status from the Command Line?](#6-how-to-check-battery-status-from-the-command-line)

[7. How to Send Files to the Trash from the macos Command Line?](#7-how-to-send-files-to-the-trash-from-the-macos-command-line)

[8. How to Find the Hardware Architecture and OS Version for My Mac?](#8-how-to-find-the-hardware-architecture-and-os-version-for-my-mac)

[9. How to Combine/Concatenate Multiple PDFs?](#9-how-to-combineconcatenate-multiple-pdfs)

[10. How to Search My Command History in `Terminal`?](#10-how-to-search-my-command-history-in-terminal)

[11. How to Disable Auto-Booting When Opening the Macbook Lid?](#11-how-to-disable-auto-booting-when-opening-the-macbook-lid)

[12. How to Copy `command line` Output to Pasteboard/Clipboard?](#12-how-to-copy-command-line-output-to-pasteboardclipboard)

[14. How to Show Hidden Files in Finder?](#14-how-to-show-hidden-files-in-finder)

[15. How to Recover a Bodged `git` Repository?](#15-how-to-recover-a-bodged-git-repository) 

[16. How to Restore the "Lost Startup Chime"?](#16-how-to-restore-the-lost-startup-chime) 

[17. Weirdness With `zsh` ](#17-weirdness-with-zsh) 

[18. How to Hide All Open Windows on a Desktop? ('Show Desktop')](#18-how-to-hide-all-open-windows-on-a-desktop-show-desktop) 

[19. How to Set Default Editor for CLI/Terminal App](#19-how-to-set-default-editor-for-cliterminal-app) 

[20. How to See Your Environment Variables](#20-how-to-see-your-environment-variables) 

[21. How to Enable `cron` on Catalina](#21-how-to-enable-cron-on-catalina)

[22. Getting Up to Speed on `zsh`](#22-getting-up-to-speed-on-zsh)

[23. Upgrade Xcode on High Sierra... or Why Does Apple Crap On Us?](#23-upgrade-xcode-on-high-sierra-or-why-does-apple-crap-on-us)  

[OTHER SOURCES:](#other-sources) 

<hr>

### 1. How to Change Where My Screenshots Are Saved?

Two lines of input are needed at the command line; regular user privileges are sufficient. The first changes the default location, the second restarts the __SystemUIServer__ 

```
     $ defaults write com.apple.screencapture location ~/Desktop/screenshots
     $ killall SystemUIServer
```

Alternatively, you may specify the full path: 

```
     $ defaults write com.apple.screencapture location Home/yourusername/Desktop/screenshots
     $ killall SystemUIServer
```

This will cause all screenshots to be saved in a folder called `screenshots` on your Desktop. You may, of course, store them anywhere you wish*. 

- Note that you must create this folder if it doesn't already exist! 

### 2. How to Prevent My Mac From Sleeping?

Caffeine may do the trick; specifically `caffeinate` may be exactly what you need for your Mac. Know first that `man caffeinate` is your friend; enter it at the command line, and you'll find all the documentation for using this utility. `caffeinate` creates assertions to alter system sleep behavior. Following are a couple of general use cases: 

```
    $ caffeinate -s  
```

or perhaps more effectively as follows: 

```
    $ caffeinate -s &
    [1] 1558         (IF YOU WISH TO RESTORE THE SLEEP PATTERN AFTER SOME TIME, simply kill it as follows: )
    $ kill 1558
```

Used in this way, `caffeinate` is a ***blunt instrument***. This command simply creates and holds an assertion that will prevent the Mac from sleeping<sup id="a1">[Note1](#f1)</sup> as long as it remains on ac/mains power. Run in the background, you can continue the terminal session for as long as needed, and then simply kill `caffeinate`'s PID to release the assertion and restore sleep patterns. 

```
    $ caffeinate -w PID
```

When used with the `-w` argument, sleep will be inhibited as long as the process ID `PID` is active. Once the the process exits, the assertion is released, and the configured sleep behavior will resume when appropriate. 

Note also that Process ID's are available from `Activity Monitor`, or can be listed in the terminal by entering `ps -Al` 

​    <b id="f1">Note1:</b> *Know that `caffeinate` will not prevent a scheduled [automatic logout](http://osxdaily.com/2013/03/23/automatically-log-out-of-a-mac-after-a-period-of-inactivity/)*. [↩](#a1) 



### 3. How to Start (`open`) an App From the macOS Command Line?

There may be occasions when you want or need to start an application from the command line. Or perhaps start an app from a script, or even to start the app at a specified time (more on scheduling in the sequel), or on an interrupt-driven basis triggered by an event. The `open` utility (ref. `man open`) is designed for this. For example, you want to start Chrome to check your Gmail account - how would you do this? Here's one way: 

a. get the location of the app

```
$ ls -d -1 /Applications/*.* | grep Chrome  
/Applications/Google Chrome.app  
```

b. get the URL for your Gmail inbox:  

```
https://mail.google.com/mail/u/0/#inbox  
```

c. use `open` to start Chrome and load GMail: 

```
$ open -a "/Applications/Google Chrome.app" https://mail.google.com/mail/u/0/#inbox
```

>         *Note that the file specification must be inside quotes to "protect" the space in the app name.* 

d. `open` also has some options specific to text editing; for example to open a `man` page with your system's default text editor. Here, we'll open the man page for `open` in the default text editor :  

```
$ man open | col -b | open -tf  
```

Which can be quite useful for perusing the system documentation offline (in this example, the `man` page for `open`), and/or making additions or changes to it either for your own use, or to share. 

### 4. How to Schedule an App to Run At a Specified Time?

In current versions of mac os, there are (at least) two distinct approaches to scheduling:   

1. `cron` is the standard (as in long-standing) method for scheduling. It's been around since the early days of Unix. That `cron` remains as a viable, well-maintained app today is a testament to its utility. And as a derivative of the BSD flavor of Unix, it is fitting that it remains a component of mac os. However, we must note that Apple has not maintained the `cron` software they distribute with mac os; `man cron`  reveals that the current version os `cron` in mac os ver 10.14.6 (Mojave) is vintage **June 17, 2007**.
2. `launchd` is a much more complicated creature than `cron`, but it's got an Apple pedigree. It was developed by Dave Zarzycki, an Apple employee who started with them in 1996 as a 17 year-old, self-taught programmer.  `launchd` can do more than `cron`, but it's much more difficult (even arcane) in use. Consequently, we'll cover `cron` here, and pick up `launchd` in [this installment](UsingLaunchdForSchedulingTasks.md). 

To continue one of the examples from above, let's assume, you want to check your Gmail account each day at 12:00. How would you do this? Here's one way to do this using `open` and `cron` : 

a. `cron` events are declared and scheduled in the `crontab`. They follow a specific syntax, although there are variations across the different versions of `cron`. We're working of course with Mac OS, and that means the Vixie (named after Paul VIxie) version of `cron`.  Creating an entry in your `crontab` file is done with a simple command: 

```bash
crontab -e
```

But wait!! Before starting you should know that the default `crontab` editor for Mac OS is `vim`. If you're comfortable using `vim`, go ahead. If you're not, I suggest you use `pico` or `nano` instead: 

```
EDITOR=nano crontab -e
```

If this is the first time you've edited your `crontab`, you'll probably find the editor opens a completely blank file. Many Linux systems will have a default `crontab` that has comments and helpful hints, but Mac OS does not. 

Let's schedule our event now. Enter the following line in the `pico` editor you've just opened: 

```
00 12 * * * open -a "/Applications/Google Chrome.app" https://mail.google.com/mail/u/0/#inbox
```

Next, tell `pico` to write your new `crontab` by entering `ctrl-o`, `enter` to accept the filename, and `ctrl-x` to exit the `pico editor. And that's it. You've just scheduled Chrome to start and fetch your Gmail inbox every day at 12:00 noon.  

Let's review what we've just done: 

You'll recognize the `open` command and the parameters that follow it from the earlier example. What we've added to that is a strange-looking sequence: 

```
00 12 * * *
```

This is simply the schedule information. It tells `cron` **when** to execute the command that follows. If you want to re-schedule for a time other that 12:00 noon, all you need change is the time. `man crontab` will guide you in the options for specifying the time and date. Until you become familiar with the syntax, you should use the [crontab guru](https://crontab.guru/#00_12_*_*_*) to check your schedule. You'll learn that  [`cron`'s simple syntax is quite flexible](https://crontab.guru/#5_4-7_1-28/2_1-9/3_*).  

### 5. How to Check the Size of a Directory?

You can of course do this from the Finder menu: `File, Get Info`, but it may be quicker from the command line.

For a directory on your Mac's HDD: 
```
$ du -sh /path/to/directory
```
For a network drive that's mounted: 
```
$ du -sh /Volumes/sharename/path/to/directory  
```

### 6. How to Check Battery Status from the Command Line?

The `pmset` utility provides a host of information, and allows manipulation of ***power management settings*** from the command line. For example, to get battery status: 

```bash
$ pmset -g batt                        # and for example, my Mac now reports" 
Now drawing from 'AC Power'
 -InternalBattery-0 (id=1234567)	100%; charged; 0:00 remaining present: true
```

The `-g`  (get) option provides data on current settings and logfiles. It can be run with normal user privileges. `pmset`can also change settings (e.g. standby, sleep, spin-down of disks, display, etc.), but those require `root`/`su` privileges. Documentation is available from `man pmset`.  

### 7. How to Send Files to the Trash from the macos Command Line?

This is easily and elegntly done thanks to the work of dabrahams. The latest version of the command line utility named `trash` is [available in this gist on GitHub](https://gist.github.com/dabrahams/14fedc316441c350b382528ea64bc09c). Its creation was spawned by a Q&A on Stack Exchange, and initially posted in [this answer](https://apple.stackexchange.com/a/162354). There is always `rm` of course, but it's a permanent and irrecoverable deletion. What makes `trash` special is that it ***moves*** files to the `Trash` folder, essentially replicating the system's `Move to Trash` feature available in `Finder`. And from `Trash` of course you have the option to recover the file, or delete it permanently. 

It's written in Python, and *open source*. If you want to "integrate" `trash` into your system: 

- Save the script as a file named `trash`, and copy `trash` to `/usr/local/bin` 

- ```
  $ chmod a+rx /usr/local/bin/trash
  ```

### 8. How to Find the Hardware Architecture and OS Version for My Mac?

Because `macos` has (some of) its roots in BSD Unix rather than Linux, the `machine` command will reveal hardware: 

```bash
$ machine
x86_64h                         # on a new-ish machine
```

And if you want to see perhaps the *shortest man page in the entire world*, check out `man machine`.  :) 

However, the following *Linux-style* command also works: 

```bash
$ uname -m
x86_64
```

`uname` has several other options, all described in `man uname`. 

And finally, suggest that you *do not* use this: 

```bash
$ arch
i386
```

This is of course an **incorrect answer** for 64-bit processors, but one that you will get as of today (Mojave 10.14.4)**!** [Some have suggested](https://unix.stackexchange.com/a/518320/286615) that the `i386` output simply means that it's *capable* of running 32-bit programs. However, `man arch` makes no such statement. Consequently, it's my opinion that Apple has simply dropped the ball! In any case, the information is virtually useless. 

To get the version of the OS: 

```bash
$ sw_vers
ProductName:	Mac OS X
ProductVersion:	10.14.4
BuildVersion:	18E226
```

Note however, there is more confusion/inconsistency between the `sw_vers` command, and `uname -r[sv]`: both commands claim to display the `OS version`, but `uname -r[sv]` actually gives the version of its kernel (currently named [`Darwin`](https://en.wikipedia.org/wiki/Darwin_%28operating_system%29)): 
```bash
$ uname -v
Darwin Kernel Version 18.5.0: Mon Mar 11 20:40:32 PDT 2019; root:xnu-4903.251.3~3/RELEASE_X86_64
```

This information is also available from Apple's *unique-to-the-Mac* command line utility `system_profiler SPSoftwareDataType`. Its output shows `System Version`, which corresponds to `OS version` given by `sw_vers`, and `Kernel Version` which corresponds to `OS version` given by `uname -r[sv]`. And yes, you're correct… this ***is*** a bit of a mess!  

```
$ system_profiler SPSoftwareDataType
Software:

    System Software Overview:

      System Version: macOS 10.14.4 (18E226)
      Kernel Version: Darwin 18.5.0
      Boot Volume: Macintosh HD
      Boot Mode: Normal
```

### 9. How to Combine/Concatenate Multiple PDFs?

[Apple has this one covered](https://support.apple.com/guide/mac-help/combine-files-into-a-pdf-mchl21ac2368/mac), and it's easy if you know ***the trick***. You should also know that the `Quick Actions > Create PDF` option in `Finder` may not show up! When you move the pointer over `Quick Actions` in `Finder` you may see only the option `Customize...`. If that's the case, click `Customize...`, then tick the box next to `Create PDF`. This will add `Create PDF` as an option for `Quick Actions`. 

### 10. How to Search My Command History in `Terminal`?

Here are some useful techniques: 

- Type `control-r` at the command prompt. This brings up a *search* prompt: `(reverse-i-search):`.  Type whatever you can recall of a previously used command (e.g. `etc` ). As you type each character, the search continues. You can iterate back through all of the search results with `control-r`. When you've found the command you were looking for, hit the `enter` key to run it again "as-is", or make edits to the command (*use either of the left-right arrow keys*) before you run it. If you want to stop searching without running a command, type `control-g`. 
- You can use the `history` command! `history` outputs the entire history to `stdout`. As such, you can *filter* the history by piping it to (e.g.) `grep`: `history | grep etc`, or redirect it to a file (e.g.`history > mycmdhistory.txt`), or any other command (e.g. `history | tail -5`).
- Of course, you can still use the *up-and-down arrow keys* to step forward (or backward) through the command history, but if your command history is extensive, this will take time.  

### 11. How to Disable Auto-Booting When Opening the Macbook Lid?

This useful bit of wisdom was found in [this article in OSXDaily](http://osxdaily.com/2017/01/19/disable-boot-on-open-lid-macbook-pro/). You can manipulate the MacOS firmware from the command line:

```bash
sudo nvram AutoBoot=%00
```

Note that you must execute a clean shutdown to save this value. To restore the AutoBoot feature:

```bash
sudo nvram AutoBoot=%03
```

--OR--

[Restore **ALL** NVRAM settings](http://osxdaily.com/2010/11/15/reset-pram-mac/) by rebooting the MacBook while holding down the `Command+Option+P+R` keys (yes, this is a two-handed operation :) 

What other NVRAM settings are available for changing? 

```bash
nvram -p
```

will list available options... but it's very messy! 

### 12. How to Copy `command line` Output to Pasteboard/Clipboard?

You can **copy** from `stdout` and **paste** to `stdin` using one of the several clipboards available.

```Bash
$ ls -la | pbcopy
```

You can then paste this output into a document using the `command-v` keyboard shortcut. 

Similarly, using `pbpaste` you can paste text you've copied to a file; e.g.

```bash
$ pbpaste > newfile.txt
```

See `man pbcopy` for further details.

### 14. How to Show Hidden Files in Finder?

There are many **hidden files and folders** in MacOS. We have to guess what Apple's motivations are for designating certain files and folders as hidden, but it seems likely this *default* configuration is to protect users from themselves. However, there are numerous situations where it's very useful to be able to see files in Finder that are hidden from our view bt default. Examples abound: 

* all the files and folders associated with MacOS' Unix underpinnings; e.g. `/usr/local/bin`, `etc`, and many more.  
* if you maintain a `git` repository on your Mac, there will be files that you will need to edit; e.g. `.gitignore`.
* all `mount`*ed* drives and shares are listed under `/Volumes`, and it is occasionally useful to see inside this *hidden folder*. 

 Fortunately, there's a simple way to turn visibility of hidden files and folders `ON` and `OFF`. If you're starting from the *default* condition in which hidden files and folders are NOT visible, use the **CLI** as follows to render them visible from within `Finder`: 

```bash
$ defaults write com.apple.finder AppleShowAllFiles TRUE 
```

If you have open Finder windows, you'll need to close them all with this command before you see the effects of this change; i.e. before Finder shows the hidden files in its listing:

```bash
$ killall Finder
```

Opening a new `Finder` window will reveal the hidden files and folders. To return to the default: 

```bash
$ defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
```

### 15. How to Recover a Bodged `git` Repository?

Recently, I inadvertently deleted all of my *local* GitHub repositories. In a comical sequence of poor decisions I made things worse by copying the entire repo from a backup, but it was not in sync with the repos on GitHub. Further attempts to resolve the issues only made things worse. Then it dawned on me that *this what `git` was made for!* A quick bit of research provided the answer - from the **CLI**:

```bash
$ git fetch origin 
# some output ...
$ git reset --hard origin/master
```

A few things to review beforehand! : 

* execute these commands from the local directory where you want your repo to live, 
* The `remote` repository is the origin you want (in my case, the remote repo at GitHub was my `origin`) 
* The `branch` you want to restore is the `master` branch

### 16. How to Restore the "Lost Startup Chime"?

The long lost startup chime has been found by [this fellow](). Here's how to get it back on your Mac: 

```bash
sudo nvram StartupMute=%00
sudo reboot		# alternatively, `Restart...` fm the System menu
# Hear the Lost Chime once again! 
# When you get tired of it: 
sudo nvram StartupMute=%01
```

[More details and *Chime Trivia* can be found here.](https://mrmacintosh.com/how-to-enable-the-mac-startup-chime-on-your-2016-macbook-pro/) 

And if you're into [*mac nostalgia*](https://duckduckgo.com/?t=ffnt&q=mac+nostalgia&ia=web) you can [get all the default macOS wallpapers in 5K!](https://512pixels.net/projects/default-mac-wallpapers-in-5k/) 

### 17. Weirdness With zsh

As most of you will be aware, Apple has made the decision to change the default shell from `bash` to `zsh` in macOS Catalina. There's more to come here on `zsh`, but for now I'll include some *discoveries* I've made here. 

* `zsh` 'over-globs'! 

  This queerness took an hour from my life: 

  ```zsh
  % curl -o rpiforum.html -L https://www.raspberrypi.org/forums/viewtopic.php?p=1528736
  zsh: no matches found: https://www.raspberrypi.org/forums/viewtopic.php?p=1528736 
  
  # wtf??
  ```

  A very old [problem according to this resource](https://github.com/ohmyzsh/ohmyzsh/issues/31). Two relatively simple solutions that might ***never*** occur to you are: 

  ```zsh
  % curl -o rpiforum.html -L "https://www.raspberrypi.org/forums/viewtopic.php?p=1528736"
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100  120k    0  120k    0     0   199k      0 --:--:-- --:--:-- --:--:--  199k
  
  # OR, A MORE PERMANENT PATCH: 
  
  % alias curl='noglob curl'
  % curl -o rpiforum.html -L https://www.raspberrypi.org/forums/viewtopic.php?p=1528736
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100  120k    0  120k    0     0   204k      0 --:--:-- --:--:-- --:--:--  204k
  ```

### 18. How to Hide All Open Windows on a Desktop? ('Show Desktop')

<kbd>fn</kbd><kbd>F11</kbd> - this will *toggle* Show & Hide all app windows on a desktop. 



### 19. How to Set Default Editor for CLI/Terminal App

If you run a command that invokes a text editor (e.g. `crontab -e`), you may find yourself in the `vi` editor. `vi`is fine once you're used to it, but proficiency in `vi`will require time and effort. If you'd prefer to avoid learning `vi`, you can easily set your default to a more user-friendly editor like `nano`: 

```bash
export EDITOR=nano
```

Enter this at the command line in `Terminal.app`. From this point forward, anytime you run `crontab -e`, your `crontab` will open in `nano`instead of `vi`. If you want to try `vi` later, simply `export EDITOR=vi`.



### 20. How to See Your Environment Variables

```zsh
printenv | less
```



### 21. How to Enable `cron` on Catalina

In Catalina, Apple has *"enhanced security"* by disallowing operations that have long been allowed. `cron`is one of those. Restoring `cron`*'s* privileges requires it be granted **Full Disk Access** in **System Preferences**. Doing this using the GUI is a two-step process: 

* Due to the way that apps are added to the Full Disk Access list, we must first find `cron` in Finder:
  * Open Finder, enter Command+Shift+G
  * Enter `usr/sbin` in the dialog box.
  * Finder displays the contents of `usr/sbin`, scan the file listing, and find the on a named `cron`. 

* Open System Preferences app & navigate to the Privacy tab in Security & Privacy
  * Select the Full Disk Access item in the listing on the left side; this populates a list of apps on the right side
  * From the Finder window above, drag and drop the `cron` app into the app list on the right. Make sure it is checked to enable access.

*Opinion: I wonder if the primary effect of Apple's "enhanced security" changes in Catalina has been to put a much larger burden on some users by forcing them to activate these work-arounds to get their tasks completed?*



### 22. Getting Up to Speed on `zsh`

Apple has decided that the most-commonly-used shell (`bash`) should no longer be the default shell for macOS, so in Catalina they have made `zsh` the default. The motivation for this decision is, uh... interesting, I think - if this is true.  IMO, `zsh` is a hopped-up version of `bash` - a version that appeals mostly to the hyperactive, or maybe even amphetamine users. But that's just my opinion, man. I'll try anything once, and here's a shortlist to get up-to-speed on `zsh`: 

* From How-To Geek: [What is ZSH, and Why Should You Use It Instead of Bash?](https://www.howtogeek.com/362409/what-is-zsh-and-why-should-you-use-it-instead-of-bash/) 
* From Armin Briegel at [Scripting OS X](https://scriptingosx.com/), a series of articles: [Moving to zsh](https://scriptingosx.com/2019/06/moving-to-zsh/), also available as a [book](https://scriptingosx.com/2019/11/new-book-release-day-moving-to-zsh/). 
* From [linux today](https://www.linuxtoday.com/), a blog post on [Writing scripts for `zsh`](https://www.linuxtoday.com/blog/writing-scripts-for-zsh.html).  
* And if you want, here's how to restore `bash` as the default shell on Catalina - [an entire article on this](https://www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/): 

```zsh
chsh -s /bin/bash
```



### 23. Upgrade Xcode on High Sierra... or Why Does Apple Crap On Us?

Apple's abject failure to maintain many of their "Open Source" tools has led me to install [**MacPorts**](https://www.macports.org). My *ancient* MacBook Pro Late 2011 runs High Sierra, and I've been reasonably happy with it - it's a lesser hassle than my new 2019 MacBook Pro w/ Catalina. Also, since this vintage Mac has a removable SSD, I can easily back out of any failures. Anyway... as I learned, before installing MacPorts I had to upgrade XCode. XCode was installed from the AppStore, so I figured it would be an easy upgrade. But in yet another demonstration of how much Apple cares for their customers, this was far from *easy*. And no - I don't want to hear any lame explanations for this from Apple's supplicants - just STFU, please. 

That said, I followed a recipe I found here [REF @cerniuk's post](https://forums.developer.apple.com/thread/110227) for uninstalling Xcode, and it seems to work. I'm sharing it here w/ one minor addition in hope that it'll help someone else: Here's what I did: 

Remove the following: 

1. /Applications/Xcode.app
2. ~/Library/Caches/com.apple.dt.Xcode
3. ~/Library/Developer
4. ~/Library/MobileDevice
5. ~/Library/Preferences/com.apple.dt.Xcode.plist 
6. ~/Library/Preferences/com.apple.dt.xcodebuild.plist
7. /Library/Preferences/com.apple.dt.Xcode.plist
8. /System/Library/Receipts/com.apple.pkg.XcodeExtensionSupport.bom
9. /System/Library/Receipts/com.apple.pkg.XcodeExtensionSupport.plist
10. /System/Library/Receipts/com.apple.pkg.XcodeSystemResources.bom
11. /System/Library/Receipts/com.apple.pkg.XcodeSystemResources.plist 

Installing an older version of XCode is a bit different - you can't get it from the AppStore. Fortunately, [MacPorts keeps a list of downloads](https://www.macports.org/install.php), and a decent set of instructions. Once that task is accomplished, you have an *upgraded* XCode install that supports MacPorts (at least until Apple decides to break things again).



<hr>


### OTHER SOURCES:

- [OSXDaily offers a list](http://osxdaily.com/category/command-line/) of "command line tips" 
- [The Mac Observer](https://www.macobserver.com) has tips, tricks & news items.
- [Q&A: Using the `at` command in macos](https://unix.stackexchange.com/questions/478823/making-at-work-on-macos) 
- [GadgetHacks has a list of *Essential* MacOS commands](https://mac-how-to.gadgethacks.com/how-to/13-terminal-commands-every-mac-user-should-know-0162453/); some are actually useful. 
- [Terminal.app keyboard shortcuts for some recent versions of MacOS](https://support.apple.com/guide/terminal/keyboard-shortcuts-trmlshtcts/mac) 
- [Q&A: Null & empty string comparison in Bash](https://stackoverflow.com/questions/21407235/null-empty-string-comparison-in-bash): Know the difference between `null` & an empty string.
- [Q&A: (How to put a) Command inside if statement of bash script](https://stackoverflow.com/questions/5276393/command-inside-if-statement-of-bash-script) 
- [On Catalina, how can a cronjob get permission to touch files on a USB disk?](https://apple.stackexchange.com/questions/372768/on-catalina-how-can-a-cronjob-get-permission-to-touch-files-on-a-usb-disk) 
- [List All Environment Variables](https://www.cyberciti.biz/faq/linux-list-all-environment-variables-env-command/) - a nixCraft article. 

<!--- 

You can hide shit in here  :)   LOL 

--->

```

```

```

```