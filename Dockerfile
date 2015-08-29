FROM centos:7.1.1503

RUN yum -y install \
        autoconf \
        automake \
        cmake \
        freetype-devel \
        gcc \
        gcc-c++ \
        git \
        libtool \
        make \
        mercurial \
        nasm \
        pkgconfig \
        zlib-devel \
 && yum clean all

WORKDIR /root
COPY build-ffmpeg.sh /root/
RUN ./build-ffmpeg.sh

ENTRYPOINT [ "/usr/local/bin/ffmpeg" ]
CMD [ "-h" ]

