#Build stage 1
FROM golang:1.20 AS build
WORKDIR /app
COPY . /app
RUN go mod download && go mod verify \
    && cd /app \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o frontend

#Build stage 2
FROM scratch
WORKDIR /app
COPY --from=build /app/templates /app/templates 
COPY --from=build /app/static /app/static 
COPY --from=build /app/frontend /app/
ENTRYPOINT ["./frontend"]