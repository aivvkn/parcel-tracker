# ---------- STAGE 1: build ----------
FROM golang:1.22-alpine AS builder

WORKDIR /app

# устанавливаем build tools
RUN apk add --no-cache build-base

# скачиваем зависимости
COPY go.mod go.sum ./
RUN go mod download

# копируем весь код
COPY . .

# собираем бинарник
RUN go build -o parcel-tracker .


# ---------- STAGE 2: final image ----------
FROM alpine:latest

WORKDIR /app

# sqlite3 (требуется для драйвера)
RUN apk add --no-cache sqlite-libs

# копируем бинарник
COPY --from=builder /app/parcel-tracker .

# создаём пустую БД если её нет
RUN touch tracker.db

CMD ["./parcel-tracker"]
