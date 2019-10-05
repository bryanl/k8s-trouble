FROM golang:latest AS builder
ADD . /apps/tempermental
WORKDIR /apps/tempermental
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /tempermental -ldflags '-s -w' ./cmd/tempermental

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /tempermental ./
RUN chmod +x ./tempermental
ENTRYPOINT ["./tempermental"]
EXPOSE 8080
