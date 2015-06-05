FROM ubuntu:14.04

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install nginx supervisor git vim wget nmap dpkg-dev debhelper libpam-dev libcap2-dev libldap2-dev libmysqlclient-dev libpq-dev libssl-dev po-debconf && \
    apt-get source pure-ftpd-postgresql && \
    cd pure-ftpd-* && \
    sed -i 's/--with-rfc2640/--with-rfc2640 --without-capabilities/g' debian/rules && \
    dpkg-buildpackage -b -uc

RUN apt-get -y install openbsd-inetd && \
    dpkg -i pure-ftpd-common* && \
    dpkg -i pure-ftpd-postgresql*

# ADD ./nginx-supervisor /etc/supervisor/conf.d/nginx.conf
# ADD ./pure-ftpd-supervisor /etc/supervisor/conf.d/pure-ftpd.conf
# ADD ./default /etc/nginx/sites-available/default
# ADD ./postgresql.conf /etc/pure-ftpd/db/postgresql.conf
# ADD ./MinUID /etc/pure-ftpd/conf/MinUID
# ADD ./ChrootEveryone /etc/pure-ftpd/conf/ChrootEveryone
# ADD ./VerboseLog /etc/pure-ftpd/conf/VerboseLog
# ADD ./pure-ftpd-common /etc/default/pure-ftpd-common
# ADD ./clean_websites /etc/cron.hourly/clean_websites

RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir /var/www && \
    chown -R www-data:www-data /var/www

RUN apt-get -y install postgresql-client

EXPOSE 80 21 20 30000 30001 30002 30003 30004 30005 30006 30007 30008 30009

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
