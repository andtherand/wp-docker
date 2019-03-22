ARG WORDPRESS_ENV=production

FROM registry.gitlab.com/talentplatforms/docker-images/wordpress-base:1.0

ENV APP_HOME=/app

RUN mkdir -p ${APP_HOME}

RUN echo '----> Creating secrets' \
  && touch ${APP_HOME}/secrets.php && echo '<?php' > ${APP_HOME}/secrets.php \
  && curl -sS https://api.wordpress.org/secret-key/1.1/salt/ >> ${APP_HOME}/secrets.php \
  && touch ${APP_HOME}/.firstrun

WORKDIR ${APP_HOME}

COPY data/docker/wordpress/files/apache/vhost.conf /etc/apache2/sites-available/000-default.conf

COPY data/docker/wordpress/files/app ${APP_HOME}/
# adds the local changes to the production image
COPY composer.local.json ${APP_HOME}/

RUN chmod +x ${APP_HOME}/start.sh ${APP_HOME}/build.sh \
  && ${APP_HOME}/build.sh
