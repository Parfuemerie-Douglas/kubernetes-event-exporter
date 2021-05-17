FROM golang:1.14-alpine

ARG user=kubernetes-event-exporter
ARG group=kubernetes-event-exporter
ARG uid=1010
ARG gid=1010

WORKDIR /src

ADD go.mod /src/go.mod
ADD go.sum /src/go.sum

RUN go mod download

ADD . /src

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO11MODULE=on go build -o /src/kubernetes-event-exporter .

RUN mkdir /app \
  && mv /src/kubernetes-event-exporter /app/kubernetes-event-exporter\
  && rm -rf /src \
  && chmod +x /app/kubernetes-event-exporter \
  && addgroup -g ${gid} ${group} \
  && adduser -u ${uid} -G ${group} -s /bin/bash -D ${user} \
  && chown ${uid}:${gid} /app/kubernetes-event-exporter

USER ${user}

ENTRYPOINT ["/app/kubernetes-event-exporter"]