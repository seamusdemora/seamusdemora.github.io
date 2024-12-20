# Integrating `Automator` With the Shell 

`Automator` has always seemed to me to be one of those *oddball* apps that Apple bundles with their OS, but *seem to have* limited practical use. According to [Wikipedia](https://en.wikipedia.org/wiki/Automator_(macOS)), `Automator` is about 20 years old - being introduced with OSX 10.4 ***Tiger***! I find it amazing that Apple keeps some of its software around for so long, but don't put any real effort into improving or modernizing it. 

That said, I've recently found a use for it: *avoiding prohibitions against non-interactive software tools (e.g. `curl`, `wget`) to automate website downloads*. It seems that web browsers which can be controlled by software (as opposed to *interactive/human browsing*) are a bit more difficult to detect and deny access. If you've got such an application, this *recipe* may be of interest. ***Basically then, the real advantage of using `Automator` is that it allows us to bypass website blocks against `curl` and `wget`, by using `Safari` in a non-interactive mode!*** 

## Monitor a website for changes

Our objective/*use-case* is to monitor a web page, and issue a ***notification*** whenever there has been a change in one particular part of it. We'll use an `Automator` *workflow*, and some `shell` scripting to accomplish this. It should probably be noted that one could probably accomplish this objective using a 100% `Automator` solution... but that has of no value to me personally. 

I'll say this again: In most cases, using `curl` or `wget` to accomplish our objective would be simpler than using `Automator`. However, for reasons I don't understand, some website operators block access to their website from `curl` and `wget`. Without belaboring this point further, let's get to the recipe.

It may help understand this *code concoction* to review an outline/summary of the approach:

``` 
     1. download a remote webpage to a local file using an 'Automator' workflow
     2. parse this d/l local file for the 'link of interest'; i.e. a link to a 'zip' 
        file stored in the website
     3. determine if the 'link of interest' ('zip' file) is new or different from 
        what was previously downloaded
     4. if it is new/different, issue a "Notification" using 'osascript'; 
        alternatively: download the 'zip' file with another 'Automator' workflow
```

### Create the `Automator` workflow: 'dl-webpg.workflow':

Armed with this outline, let's open `Automator`, and create the *workflow*: 

1. find the goofy `Automator` icon in the `Other` folder in `Launchpad`, and click to start it
2. click the `+` in the tab bar to create a new *workflow*; a popup will appear; in the popup select the `Workflow` type, and then click the `Choose` button to dismiss the popup:

![Screenshot 2024-12-18 at 2.32.14 PM](/Users/jmoore/Desktop/screenshots/Screenshot 2024-12-18 at 2.32.14 PM.png)

3. select `Internet` from the `Actions` list; in the adjacent list first drag & drop `Get Specified URLs`, and then `Download URLs` into the blank workspace in the GUI

![Screenshot 2024-12-18 at 2.32.43 PM](/Users/jmoore/Desktop/screenshots/Screenshot 2024-12-18 at 2.32.43 PM.png)

​	![Screenshot 2024-12-18 at 2.33.27 PM](/Users/jmoore/Desktop/screenshots/Screenshot 2024-12-18 at 2.33.27 PM.png)

We've still got a couple of details to attend to, but let's go ahead and `Save` our `workflow`. I'm saving to `/Users/seamus/scripts/recipe-web/dl-webpg.workflow`; you should choose whatever location is best for you. 

The first detail is the `Address` field of the `Get Specified URLs` action. For that field I have chosen the following URL - a *"topic"* in the Raspberry Pi forums where an author has posted some code for a script in a file called `usb-boot.zip`.  This code is updated from time to time, and IAW our stated objective, we would like to be ***notified*** when a new version has been posted. Consequently, we will copy-and-paste this URL into the 'Address' field for the `Get Specified URLs` 'Action' : 

```
https://forums.raspberrypi.com/viewtopic.php?p=1230182
```

The only other detail is to specify the local filesystem location where the downloaded webpage will be saved. For that, I'll use the following **folder** (again, you should use whatever works best for you):

```
/Users/seamus/scripts/recipe-web/tmpurl
```

You can now test the workflow you've created; click the `Run` icon in the URH corner of the GUI. The workflow should download a copy of the file pointed to by the URL to the local folder defined above. The results will appear in the `Log` section of the `Automator` GUI. 

### Create a `bash` script that uses the 'dl-webpg.workflow':

I use `bash` simply because I prefer it over `zsh`, so there's absolutely no reason you cannot use `zsh`. Specifically, I use a current version of `bash` that was installed, and is maintained, with [MacPorts](https://www.macports.org). Following is a `bash` script that *incorporates* `dl-webpg.workflow`. Note that its usage is very similar to the way we'd use a function call. 

```bash
#!/opt/local/bin/bash
PATH=/opt/local/libexec/gnubin:/opt/local/bin:$PATH

WRK_FLO="/Users/seamus/scripts/recipe-web/dl-webpg.workflow"

# Clear the d/l folder of any files
DL_FLDR="/Users/seamus/scripts/recipe-web/tmpurl"
if [ -n "$(ls -A "$DL_FLDR")" ]; then
		rm "$DL_FLDR"/*
fi
# Run dl-webpg.workflow & test result
DL_FILE="$(automator "$WRK_FLO" | awk 'NR == 2' | tr -d "\"" | tr -d ' ')"
if ! [ -f "$DL_FILE" ]; then
		echo -e "automator dl-webpg.workflow failed; exit now!"
		exit
fi
# If we've reached this pont, we should have a d/l file to parse
# and find the URL for the *objective file*: 'usb-boot.zip'
NEW_URL_STRING=$(grep -Eo '/download/file\.php\?id=[0-9]+' "$DL_FILE" | head -1)
# We must now compare the current URL_STRING value against the stored previous value
# If the current value of URL_STRING is different, then we download the objective file
OLD_URL_STRING=$(cat "/Users/seamus/scripts/recipe-web/urlstring.txt")
if [ "$OLD_URL_STRING" = "$NEW_URL_STRING" ]; then
		echo -e "URL strings match; nothing more to do; EXIT"
		exit
else
		osascript -e 'display notification "A new version of usb-boot.zip is available for download." with title "NOTICE!"'
fi
# Here we post a notification that a newer version of 'usb-boot.zip' is available. 
# Otherwise, we may add another .workflow to d/l the new 'usb-boot.zip'

```

Hopefully, this recipe has illustrated a potential application for `Automator's` control of Safari, and made it more accessible to those who've not used it. I'll stop here rather than cover the second `Automator` workflow to d/l the .zip file.  



<!---

### Create the second workflow: 'dl-newof.workflow':

One of the `Automator` *workflows* will download the web-page to a local file for parsing, the other will download a file that's referenced therein - the '***objective***' file. The `bash` script will provide the decision logic and other implementation details. 

--->
