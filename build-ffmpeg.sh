#!/bin/bash

# Loosely based on the ffmpeg instructions...
# https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

export DIR=/usr/local
export SRC=/root/ffmpeg_src
mkdir $SRC

cd $SRC
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="$DIR"
make
make install
make distclean

cd $SRC
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --prefix="$DIR" --enable-static
make
make install
make distclean

cd $SRC
hg clone https://bitbucket.org/multicoreware/x265
cd $SRC/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$DIR" -DENABLE_SHARED:bool=off ../../source
make
make install

cd $SRC
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$DIR" --disable-shared
make
make install
make distclean

cd $SRC
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$DIR" --disable-shared --enable-nasm
make
make install
make distclean

cd $SRC
git clone git://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="$DIR" --disable-shared
make
make install
make distclean

cd $SRC
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="$DIR" --disable-shared
make
make install
make distclean

cd $SRC
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
LDFLAGS="-L$DIR/lib" CPPFLAGS="-I$DIR/include" ./configure --prefix="$DIR" --with-ogg="$DIR" --disable-shared
make
make install
make distclean

cd $SRC
git clone -b v1.4.0 --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$DIR" --disable-examples
make
make install
make clean

cd $SRC
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$DIR/lib/pkgconfig" ./configure --prefix="$DIR" --extra-cflags="-I$DIR/include" --extra-ldflags="-L$DIR/lib" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265
make
make install
make distclean
hash -r

echo DONE
