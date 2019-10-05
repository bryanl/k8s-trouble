FROM golang:latest AS builder
ADD . /apps/hello-world
WORKDIR /apps/hello-world
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /hello-world ./cmd/hello-world

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /hello-world ./
RUN chmod +x ./hello-world
ENTRYPOINT ["./hello-world"]
EXPOSE 8080
