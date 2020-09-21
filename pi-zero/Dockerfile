FROM debian:stretch

MAINTAINER Peter Lai "peter@diode.io"

LABEL crosscompie={pizero}

ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=6
ENV CC="arm-linux-gnueabihf-gcc -O3"
ENV CXX="arm-linux-gnueabihf-g++ -O3"
ENV AR="arm-linux-gnueabihf-ar r"
ENV RANLIB="arm-linux-gnueabihf-ranlib"
ENV CGO_ENABLED=1

RUN apt-get update -y && \
    apt-get install -y git && \
    apt-get install -y build-essential && \
    apt-get install -y pkg-config && \
    apt-get install -y upx && \
    apt-get install -y zip && \
    apt-get install -y wget

# for building raspberry pi firmware
RUN echo "Downloading raspberrypi tools......"
RUN git clone --progress --verbose https://github.com/raspberrypi/tools.git --depth=1 pitools
ENV PATH "/pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH"

# positioning strip
RUN ln -s `which arm-linux-gnueabihf-strip` /pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/strip

# install golang
RUN echo "Build and install golang......"
RUN wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz && \
    [ "aed845e4185a0b2a3c3d5e1d0a35491702c55889192bb9c30e67a3de6849c067" = "$(sha256sum go1.14.4.linux-amd64.tar.gz | cut -d ' ' -f1)" ] && \
    tar -xvf go1.14.4.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT "/usr/local/go"
RUN mkdir /go
ENV GOPATH "/go"
ENV PATH "$GOPATH/bin:$GOROOT/bin:$PATH"

RUN mkdir build
WORKDIR /build

# install openssl
RUN echo "Installing openssl......"
COPY *.deb ./
RUN mkdir /openssl && \
    ar x libssl1.1_1.1.1d-0+deb10u3+rpt1_armhf.deb && \
    tar -C /openssl/ -xJf data.tar.xz && \
    ar x libssl-dev_1.1.1d-0+deb10u3+rpt1_armhf.deb && \
    tar -C /openssl/ -xJf data.tar.xz && \
    ar x libc6_2.28-10+rpi1_armhf.deb && \
    tar -C /pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/arm-linux-gnueabihf/libc/ -xJf data.tar.xz

# Couldn't get this to work, so using sed instead...
# ENV PKG_CONFIG_LIBSSL_PREFIX /openssl/usr
# ENV PKG_CONFIG_LIBCRYPTO_PREFIX /openssl/usr
RUN sed -i -e 's!/usr!/openssl/usr!' /openssl/usr/lib/arm-linux-gnueabihf/pkgconfig/libcrypto.pc && \
    sed -i -e 's!/usr!/openssl/usr!' /openssl/usr/lib/arm-linux-gnueabihf/pkgconfig/libssl.pc

ENV PKG_CONFIG_PATH /openssl/usr/lib/arm-linux-gnueabihf/pkgconfig
ENV CPATH /openssl/usr/include/:/openssl/usr/include/arm-linux-gnueabihf/
ENV CGO_LDFLAGS "-L/openssl/usr/lib/arm-linux-gnueabihf/ -l:libssl.a -l:libcrypto.a -ldl"

# build diode
RUN git clone https://github.com/diodechain/diode_go_client.git
WORKDIR /build/diode_go_client

ARG branch=master
RUN git fetch origin
RUN git reset --hard origin/$branch
RUN make archive
