#!/bin/bash

# This script will backup all mysql databases into 
# compressed file named after date, ie: /var/backup/mysql/2016-07-13.tar.bz2

# credits: https://stackoverflow.com/a/38345544/

# Setup variables used later

# Create date suffix with "F"ull date format
suffix=$(date +%F)
# Retrieve all database names except information schemas. Use sudo here to skip root password.
dbs=$(sudo mysql --defaults-extra-file=/root/.my.cnf --batch --skip-column-names -e "SHOW DATABASES;" | grep -E -v "(information|performance)_schema")
# Create temporary directory with "-d" option
tmp=$(mktemp -d)
# Set output dir here. /var/backups/ is used by system, 
# so intentionally used /var/backup/ for user backups.
outDir="~/_BACKUP/mysql"
# Create output file name
out="$outDir/$suffix.tar.gz"

# Actual script

# Check if output directory exists
if [ ! -d "$outDir" ];then
  # Create directory with parent ("-p" option) directories
  sudo mkdir -p "$outDir"
fi

# Loop through all databases
for db in $dbs; do
  # Dump database to temporary directory with file name same as database name + sql suffix
  sudo mysqldump --defaults-extra-file=/root/.my.cnf --databases "$db" > "$tmp/$db.sql"
done

# Go to tmp dir
cd $tmp

# Compress all dumps with gzip, discard any output to /dev/null
sudo tar -zcf "$out" * > "/dev/null"

# Cleanup
cd "/tmp/"
sudo rm -rf "$tmp"