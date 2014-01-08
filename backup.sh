#!/bin/sh

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



# Setup the $BACKUPS folder and start the clock
# =============================================
clear

START=$(date +%Y%m%d%H%M%S)

if [ ! -d "$BACKUPS" ]; then
    mkdir $BACKUPS
fi
cd $BACKUPS


# Delete backup folders older than $MAXAGE days
# =============================================
for i in `find * -maxdepth 1 -type d -mtime +$MAXAGE -print`
do
    echo "Deleting directory $i"
    rm -rf $i
done


# Create the folder for the current backup
# ========================================
if [ ! -d "$FOLDER" ]; then
    mkdir $FOLDER
fi
cd $FOLDER


# Loop through and backup databases
# =================================
for i in "${DATABASES[@]}"
do
    echo "$(date +%Y-%m-%d-%H.%M.%S) : Backing up $i..."
    ssh $SERVER "mysqldump -h 127.0.0.1 -u $DATABASE_USER -p\"$DATABASE_PASSWORD\" $i | gzip -cf" > $i-$(date +%Y-%m-%d-%H.%M.%S).sql.gzip
done


# Loop through and backup folders (assets/uploads/etc)
# ====================================================
for i in "${FOLDERS[@]}"
do
    echo "$(date +%Y-%m-%d-%H.%M.%S) : Backing up $i..."

    # Remove folder's trailing slash before the others are replaced by dashes
    TEMP=${i#?}

    ssh $SERVER "cd $i;tar -jcpf - ." > ${TEMP//\//-}-$(date +%Y-%m-%d-%H.%M.%S).tar.bz2
done


# Stop the clock and show how much time we had to drink coffees|beers
# ===================================================================
END=$(date +%Y%m%d%H%M%S)
DELTA=$(( ($END - $START)/60 ))

echo "Backup took $DELTA minutes"
