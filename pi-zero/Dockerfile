FROM debian:buster

MAINTAINER Peter Lai "peter@diode.io"

LABEL crosscompie={pizero}

ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=6
ENV CC=arm-linux-gnueabihf-gcc
ENV CXX=arm-linux-gnueabihf-g++
ENV CGO_ENABLED=1

RUN apt-get update -y && \
    apt-get install -y git && \
    apt-get install -y build-essential && \
    apt-get install -y pkg-config && \
    apt-get install -y wget

# for building raspberry pi firmware
RUN echo "Downlaod raspberrypi tools......"
RUN git clone --progress --verbose https://github.com/raspberrypi/tools.git --depth=1 pitools
ENV PATH "/pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH"

# install golang
RUN echo "Install golang......"
RUN wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz && tar -xvf go1.13.3.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT "/usr/local/go"
RUN mkdir /go
ENV GOPATH "/go"
ENV PATH "$GOPATH/bin:$GOROOT/bin:$PATH"

# install openssl
RUN echo "Install openssl......"
RUN wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz && tar xzf openssl-1.0.2l.tar.gz
RUN mkdir /usr/local/openssl
WORKDIR /openssl-1.0.2l
RUN ./Configure --prefix=/usr/local/openssl os/compiler:arm-linux-gnueabihf
RUN make CC="arm-linux-gnueabihf-gcc" AR="arm-linux-gnueabihf-ar r" RANLIB="arm-linux-gnueabihf-ranlib"
RUN make install

RUN mkdir build
WORKDIR /build
