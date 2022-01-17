#!/bin/bash

# Location where the Let's Encrypt configuration files are (and the ones which are to be backed up)
backup_from="/etc/letsencrypt/"

# Where files are to be backed up to
backup_to="/var/backups/letsencrypt/"

# The number of days to keep backup files before deleting them
days="120"

# Obtain the current datetime stamp
date=$(date +"%Y%m%d-%H%M")

# Location of temporary directory where files will be stored for a short period whilst they are compressed
tmp_location="/tmp/"

# Build the backup name
backup_name="letsencrypt_backup-${date}"

######################################################
##### EDITING BELOW MAY CAUSE UNEXPECTED RESULTS #####
######################################################

# Make a temporary directory
mkdir -p ${tmp_location}${backup_name}

# Copy the configuration files to the temporary directory
cp -r ${backup_from}. ${tmp_location}${backup_name}

# Access the temporary directory
cd $tmp_location

# Set default file permissions
umask 177

# Compress the backup into a tar file
tar -cvzf ${tmp_location}${backup_name}.tar.gz ${backup_name}

# Create the backup location, if it doesn't already exist
mkdir -p ${backup_to}

# Move the tar.gz file to the backup location
mv ${tmp_location}${backup_name}.tar.gz ${backup_to}

# Delete the old directory from the temporary folder
rm -rf ${tmp_location}${backup_name}/

# Set a value to be used to find all backups with the same name
find_backup_name="${backup_to}letsencrypt_backup-*.tar.gz"

# Delete files which are older than the number of days defined
find $find_backup_name -mtime +$days -type f -delete