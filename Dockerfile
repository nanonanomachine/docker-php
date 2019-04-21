FROM php:7.2.14-cli-alpine3.9

# memcached
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

# zip
RUN apk add --nocache --update zip zlib-dev \
    && docker-php-ext-install zip

# mysqli
RUN docker-php-ext-install mysqli

# gd
RUN apk add --no-cache --update libpng-dev \
    && docker-php-ext-install gd

# pdo-mysql
RUN docker-php-ext-install pdo_mysql

# git
RUN apk add --no-cache --upate git

# php.ini settings
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
ADD php.ini $PHP_INI_DIR/conf.d/php.ini

ENV BASE_PATH /opt/raksul
WORKDIR $BASE_PATH
