#!/bin/bash

# Assumes that your setup is configured such that mysql and mysqldump don't
# prompt you for password. This is very useful for running cron jobs.
# See https://stackoverflow.com/a/19913912/ for how to achieve this.
# Also see https://dev.mysql.com/doc/refman/5.7/en/option-files.html

DIR_TIMESTAMP=$(date +"%Y-%h-%d")
BACKUP_DIR="Your/Backup/Dir/DB/MySQL/$DIR_TIMESTAMP"

mkdir -p "$BACKUP_DIR"

databases=`mysql --batch --skip-column-names -e "SHOW DATABASES;" | grep -E -v "(information|performance)_schema"`

for db in $databases; do
  FILE_TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
  mysqldump --force --opt --databases $db | gzip > "${BACKUP_DIR}/${db}_${FILE_TIMESTAMP}.sql.gz"
done
