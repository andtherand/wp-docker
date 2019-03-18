FROM node:8

WORKDIR /home/node/app

RUN mkdir /app-resources
COPY ./entrypoint.sh /app-resources/
RUN chmod +x /app-resources/entrypoint.sh

USER "node"
ENTRYPOINT [ "/app-resources/entrypoint.sh" ]
