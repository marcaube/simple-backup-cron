simple-backup-cron
==================

A simple bash script to backup remote databases and folders.

This is a low-tech script I wrote a while ago to keep 10 days of backups of 
production assets on my workstation. I use it to backup [UGC](http://en.wikipedia.org/wiki/User-generated_content)
like uploaded images and also MySQL dumps.


## Usage

Copy the script to the computer where you want to store the backups and configure the script.

```bash
# CONFIG ----------------------------------------------------------------------

# Where to save the backups on your local machine (absolute path)
BACKUPS=~/Backups

# The server (user@server.com) to SSH to, you have to log-in without password using a public-key
SERVER=user@server.com

# A list of databases to backup
DATABASES=("database_1" "database_2")

# MySQL database user and password (has to be able to access every databases to backup)
DATABASE_USER=user
DATABASE_PASSWORD=password

# A list of folders to backup
FOLDERS=("/home/user/www/website.com/uploads" "/home/user/www/website.com/assets")

# The naming used for backup folders (i.e. $(date +%Y-%m-%d) or $(date +%Y-%m-%d-%H.%M.%S))
FOLDER=$(date +%Y-%m-%d)

# How many days before backups are "stale" and ready to be trashed
MAXAGE=10

# END CONFIG ------------------------------------------------------------------
```

You can run the script manually

```bash
$ sh backup.sh >> backup_errors.log
```

Or you can configure a cron job to run it every `hour|day|week` using crontab

```bash
$ crontab -e
```

This would be a cron job to run do the backups every morning at 9:00

```bash
0       9       *       *       *       sh ~/path/backup.sh >> ~/path/backup_errors.log
```


## License

simple-backup-cron is released under the MIT License. See the bundled [LICENSE]() file for details.
