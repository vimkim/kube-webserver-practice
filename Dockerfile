FROM golang:1.23.5 AS builder

WORKDIR /app
COPY main.go .

# Ensure a static binary for Linux (Alpine uses musl)
RUN go mod init app && go mod tidy && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server .

# Ensure execution permissions
RUN chmod +x /root/server

EXPOSE 8080

CMD ["./server"]
