FROM ubuntu:14.04

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install nginx supervisor git vim wget nmap dpkg-dev debhelper libpam-dev libcap2-dev libldap2-dev libmysqlclient-dev libpq-dev libssl-dev po-debconf mysql-server && \
    apt-get source pure-ftpd-mysql && \
    cd pure-ftpd-* && \
    sed -i 's/--with-rfc2640/--with-rfc2640 --without-capabilities/g' debian/rules && \
    dpkg-buildpackage -b -uc

RUN apt-get -y install openbsd-inetd && \
    dpkg -i pure-ftpd-common* && \
    dpkg -i pure-ftpd-mysql*

RUN apt-get -y install pwgen

ADD ./config/supervisor-nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD ./config/supervisor-pure-ftpd.conf /etc/supervisor/conf.d/pure-ftpd.conf
ADD ./config/supervisor-mysql.conf /etc/supervisor/conf.d/mysql.conf
ADD ./config/nginx-default-vhost /etc/nginx/sites-available/default
ADD ./config/pure-ftpd-mysql.conf /etc/pure-ftpd/db/mysql.conf
ADD ./config/db.sql /tmp/db.sql
ADD ./start.sh /start.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir /var/www && \
    mkdir /var/www/users && \
    mkdir /var/www/websites && \
    chown -R www-data:www-data /var/www

EXPOSE 80 21 20 30000 30001 30002 30003 30004 30005 30006 30007 30008 30009

CMD ./start.sh
