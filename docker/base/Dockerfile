FROM alpine:3.12.0

ENV TZ America/Lima

RUN apk update && apk add --no-cache tzdata py3-pip py3-requests python3-dev curl
RUN pip3 install -U pip
RUN pip install setuptools gunicorn

WORKDIR /app