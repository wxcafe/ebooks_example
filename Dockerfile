# Ebooks
#
# VERSION 1

FROM ebooks_base

MAINTAINER wxcafé "wxcafe@wxcafe.net"
ENV DEBIAN_FRONTEND noninteractive

COPY bots.rb /ebooks/
COPY run.sh  /ebooks/
COPY run.rb  /ebooks/
COPY corpus  /ebooks/corpus/
COPY model   /ebooks/model/

WORKDIR /ebooks

CMD ["./run.sh"]
