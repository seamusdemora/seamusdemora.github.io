# Eclectic Tips & Tricks for Mac OS

### 1. How Do I Change Where My Screenshots Are Saved? :

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

### 2. How Do I Prevent My Mac From Sleeping? :

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



### 3. How Do I Start (`open`) an App From the Mac OS Command Line?

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

### 4. How Do I Schedule an App to Run At a Specified Time?

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

### 5. How Do I Check the Size of a Directory?

You can of course do this from the Finder menu: `File, Get Info`, but it may be quicker from the command line.

For a directory on your Mac's HDD: 
```
$ du -sh /path/to/directory
```
For a network drive that's mounted: 
```
$ du -sh /Volumes/sharename/path/to/directory  
```

### 6. Can I Check Battery Status from the Command Line?

Yes - and a lot more! The `pmset` utility provides a host of information, and allows manipulation of ***power management settings*** from the command line. For example, to get battery status: 

```bash
$ pmset -g batt                        # and for example, my Mac now reports" 
Now drawing from 'AC Power'
 -InternalBattery-0 (id=1234567)	100%; charged; 0:00 remaining present: true
```

The `-g`  (get) option provides data on current settings and logfiles. It can be run with normal user privileges. `pmset`can also change settings (e.g. standby, sleep, spin-down of disks, display, etc.), but those require `root`/`su` privileges. Documentation is available from `man pmset`.  

### 7. Can I Send Files to the Trash from the macos Command Line?

Yes - thanks to the work of dabrahams. The latest version of the command line utility named `trash` is [available in this gist on GitHub](https://gist.github.com/dabrahams/14fedc316441c350b382528ea64bc09c). Its creation was spawned by a Q&A on Stack Exchange, and initially posted in [this answer](https://apple.stackexchange.com/a/162354). There is always `rm` of course, but it's a permanent and irrecoverable deletion. What makes `trash` special is that it ***moves*** files to the `Trash` folder, essentially replicating the system's `Move to Trash` feature available in `Finder`. And from `Trash` of course you have the option to recover the file, or delete it permanently. 

It's written in Python, and *open source*. If you want to "integrate" `trash` into your system: 

- Save the script as a file named `trash`, and copy `trash` to `/usr/local/bin` 

- ```
  $ chmod a+rx /usr/local/bin/trash
  ```

### 8. How Do I Find the Hardware Architecture and OS Version for My Mac?

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

### 9. How Do I Combine/Concatenate Multiple PDFs?

[Apple has this one covered](https://support.apple.com/guide/mac-help/combine-files-into-a-pdf-mchl21ac2368/mac), and it's easy if you know ***the trick***. You should also know that the `Quick Actions > Create PDF` option in `Finder` may not show up! When you move the pointer over `Quick Actions` in `Finder` you may see only the option `Customize...`. If that's the case, click `Customize...`, then tick the box next to `Create PDF`. This will add `Create PDF` as an option for `Quick Actions`. 

### 10. How Do I Search My Command History in `Terminal`?

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

### 12. Can I Copy `command line` Output to Pasteboard/Clipboard?

Yep! You can **copy** from `stdout` and **paste** to `stdin` using one of the several clipboards available.

```Bash
$ ls -la | pbcopy
```

You can then paste this output into a document using the `command-v` keyboard shortcut. 

Similarly, using `pbpaste` you can paste text you've copied to a file; e.g.

```bash
$ pbpaste > newfile.txt
```

See `man pbcopy` for further details.



### OTHER SOURCES:

- [OSXDaily offers a list](http://osxdaily.com/category/command-line/) of "command line tips" 
- [The Mac Observer](https://www.macobserver.com) has tips, tricks & news items.


<!--- 

# Miscellaneous Tips & Tricks for Mac OS

## 1. How Do I Change Where My Screenshots Are Saved? : 

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

* Note that you must create this folder if it doesn't already exist! 

## 2. How Do I Prevent My Mac From Sleeping? : 

Caffeine may do the trick; specifically `caffeinate` may be exactly what you need for your Mac. Know first that `man caffeinate` is your friend; enter it at the command line, and you'll find all the documentation for using this utility. `caffeinate` creates assertions to alter system sleep behavior. Following are a couple of general use cases: 

```
    $ caffeinate -s  
```
or perhaps more effectively as follows: 
```
    $ caffeinate -s &
    [1] 1558         (IF YOU WISH TO RESTORE THE SLEEP PATTERN AFTER SOME TIME, simply kill it )
    $ kill 1558
```
Used in this way, `caffeinate` is a ***blunt instrument***. This command simply creates and holds an assertion that will prevent the Mac from sleeping as long as it remains on ac/mains power. Run in the background, you can continue the terminal session for as long as needed, and then simply kill `caffeinate`'s PID to release the assertion and restore sleep patterns. 

```
    $ caffeinate -w PID
```
When used with the `-w` argument, sleep will be inhibited as long as the process ID `PID` is active. Once the the process exits, the assertion is released, and the configured sleep behavior will resume when appropriate. 

Note also that Process ID's are available from `Activity Monitor`, or can be listed in the terminal by entering `ps -Al`

## 3. How Do I Start an App From The Mac's Command Line?  

There may be occasions when you want or need to start an application from the command line. Or perhaps start an app from a script, or even to start the app at a specified time (more on scheduling in the sequel), or on an interrupt-driven basis triggered by an event. For example, you want to check your Gmail account each day at 12:00. How would you do this? Here's one way: 

a. get the location of the app

```
$ ls /Applications | grep Chrome  
Google Chrome.app  
```

b. get the URL for your Gmail inbox:  
```
https://mail.google.com/mail/u/0/#inbox  
```

c. use `open` to start Chrome and load GMail: 
```
$ open -a "/Applications/Google Chrome.app" https://mail.google.com/mail/u/0/#inbox
```
*Note that the file specification must be inside quotes to "protect" the space in the app name.* 

## 3. How Do I Schedule an App to Run At a Specified Time?

In general, there are (at least) two distinct approaches to scheduling in current versions of mac os:   
a. `cron` is the standard (as in long-standing) method for scheduling. It's been around since the early days of Unix, and as a derivative of the BSD flavor of Unix, upon which mac os is built! That `cron` remains as a viable, well-maintained app today is a testament to its utility.  
b. `launchd` is a much more complicated creature than `cron`, but it's got an Apple pedigree. It was developed by Dave Zarzycki, an Apple employee who started with them in 1996 as a 17 year-old, self-taught programmer. To use `launchd` effectively, you'll need to spend time preparing yourself. Consequently, we'll start here with `cron`, and pick up `launchd` in a future installment. 

d. a `crontab` event, make the appropriate entry in your `crontab` [enter `crontab -e` at the command prompt `$`, then add the following line]:
```bash
$ ps -A | grep TextEdit 
 1864 ??         0:00.85 /Applications/TextEdit.app/Contents/MacOS/TextEdit
 1873 ttys002    0:00.00 grep TextEdit
```



b. start the app 

```
$ open -a /Applications/TextEdit.app/Contents/MacOS/TextEdit
```

REFERENCES:
1. [Q&A: Using the `at` command in macos:](https://unix.stackexchange.com/questions/478823/making-at-work-on-macos)  


--->

```

```

```

```