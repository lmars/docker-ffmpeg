FROM ubuntu:precise
MAINTAINER Lewis Marshall <lewis@lmars.net>

ENV INSTALL_DIR /usr/local

# Enable Universe and Multiverse
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe multiverse >> /etc/apt/sources.list && \
    apt-get update

# Install dependent packages
RUN apt-get install -y autoconf automake libass-dev libgpac-dev libmp3lame-dev \
    libtheora-dev libtool libvorbis-dev pkg-config texi2html wget && \
    apt-get clean

# Install build tools
RUN apt-get install -y build-essential && \
    apt-get clean

# Install YASM
ENV YASM_VERSION 1.2.0
RUN cd /tmp && \
    wget http://www.tortall.net/projects/yasm/releases/yasm-$YASM_VERSION.tar.gz && \
    tar xzf yasm-$YASM_VERSION.tar.gz && \
    cd yasm-$YASM_VERSION && \
    ./configure --prefix=$INSTALL_DIR && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf yasm*

# Install recent version of git
RUN apt-get install -y python-software-properties && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y git
    apt-get clean

# Install x264
ENV X264_SHA c628e3b
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
ENV FDK_AAC_TAG v0.1.2
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
ENV LIBVPX_TAG v1.2.0
RUN cd /tmp && \
    git clone --depth 1 --branch $LIBVPX_TAG http://git.chromium.org/webm/libvpx.git && \
    cd libvpx && \
    ./configure --prefix=$INSTALL_DIR --disable-examples --enable-static --enable-shared && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf libvpx

# Install ffmpeg
ENV FFMPEG_TAG n1.2.4
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
