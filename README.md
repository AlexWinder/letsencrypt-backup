# Let's Encrypt Backup

During installation of Let's Encrypt/Certbot you are advised that you should take a backup of your configuration regularly. This configuration also includes your account credentials. 

```
   Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.
```

This simple BASH script is designed to easily backup these files in a compressed/archived format.

## Contributors

- [Alex Winder](https://www.alexwinder.uk) 