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

