FROM ruby:2.1

VOLUME    ["/data"]
ADD       . /data
WORKDIR   /data

RUN bundle install
RUN apt-get update
RUN apt-get -y install nodejs

CMD rails s -p $PORT
