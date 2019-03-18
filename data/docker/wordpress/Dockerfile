FROM php:7.3-apache as base

ENV CORE_PACKAGES="zip libzip-dev unzip curl libmagickwand-dev git" \
  PHP_EXTENSIONS="mysqli zip opcache" \
  PECL_EXTENSIONS="imagick"

RUN apt-get update && apt-get --no-install-recommends -fqq install ${CORE_PACKAGES} \
  && apt-get autoclean && apt-get -y autoremove \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && docker-php-ext-install ${PHP_EXTENSIONS} \
  && pecl install ${PECL_EXTENSIONS} \
  && docker-php-ext-enable ${PECL_EXTENSIONS} \
  && a2enmod rewrite headers

# CLIS
FROM composer:1.8.4 as clis

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp

# FINAL STAGE
FROM base as final

ENV APP_HOME=/app

RUN mkdir -p ${APP_HOME}

COPY --from=clis /usr/bin/composer /usr/bin/composer
COPY --from=clis /usr/bin/wp /usr/bin/wp

RUN echo '----> Creating secrets' \
  && touch ${APP_HOME}/secrets.php && echo '<?php' > ${APP_HOME}/secrets.php \
  && curl -sS https://api.wordpress.org/secret-key/1.1/salt/ >> ${APP_HOME}/secrets.php \
  && touch ${APP_HOME}/.firstrun

WORKDIR ${APP_HOME}

COPY /files/apache/vhost.conf /etc/apache2/sites-available/000-default.conf

# RUN composer install

COPY /files/app ${APP_HOME}/
RUN chmod +x ${APP_HOME}/start.sh ${APP_HOME}/build.sh
