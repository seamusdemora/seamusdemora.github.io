# Serial Communications Using Mac OS

Mac OS has the tools needed to communicate with all or most serial devices, but IMHO, they're not documented as well as they should be. I found it to be a bit of a trial-and-error process, but having been through that I find it works quite well now. Here's my system setup: 

### The Hardware:

If you've got a recently-manufactured MacBook you'll have only USB-C ports (yeah, no DB9 connectors since the '60s :)   This means you'll need an **adapter cable** - a cable with a **USB-C** connector on one end, and a **DB9** connector on the other. This is not a DIY cable as there are USB-to-UART interface electronics packaged in the DB9 connector housing. My adapter cable is made by Tripp-Lite; it's called a [USB-C to DB9 Serial Adapter Cable](https://www.tripplite.com/usb-c-to-db9-serial-adapter-cable-male-male-5-ft~U209005C). I've found the cable itself works well, but it's ***NOT*** configured as a null modem cable. This means you'll need another piece of hardware: either a **null modem cable**, or a **null modem adapter**. A **null modem cable** approximately 3 meters in length may be a good choice because the Tripp-Lite adapter cable isn't very long, and its short length will be inconvenient at times. 

Of course if your serial device is in the next room, you may need a longer cable. However, know that beyond a certain cable length, the [RS-232](https://www.lammertbies.nl/comm/info/rs-232-specs) signal will begin to degrade, and eventually cease to function. The length limit is a function of *baud rate* and the *capacitance* of the cable used. The old RS-232 specification called out 50 feet (16 m) as a length limit, but this was based on a total cable capacitance of 2,500 pf (pico farads). By using "modern" cable ([reference](https://www.quabbin.com/tech-briefs/why-cable-capacitance-important-electronic-applications)) it's possible to extend the length of the cable and/or the baud rate - but again, there are limits. 

### A Diversion to [Blether](https://www.thefreedictionary.com/blether) About Maximum Cable Length for RS-232:

If you need to push the limit on cable length, here's the general approach: 

- Know your operating frequency & [why it's important](https://www.eetimes.com/getting-the-most-out-of-your-twisted-pair-cable/#). For <u>example</u>, at 115,200 baud, the cable should have an operating frequency of around 1.5 MHz, roughly (very) estimated as follows: 

   - **transition rate = 115,200 * 1.25 = 144 kHZ**; to account for the start/stop & parity bits 

   - I'll do a bit of "fudging" here in the interest of brevity: **a)** We know that [square waves are rich in harmonics (overtones)](http://www.informit.com/articles/article.aspx?p=1374896&seqNum=7). **b)** [Nyquist informed us](http://microscopy.berkeley.edu/courses/dib/sections/02Images/sampling.html) that we must sample at a rate of at least twice the fundamental frequency to recover that signal. If we assume we need the 3rd and 5th harmonics to guarantee "good" signal fidelity at the end of the cable, then Nyquist would say we need: 

      **Nyquist Freq = 2 * 5 * 144 kHz = 1.44 MHz**  

- Find the manufacturer's published specifications for *capacitance per unit length* (at or above the operating frequency). As an example, let's choose [this cable](https://www.quabbin.com/products/general-purpose-wire-cable/multipair/rs-232/8508) that has 13 pf/foot (43 pf/m). 

- Do the math: **L<sub>max</sub> = 2,500 / 43 = 58 meters**  

### The Driver:

I tried using the driver included (inconveniently on a mini-CD) with the Tripp-Lite cable. This was an exercise in frustration, and it really pissed me off! **Why?** ***Because Tripp-Lite couldn't be bothered to do this correctly***. Apple's native drivers just didn't cooperate for reasons I still don't understand. After wasting too much time, I found an ***excellent*** driver from [Jeroen Arnoldus](https://www.mac-usb-serial.com/). Owners of new Macs will be glad to know this driver is compatible with [Mac OS *Catalina*](https://en.wikipedia.org/wiki/MacOS_Catalina). 

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



```bash
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
root@OPNsense:~ # echo f3 > /dev/led/igb0   # turn the LEDs ON & OFF
root@OPNsense:~ # echo f2 > /dev/led/igb0
root@OPNsense:~ # echo f1 > /dev/led/igb0
root@OPNsense:~ # echo f0 > /dev/led/igb0
root@OPNsense:~ # echo 0 > /dev/led/igb0
root@OPNsense:~ # 
```



### Terminating `screen`: 

When you're finished, you may wonder how to quit `screen`! As with all things, it's only difficult when you don't know how - here's how: 

```bash
$ screen -ls        # retrieves list of all screen sessions; for example:
There is a screen on:
	1172.ttys001.MyMacbookPro	(Attached)
1 Socket in /var/folders/9t/_1d0fdt969x5s97bnfz40jdw0000gp/T/.screen.
$ screen -XS 1172.ttys001.MyMacbookPro quit
# c'est finis
```

