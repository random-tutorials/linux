#!/bin/bash

echo "Cleaning up space, removing packages no longer required"
sudo apt autoremove

echo "Cleaning up space with journalctl"
sudo journalctl --disk-usage
sudo journalctl --vacuum-time=3d

echo "Cleaning up space, removing apt cache"
sudo du -sh /var/cache/apt 
sudo apt clean

echo "Cleaning up space, removing thumbnails cache"
du -sh ~/.cache/thumbnails
rm -rf ~/.cache/thumbnails/*

# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
read -p "CLOSE ALL SNAPS BEFORE RUNNING THIS, then Press Enter to continue" < /dev/tty

du -h /var/lib/snapd/snaps

set -eu
sudo snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

echo "Old revisions of snaps cleaned, you have now this much space used by snaps"
du -h /var/lib/snapd/snaps
