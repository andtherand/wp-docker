FROM composer:1.8.4 as composer

FROM tp-wordpress:1.0

COPY --from=composer /usr/bin/composer /usr/bin/composer
