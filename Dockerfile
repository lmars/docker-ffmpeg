FROM stackbrew/ubuntu:precise
MAINTAINER Lewis Marshall <lewis@lmars.net>

ENV INSTALL_DIR /usr/local

# Enable Universe and Multiverse
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe multiverse >> /etc/apt/sources.list && apt-get update

# Install dependent packages
RUN apt-get install -y autoconf automake libass-dev libgpac-dev libmp3lame-dev libtheora-dev libtool libvorbis-dev pkg-config texi2html wget && apt-get clean

# Install build tools
RUN apt-get install -y build-essential && apt-get clean

# Install YASM
ENV YASM_VERSION 1.2.0
RUN cd /tmp && wget http://www.tortall.net/projects/yasm/releases/yasm-$YASM_VERSION.tar.gz && tar xzvf yasm-$YASM_VERSION.tar.gz && cd yasm-$YASM_VERSION && ./configure --prefix=$INSTALL_DIR && make && make install && cd .. && rm -rf yasm-*
