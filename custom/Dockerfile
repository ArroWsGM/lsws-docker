FROM litespeedtech/litespeed:latest
#RUN apt-get update && apt-get install lsphp74-pspell -y
#ADD file:5d68d27cc15a80653c93d3a0b262a28112d47a46326ff5fc2dfbf7fa3b9a0ce8 in /
CMD ["bash"]
ENV LS_FD=/usr/local/lsws
ARG LSWS_VERSION
ARG PHP_VERSION
ARG PHP_VERSION_GEN
ARG NODE_VERSION

RUN apt-get update
#RUN LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c apt-get update \
#    && apt-get -y install wget curl tzdata cron
#COPY lsws-install.sh /
RUN /bin/bash /lsws-install.sh $LSWS_VERSION
RUN apt-get install -y mysql-client $PHP_VERSION $PHP_VERSION-common $PHP_VERSION-mysql
RUN apt-get install -y $PHP_VERSION-redis $PHP_VERSION-memcached $PHP_VERSION-intl
RUN apt-get install -y $PHP_VERSION-opcache $PHP_VERSION-curl $PHP_VERSION-imagick
RUN if [[ $PHP_VERSION == lsphp7* ]]; then apt-get install $PHP_VERSION-json -y; fi
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
#    &&  chmod +x wp-cli.phar \
#    && mv wp-cli.phar /usr/bin/wp \
RUN rm /usr/bin/php \
    && ln -s /usr/local/lsws/$PHP_VERSION/bin/php /usr/bin/php
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c wget -O -  https://get.acme.sh | sh
#EXPOSE 7080
#ADD ../extracted/docker.xml /usr/local/lsws/conf/templates/docker.xml
#ADD ../extracted/setup_docker.sh /usr/local/lsws/bin/setup_docker.sh
#ADD httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
#ADD ../extracted/htpasswd /usr/local/lsws/admin/conf/htpasswd
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c $LS_FD/bin/setup_docker.sh $PHP_VERSION \
#    && rm $LS_FD/bin/setup_docker.sh
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c chown 999:999 $LS_FD/conf -R
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c cp -RP $LS_FD/conf/ $LS_FD/.conf/
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c cp -RP $LS_FD/admin/conf $LS_FD/admin/.conf/
RUN rm -f $LS_FD/fcgi-bin/lsphp
#RUN if [[ $PHP_VERSION == lsphp8* ]]; then ln -sf $LS_FD/$PHP_VERSION/bin/lsphp $LS_FD/fcgi-bin/lsphp8; fi
#RUN if [[ $PHP_VERSION == lsphp8* ]]; then ln -sf $LS_FD/fcgi-bin/lsphp8 $LS_FD/fcgi-bin/lsphp; fi
#RUN if [[ $PHP_VERSION == lsphp7* ]]; then ln -sf $LS_FD/$PHP_VERSION/bin/lsphp $LS_FD/fcgi-bin/lsphp7; fi
#RUN if [[ $PHP_VERSION == lsphp7* ]]; then ln -sf $LS_FD/fcgi-bin/lsphp7 $LS_FD/fcgi-bin/lsphp; fi
#COPY ../extracted/entrypoint.sh /entrypoint.sh
#RUN |2 LSWS_VERSION=6.0.8 PHP_VERSION=lsphp74 /bin/sh -c chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]
#WORKDIR /var/www/vhosts/

COPY fcgi-install.sh /
RUN chmod +x /fcgi-install.sh \
    && /bin/bash /fcgi-install.sh $PHP_VERSION $LS_FD

RUN apt-get update \
    && apt-get install -y gnupg gosu ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2 \
    && mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu impish main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get update
RUN apt-get install -y $PHP_VERSION-pgsql $PHP_VERSION-sqlite3 $PHP_VERSION-ldap
RUN apt-get install -y $PHP_VERSION-pear g++ build-essential \
    && /usr/local/lsws/$PHP_VERSION/bin/pecl install swoole pcov xdebug
RUN echo "extension=swoole.so" >> /usr/local/lsws/$PHP_VERSION/etc/php/$PHP_VERSION_GEN/mods-available/60-swoole.ini \
    && echo "extension=pcov.so" >> /usr/local/lsws/$PHP_VERSION/etc/php/$PHP_VERSION_GEN/mods-available/60-pcov.ini \
    && echo "zend_extension=xdebug.so" >> /usr/local/lsws/$PHP_VERSION/etc/php/$PHP_VERSION_GEN/mods-available/70-xdebug.ini

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && apt-get install -y postgresql-client \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*