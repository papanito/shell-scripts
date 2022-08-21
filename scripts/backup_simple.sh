#!/bin/bash
# @file backup_simple.sh
# @brief simple backup script
# @description
#     Simple backup script to save essential configurations and data as tar file
#
#     Backups the following folders
#
#     - /var/lib/mysql/
#     - /var/www
#     - /etc
#
#     Saves data to `/mnt/backup/'$today`
# @noargs

today=`date '+%Y%m%d'`
now=`date '+%Y%m%d%H%M'`

backupdir='/mnt/backup/'$today
if [ ! -d "$backupdir" ]; then
	mkdir $backupdir
fi

echo Backup will be stored at $backupdir
tar czfv $backupdir/var-lib-mysql-$now.tar.gz /var/lib/mysql/
tar czfv $backupdir/var-www-$now.tar.gz /var/www/
tar czfv $backupdir/etc-$now.tar.gz /etc/
