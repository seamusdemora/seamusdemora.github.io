## AutoFS Example: A Peristent Mount for a Synology NAS

I needed **persistent, reliable** mounts for shares on my Synology NAS (model DS1621+, DSM 7.3.2-86009 Update 3), **and** as a destination for [Time Machine](https://en.wikipedia.org/wiki/Time_Machine_(macOS)) backups. The example here is a fairly straightforward configuration once you understand a wee bit of what's going on in Apple's AutoFS. But this necessary understanding is made far more difficult by Apple's discontinuation of the documentation! Not to get too far off on a tangent, but I simply don't understand why Apple has removed the documentation for AutoFS, and why they seem to have abandoned development of it. If anyone has any background on this, I'd love to [hear from you](https://github.com/seamusdemora/seamusdemora.github.io/issues). In the meantime, I've managed to locate a copy of the AutoFS documentation that may be accessed [here in PDF format](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/Autofs.pdf), or [here in GitHub markdown](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/AutoFS.md). 

### Before proceeding, here's an "inconvenient truth" regarding `autofs`:

| ***During any OS update or upgrade, Apple routinely replaces the file `/etc/auto_master` with their "DEFAULT" version; i.e. they replace/over-write any and all  changes you might have made to this file (and perhaps others). They do  this without warning or notification.*** |
| :----------------------------------------------------------- |

The significance of this comment will become obvious in the sequel; we get on with that below:

### I. autofs for read-only file systems (Catalina & later)

Without further ado, here are the required changes for my Catalina, Ventura and (*recently*) Tahoe systems. Please note that the following operations require `root` privileges: 

#### 1. Modify the file `/etc/auto_master` to add one line as shown below:

```
#
# Automounter master map
#

+auto_master            # Use directory service
#/net                   -hosts          -nobrowse,hidefromfinder,nosuid
/home                   auto_home       -nobrowse,hidefromfinder
/Network/Servers        -fstab
/-                      -static 

# above is default; add this one line: 
/System/Volumes/Data/mnt/synology       auto_synology
```

You may choose an alternative folder name in place of `synology`; `auto_synology` is a file (also in `/etc`) containing details for the auto mount. 

#### 2. Create the file `/etc/auto_synology` with the following content:

```
syn_backup        -fstype=smbfs ://username:password@SynologyNAS-1/backups
syn_music         -fstype=smbfs ://username:password@SynologyNAS-1/music
syn_pictures      -fstype=smbfs ://username:password@SynologyNAS-1/pictures
```

My Synology NAS was configured with SMB (aka CIFS) shares. In this example, I'm going to ***automount*** three (3) of them. Note the pattern: one line for each share you wish to automount. 
   * The first column is the share's name under the *mount point* (i.e. `/System/Volumes/Data/mnt/synology` from the `/etc/auto_master` entry). 

   * The 2nd column specifies the network file system format as defined for the share on the Synology server; in this case I used SMB

   * The 3rd column gives the userid & password defined for a valid user account on the Synology NAS, followed by the network name (`SynologyNAS-1` in this example), and the proper share name as defined on the server (e.g. `/backups`).

#### 3. Run the "magic command" to immediately apply all changes :)

Having modified the file `/etc/auto_master`, and created the `/etc/auto_synology` file, all that remains is to apply the changes:

```zsh
% sudo automount -vc
```

You should now find all the shares specified in `/etc/auto_synology` `mount`ed at the mount point specified in `/etc/auto_master`; i.e.: 

* `/System/Volumes/Data/mnt/synology/backups` 
* `/System/Volumes/Data/mnt/synology/music` 
* `/System/Volumes/Data/mnt/synology/pictures` 

### II. autofs for read-write file systems (Mojave & earlier)

The only change required is in the `/etc/auto_master` file. The single added line should reflect the more straightforward file system hierarchy:

```
# to the default auto_master file, add this one line: 
/Volumes/mnt/synology       auto_synology
```
The `/etc/auto_synology` file is identical, and the same "magic command" immediately applies all changes.

### III. Other Ideas:

Nothing exceptional here, I only wanted to make a point that creating *symbolic links* to the mount points can come in handy. As I use the *AutoFS* feature mostly to simplify routine access to network shares, I've found it useful to create *symlinks* that are convenient & useful in scripts & working from the command line. For example, I have created a symlink to the directory where my `rsync` backups are stored. The mount point is `/System/Volumes/Data/mnt/synology/syn_bkup` and the directory is `rsync-myMac`. To easily access that location, I've created the following symlink: 

```zsh
% ln -s /System/Volumes/Data/mnt/synology/syn_bkup/myMac ~/rsyn_bkup
```

## Other Potentially Useful & Interesting Stuff:

1. As noted above, I've noticed that each time my OS is updated (or upgraded), Apple's installation routines ***revert*** any changes I've made to my `/etc/auto_master` file. I still do not understand **why** Apple does this, but I have been forced to deal with it. My current solution is as follows: 

   ```zsh
   % cd /etc
   % sudo cp auto_master auto_master.backup
   % sudo chflags simmutable /etc/auto_master
   
   # REF: see 'man chflags' for details and options
   ```

   Note that it is not possible to protect the file `/etc/auto_master` from Apple! However, the .backup file (`/etc/auto_master.backup`) can be protected... but just to be sure, I also keep a copy of the backup in `$HOME`!  

2. An improvement to the solution in 1. above would be to create a background job using `launchd` that checked an MD5 signature of the `.backup` file to that of the `/etc/auto_master`. A mis-match in MD5 signatures could be used to set a notification. That's a *future* project.  :)  

3. If you happen to have "AppleCare*less*" support for your Mac, do not let one of their ignorant "tech support" staff tell you that NAS is not supported on current versions of macOS for Time Machine backups! In a rare moment of candor, even [Apple says that TM-NAS backup is supported](https://support.apple.com/en-my/guide/mac-help/mh15139/26/mac/26). 

4. If you happen to favor NFS over SMB for network mounts, I found a popular gist for [Automounting NFS shares in OS X](https://gist.github.com/L422Y/8697518) that may be useful.  Another approach to automounting NFS shares in macOS is provided in the blog post ["Persistent NFS mount points on macOS - Using vifs and fstab to mount NFS shares"](https://tisgoud.nl/2020/10/persistent-nfs-mount-points-on-macos/). 

5. **The AutoFS example here is not the only solution!** Recently (March-April, 2026) I've noticed that there seems to be an increasing number of alternative solutions for persistent network/NAS mounts for use in macOS. Perhaps this reflects growing frustration that [Apple - one of the three largest companies in the world](https://www.fool.com/research/largest-companies-by-market-cap/) - has no (actively maintained) solution for this common need ***?!*** Anyway - here's a short list of alternative solutions/approaches gleaned from simple searches on the Internet: 

     -  [Network Share Mounter](https://gitlab.rrze.fau.de/faumac/networkShareMounter) - free, open-source, GitLab
     -  [macOS-Drive-Mounter](https://github.com/PangeranWiguan/macOS-Drive-Mounter) - free, open-source, GitHub
     -  [AutoMounter](https://www.pixeleyes.co.nz/automounter/) - commercial, by 'PixelEyes', also available in AppStore 
     -  [Connect CIFS network drive under MacOS](https://www.tik.uni-stuttgart.de/support/anleitungen/fileservice-cifs/Connect_Network_Drive_MacOS.pdf) - a PDF "How-To" fm University of Stuttgart 
     -  [Volume Manager](https://plumamazing.com/volume-manager) - commercial, by 'plum amazing software' 
     -  [macOS Network Auto-Mount](https://github.com/ctrlcmdshft/macos-network-automount) - free, open-source, GitHub
     -  [a GitHub search for "automount"](https://github.com/topics/automount) - many other repos for automounting
     -  [a duck-duck search for auto mount software](https://duckduckgo.com/?t=ffab&q=macos%20auto%20mount%20software%20german%20university&ia=web) - produced several in above list & more 

## REFERENCES: 

1.  [Autofs: Automatically Mounting Network File Shares in Mac OS X](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/AutoFS.md) - in Markdown format
2.  [Autofs: Automatically Mounting Network File Shares in Mac OS X](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/Autofs.pdf) - in PDF format 
3.  [Introduction to Autofs in Mac OS X](https://lowendmac.com/2009/introduction-to-autofs-in-mac-os-x/) - a brief, but informative blog by Keith Winston, 2009 
4.  [Autofs on Mac OS X](https://gist.github.com/rudelm/7bcc905ab748ab9879ea) - rudelm's GitHub gist; 14 revisions, 251 stars (*current and popular*) 
5.  [Network Share Mounter](https://gitlab.rrze.fau.de/faumac/networkShareMounter) - a free & open-source alternative to AutoFS from Germany
