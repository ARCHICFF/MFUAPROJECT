#!/bin/bash
# Скрипт генерирует случайный пароль длиной 8 символов

length=8
chars='A-Za-z0-9!@#$%^&*()_+'

password=$(tr -dc "$chars" < /dev/urandom | head -c "$length")

echo "Сгенерированный пароль: $password"
