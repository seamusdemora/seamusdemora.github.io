# An AutoFS Example:

I needed **persistent, reliable, on-demand** mounts for shares on my Synology NAS (model DS1621+, DSM 7.3), **and** as a destination for [Time Machine](https://en.wikipedia.org/wiki/Time_Machine_(macOS)) backups. The example here is a fairly straightforward configuration once you understand a wee bit of what's going on in Apple's AutoFS. This necessary understanding is made far more difficult by Apple's discontinuation of support for it, and removal of the documentation from their website! 

Not to get too far off on a tangent, but I simply don't understand why Apple has removed the documentation for AutoFS, and why they seem to have abandoned development of it. Do they have a more modern replacement? ... ***I don't think so***.  If anyone has any background on this, I'd love to [hear from you](https://github.com/seamusdemora/seamusdemora.github.io/issues). In the meantime, I've managed to locate a copy of the AutoFS documentation that may be accessed [here in PDF format](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/Autofs.pdf), or [here in GitHub markdown](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/AutoFS.md). 

#### Before proceeding, be aware of Apple's "*active* inconvenience" :

| ***During any OS update or upgrade, Apple routinely replaces the file `/etc/auto_master` with their "DEFAULT" version; i.e. they replace/over-write any and all  changes you might have made to this file (and perhaps others). They do  this without warning or notification.*** |
| :----------------------------------------------------------- |

The significance of this comment will become obvious in the sequel; [we address it below](#other-potentially-useful-interesting-or-annoying-stuff): 

## AutoFS for recent OS versions (Catalina & later)

Without further ado, here is the **autofs** configuration for my Catalina, Ventura and (*recently*) Tahoe systems. Please note that the following operations require `root` privileges: 

### 1. Locate and edit file `/etc/auto_master` as below:

```
% cd /etc
% sudo nano auto_master			# choose your favorite editor
------------------------------------------------------------
#
# Automounter master map
#

+auto_master            # Use directory service
#/net                   -hosts          -nobrowse,hidefromfinder,nosuid
/home                   auto_home       -nobrowse,hidefromfinder
/Network/Servers        -fstab
/-                      -static 

# all the above is default; add the following line(s): 
/System/Volumes/Data/mnt/synology       auto_synology_indirect
/-										auto_synology_direct  
------------------------------------------------------------
# save the file, exit the editor
% 
```

The last two lines in `/etc/auto_master` inform **autofs** that "*maps*" for the ***indirect mounts*** are located in the file `/etc/auto_synology_indirect`, and that maps for the ***direct mounts*** are located in the file `/etc/auto_synology_direct`. You can name these files whatever you like; I chose these names to remind me of their different purposes. 

Now, let's answer some questions you may have:

| Q1: *"What's the difference between an indirect mount and a direct mount?"* |
| :----------------------------------------------------------- |
| Well... you can read [this section of the AutoFS White Paper](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/AutoFS.md#direct-indirect-and-executable-maps)... perhaps you can make more sense of it than I could? Put another way, *"I don't really know!"* But I have learned this much: ***A direct mount is needed for reliable Time Machine backups.*** More on that to follow. |

| Q2: *"Why did you choose `/System/Volumes/Data` as the location for `./mnt` ?"* |
| :----------------------------------------------------------- |
| **Because it seems to work!** *Seriously*: Apple's ability to mount NAS drives *anywhere* appears tenuous and ever-changing; numerous issues and complaints have been reported! But don't take my word for it - do your own research, or try it yourself. I realize this location for a mount point is unorthodox, but it has worked on Ventura for 3+ years, and it does work on Tahoe - as of ver 26.5. Of course you are free to try Apple's recommended location of `/Volumes`.  As a closed-source, proprietary OS and filesystem that is poorly documented, my view is that it is *inscrutable*, and so I *"stick with what works for me"*. |

| Q3: *"Why can `Finder` not navigate to `/System/Volumes/Data`?"* |
| :----------------------------------------------------------- |
| I have no idea why, but [others have reported the issue](https://forums.macrumors.com/threads/navigate-system-volumes-data-in-finder-file-open-dialog.2346503/). However, while `Finder` navigation is *far from straightforward*, you can get there (at least in macOS Tahoe 26.5) via the following procedure: |
  -  In `Finder` navigate to:  `/System/Volumes/Macintosh HD`, 
  -  Then, ***right-click*** the `Macintosh HD` icon, and select "`Open Macintosh HD in new tab`". 

-  In the new `Finder` tab you will find a folder called `mnt` - which may be empty, ***BUT*** 
-  `/System/Volumes/Macintosh HD/mnt` (aka `/System/Volumes/Data/mnt`) will eventually contain your AutoFS mounts once you complete the procedure below. 
-  A far easier way to get there is avoid Apple's *chicanery*, and access the folder ***directly*** using the `Terminal.app` via the following commands: `cd /System/Volumes/Data` or `ls -l /System/Volumes/Data`. 



### 2. Create the file `/etc/auto_synology_indirect` as follows:

```
syn_backups     -fstype=smbfs   ://username:password@SynologyNAS-1/backups
syn_music       -fstype=smbfs   ://username:password@SynologyNAS-1/music
syn_pictures    -fstype=smbfs   ://username:password@SynologyNAS-1/pictures
```

My Synology NAS is configured with SMB shares. In this step, we ***automount*** three (3) of them as **indirect-mounts**. Note the pattern: one line with three columns for each share you wish to automount. 
   * The first column is the share's name under the *mount point* (i.e. `/System/Volumes/Data/mnt/synology` from the `/etc/auto_master` entry). 

   * The 2nd column specifies the network file system format as defined for the share on the Synology server; in this case I used SMB: `-fstype=smbfs`

   * The 3rd column gives the userid & password defined for a valid user account on the Synology NAS, followed by the network name (`SynologyNAS-1` in this example) or IP address, and the *proper share name as defined on the server* (e.g. `/backups`). 



### 3. Create the file `/etc/auto_synology_direct` as follows: 

```
/System/Volumes/Data/mnt/synology/syn_tm_for_toadie  -fstype=smbfs ://username:password@SynologyNAS-1/TM-for-toadie
```

In this step we ***automount*** a single share from SynologyNAS-1 as a **direct-mount**. We use the **direct-mount** because this share is used as a **Time Machine backup** for my MacBook named **toadie**. Note - as before - the pattern of a single line with three columns for each share. You may also note the difference between the **indirect** and **direct** mount specification is limited to the first column: the **direct mount** employs a complete volume and folder specification. 



### 4. Verify the mount point exists in the required location :

```zsh
% ls -l /System/Volumes/Data 
total 1
drwxrwxr-x 53 root admin 1696 May 16 23:00 Applications
drwxr-xr-x  2 root wheel   64 Mar 17 20:05 cores
dr-xr-xr-x  2 root wheel    1 May 15 16:47 home
drwxr-xr-x 67 root wheel 2144 May 15 16:47 Library
drwxr-xr-x  3 root wheel   96 Apr 24 00:27 mnt			# <=== VERIFY ./mnt present
drwxr-xr-x  3 root wheel   96 Apr 21 23:25 MobileSoftwareUpdate
drwxr-xr-x  4 root wheel  128 Apr 21 23:25 opt
...
% 
```

If there is no `./mnt` folder in `/System/Volumes/Data`, you must create one: 

```zsh
% cd /System/Volumes/Data && sudo mkdir mnt
# verify its creation, permissions and ownership are as shown above
# also note that you can (optionally) create a folder(s) under ./mnt;
# e.g. 'synology' in my case to organize your mount points if you're so inclined
```



### 5. Run the "magic command" to immediately apply all changes :)

Having modified the file `/etc/auto_master`, and created the files `/etc/auto_synology_indirect` and `/etc/auto_synology_direct`, all that remains is to apply the changes using the `automount` command:

```zsh
% sudo automount -vc
```

You should now find all the shares specified in `/etc/auto_synology_indirect` `mount`ed at the mount point specified in `/etc/auto_master`; i.e.: 

```zsh
% ls -l /System/Volumes/Data/mnt/synology
total 3 
dr-xr-xr-x 2 root wheel 1 May 22 14:48 syn_backups
dr-xr-xr-x 2 root wheel 1 May 22 14:48 syn_music
dr-xr-xr-x 2 root wheel 1 May 22 14:48 syn_pictures
```

***BUT...*** Where is the **direct-mount** `/System/Volumes/Data/mnt/synology/syn_tm_for_toadie`? 

You can find the **direct-mounted** SynologyNAS-1 share in ... (*drum roll, please*) `/Volumes`!  Oddly, with some caveats on viewing: 

```zsh
% ls -l /Volumes
ls: cannot access '/Volumes/syn_tm_for_toadie': Permission denied
total 0
drwxr-xr-x 3 root wheel 96 Apr 22 01:17  com.apple.TimeMachine.localsnapshots
lrwxr-xr-x 1 root wheel  1 May 15 16:48 'Macintosh HD' -> /
d????????? ? ?    ?      ?            ?  syn_tm_for_toadie  

# WTF,O ??

% sudo !!
sudo ls -l /Volumes
total 16
drwxr-xr-x 3 root wheel    96 Apr 22 01:17  com.apple.TimeMachine.localsnapshots
lrwxr-xr-x 1 root wheel     1 May 15 16:48 'Macintosh HD' -> /
drwx------ 1 root wheel 16384 May 21 10:50  syn_tm_for_toadie 
%
```

At present, I am at a complete loss to explain the odd permissions/attributes that were set by macOS Tahoe 26.5 for `/Volumes/syn_tm_for_toadie`.  I'm continuing to experiment, and will update when/if I find an answer. ***HOWEVER***, the good news is that Time Machine is happy, and has made a successful backup: 

```zsh
% sudo tmutil setdestination smb://myusernm:mypasswd@NetgearNAS-1/TM-for-toadie

% tmutil startbackup 

% 
```

![TM-screenshot-autofs](./pix/TM-screenshot-autofs.png)





## AutoFS for earlier OS versions (Mojave & earlier)

The only change required is in the `/etc/auto_master` file. The single added line should reflect the more straightforward file system hierarchy:

```
# to the default auto_master file, add this one line: 
/Volumes/mnt/synology       auto_synology
```
The `/etc/auto_synology` file is identical, and the same "magic command" immediately applies all changes.



## Miscellany:

Nothing exceptional here, I only wanted to make a point that creating *symbolic links* (or perhaps  a macOS `alias`?) to the mount points can come in handy. As I use the *AutoFS* feature mostly to simplify routine access to network shares, I've found it useful to create *symlinks* that are convenient & useful in scripts & working from the command line. For example, I have created a symlink to the directory where my `rsync` backups are stored. The mount point is `/System/Volumes/Data/mnt/synology/syn_backups` and the directory is `rsync-myMac`. To easily access that location, I've created the following symlink: 

```zsh
% ln -s /System/Volumes/Data/mnt/synology/syn_backups/rsync-myMac ~/rsyn_bkup
```



## Other Potentially Useful, Interesting or Annoying Stuff:

1. As noted above, I've noticed that each time my OS is updated (or upgraded), Apple's installation routines ***revert*** any changes I've made to my `/etc/auto_master` file. I still do not understand **why** Apple does this, but I have been forced to deal with it. My current solution is to make a backup copy of my autofs configuration files in `/etc` (`auto_master`, `auto_synology_indirect` and `auto_synology_direct`), and set the system-level `immutable` flag on the backups: 

   ```zsh
   % cd /etc
   % sudo cp auto_master auto_master.backup
   % sudo chflags simmutable /etc/auto_master.backup
   
   # REF: see 'man chflags' for details and options
   ```

   Note that the `immutable` flag will not protect the file `/etc/auto_master` from Apple! The backup file (`/etc/auto_master.backup`) can be protected (at least for now)... but just to be safe, I also keep a copy of the `immutable` backup in `$HOME`!  

2. An improvement to the solution in 1. above would be to create a background job using `launchd` that checked an MD5 signature of the `.backup` file to that of the `/etc/auto_master`. A mis-match in MD5 signatures could be used to set a notification, or automatic restoration, but that's a *future* project.  :)  

3. If you happen to have "AppleCare*less*" support for your Mac, do not let one of their ignorant "tech support" staff waste your time after telling you, "*No - NAS is not supported on current versions of macOS for Time Machine backups!*" (Yes - this actually happened to me.) In a rare moment of candor, even [Apple says that TM-NAS backup is supported](https://support.apple.com/en-my/guide/mac-help/mh15139/26/mac/26). 

4. If you happen to favor NFS over SMB for network mounts, I found a popular gist for [Automounting NFS shares in OS X](https://gist.github.com/L422Y/8697518) that may be useful.  Another approach to automounting NFS shares in macOS is provided in the blog post ["Persistent NFS mount points on macOS - Using vifs and fstab to mount NFS shares"](https://tisgoud.nl/2020/10/persistent-nfs-mount-points-on-macos/). 

5. **The AutoFS example here is not the only solution!** Recently (April-May, 2026) I've noticed that there seems to be more alternative solutions/apps for persistent network/NAS mounts for use in macOS. Perhaps this reflects growing frustration that [Apple - one of the three largest companies in the world](https://www.fool.com/research/largest-companies-by-market-cap/) - has no (actively maintained) solution for this common need ***?!*** Following is a short and incomplete list of alternative solutions for auto-mounting gleaned from simple searches on the Internet: 

     -  [Network Share Mounter](https://gitlab.rrze.fau.de/faumac/networkShareMounter) - free, open-source, GitLab
     -  [macOS-Drive-Mounter](https://github.com/PangeranWiguan/macOS-Drive-Mounter) - free, open-source, GitHub
     -  [AutoMounter](https://www.pixeleyes.co.nz/automounter/) - commercial, by 'PixelEyes', also available in AppStore 
     -  [Connect CIFS network drive under MacOS](https://www.tik.uni-stuttgart.de/support/anleitungen/fileservice-cifs/Connect_Network_Drive_MacOS.pdf) - a PDF "How-To" fm University of Stuttgart 
     -  [Volume Manager](https://plumamazing.com/volume-manager) - commercial, by 'plum amazing software' 
     -  [macOS Network Auto-Mount](https://github.com/ctrlcmdshft/macos-network-automount) - free, open-source, GitHub
     -  [a GitHub search for "automount"](https://github.com/topics/automount) - many other repos for automounting
     -  [a duck-duck search for auto mount software](https://duckduckgo.com/?t=ffab&q=macos%20auto%20mount%20software%20german%20university&ia=web) - produced several in above list & more 



## REFERENCES *and* ALTERNATIVES: 

1.  [Autofs: Automatically Mounting Network File Shares in Mac OS X](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/AutoFS.md) - in Markdown format
2.  [Autofs: Automatically Mounting Network File Shares in Mac OS X](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/Autofs.pdf) - in PDF format 
3.  [Introduction to Autofs in Mac OS X](https://lowendmac.com/2009/introduction-to-autofs-in-mac-os-x/) - a brief, but informative blog by Keith Winston, 2009 
4.  [Autofs on Mac OS X](https://gist.github.com/rudelm/7bcc905ab748ab9879ea) - rudelm's GitHub gist; 14 revisions, 251 stars (*current and popular*) 
5.  [Network Share Mounter](https://gitlab.rrze.fau.de/faumac/networkShareMounter) - a free & open-source alternative to AutoFS from Germany



<!--- 

You can hide shit in here  :)   LOL 

POINT: "/Volumes (actually /System/Volumes/Data/Volumes) is just a directory  owned by Finder to mount volumes. Since it's owned by Finder, it's not a good idea to use it for mounting volumes using any other method."  [**REF**](https://discussions.apple.com/thread/256271046?answerId=261889439022#261889439022), but compare this POINT to this [DDG search](https://duckduckgo.com/?t=ffab&q=in%20macOS%20is%20%2FSystem%2FVolumes%2FData%2FVolumes%20the%20same%20location%20as%20%2FVolumes%3F&ia=web).  

--->
