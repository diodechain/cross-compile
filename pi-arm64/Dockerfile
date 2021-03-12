FROM debian:stretch

MAINTAINER Peter Lai "peter@diode.io"

LABEL crosscompie={piarm64}

ENV GOOS=linux
ENV GOARCH=arm
ENV CC="arm-linux-gnueabihf-gcc -O3 -march=armv8-a"
ENV CXX="arm-linux-gnueabihf-g++ -O3 -march=armv8-a"
ENV CGO_ENABLED=1

RUN apt-get update -y && \
    apt-get install -y git && \
    apt-get install -y build-essential && \
    apt-get install -y pkg-config && \
    apt-get install -y upx && \
    apt-get install -y zip && \
    apt-get install -y wget

# for building raspberry pi firmware
RUN echo "Downlaod raspberrypi tools......"
RUN git clone --progress --verbose https://github.com/raspberrypi/tools.git --depth=1 pitools
ENV PATH "/pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH"

# positioning strip
RUN ln -s `which arm-linux-gnueabihf-strip` /pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/strip

# install golang
RUN echo "Build and install golang......"
RUN wget https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz && \
    [ "9a58494e8da722c3aef248c9227b0e9c528c7318309827780f16220998180a0d" = "$(sha256sum go1.15.5.linux-amd64.tar.gz | cut -d ' ' -f1)" ] && \
    tar -xvf go1.15.5.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT "/usr/local/go"
RUN mkdir /go
ENV GOPATH "/go"
ENV PATH "$GOPATH/bin:$GOROOT/bin:$PATH"

# install openssl
RUN echo "Build and install openssl......"
RUN mkdir /usr/local/openssl
RUN wget -O openssl.tar.gz https://github.com/openssl/openssl/archive/OpenSSL_1_0_2u.tar.gz && \
    [ "82fa58e3f273c53128c6fe7e3635ec8cda1319a10ce1ad50a987c3df0deeef05" = "$(sha256sum openssl.tar.gz | cut -d ' ' -f1)" ] && \
    tar -xzf openssl.tar.gz
WORKDIR /openssl-OpenSSL_1_0_2u
RUN ./Configure linux-aarch64 no-ssl2 no-ssl3 no-dtls no-dtls1 no-asm --prefix=/usr/local/openssl os/compiler:arm-linux-gnueabihf
# RUN make
RUN make AR="arm-linux-gnueabihf-ar r" RANLIB="arm-linux-gnueabihf-ranlib"
RUN make install
ENV PKG_CONFIG_PATH=/usr/local/openssl/lib/pkgconfig

RUN mkdir build
WORKDIR /build

RUN git clone https://github.com/diodechain/diode_client.git
WORKDIR /build/diode_client

ARG branch=master
RUN git pull
RUN git checkout $branch
RUN make archive