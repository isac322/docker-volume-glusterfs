FROM golang:1.16 as builder
WORKDIR /go/src/github.com/isac322/docker-volume-glusterfs
COPY . .
RUN go get -d -v ./...
RUN go install --ldflags '-extldflags "-static"' -v ./...

FROM ubuntu:20.04
RUN apt-get update \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:gluster/glusterfs-9 \
  && apt-get update \
  && apt-get install glusterfs-client -y \
  && apt-get purge software-properties-common -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/docker-volume-glusterfs .
CMD ["docker-volume-glusterfs"]

