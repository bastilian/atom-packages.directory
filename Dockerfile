FROM debian:jessie

MAINTAINER Sebastian Gräßl <sebastian@validcode.me>

ENV RACK_ENV development

RUN apt-get update -qq && apt-get install -y build-essential wget zsh python python-dev python-pip python-virtualenv git
RUN apt-get install -y ruby ruby-dev
RUN gem install bundler
RUN rm -rf /var/lib/apt/lists/*

RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc
RUN npm install -g bower

RUN mkdir /site
WORKDIR /site

COPY Gemfile* /site/
RUN bundle install --system

COPY bower.json /site/
COPY .bowerrc /site/
RUN bower --allow-root install

EXPOSE 9393
