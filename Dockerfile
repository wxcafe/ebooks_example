# Ebooks
#
# VERSION 1

FROM ebooks_base

MAINTAINER wxcafé "wxcafe@wxcafe.net"

COPY bots.rb /ebooks/
COPY run.sh /ebooks/
COPY corpus  /ebooks/corpus/
COPY model   /ebooks/model/

WORKDIR /ebooks
VOLUME /var/log/

CMD ["./run.sh"]
