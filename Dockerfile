FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev 
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs
RUN mkdir /chatapp
WORKDIR /chatapp
ADD Gemfile /chatapp/Gemfile
ADD Gemfile.lock /chatapp/Gemfile.lock
ADD package.json /chatapp/package.json
RUN bundle install
RUN npm install

# The following two seem to be redundant, but without this hack node_modules/.bin/browserifyinc 
# is not generated and we get errors in the browser at runtime
RUN npm install browserify
RUN npm install browserify-incremental

#ADD . /chatapp
