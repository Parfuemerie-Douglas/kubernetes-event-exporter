FROM golang:1.14-alpine AS builder

WORKDIR /src

ADD go.mod /src/go.mod
ADD go.sum /src/go.sum

RUN go mod download

ADD . /src

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO11MODULE=on go build -o /src/kubernetes-event-exporter .

FROM gcr.io/distroless/base
COPY --from=builder --chown=nonroot:nonroot /src/kubernetes-event-exporter /kubernetes-event-exporter

USER nonroot

ENTRYPOINT ["/kubernetes-event-exporter"]



