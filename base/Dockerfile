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

WORKDIR /ebooks

CMD ["./run.sh"]
