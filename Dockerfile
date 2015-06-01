FROM ubuntu:15.04

MAINTAINER Conrad Kleinespel <conradk@conradk.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nano vim emacs git wget gcc autoconf automake libtool strace valgrind gdb

RUN apt-get install -y cmake make bison flex
RUN apt-get install -y libapr1 libapr1-dbg libapr1-dev libaprutil1
RUN apt-get install -y apache2 apache2-bin apache2-data apache2-dbg apache2-dev apache2-mpm-prefork apache2-utils

# asn1c lib
RUN cd /tmp && git clone -b JFS-intx https://github.com/open-io/asn1c.git
# with the current asn1c, you'd need to "make check" after "make" to generate the skeletons lib
RUN cd /tmp/asn1c && autoreconf -iv && ./configure && make && make install && ldconfig `pwd`
# end asn1c

RUN apt-get install -y libattr1 libattr1-dev
RUN apt-get install -y curl libcurl3 libcurl3-dbg libcurl4-openssl-dev
RUN apt-get install -y libdbus-1-3 libdbus-1-dev libdbus-glib-1-2 libdbus-glib-1-2-dbg libdbus-glib-1-dev
RUN apt-get install -y libexpat1 libexpat1-dev
RUN apt-get install -y libgamin0 libgamin-dev
RUN apt-get install -y libglib2.0-0 libglib2.0-0-dbg libglib2.0-dev
RUN apt-get install -y libevent-2.0-5 libevent-dev libevent-dbg libevent-extra-2.0-5

# gridinit
RUN cd /tmp && git clone https://github.com/open-io/gridinit.git && cd gridinit && cmake . && make && make install && ldconfig `pwd`
# end gridinit

RUN apt-get install -y micro-httpd libmicrohttpd-dbg libmicrohttpd-dev libmicrohttpd10
RUN apt-get install -y libjson-c-dev libjson-c2 libjson-c2-dbg
RUN apt-get install -y liblzo2-2 liblzo2-dev
RUN apt-get install -y libneon27 libneon27-dbg libneon27-dev
RUN apt-get install -y libsnmp30 libsnmp30-dbg libsnmp-dev
RUN apt-get install -y libssl-dev libssl1.0.0 libssl1.0.0-dbg
RUN apt-get install -y python-distutils-extra python-dev
RUN apt-get install -y libsqlite3-0 libsqlite3-0-dbg libsqlite3-dev
RUN apt-get install -y libdb-dev libdb5.3

# zeromq
RUN apt-get install -y libtool autoconf automake build-essential pkg-config uuid-dev
RUN cd /tmp && wget http://download.zeromq.org/zeromq-4.0.5.tar.gz && tar -xzvf zeromq-4.0.5.tar.gz && cd zeromq-4.0.5 && ./configure && make && make install && ldconfig `pwd`
# end zeromq

RUN apt-get install -y libzookeeper-mt2 libzookeeper-mt-dev libzookeeper-java libzookeeper2 zookeeper zookeeper-bin zookeeperd python-zookeeper

# librain
RUN cd /tmp && git clone http://lab.jerasure.org/jerasure/gf-complete.git && cd gf-complete && autoreconf --force --install && ./configure && make && make install && ldconfig `pwd`
RUN cd /tmp && git clone http://lab.jerasure.org/jerasure/jerasure.git    && cd jerasure    && autoreconf --force --install && ./configure && make && make install && ldconfig `pwd`
RUN cd /usr/local/include && ln -s jerasure/galois.h && cd jerasure && ln -s ../jerasure.h
RUN cd /tmp && git clone https://github.com/open-io/redcurrant-librain.git librain && cd librain && cmake . && make && make install && ldconfig `pwd`
# end librain

# SDS
RUN cd /tmp && git clone https://github.com/open-io/oio-sds.git
RUN apt-get install -y python-setuptools
RUN cd /tmp/oio-sds && cmake -DLD_LIBDIR=lib64 -DASN1C_LIBDIR=/tmp/asn1c/skeletons/.libs/ -DDB_LIBDIR=/usr/lib/x86_64-linux-gnu/ -DAPACHE2_INCDIR=/usr/include/apache2/ -DMICROHTTPD_LIBDIR=/usr/lib/x86_64-linux-gnu/ -DGRIDINIT_LIBDIR=/usr/local/lib64/ -DLIBRAIN_LIBDIR=/usr/local/lib64/ . && make && make install
#end SDS

# make OpenIO libraries available symstem wide
ENV LD_LIBRARY_PATH /usr/local/lib/:/usr/local/lib64/

# make custom binaries available from within the container
ADD bin /usr/local/bin

# fix bug with `getlogin()` until (and if) https://github.com/open-io/oio-sds/pull/33 gets merged
RUN ["/bin/sed", "-i", "-e", "s/os.getlogin()/pwd.getpwuid(os.getuid())/g", "/usr/local/bin/oio-bootstrap.py"]
RUN ["/bin/sed", "-i", "-e", "s/import os, errno/import os, errno, pwd/g", "/usr/local/bin/oio-bootstrap.py"]

# test files, see README.md for usage
ADD test /root/test

ENTRYPOINT ["/usr/local/bin/startup"]
