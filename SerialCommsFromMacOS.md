# Serial Communications Using Mac OS

Mac OS has the tools needed to communicate with all or most serial devices, but IMHO, they're not documented as well as they should be. I found it to be a bit of a trial-and-error process, but having been through that I find it works quite well now. Here's my system setup: 

### The hardware:

If you've got a recently-manufactured MacBook you'll have only USB-C ports (yeah, no DB9 connectors since the '60s :)   This means you'll need an **adapter cable** - a cable with a **USB-C** connector on one end, and a **DB9** connector on the other. This is not a DIY cable as there are USB-to-UART interface electronics packaged in the DB9 connector housing. My adapter cable is made by Tripp-Lite; it's called a [USB-C to DB9 Serial Adapter Cable](https://www.tripplite.com/usb-c-to-db9-serial-adapter-cable-male-male-5-ft~U209005C). I've found the cable itself works well, but it's ***NOT*** configured as a null modem cable. This means you'll need another piece of hardware: either a **null modem cable**, or a **null modem adapter**. An 8' to 12' cable will be a good choice because the Tripp-Lite adapter cable isn't very long, and that short length will be inconvenient at times.  

### The driver: 

I tried using the driver included (inconveniently on a mini-CD) with the Tripp-Lite cable. This was an exercise in frustration, and it really pissed me off because Tripp-Lite couldn't be bothered to do this correctly. Apple's native drivers just didn't cooperate for reasons I still don't understand. After wasting too much time, I found an ***excellent*** driver from [Jeroen Arnoldus](https://www.mac-usb-serial.com/). 

### Using `screen`:

Once a functional driver has been installed, and the adapter cable and null modem cable/adapter are in place, we're ready to make a connection. I'll be connecting to an [APU.2C2 from PC Engines GmbH](https://www.pcengines.ch/apu2.htm) hosting an [OpenBSD-based OPNsense firewall](https://opnsense.org/) as an example, and to verify things work as they should. However, the approach should work for connecting to any serial device. 

Checking documentation for the APU.2C2 and OPNsense, I determine that the required comm port specs are 115,200 bps, 8-N-1. 

> **Note:** It's entirely possible that the hardware device itself and the software hosted on that device may have different baud rate specifications. My APU.2C2 from [PC Engines GmbH](PC Engines GmbH) and the [OPNsense software](https://opnsense.org/) it hosts both use 115,200 baud, but this will not necessarily be the case with other hardware platforms. If this is your situation, you may be able to alter the baud rate setting of your device in its BIOS, or a configuration file that's used during the device's boot process. 

So I'm ready to communicate with my device: Start by launching a new terminal window, and proceed as follows: 

##### a. determine which driver to use:

```
$ ls -l /dev | grep Repleo
crw-rw-rw-  1 root    wheel           21,   9 Sep  7 00:01 cu.Repleo-PL2303-00005014
crw-rw-rw-  1 root    wheel           21,   8 Sep  6 19:24 tty.Repleo-PL2303-00005014
```

>  **Note:** use `cu.Repleo-PL2303-00005014` as we're initiating the connection *from* a UNIX-based system (e.g. Mac OS); i.e. [tty devices are for calling into UNIX systems, whereas CU (Call-Up) devices are for calling from them](https://pbxbook.com/other/mac-tty.html).

##### b. launch `screen` with the required driver, and the appropriate comm port specs:

```
screen /dev/cu.Repleo-PL2303-00005014 115200
```

After connecting power to the APU.2C2, we can follow the boot process on our `screen` terminal. Eventually we reach the login prompt for OPNsense



```
login: root
Password:
Last login: Mon Jun  5 14:58:05 on ttyu0
----------------------------------------------
|      Hello, this is OPNsense 18.1          |         @@@@@@@@@@@@@@@
|                                            |        @@@@         @@@@
| Website:      https://opnsense.org/        |         @@@\\\   ///@@@
| Handbook:     https://docs.opnsense.org/   |       ))))))))   ((((((((
| Forums:       https://forum.opnsense.org/  |         @@@///   \\\@@@
| Lists:        https://lists.opnsense.org/  |        @@@@         @@@@
| Code:         https://github.com/opnsense  |         @@@@@@@@@@@@@@@
----------------------------------------------

  0) Logout                              7) Ping host
  1) Assign interfaces                   8) Shell
  2) Set interface IP address            9) pfTop
  3) Reset the root password            10) Firewall log
  4) Reset to factory defaults          11) Reload all services
  5) Power off system                   12) Upgrade from console
  6) Reboot system                      13) Restore a backup

Enter an option: 8

root@OPNsense:~ # ls /dev/led
igb0    igb1    igb2
root@OPNsense:~ # echo f3 > /dev/led/igb0
root@OPNsense:~ # echo f2 > /dev/led/igb0
root@OPNsense:~ # echo f1 > /dev/led/igb0
root@OPNsense:~ # echo f0 > /dev/led/igb0
root@OPNsense:~ # echo 0 > /dev/led/igb0
root@OPNsense:~ # 
```

