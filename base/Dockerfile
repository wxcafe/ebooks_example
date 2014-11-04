# Ebooks
#
# VERSION 1

FROM debian:jessie

MAINTAINER wxcafé "wxcafe@wxcafe.net"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y ruby ruby-dev build-essential libssl-dev
RUN mkdir /ebooks
RUN gem install simple_oauth -v 0.2.0
RUN gem install twitter_ebooks -v 2.2.9

WORKDIR /ebooks

CMD ["./run.sh"]
