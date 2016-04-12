FROM alpine:latest

MAINTAINER Sebastian Gräßl <sebastian@validcode.me>

ENV RACK_ENV development

RUN apk add --update build-base
RUN apk add nodejs ruby ruby-dev ruby-bundler ruby-bigdecimal ruby-io-console libffi libffi-dev git zsh wget
RUN rm -rf /var/cache/apk/*
RUN npm install -g bower

RUN mkdir /site
WORKDIR /site

COPY Gemfile* /site/
RUN bundle install --system

COPY bower.json /site/
COPY .bowerrc /site/
RUN bower --allow-root install

EXPOSE 9393
