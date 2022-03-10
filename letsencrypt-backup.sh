#!/bin/bash

######################
##### PARAMETERS #####
######################

# Location where the Let's Encrypt configuration files are (and the ones which are to be backed up)
from="${from:-/etc/letsencrypt/}"
# Where files are to be backed up to
to="${to:-/var/backups/letsencrypt/}"
# The number of days to keep backup files before deleting them
days="${days:-120}"

# Enable named parameters to be passed in
while [ $# -gt 0 ]; do

    # If help has been requested
    if [[ $1 == *"--help" ]]; then
        echo
        echo "Let's Encrypt Backup Script"
        echo
        echo "This script allows you to easily backup configuration settings, keys and certificates issued by Let's Encrypt."
        echo "https://github.com/AlexWinder/letsencrypt-backup"
        echo
        echo "Options:"
        echo
        echo "--from    The location where your Let's Encrypt configuration files are. Default: ${from}"
        echo "--to      Where you would like to back the files up to. Default: ${to}"
        echo "--days    The number of days to keep backup files before deleting them. Default: ${days} (days)"
        echo "--help    Display help about this script"
        echo
        exit 0
    fi

    # Check all other passed in parameters
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
    fi

    shift
done

#########################
##### PREREQUISITES #####
#########################

# Obtain the current datetime stamp
date=$(date +"%Y%m%d-%H%M")

# Location of temporary directory where files will be stored for a short period whilst they are compressed
tmp_location="/tmp/"

# Build the backup name
backup_name="letsencrypt_backup-${date}"

# Make sure that directory paths are in the correct format - remove all trailing slashes then add one onto the end
from=$(echo $from | sed 's:/*$::')/
to=$(echo $to | sed 's:/*$::')/

#######################
##### SCRIPT BODY #####
#######################

# Make a temporary directory
mkdir -p ${tmp_location}${backup_name}

# Copy the configuration files to the temporary directory
cp -r ${from}. ${tmp_location}${backup_name}

# Access the temporary directory
cd $tmp_location

# Set default file permissions
umask 177

# Compress the backup into a tar file
tar -cvzf ${tmp_location}${backup_name}.tar.gz ${backup_name}

# Create the backup location, if it doesn't already exist
mkdir -p ${to}

# Move the tar.gz file to the backup location
mv ${tmp_location}${backup_name}.tar.gz ${to}

# Delete the old directory from the temporary folder
rm -rf ${tmp_location}${backup_name}/

# Set a value to be used to find all backups with the same name
find_backup_name="${to}letsencrypt_backup-*.tar.gz"

# Delete files which are older than the number of days defined
find $find_backup_name -mtime +$days -type f -delete
