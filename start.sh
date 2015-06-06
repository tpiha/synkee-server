#! /bin/bash

# if not installed
if [ ! -f /installed ]; then

# create all variables if not passed through the environment
: ${DB_USER:=root}
: ${DB_PASSWORD:=$(pwgen 20 1)}
: ${DB_NAME:=synkee_server}
: ${DB_ENCODING:=UTF-8}
: ${DB_PG_DUMP_FILE:=/tmp/db.sql}

# start mysql
/etc/init.d/mysql start

# prepare mysql database
echo "CREATE DATABASE $DB_NAME;" | mysql -u root
cat /tmp/db.sql | mysql -u root $DB_NAME
/bin/rm -f ${DB_PG_DUMP_FILE}

# stop mysql
/etc/init.d/mysql stop

# save password
echo $DB_PASSWORD > /mysqlpwd

# save installed state
touch /installed

# add password and ip to config files
# sed -i "s/POSTGRESQL_PASSWORD/$DB_PASSWORD/g" /etc/pure-ftpd/db/postgresql.conf
# sed -i "s/EXTERNAL_IP/$IP/g" /etc/supervisor/conf.d/pure-ftpd.conf

# end if not installed
fi

# run supervisor
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
