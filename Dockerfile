FROM php:7.4-fpm-alpine

# Install dependencies
RUN apk --update add wget \
    curl \
    grep \
    build-base \
    libmcrypt-dev \
    libxml2-dev \
    pcre-dev \
    libtool \
    make \
    autoconf \
    g++ \
    cyrus-sasl-dev \
    libgsasl-dev

# Install PECL and PEAR extensions
RUN pecl install \
    mongodb \
    redis

RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
RUN docker-php-ext-install pdo pdo_mysql

RUN apk add --update --no-cache libzip-dev gmp gmp-dev freetype-dev libjpeg-turbo-dev libpng-dev oniguruma-dev

RUN docker-php-ext-install mbstring bcmath gmp sockets zip \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP_CodeSniffer
RUN composer global require "squizlabs/php_codesniffer=*"

# Install PHP Coding Standards Fixer
RUN composer global require friendsofphp/php-cs-fixer

# Install Laravel Envoy
RUN composer global require laravel/envoy

WORKDIR /app
