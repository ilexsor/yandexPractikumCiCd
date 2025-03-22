# Build stage
FROM golang:1.23 AS builder

WORKDIR /app

COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o main .

# Release stage
FROM alpine:3.18

WORKDIR /app

COPY --from=builder /app/main .

RUN chmod +x main

COPY --from=builder /app/tracker.db .

CMD ["./main"]