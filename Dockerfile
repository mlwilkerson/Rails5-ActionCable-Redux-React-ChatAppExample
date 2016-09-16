FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev 
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs

# We'll want to mount our app unthat share the same pre-built node_modules under this /app directory
# When docker-compose runs the app container, it will mount the root of the source code repo under /app/repo
# So everything under /app/repo will be shared between the container and the host machine.
# Normally `npm install` puts all of of the node packages in a subdirectory under that execution directory.
# So that would be repo/node_modules.
# But the big idea of Docker is pre-building those dependencies and including them in the docker image.
# See this for a discussion of how node looks for the node_modules directory:
#    http://stackoverflow.com/questions/18974436/change-node-modules-location 
#
# Nutshell, if it doesn't find node_modules under the app directory, it will search up the parent directories looking for it.
# Hence, we'll create that parent directory here and have npm build everything into it.

RUN mkdir -p /app/repo
WORKDIR /app

# Build out all of the Rails dependencies. We'll do this from the parent directory too, just for consistency.
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Build the node dependencies from that same parent directory.
ADD package.json /app/package.json

WORKDIR /app/repo

# Since we'll be mounting the Git repo under /app/repo, let's call that out here
VOLUME /app/repo
