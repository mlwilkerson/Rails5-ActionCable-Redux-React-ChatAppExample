FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm
RUN mkdir /chatapp
RUN ln -s /usr/bin/nodejs /usr/bin/node
WORKDIR /chatapp
ADD Gemfile /chatapp/Gemfile
ADD Gemfile.lock /chatapp/Gemfile.lock
RUN bundle install
ADD . /chatapp
