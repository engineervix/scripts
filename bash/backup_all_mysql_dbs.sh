#!/bin/bash
 
TIMESTAMP=$(date +"%F")
BACKUP_DIR="$HOME/_BACKUP/mysql/$TIMESTAMP"
 
mkdir -p "$BACKUP_DIR/mysql"
 
databases=`mysql --batch --skip-column-names -e "SHOW DATABASES;" | grep -E -v "(information|performance)_schema"`
 
for db in $databases; do
  mysqldump --force --opt --databases $db | gzip > "$BACKUP_DIR/$db`date +%Y%m%d`.gz"
done
