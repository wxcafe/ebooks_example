# Ebooks
#
# VERSION 1

FROM debian:jessie

MAINTAINER wxcafé "wxcafe@wxcafe.net"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y ruby ruby-dev build-essential libssl-dev
RUN mkdir /ebooks
RUN gem install twitter_ebooks

COPY bots.rb /ebooks/
COPY run.sh  /ebooks/
COPY run.rb  /ebooks/
COPY corpus  /ebooks/corpus/
COPY model   /ebooks/model/

RUN apt-get remove -y build-essential
RUN apt-get -y dist-upgrade

VOLUME /var/log/ebooks

WORKDIR /ebooks

CMD ["./run.sh"]
