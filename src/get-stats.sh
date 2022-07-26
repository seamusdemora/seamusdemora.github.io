#!/bin/zsh

# also works w/ bash: /opt/local/bin/bash for GNU bash via MacPorts, or /bin/bash
#
# script name 'get-stats.sh`:
# macOS - Compare stat's of two folders: SOURCE_ORIGINAL & DEST_RESTORE. Typical usage
# is evaluating rsync options to determine any loss of meta-data between the source dir 
# of an rsync backup against the corresponding rsync dest after restoration:
#
#                      rsync backup          rsync restore
#     SOURCE_ORIGINAL  ----------->  BACKUP  ------------>   DEST_RESTORE
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
