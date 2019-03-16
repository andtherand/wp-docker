#!/bin/bash

set -euo pipefail

echo "--> HI from Wordpress start script"

sleep 10;

echo "--> CHOWN !?!? $(whoami)"

# setup database and user
echo '--> Installing database with admin'
install_core="wp core install --url=localhost --title=\"$WORDPRESS_TITLE\" \
  --admin_user=\"$WORDPRESS_ADMIN_NAME\" --admin_password=\"$WORDPRESS_ADMIN_PASSWORD\" \
  --admin_email=\"$WORDPRESS_ADMIN_EMAIL\" \
  --allow-root"

until eval $install_core
do
  echo '--> Waiting for database, trying again.'
  sleep 5
done

echo '---> Wordpress settings'
wp option update default_pingback_flag 0 --allow-root
wp option update default_ping_status 0 --allow-root
wp option update default_comment_status 0 --allow-root
wp option update comments_notify 0 --allow-root
wp option update uploads_use_yearmonth_folders 0 --allow-root
wp option update permalink_structure /%postname%/ --allow-root

wp language core install ${WORDPRESS_LANG} --activate --allow-root

echo '---> Activate all plugins'
wp plugin activate --all --allow-root


if [ ! -d "/var/www/html/wp-content/themes/${WORDPRESS_THEME}" ]; then
  echo "THEME ${WORDPRESS_THEME} not found :/"
fi

tree -d "/var/www/html/wp-content/themes/"

echo '---> Activate theme'
wp theme activate "${WORDPRESS_THEME}" --allow-root
