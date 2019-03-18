#!/bin/bash

set -exou pipefail

echo '-----------------------------------'
echo '--> Hi from Wordpress build script'

if [ -f ${APP_HOME}/composer.lock ]; then
  composer update -n
fi

if [ -f ${APP_HOME}/.firstrun ]; then
  if [ -f ${APP_HOME}/composer.json ]; then
    # install dependencies
    echo '----> Installing Wordpress and dependencies'
    if [ $WORDPRESS_ENV = "development" ]; then
      composer install -n
    else
      composer install -n --no-dev
    fi
  fi
fi

if [ -f ${APP_HOME}/wp/wp-config-sample.php ]; then
  echo '----> Removing sample config'
  rm ${APP_HOME}/wp/wp-config-sample.php
fi

if [ -f ${APP_HOME}/wp/readme.html ]; then
  echo '----> Removing readme'
  rm ${APP_HOME}/wp/readme.html
fi
