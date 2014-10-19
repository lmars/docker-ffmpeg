FROM ubuntu:trusty
MAINTAINER Lewis Marshall <lewis@lmars.net>

ENV INSTALL_DIR /usr/local

# Enable Universe and Multiverse
RUN sed -re 's/ main$/ main restricted universe multiverse/g' -e "s:/archive\.:/us.archive\.:g" -i /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y --force-yes && \
    apt-get clean

# Install dependent packages
RUN apt-get install -y autoconf automake libass-dev libgpac-dev libmp3lame-dev git \
    libtheora-dev libtool libvorbis-dev pkg-config texi2html wget && \
    apt-get clean

# Install build tools
RUN apt-get install -y build-essential && \
    apt-get clean

# Install YASM
ENV YASM_TAG v1.3.0
RUN cd /tmp && \
    git clone --depth 1 --branch $YASM_TAG https://github.com/yasm/yasm.git && \
    cd yasm && \
    autoreconf -fiv && \
    ./configure --prefix=$INSTALL_DIR && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf yasm

# Install x264
ENV X264_SHA 021c0dc
RUN cd /tmp && \
    git clone git://git.videolan.org/x264.git && \
    cd x264 && \
    git checkout $X264_SHA && \
    ./configure --prefix=$INSTALL_DIR --enable-static --enable-shared && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf x264

# Install fdk-aac
ENV FDK_AAC_TAG v0.1.3
RUN cd /tmp && \
    git clone --depth 1 --branch $FDK_AAC_TAG git://github.com/mstorsjo/fdk-aac.git && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix=$INSTALL_DIR --enable-static --enable-shared && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf fdk-aac

# Install libvpx
ENV LIBVPX_TAG v1.3.0
RUN cd /tmp && \
    git clone --depth 1 --branch $LIBVPX_TAG https://chromium.googlesource.com/webm/libvpx && \
    cd libvpx && \
    ./configure --prefix=$INSTALL_DIR --disable-examples --enable-static --enable-shared && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf libvpx

# Install ffmpeg
ENV FFMPEG_TAG n2.4.2
RUN cd /tmp && \
    git clone --depth 1 --branch $FFMPEG_TAG  git://source.ffmpeg.org/ffmpeg && \
    cd ffmpeg && \
    ./configure --prefix=$INSTALL_DIR \
      --extra-cflags="-I${INSTALL_DIR}/include" \
      --extra-ldflags="-L${INSTALL_DIR}/lib" \
      --extra-libs="-ldl" \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libmp3lame \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-shared \
      --enable-nonfree && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf ffmpeg
