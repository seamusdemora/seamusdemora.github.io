## Use rsync on macOS Without Losing Data

Backups are typically done using Network Attached Storage (NAS) devices. There are numerous file systems in use to support that, but if you're using one of the jumbo storage units, your choices may be limited. But even if the manufacturer offers a multitude of file system options, time and the learning curve may push you toward a familiar option - one you've already invested time and effort in learning. When bringing my new Synology NAS online recently, I found there are other factors that may limit your choices. I found Synology's documentation and technical support *sorely lacking*; i.e. non-existent. 

Without belaboring that further, I'll just explain the issue, and provide the solution I developed. 

### The issue is *metadata* - how to avoid losing it:

This is probably best explained by a brief example: Consider a folder on your macOS local drive for which you want to create a backup using `rsync`. Let's see what happens: 

```bash
# From my macOS Terminal.app:
% ls -lR xyz-original 
total 16
-rw-r--r--@ 1 seamus  staff   28 Jun 15 01:51 README1
-rw-r-----  1 seamus  staff   30 Jun 20 14:50 ReadMe2
lrwxr-xr-x  1 seamus  staff   26 Jun 20 15:22 f1f2 -> ./folder1/folder1-file2.sh
drwxr-xr-x  4 seamus  staff  128 Jun 20 15:10 folder1

xyz-original/folder1:
total 0
-rw-------  1 seamus  staff  0 Jun 20 15:09 folder1-file1.txt
-rwxr-x---  1 seamus  staff  0 Jun 20 15:10 folder1-file2.sh
# i.e. 2 files, a symlink and a subfolder with two more files; a variety of permissions
```

Note the user & group ownership, the modes (permissions), and the modification time-stamps for each file, folder and link. These parameters are collectively referred to as *meta-data*. When using `rsync` as a backup solution, you will naturally expect that all meta-data will be recovered if and when your backup is restored. Unfortunately, that does not happen automatically or by default - as shown below. In this example, the folder `xyz-original` has been backed up to a NAS drive (my Synology `DS1621+` in this case) in folder `xyz-backup`, and then restored to my local folder `xyz-restored` using `rsync`:  

```bash
# make a back up of `xyz-original` on the Synology NAS:
% rsync -avi ~/xyz-original/ /System/Volumes/Data/mnt/synology/syn_backup/xyz-backup          
sending incremental file list
.d..tp.g.... ./
>f++++++++++ README1
>f++++++++++ ReadMe2
cL++++++++++ f1f2 -> ./folder1/folder1-file2.sh
cd++++++++++ folder1/
>f++++++++++ folder1/folder1-file1.txt
>f++++++++++ folder1/folder1-file2.sh

sent 506 bytes  received 110 bytes  1,232.00 bytes/sec
total size is 84  speedup is 0.14

# restore 'xyz-backup' from the Synology NAS to local folder 'xyz-restored' for comparison: 
% rsync -avi /System/Volumes/Data/mnt/synology/syn_backup/xyz-backup/ ~/xyz-restored 
sending incremental file list
.d..tp...... ./
>f++++++++++ README1
>f++++++++++ ReadMe2
cL++++++++++ f1f2 -> ./folder1/folder1-file2.sh
cd++++++++++ folder1/
>f++++++++++ folder1/folder1-file1.txt
>f++++++++++ folder1/folder1-file2.sh

sent 454 bytes  received 110 bytes  1,128.00 bytes/sec
total size is 84  speedup is 0.15
```
Compare the metadata:
```bash
# compare 'xyz-original' to 'xyz-restored':
% ls -lR xyz-restored
total 16
-rwx------  1 seamus  staff   28 Jun 15 01:51 README1
-rwx------  1 seamus  staff   30 Jun 20 14:50 ReadMe2
lrwx------  1 seamus  staff   26 Jun 20 15:22 f1f2 -> ./folder1/folder1-file2.sh
drwx------  4 seamus  staff  128 Jun 20 15:10 folder1

xyz-restored/folder1:
total 0
-rwx------  1 seamus  staff  0 Jun 20 15:09 folder1-file1.txt
-rwx------  1 seamus  staff  0 Jun 20 15:10 folder1-file2.sh
```

Which is clearly different from the `ls -lR xyz-original` result shown above. This comparison may be easily automated using the following script - `get-stats.sh`; [latest version](src/get-stats.sh): 

```bash
#!/bin/zsh

# also works w/ bash: /opt/local/bin/bash if you're using GNU bash via MacPorts, or /ban/bash
#
# script name 'get-stats.sh`:
# macOS - Compare stat's of source dir for rsync backup against rsync dest after restore:
# used to evaluate rsync options for their ability to restore files & folders previously 
# backed up on the SynologyNAS drive with the same ownership & permissions as original.
#
# Assumes ./xyz-original & ./xyz-restored are located in $HOME

cd $HOME
SOURCE_ORIGINAL="xyz-original"
DEST_RESTORE="xyz-restored"
STATFILE_ORIGINAL="xyz-original-stat.txt"
STATFILE_RESTORED="xyz-restored-stat.txt"
STATFILE_DIFF="stat_diffs.txt"

cd $SOURCE_ORIGINAL
find . -exec stat --format='%n %A %U %G' {} \; | sort > $HOME/$STATFILE_ORIGINAL 
cd ../$DEST_RESTORE
find . -exec stat --format='%n %A %U %G' {} \; | sort > $HOME/$STATFILE_RESTORED
cd $HOME
# run `diff` on files containing `stat` results for comparison & output results:
diff -sy --suppress-common-lines $STATFILE_ORIGINAL $STATFILE_RESTORED > $STATFILE_DIFF

cat $STATFILE_DIFF
```

The `get-stats.sh` script confirms the loss of *metadata* for this backup, but the ***burning question*** remains un-answered: ***How do we avoid loss of metadata with `rsync` in this situation?*** 

### Avoiding metadata loss in `rsync` backup-restore cycle: 

```bash
# repeat the previous backup-restore cycle with a NEW SET OF OPTIONS:
% rsync -rlAXtgoDiv --fake-super ~/xyz-original/ /System/Volumes/Data/mnt/synology/syn_backup/xyz-backup 
# ... output controlled by options `i` and `v`

% rsync -rlAXtgoDiv --fake-super /System/Volumes/Data/mnt/synology/syn_backup/xyz-backup/ ~/xyz-restored 
# ...

# compare the `stat` results to reveal any differences in metadata between `xyz-original` and `xyz-restored`:
% ./get-stats.sh
Files xyz-original-stat.txt and xyz-restored-stat.txt are identical
```

This backup-restore cycle lost no metadata. A brief explanation of each of the `rsync` options follows; see `man rsync` for details.

```
#  -r					recursive; recurse into directories
#  -l					copy symlinks as symlinks
#  --acls, -A           preserve ACLs (implies --perms, -p)
#  --xattrs, -X         preserve extended attributes
#  -t					preserve modification times
#  -g					preserve group
#  -o					preserve owner
#  -D					preserve devices and special files
#  -v					increased verbosity; may be repeated
#  -i					itemize changes
#  --fake-super			store/recover privileged attrs using xattrs (for ACLs & XATTRs)
```









---

### REFERENCES: 

1. [Rsync between Mac and Linux](https://odd.blog/2020/10/06/rsync-between-mac-and-linux/); a few words re `--iconv` - the `rsync` character set conversion option 
2. [Why add a trailing slash after an rsync destination?](https://unix.stackexchange.com/questions/402555/why-add-a-trailing-slash-after-an-rsync-destination) ; a trailing `/` plays an important role for src & dest
