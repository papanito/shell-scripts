#!/usr/bin/env bash
#########################################################################
#Name: backup-docker-volumes.sh
#Subscription: This Script backups docker volumes to a backup directory
##by A. Laub
#andreas[-at-]laub-home.de
#
#License:
#This program is free software: you can redistribute it and/or modify it
#under the terms of the GNU General Public License as published by the
#Free Software Foundation, either version 3 of the License, or (at your option)
#any later version.
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#or FITNESS FOR A PARTICULAR PURPOSE.
#########################################################################
#Set the language
export LANG="en_US.UTF-8"
#Load the Pathes
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# set the variables

# Where to store the Backup files?
if [[ -z "$BACKUPDIR" ]]; then
    BACKUPDIR=/var/backup/
fi

# How many Days should a backup be available?
if [[ -z "$DAYS" ]]; then
    DAYS=2
fi

# Timestamp definition for the backupfiles (example: $(date +"%Y%m%d%H%M") = 20200124-2034)
TIMESTAMP=$(date +"%Y%m%d%H%M")

# if you want to use memory limitation. Must be supported by the kernel.
#MEMORYLIMIT="-m 35m"
function docker_backup:compose {
    # Which Docker Compose Project you want to backup?
    # Docker Compose Project pathes separated by space
    #COMPOSE="/opt/project1 /opt/project2"
    # you can use the following two big command to read out all compose projects
    # uncommend if you like to read automatic all projects:
    ALLCONTAINER=$(docker ps --format '{{.Names}}')
    ALLPROJECTS=$(for i in $ALLCONTAINER; do docker inspect --format '{{ index .Config.Labels "com.docker.compose.project.working_dir"}}' $i; done | sort -u)
    # then to use all projects without filtering it:
    COMPOSE=$ALLPROJECTS
    # you can filter all Compose Projects with grep (include only) or grep -v (exclude) or a combination
    # to do a filter for 2 or more arguments separate them with "\|"
    # example: $(echo $ALLPROJECTS |grep 'project1\|project2' | grep -v 'database')
    # to use volumes with name project1 and project2 but not database
    #COMPOSE=$(echo -e "$ALLPROJECTS" | grep 'project1\|project2' | grep -v 'database')
    #COMPOSE=$(echo -e "$ALLPROJECTS" | grep -v 'mailcow-dockerized')

    BACKUPDIR=$BACKUPDIR/compose
    ### Do the stuff
    echo -e "Start $TIMESTAMP Backup for Docker Compose Projects:\n"
    if [ ! -d $BACKUPDIR ]; then
	    mkdir -p $BACKUPDIR
    fi

    for i in $COMPOSE; do
	    PROJECTNAME=${i##*/}
	    echo -e " Backup von Compose Project:\n  * $PROJECTNAME";
	    cd $i
	    tar -czf $BACKUPDIR/$PROJECTNAME-$TIMESTAMP.tar.gz .
	    # dont delete last old backups!
	    OLD_BACKUPS=$(ls -1 $BACKUPDIR/$PROJECTNAME*.tar.gz |wc -l)
	    if [ $OLD_BACKUPS -gt $DAYS ]; then
		    find $BACKUPDIR -name "$PROJECTNAME*.tar.gz" -daystart -mtime +$DAYS -delete
	    fi
    done
    echo -e "\n$TIMESTAMP Backup for Compose Projects completed\n"
}

function docker_backup:volumes {
    # Which Volumes you want to backup?
    # Volumenames separated by space
    #VOLUME="project1_data_container1 project2_data_container1"
    # you can use "$(docker volume ls  -q)" for all volumes
    if [[ -z "$VOLUME" ]]; then
        VOLUME=$(docker volume ls -q)
    fi
    # you can filter all Volumes with grep (include only) or grep -v (exclude) or a combination
    # to do a filter for 2 or more arguments separate them with "\|"
    # example: $(docker volume ls -q |grep 'project1\|project2' | grep -v 'database')
    # to use volumes with name project1 and project2 but not database
    #VOLUME=$(docker volume ls -q |grep 'project1\|project2' | grep -v 'database')
    #VOLUME=$(docker volume ls -q | grep -v 'mailcowdockerized\|_db')

    BACKUPDIR=$BACKUPDIR/volumes
    ### Do the stuff
    echo -e "Start $TIMESTAMP Backup for Volumes:\n"
    if [ ! -d $BACKUPDIR ]; then
	    mkdir -p $BACKUPDIR
    fi

    for i in $VOLUME; do
	    echo -e " Backup von Volume:\n  * $i";
	    docker run --rm \
            -v $BACKUPDIR:/backup \
            -v $i:/data:ro \
	        -e TIMESTAMP=$TIMESTAMP \
	        -e i=$i	${MEMORYLIMIT} \
	        --name volumebackup \
            alpine sh -c "cd /data && /bin/tar -czf /backup/$i-$TIMESTAMP.tar.gz ."
        #debian:stretch-slim bash -c "cd /data && /bin/tar -czf /backup/$i-$TIMESTAMP.tar.gz ."
	    # dont delete last old backups!
        OLD_BACKUPS=$(ls -1 $BACKUPDIR/$i*.tar.gz |wc -l)
	    if [ $OLD_BACKUPS -gt $DAYS ]; then
		    find $BACKUPDIR -name "$i*.tar.gz" -daystart -mtime +$DAYS -delete
	    fi
    done
    echo -e "\n$TIMESTAMP Backup for Volumes completed\n"
}
