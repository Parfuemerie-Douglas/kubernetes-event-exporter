FROM golang:1.14 AS builder

ADD . /app
WORKDIR /app

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO11MODULE=on go build -mod=vendor -a -o /main .

FROM gcr.io/distroless/base

ARG user=scraper
ARG group=scraper
ARG uid=1010
ARG gid=1010

RUN addgroup -g ${gid} ${group} \
  && adduser -u ${uid} -G ${group} -s /bin/bash -D ${user}

COPY --from=builder --chown=scraper:scraper /main /kubernetes-event-exporter

USER scraper

ENTRYPOINT ["/kubernetes-event-exporter"]