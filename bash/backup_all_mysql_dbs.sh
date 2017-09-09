#!/bin/bash
 
TIMESTAMP=$(date +"%F")
BACKUP_DIR="~/_BACKUP/mysql/$TIMESTAMP"
 
mkdir -p "$BACKUP_DIR/mysql"
 
databases=`sudo mysql --defaults-extra-file=/root/.my.cnf --batch --skip-column-names -e "SHOW DATABASES;" | grep -E -v "(information|performance)_schema"`
 
for db in $databases; do
  mysqldump --force --opt --defaults-extra-file=/root/.my.cnf --databases $db | gzip > "$BACKUP_DIR/$db.gz"
done
