#!/bin/bash
#Simple backup script to save essential configurations and data as tar file

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
