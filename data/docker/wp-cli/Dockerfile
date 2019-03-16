FROM tp-wordpress:1.0

RUN apt-get update && apt-get install tree -yqq
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar && mv wp-cli.phar /bin/wp \
  && mkdir /app

COPY start.sh /app/
