FROM docker.io/library/python:3.9-slim
ENV PYTHONUNBUFFERED 1

RUN mkdir /tmp/scw-cli
WORKDIR /tmp/scw-cli

RUN apt update && apt -y install curl

RUN curl -s https://raw.githubusercontent.com/scaleway/scaleway-cli/master/scripts/get.sh | sh

COPY config_scw.yaml /root/.config/scw/config.yaml

RUN python -m venv venv
ENV PATH="/tmp/scw-cli/venv:$PATH"

RUN pip install awscli && pip install awscli-plugin-endpoint

COPY config_aws /root/.aws/config
COPY credentials_aws /root/.aws/credentials

COPY archive.sh /tmp/scw-cli/archive.sh
RUN chmod +x archive.sh