# Let's Encrypt Backup

During installation of Let's Encrypt/Certbot you are advised that you should take a backup of your configuration regularly. This configuration also includes your account credentials.

```shell
Your account credentials have been saved in your Certbot
configuration directory at /etc/letsencrypt. You should make a
secure backup of this folder now. This configuration directory will
also contain certificates and private keys obtained by Certbot so
making regular backups of this folder is ideal.
```

This simple BASH script is designed to easily backup these files in a compressed/archived format to a location outside of production.

## Contributors

- [Alex Winder](https://www.alexwinder.uk)

## Prerequisites

To be able to use this you must have the following installed:

- GNU tar

If you do not have `tar` installed then you can do so with the following:

### Debian

The following installs `tar` on Debian.

```bash
apt-get install tar
```

### Ubuntu

This command will install `tar` on Ubuntu. The `sudo` command ensures that the `apt` command is run with `root` privileges.

```bash
sudo apt-get install tar
```

### CentOS

Execute the following command as `root` user on the shell to install `tar` on CentOS.

```bash
yum install tar
```

### Versions

This BASH script has been tested to work on the following:

- Debian 9 Stretch
- Debian 10 Buster
- Debian 11 Bullseye
- Certbot 0.28.0

To find your version of Certbot.

```bash
root@0:~# apt-cache policy certbot | grep -i Installed
  Installed: 0.28.0-1~bpo9+1
```

Or, for those not running a distribution with `apt`.

```bash
root@0:~# /usr/bin/certbot --version
certbot 0.28.0
```

Whilst these versions have been tested your mileage may vary, there is very little reason if you are using an older/newer version of Debian or another flavour of Linux you may need to alter the directory locations, but the script itself should still work as it relies primarily on simple BASH file system commands and `tar`.

## Getting Started

The simplest way to get started is to clone the repository:

```shell
git clone https://github.com/AlexWinder/letsencrypt-backup.git
```

This script assumes that you are using the default directory of `/etc/letsencrypt`. If your Let's Encrypt configuration files are in a different location then you will need to amend this as appropriate, as detailed in the section below.

Once cloned you will need to set up a crontab to run periodically to execute the [letsencrypt-backup.sh](letsencrypt-backup.sh) script. The example below will run the backup script every day at 00:00, however you are free to run the script as often or as little as your requirements or resources permit.

```crontab
0 0 * * * /location/to/letsencrypt-backup/letsencrypt-backup.sh
```

You will need to drop in the correct location to the directory as per your system when you cloned the repository.

### File Permissions

You may run in to some file permissions issues, this is normally caused by the letsencrypt-backup.sh script not be accessible by the current user. To resolve this you should change the permissions of the file to allow it to be executable by the current user.

```bash
chmod 700 /location/to/letsencrypt-backup/letsencrypt-backup.sh
```

You will need to drop in the correct location to the directory as per your system when you cloned the repository.

To test that the permissions issue is now resolved you can attempt to execute the script manually.

```bash
/location/to/letsencrypt-backup/letsencrypt-backup.sh
```

### Custom Paths

By default the script will use the following settings:

- Configuration files are backed up from `/etc/letsencrypt/`.
- Backup files are sent to `/var/backups/letsencrypt/`.
- Backup files are kept for 120 days.

If you wish to override any of these options you can pass in any of the following flags to the script with your custom argument:

```bash
./letsencrypt-backup.sh --from <configuration location> --to <backup location> --days <number of days to store backups>
```

For example:

```bash
./letsencrypt-backup.sh --from /etc/certbot --to /home/certbot/backups --days 365
```

In the above example we are taking the configuration files in `/etc/certbot`, compressing and then sending them to `/home/certbot/backups`, and deleting any which are older than 365 days old.

You are free to use any combination of the above flags (`--from`, `--to`, and `--days`). Any which you do not specify will take the default value as listed above.

## Extracting Backups

If you wish to extract a particular backup you can do so with the following command:

```bash
tar -xvf /var/backups/letsencrypt/letsencrypt_backup-DATE-TIME.tar.gz
```

You should swap in the path and filename as per your own setup. This will extract the backup to its own directory as per your current working directory.

## License

This project is licensed under the [MIT License](LICENSE.md).
