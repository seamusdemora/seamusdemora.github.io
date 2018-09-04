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

Used in this way, `caffeinate` is a ***blunt instrument***. This command simply creates and holds an assertion that will prevent the Mac from sleeping as long as it remains on ac/mains power. Run in the background, you can continue the terminal session for as long as needed, and then simply kill `caffeinate`'s PID to release the assertion and restore sleep patterns. 

```
    $ caffeinate -w PID
```

When used with the `-w` argument, sleep will be inhibited as long as the process ID `PID` is active. Once the the process exits, the assertion is released, and the configured sleep behavior will resume when appropriate. 

Note also that Process ID's are available from `Activity Monitor`, or can be listed in the terminal by entering `ps -Al`

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
i. `cron` is the standard (as in long-standing) method for scheduling. It's been around since the early days of Unix. That `cron` remains as a viable, well-maintained app today is a testament to its utility. And as a derivative of the BSD flavor of Unix, it is fitting that it remains a component of mac os.   
ii. `launchd` is a much more complicated creature than `cron`, but it's got an Apple pedigree. It was developed by Dave Zarzycki, an Apple employee who started with them in 1996 as a 17 year-old, self-taught programmer. To use `launchd` effectively, you'll need to spend time preparing yourself. Consequently, we'll start here with `cron`, and pick up `launchd` in a future installment. 

To continue one of the examples from above, let's assume, you want to check your Gmail account each day at 12:00. How would you do this? Here's one way to do this using `open` and `cron` : 

a. `cron` events are declared and scheduled in the `crontab`. They follow a specific syntax, although there are variations across the different versions of `cron`. We're working of course with Mac OS, and that means the Vixie (named after Paul VIxie) version of `cron`.  Creating an entry in your `crontab` file is done with a simple command: 

```bash
crontab -e
```

But wait!! Before starting you should know that the default editor for Mac OS is `vim`. If you're comfortable using `vim`, go ahead. If you're not, I suggest you use `pico` instead: 

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



<---

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
```

```

$ ps -A | grep TextEdit 
 1864 ??         0:00.85 /Applications/TextEdit.app/Contents/MacOS/TextEdit
 1873 ttys002    0:00.00 grep TextEdit
```  
b. start the app 

```
$ open -a /Applications/TextEdit.app/Contents/MacOS/TextEdit
```

```
   
``` 
--->
