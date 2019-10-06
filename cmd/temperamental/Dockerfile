FROM golang:latest AS builder
ADD . /apps/temperamental
WORKDIR /apps/temperamental
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /temperamental -ldflags '-s -w' ./cmd/temperamental

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /temperamental ./
RUN chmod +x ./temperamental
ENTRYPOINT ["./temperamental"]
EXPOSE 8080
