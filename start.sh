#! /bin/bash

# if not installed
if [ ! -f /installed ]; then

# create all variables if not passed through the environment
: ${DB_USER:=postgres}
: ${DB_PASSWORD:=$(pwgen 20 1)}
: ${DB_NAME:=synkee-server}
: ${DB_ENCODING:=UTF-8}
: ${DB_PG_DUMP_FILE:=/tmp/db.sql}

# start postgres
/etc/init.d/postgresql start

# prepare postgres database and user
sudo -u postgres createdb $DB_NAME
sudo -u postgres psql $DB_NAME < $DB_PG_DUMP_FILE
sudo -u postgres psql template1 -c "ALTER USER postgres with encrypted password '$DB_PASSWORD';"
/bin/rm -f ${DB_PG_DUMP_FILE}

# stop postgres
/etc/init.d/postgresql stop

# save password
echo $DB_PASSWORD > /pgpwd

# setup postgres acl
mv /postgres-pg-hba.conf /etc/postgresql/9.3/main/pg_hba.conf

# save installed state
touch /installed

# add password and ip to config files
sed -i "s/POSTGRESQL_PASSWORD/$DB_PASSWORD/g" /etc/pure-ftpd/db/postgresql.conf
sed -i "s/EXTERNAL_IP/$IP/g" /etc/supervisor/conf.d/pure-ftpd.conf

# end if not installed
fi

# run supervisor
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
