FROM ruby:2.1

VOLUME    ["/data"]
WORKDIR   /data

ADD Gemfile /data
ADD Gemfile.lock /data

RUN bundle install
RUN apt-get update
RUN apt-get -y install nodejs

# Docker caches ADD directory commands based on directory path.
# Save this for last so everything above is built from the cache.
ADD . /data
CMD rails s -p $PORT
