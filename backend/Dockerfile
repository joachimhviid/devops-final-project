#Build stage 1
FROM golang:1.20 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o backend .

#Build stage 2
FROM scratch
WORKDIR /app
COPY --from=build /app/backend .
ENTRYPOINT ["/app/backend"]