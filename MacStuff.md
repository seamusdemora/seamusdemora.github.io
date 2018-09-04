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
