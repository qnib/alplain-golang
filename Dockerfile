ARG DOCKER_REGISTRY=docker.io
ARG DOCKER_IMG_TAG=":3.6"
ARG DOCKER_IMG_HASH="@sha256:0b220296255b5458feddda48bc848b0ab2d7e4d6601bb92ff58f41cfc24202a7"
FROM ${DOCKER_REGISTRY}/qnib/alplain-init${DOCKER_IMG_TAG}${DOCKER_IMG_HASH}

# Inspired by official golang image
# > https://github.com/docker-library/golang/blob/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/alpine/Dockerfile
RUN apk add --no-cache ca-certificates
ARG GOLANG_VERSION=1.9.2
ARG GOLANG_SRC_URL=https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		bash \
		gcc \
		musl-dev \
		openssl \
		go \
	\
	&& export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
	\
	&& wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz \
	&& cd /usr/local/go/src \
	&& ./make.bash \
	&& apk del .build-deps


ENV GOPATH /usr/local/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
RUN apk --no-cache  add git gcc musl-dev \
 && go get -u github.com/kardianos/govendor
