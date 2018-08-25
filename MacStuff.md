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

## 1. How Do I Prevent My Mac From Sleeping? : 

Caffeine may do the trick; specifically `caffeinate` may be exactly what you need for your Mac. Know first that `man caffeinate` is your friend; enter it at the command line, and you'll find all the documentation for using this utility. `caffeinate` creates assertions to alter system sleep behavior. Following are a couple of general use cases: 

```
    $ caffeinate -s  
```   
or perhaps more effectively as follows: 
```
    $ caffeinate -s &
    [1] 1558         (AND IF YOU WISK TO RESTORE THE SLEEP PATTERN AFTER SOME TIME, simply kill it )
    $ kill 1558
```
Used in this way, `caffeinate` is a ***blunt instrument***. This command simply creates and holds an assertion that will prevent the Mac from sleeping as long as it remains on battery power. Run in the background, you can continue the terminal session for as long as needed, and then simply kill `caffeinate`'s PID to release the assertion and restore sleep patterns. 

```
    ~ caffeinate -w PID
```
When used with the `w` argument, sleep will be inhibited as long as the process ID `PID` is active. Once the the process exits, the assertion is released, and the configured sleep behavior will resume when appropriate. 

Process ID's are available from `Activity Monitor`, or can be listed in the terminal by entering `ps -Al`
