FROM alpine:latest

RUN apk add --virtual .build-deps git cmake autoconf automake make gcc g++ pcsc-lite pcsc-lite-dev pcsc-lite-libs

WORKDIR /tmp

RUN git clone https://github.com/stz2012/libarib25.git \
	&& cd ./libarib25/cmake \
	&& cmake .. \
	&& make \
	&& make install

RUN git clone https://github.com/nativeshoes/px_drv \ 
	&& cd px_drv/recpt1 \
 	&& sh autogen.sh \
	&& ./configure --enable-b25 \
	&& sed -i -E 's!(typedef struct )msgbuf!\1!' recpt1core.h \
	&& sed -i -E 's!(#ifndef )!#include <sys/types.h>\n\1!' recpt1.h \
	&& make \
	&& make install
