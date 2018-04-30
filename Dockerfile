ARG DOCKER_REGISTRY=docker.io
ARG DOCKER_IMG_TAG=":edge"
ARG DOCKER_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/qnib/alplain-init${DOCKER_IMG_TAG}${DOCKER_IMG_HASH}

# Inspired by official golang image
# > https://github.com/docker-library/golang/blob/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/alpine/Dockerfile
RUN apk add --no-cache	musl-dev \
		openssl \
		librdkafka-dev \
		git \
		go \
 && go get -u github.com/kardianos/govendor

ENV GOPATH /usr/local/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" \
 && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
