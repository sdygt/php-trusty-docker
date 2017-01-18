FROM ubuntu:trusty

ENV LC_ALL C.UTF-8
RUN apt-get update && \
    apt-get install -y python-software-properties software-properties-common curl
RUN add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install apache2 libapache2-mod-php7.0 php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-mysql php7.0-sqlite php7.0-xml php7.0-zip php7.0-mbstring php7.0-mcrypt php7.0-intl php7.0-soap php7.0-imap php-imagick && apt-get clean && rm -r /var/lib/apt/lists/* && \
    sed -i -e 's/max_execution_time = 30/max_execution_time = 60/g' /etc/php/7.0/apache2/php.ini && \
    sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php/7.0/apache2/php.ini && \
    sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-available/dir.conf && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    chmod 777 -R /var/www

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl
WORKDIR /var/www/html

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
