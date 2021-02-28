## Installation Log & Notes

Following is a record of an Ubuntu installation on a late-2011 Macbook Pro. This is a "dual boot" installation - Ubuntu 20.04 alongside macOS High Sierra.



### 1. Let's see what we have on our 2TB SSD:

```bash
$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *2.0 TB     disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:                 Apple_APFS Container disk1         753.0 GB   disk0s2
   3:       Microsoft Basic Data OTHEROS                 1.2 TB     disk0s3

/dev/disk1 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +753.0 GB   disk1
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            371.8 GB   disk1s1
   2:                APFS Volume Preboot                 40.1 MB    disk1s2
   3:                APFS Volume Recovery                1.0 GB     disk1s3
   4:                APFS Volume VM                      8.6 GB     disk1s4


```



### 2. The "guide" for this installation: 
During this effort, we will use @japhwil's *recipe* for dual-boot installation of Ubuntu on a Mac as a guide. This *recipe* is documented in these answers: [Install Ubuntu 20.04 on Mac mini 2018 w/ Catalina](https://askubuntu.com/a/1245535/831935), and [In response to my question](https://askubuntu.com/a/1246811/831935) 
### 3. First step: Remove `rEFInd`, and any remains from a previous attempt:
`rEFInd` must be removed prior to the Ubuntu installation according to @japhwil's *recipe*. Let's first verify where `rEFInd` is located: 

```bash
$ sudo diskutil mount disk0s1 
$ $ ls -l /Volumes/EFI/EFI
total 4
drwxrwxrwx  1 jmoore  staff   512 Apr  4 21:30 APPLE
drwxrwxrwx  1 jmoore  staff  1024 Mar 18 04:23 refind
drwxrwxrwx  1 jmoore  staff   512 Mar 18 04:23 tools
```

***As an aside:*** On this (first) effort, we'll follow @japhwil's *recipe* strictly, and remove `rEFInd`, but we note that `rEFInd` seems to have been bypassed in a *boot coup*  by Apple during a recent update. One wonders then if it is actually necessary to remove `rEFInd` under this circumstance, but we'll leave that as an open question for now.

Instructions, advice and other information on removal of `rEFInd` are provided by:

- [this answer on SE](https://superuser.com/a/1139054) 
- [the `rEFInd` author's instructions](http://www.rodsbooks.com/refind/installing.html#uninstalling) 

After consulting these sources, we should **verify** that this is actually the true location of the `rEFInd` install by confirming that the file `refund.conf` is located there: 

```bash
$ ls -l /Volumes/EFI/EFI/refind
total 524
-rwxrwxrwx  1 jmoore  staff     140 Mar 18 04:23 BOOT.CSV
drwxrwxrwx@ 1 jmoore  staff   12800 Mar 18 04:23 icons
drwxrwxrwx  1 jmoore  staff    2560 Mar 18 04:23 keys
-rwxrwxrwx@ 1 jmoore  staff   31891 Mar 18 04:23 refind.conf
-rwxrwxrwx@ 1 jmoore  staff  219720 Mar 18 04:23 refind_x64.efi
```

`refind.conf` is present, so it's safe to conclude this is the installation location; i.e. this is where we will (at least temporarily) delete/remove/uninstall `rEFInd`: 

``` bash
$ cd /Volumes/EFI/EFI
$ $ ls -l
total 4
drwxrwxrwx  1 jmoore  staff   512 Apr  4 21:30 APPLE
drwxrwxrwx  1 jmoore  staff  1024 Mar 18 04:23 refind
drwxrwxrwx  1 jmoore  staff   512 Mar 18 04:23 tools
MacBook-2:EFI jmoore$ sudo rm -R refind
# For some reason, rm ignored -R & demanded confirmation on many files; e.g.:
# override rwxrwxrwx  _unknown/_unknown hidden for refind/icons/._os_linuxmint.png? y
# rm: refind/icons/._os_linuxmint.png: No such file or directory 
$ $ sudo rm -R tools
override rwxrwxrwx  _unknown/_unknown hidden for tools/._gptsync_x64.efi? y
rm: tools/._gptsync_x64.efi: No such file or directory
$ ls -l
total 1
drwxrwxrwx  1 jmoore  staff  512 Apr  4 21:30 APPLE
```

Note that the folder `tools` was part of the `rEFInd` installation, and therefore also deleted. And so now `rEFInd` is gone! 



### 4. Second step: [Preparations for installation](https://askubuntu.com/a/1245535/831935) 

- A bootable USB stick prepared previously will be used. It was created from the Ubuntu desktop ISO downloaded from Ubuntu's website, and written to USB using `balenaEtcher`. The Macbook has successfully booted into the "Live" Ubuntu system, and it is therefore a "good" copy. 
- A partition was also previously created, and should be sufficient. This partition is seen above under `diskutil list`, and is labeled: `Microsoft Basic Data OTHEROS`; i.e. a FAT partition of 1.2 TB in size. Checking the contents of this partition: 

   ```bash
   $ ls -la /Volumes/OTHEROS
   total 256
   drwxrwxrwx@ 1 jmoore  staff  32768 Jun  6 19:24 .
   drwxr-xr-x@ 4 root    wheel    128 Jun  6 19:24 ..
   drwxrwxrwx  1 jmoore  staff  32768 Jun  6 19:24 .Spotlight-V100
   drwxrwxrwx  1 jmoore  staff  32768 Jun  6 19:24 .Trashes
   drwxrwxrwx  1 jmoore  staff  32768 Jun  6 19:24 .fseventsd
   ```

- All hidden files created by macOS. Screenshots of `Disk Utility` and the `Info` tab are included below. Also note that during the re-formatting of `OTHEROS` partition, the scheme `GUID Partition Map` was not an available option. That option seems to be available only when the device is selected in `Disk Utility` - and as shown in the screenshot below, it is set raw the recipe.

And so **Preparations** appear to be complete. 



### 5. Third step: [Boot and Install Ubuntu](https://askubuntu.com/a/1245535/831935)  

- This Macbook predates Apple's "*innovative*" T2 chip, and so Step 1 is unnecessary. 
- `Shutdown...` Macbook, insert USB w/ Ubuntu ISO, press Power button, immediately press & hold the <kbd>option</kbd> key. 
- Interestingly, two (2) USB icons labeled `EFI boot` are displayed. Select the first & proceed.
- `GNU GRUB` menu appears on screen w/ several choices. The *recipe* says select the `Ubuntu` option, then "launch the Ubuntu installer via terminal", but there are options at the bottom of the screen for command line (`c`) and edit commands (`e`). Since the `c` and `e` options aren't mentioned, we'll simply press <kbd>enter</kbd>. 

  - This launches a process... 'Checking disks', then a GUI with an `Install Ubuntu` option. Followed this for a while, but no command line options were offered. Finally quit the installer & went to the "Live" system. Started terminal in Live system, `man ubiquity` showed no `-b` option. 

- Let's start over with a re-boot: This second effort went exactly as the first, suggesting that no *"opportunities"* were missed in the first attempt. Once again, a terminal was started in the Live system - this time the command `ubiquity -b` was entered. The output from this command appeared to be an error. I left the terminal window open with the apparently *"hung"* command in the terminal, and clicked the `Install` button in the GUI window. 
- The install process proceeded to a surprising, but successful completion! The only *challenge* came during the disk partitioning process, but this was aided by the graphical tool in the installer. I formatted the majority of the 1.25TB FAT32 partition as `ext4`; creating a small `swap` partition, and also created a small FAT32 partition as a *"shared"* area to be accessible from Ubuntu and macOS.
- Shortly thereafter, the installer announced it was finished, and instructed to power down, remove the USB stick and reboot. 



### 6. Fourth step: A Surprise Conclusion

I expected (hoped actually) that when I started the Macbook, and held down the <kbd>option</kbd> key, I would be greeted by the native macOS bootloader, offering two choices: macOS and Linux Ubuntu. I further expected that since the `ubiquity -b` command had not produced the hoped-for results, it may be necessary to remove GRUB from the EFI partition, and install rEFInd (*Confession*: I am not a big fan of GRUB). These were my **expectations**. 

Instead, when the macOS bootloader screen appeared, there was only one option: `Macintosh HD`. My initial disappointment turned to pleasant surprise when, after inspection, I realized that the EFI partition was unchanged (no GRUB)... apparently `ubiquity -b` had somehow worked! 

Installation of rEFInd was completed effortlessly, and I verified success by seeing the `rEFInd` folders in the EFI partition. After another reboot, the `rEFInd` screen appeared as expected. I chose the Linux system, and the new Ubuntu installation booted quickly.



```bash
$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *2.0 TB     disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:                 Apple_APFS Container disk1         753.0 GB   disk0s2
   3:       Microsoft Basic Data                         1.1 TB     disk0s3
   4:                 Linux Swap                         10.5 GB    disk0s4
   5:       Microsoft Basic Data SHARED                  68.5 GB    disk0s5

/dev/disk1 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +753.0 GB   disk1
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            372.0 GB   disk1s1
   2:                APFS Volume Preboot                 40.1 MB    disk1s2
   3:                APFS Volume Recovery                1.0 GB     disk1s3
   4:                APFS Volume VM                      8.6 GB     disk1s4


```



## Addendum:

### I. Partition Type

Note in the `diskutil list` output above that the partition containing the Linux installation (`disk0s3`) still has a `TYPE` of `Microsoft Basic Data` - the same value/type it had before the installation. This is due, I think, to the fact that this partition was originally formatted as `FAT32`. That label sticks, even though it is now formatted as `ext4`! 

According to @DavidAnderson on StackExchange, this can be left as-is, or it can be changed as follows:

```
Partition 3 is a microsoft type and should be a linux type.
From Ubuntu, open a Terminal window. Press the key combination option-control-T. Ener the command: sudo gdisk /dev/sda
Enter the following commands:
t
3
8300
w
y
Reboot the computer.
```



### II. `rEFInd` Adjustments

There are several adjustments that can be made to `rEFInd` to *personalize* it, and make it resistant to `boot coups`. These are mostly covered on the [`rEFInd` website](http://www.rodsbooks.com/refind/), and will be covered here once they've been tried.  