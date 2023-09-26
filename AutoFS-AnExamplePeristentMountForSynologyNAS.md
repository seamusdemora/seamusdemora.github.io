## AutoFS Example: A Peristent Mount for a Synology NAS

I needed a persistent mount for a share on my Synology NAS (model DS1621+, DSM 7.1.1-42962). As it turns out, this is a fairly straightforward configuration once you understand a wee bit of what is going on in Apple's AutoFS... made far more difficult by Apple's discontinuation of the documentation! Not to get too far off on a tangent, but I simply don't understand why Apple has removed the documentation for AutoFS, and why they seem to have abandoned development of it. If anyone has any background on this, I'd love to hear from you. In the meantime, I've managed to locate a [copy of the AutoFS documentation that may be accessed here](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/Autofs.pdf). 

### I. autofs for read-only file systems (Catalina & later)

Without further ado, here are the required changes for my Catalina and Ventura systems. Please note that the following operations require `root` privileges: 

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

You may choose an alternative name for `synology`, and `auto_synology` is a file containing details for the auto mount. 

#### 2. Create the file `/etc/auto_synology` with the following content:

```
syn_backup        -fstype=smbfs ://username:password@SynologyNAS-1/backups
syn_music         -fstype=smbfs ://username:password@SynologyNAS-1/music
syn_pictures      -fstype=smbfs ://username:password@SynologyNAS-1/pictures
```

My Synology NAS was configured with SMB (or CIFS) shares. In this example, I'm going to ***automount*** three (3) of them. Note the pattern: one line for each share you wish to automount. 
   * The first column is the share's name under the *mount point* (i.e. `/System/Volumes/Data/mnt/synology` from the `/etc/auto_master` entry). 

   * The 2nd column specifies the network file system format as defined for the share on the Synology server; in this case I used SMB

   * The 3rd column gives the userid & password defined for a valid user account on the Synology NAS, followed by the network name (`SynologyNAS-1`), and the proper share name as defined on the server.

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

1. I recently came across a very popular gist for [Automounting NFS shares in OS X](https://gist.github.com/L422Y/8697518) that may be useful for using AutoFS to automount NFS shares (my example is for SMB).

2. I've noticed that each time my OS is updated (or upgraded), Apple's installation routines ***revert*** any changes I've made to my `/etc/auto_master` file. I still do not understand **why** Apple does this, but I have discovered a cure for it. The following command will **preserve** all of my changes to `/etc/auto_master`, allowing it to survive (at least) Apple's updates:

   ```zsh
   sudo chflags simmutable /etc/auto_master

   # REF: 'man chflags' for details and options
   ```
