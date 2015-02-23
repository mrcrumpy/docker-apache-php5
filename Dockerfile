FROM ubuntu:trusty

MAINTAINER Christian Maniewski "c.maniewski@crolla-lowis.de"

RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ufirst/php5
RUN apt-get update

RUN apt-get -y install apache2 php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-curl php5-cli php5-gd php5-pgsql php5-sqlite php5-common php-pear curl php5-json memcached php5-memcache

# RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/
RUN mv /usr/bin/composer.phar /usr/bin/composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Add our fpm configuration
COPY fpm.conf /etc/php5/fpm/pool.d/www.conf

# Add our apache configuration
COPY apache2.conf /etc/apache2/apache2.conf

# Give www-data write access to mounted volumes
RUN usermod -u 1000 www-data

# Enable apache modules
RUN a2enmod proxy_fcgi
RUN a2enmod rewrite
RUN a2enmod headers

EXPOSE 80

CMD ["/run.sh"]