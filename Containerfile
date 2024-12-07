FROM docker.io/library/python:3.9-slim
ENV PYTHONUNBUFFERED 1

RUN mkdir /tmp/scw-cli
WORKDIR /tmp/scw-cli
COPY .env_rclone /tmp/scw-cli/.env

RUN apt update && apt -y install curl unzip

RUN curl -s https://raw.githubusercontent.com/scaleway/scaleway-cli/master/scripts/get.sh | sh

COPY config_scw.yaml /root/.config/scw/config.yaml

RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
RUN unzip rclone-current-linux-amd64.zip
RUN rm rclone-current-linux-amd64.zip
RUN cp rclone-*-linux-amd64/rclone /usr/local/bin/rclone

COPY rclone.conf /root/.config/rclone/rclone.conf

COPY archive.sh /tmp/scw-cli/archive.sh
RUN chmod +x archive.sh