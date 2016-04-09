FROM ruby:2.2.3

ENV RACK_ENV development

RUN mkdir /site
WORKDIR /site

COPY Gemfile* /site/
RUN bundle install --system

EXPOSE 9393
