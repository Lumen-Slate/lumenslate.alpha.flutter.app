## Stage 1
FROM ubuntu:latest AS build-env

RUN apt-get update \
    && apt-get install -y curl git wget unzip gdb libstdc++6 libglu1-mesa python3 \
    && apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

 #Enable web capabilities
RUN flutter config --enable-web
RUN flutter upgrade
RUN flutter pub global activate webdev

RUN flutter doctor -v

## Copy files to container and build
RUN mkdir /app
WORKDIR /app
COPY . .

## Create logs directory
RUN mkdir -p /app/logs

## Configure Flutter logging
ENV FLUTTER_LOG_DIR=/app/logs

RUN flutter pub upgrade web
RUN flutter build web

# Stage 2: Serve with nginx
FROM nginx:alpine AS serve
COPY --from=build-env /app/build/web /usr/share/nginx/html
COPY --from=build-env /app/logs /app/logs
COPY ./my_app.conf /etc/nginx/conf.d/default.conf
EXPOSE 80