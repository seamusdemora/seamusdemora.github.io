## LaunchControl is a Better Solution

I completely stopped using Apple's `launchctl` (described below) several months after this recipe was originally published in Nov, 2019. I've never looked back. [`**LaunchControl**`](https://soma-zone.com/LaunchControl/) is easily one of the 2 or 3 most competent apps I've used on mac OS. In 2 + years of use, I've found it to be both well-designed and well-supported. This is so different from most software products you buy today - especially the native apps designed by Apple!  And so, while I will leave the original recipe here for those who want to try their hand at the tedious manual creation of .plist files for` launchctl,` I no longer use it. `LaunchControl` saves time - lots of time.

## Using launchd for Scheduling Jobs in MacOS

[`launchd`](https://www.launchd.info/) is Apple's initialization and service management software. IMHO, it's nothing to write home about, but as I use a Mac, it's a fact of life. My interest in it lies mainly in being able to schedule jobs to be run at a certain time (or perhaps when a certain condition is satisfied). In that context it serves the same purpose as `cron`. The downside is that it is a helluva' lot more difficult to prepare a `.plist` file than to enter a line in your `crontab`. However, Apple refuses to maintain its `cron` utility (`man cron` says it's vintage is June 17, 2007!), and perhaps the extra effort in learning `launchd` may pay dividends one day. 

For those interested in such things, there's an interesting Wikipedia article on [`launchd`](https://en.wikipedia.org/wiki/Launchd). Turns out that `launchd` may have provided a form of *inspiration* for the open source community to develop its `systemd` ([the subject of another interesting Wikipedia article](https://en.wikipedia.org/wiki/Systemd)), which provides a similar set of services for Linux et al.

But on to the task at hand: For [personal computer systems](https://en.wikipedia.org/wiki/Personal_computer) (as opposed to *servers*), it is common practice for them to enter a [*sleep mode*](https://en.wikipedia.org/wiki/Sleep_mode) to conserve energy when the system is idling. Typically, some or all of the services normally provided by the PC may be unavailable during *sleep mode*. An advantage of `launchd` over `cron` is this: 

> `cron` jobs scheduled to run during sleep mode are simply discarded - lost and forgotten. `launchd` scheduled jobs, on the other hand, will run as soon as the system leaves sleep mode.

This is a [critical difference in some situations](https://apple.stackexchange.com/questions/376203/how-to-run-script-at-wake/376329#376329). For example, if you need a task to run once a day, then as long as your system isn't asleep the entire day, and it is scheduled using  `launchd`, the task will be run *eventually*. Here's what I mean: 

- If you schedule your script to run at (for example) 12:00 noon, AND your mac is awake at 12:00 noon, then your script will run at 12:00 noon.
- If you schedule your script to run at (for example) 12:00 noon, BUT your mac is asleep at 12:00 noon, then your script will run as soon as your mac wakes up.

To be sure, there are several 3rd party apps that will accomplish this, but as `launchd` is part of MacOS, I feel it has an inherent advantage over these 3rd party solutions. That said, one 3rd party tool you should consider for use ***with*** `launchd` is [`LaunchControl`](https://www.soma-zone.com/LaunchControl/) (instead of the native `launchctl`). `LaunchControl` is a GUI-based app used only to help you create/edit your `.plist` control file, and can help managing & troubleshooting if that becomes necessary. 

A `.plist` file (derived from *property list*) is an [XML](https://en.wikipedia.org/wiki/XML) formatted file containing the instructions that will be used by `launchd` to start your program. A `.plist` file can be very simple, but until you become familiar with its syntax, even a simple `.plist` can be vexing. For this piece, we'll create the `.plist` "manually" using nothing but a text editor... we'll learn more that way. :)   

If we spend a few minutes perusing our system manuals (`man launchd.plist` in this case), we'll discover that the *configuration key* needed to use in our `.plist` to schedule the time to run your job/script is `StartCalendarInterval`. So this *configuration key* will be the basis for the example below. Also, as noted above, we find the following passage in `man launchd.plist`: 

> Unlike cron which skips job invocations when the computer is asleep, launchd will start the job the next time the computer wakes up.  If multiple intervals transpire before the computer is woken, those events will be coalesced into one event upon wake from sleep. 

## Example

Here's an example of how to use `launchd`to create a `User Agent`. The scope of a `User Agent` is that it only runs for one user. *Note that it is also possible to create `Global Agent`, or a `Global Daemon` that runs for multiple/all users, but we'll leave that for another day.*

For this example, we will run a `bash` script at odd times just after midnight on each weekday, Monday through Friday. Here's how to use `launchd` to accomplish that: 

#### STEP 1. Create the script to be run by launchd:

Our script is a simple one: `echo` the current time to `stdout`. Create this `bash` script in your home directory to output the date and time whenever it's run: 

  ```
  #!/bin/bash
  CURRENTDATE=`date +"%c"`
  echo Current Date and Time is: ${CURRENTDATE}
  ```
  Name the script `echodatetime.sh` & make it executable (`chmod 755 echodatetime.sh`)

#### STEP 2. Create a .plist file in your user folder: ~/Library/LaunchAgents

We will name this file: `sdm.simple.exampleofPLIST.plist` 

> NOTE! DO NOT USE `~/` as shortcut for user's home directory in the `.plist`! You must use a full path specification, or it won't work.  

  ```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Disabled</key>
	<false/>
	<key>Label</key>
	<string>seamus.simple.example</string>
	<key>ProgramArguments</key>
	<array>
		<string>/Users/jmoore/scripts/echodatetime.sh</string>
	</array>
	<key>StandardErrorPath</key>
	<string>/Users/jmoore/scripts/echodatetime.error.txt</string>
	<key>StandardOutPath</key>
	<string>/Users/jmoore/scripts/echodatetime.log.txt</string>
	<key>StartCalendarInterval</key>
	<array>
		<dict>
			<key>Hour</key>
			<integer>0</integer>
			<key>Minute</key>
			<integer>28</integer>
			<key>Weekday</key>
			<integer>1</integer>
		</dict>
		<dict>
			<key>Hour</key>
			<integer>0</integer>
			<key>Minute</key>
			<integer>30</integer>
			<key>Weekday</key>
			<integer>2</integer>
		</dict>
		<dict>
			<key>Hour</key>
			<integer>0</integer>
			<key>Minute</key>
			<integer>32</integer>
			<key>Weekday</key>
			<integer>3</integer>
		</dict>
		<dict>
			<key>Minute</key>
			<integer>34</integer>
			<key>Weekday</key>
			<integer>4</integer>
		</dict>
		<dict>
			<key>Minute</key>
			<integer>36</integer>
			<key>Weekday</key>
			<integer>5</integer>
		</dict>
	</array>
</dict>
</plist>
  ```
  This `.plist` will cause `~/echodatetime.sh` to be executed at the following times:  
  Each Monday at 00:28  
  Each Tuesday at 00:30  
  Each Wednesday at 00:32  
  Each Thursday at 00:34  
  Each Friday at 00:36   

> You may of course change this timing to suit you by simply changing the `integer` values in the appropriate `key`s.

This example was chosen to show the somewhat odd syntax required for such a schedule, and specifically to highlight the fact that while Apple claims in `man launchd.plist` that the *semantics* for `launchd` are "similar" to those for `crontab`, the *syntax* is ***entirely different***. This strikes me as an entirely *misleading* statement, but then Apple is not known for having good manuals! 

Having made that point convincingly (I hope), scheduling a single event may be accomplished by substituting the simpler `StartCalendarInterval` key shown below into the `.plist` shown above: 

```
	<key>StartCalendarInterval</key>
	<array>
		<dict>
			<key>Hour</key>
			<integer>12</integer>
			<key>Minute</key>
			<integer>0</integer>
		</dict>
	</array>
```

Before proceeding, note two points re. our `.plist` 

- Note the `Label` key, and that it is ***different*** from the file name.
- Note the keys `StandardErrorPath` and `StandardOutPath` effectively define `stderr` and `stdout` for our script.

#### STEP 3. `load` your job:

  ```bash
  $ launchctl load ~/Library/LaunchAgents/sdm.simple.exampleofPLIST.plist  
  $ 
  ```
***NOTE:*** `launchctl load` is done on the `.plist` ***file name***, whereas `launchctl start` is done on the `.plist` ***Label string***. Once the job is `load`*ed*, `launchd` will see that it is executed. There is no need to execute a `launchctl start ...`, unless you want the job started and run immediately. 

#### STEP 4. Monitor the output file:

  ```
  $ tail -f ~/echodatetime.log.txt  
  ```

You will see a datetime output in your terminal screen based on the timing you've used in your `StartCalendarInterval` key. 

#### STEP 5. Optional: `stop` and `unload` your job

If you decide to *retire* your `launchd` job, and don't wish it to run any longer, you still have a little work to do! You have to proactively `retire` your `launchd` job, or it will continue to run iaw your .plist file *forever*. This can be done in one of two ways: 

1. `unload` then `remove` the job using `launchctl`, and then delete or move the .plist file to location outside of `~/Library/UserAgents` :

```
$ launchctl unload ~/Library/LaunchAgents/sdm.simple.exampleofPLIST.plist  
$ launchctl remove seamus.simple.example  
$ mv ~/LaunchAgents/sdm.simple.exampleofPLIST.plist ~/archive
```
2. Leave the file where it is, but change the value of the `Disabled` key in the .plist to `true/` 

You can check the status of your `launchd` job as follows:

```
launchctl list | grep seamus
```

# Miscellany

- The `.plist` files above have been tested, and operated successfully on my macbook pro running Mojave (ver 10.14.6). Also verified the behavior of `launchd` when an event schedule occurs during `sleep`: The task ran immediately after the mac "woke up", and logged the time it awakened (i.e. not the scheduled time).

- Yes, the .plist syntax is arcane! Consider using [`LaunchControl`](https://www.soma-zone.com/LaunchControl/) instead of manually hacking these files.

- A potentially useful hint: You can check the syntax of your .plist file like so: 

```bash
$ plutil -lint /Users/seamus/Library/LaunchAgents/sdm.simple.exampleofPLIST.plist  
/Users/seamus/Library/LaunchAgents/sdm.simple.exampleofPLIST.plist: OK  
$
```

