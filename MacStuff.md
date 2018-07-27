# Miscellaneous Mac Tips & Tricks

## 1. Change Where Your Screenshots Are Saved: 

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
