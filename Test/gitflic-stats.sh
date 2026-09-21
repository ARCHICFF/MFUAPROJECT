#!/bin/bash
# GitFlic Repository Analyzer (без сторонних библиотек — только curl, grep, sed)
# Использование: ./gitflic-stats.sh userAlias/projectAlias
# Пример:        ./gitflic-stats.sh SantaSpeen/gitflic

# --- Цвета ---
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Проверка зависимостей (только базовые утилиты, jq не нужен) ---
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Ошибка: команда 'curl' не найдена. Установите её (sudo apt install curl).${RESET}"
    exit 1
fi

# --- Проверка аргумента ---
if [ -z "$1" ]; then
    echo -e "${RED}Ошибка: укажите репозиторий в формате userAlias/projectAlias${RESET}"
    echo "Пример: ./gitflic-stats.sh SantaSpeen/gitflic"
    exit 1
fi

repo="$1"
owner="${repo%%/*}"
project="${repo#*/}"

if [ "$owner" == "$repo" ] || [ -z "$project" ]; then
    echo -e "${RED}Ошибка: неверный формат. Нужно userAlias/projectAlias${RESET}"
    exit 1
fi

echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  🚀 GitFlic Repository Analyzer           ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# --- Запрос к API ---
# Публичный REST API GitFlic: https://gitflic.ru/help/api/intro
url="https://api.gitflic.ru/project/${owner}/${project}"
response=$(curl -s -w "\n%{http_code}" "$url")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" -eq 404 ]; then
    echo -e "${RED}Ошибка: репозиторий '$repo' не найден.${RESET}"
    exit 1
elif [ "$http_code" -eq 403 ] || [ "$http_code" -eq 429 ]; then
    echo -e "${RED}Ошибка: превышен лимит запросов к GitFlic API либо доступ запрещён.${RESET}"
    exit 1
elif [ "$http_code" -ne 200 ]; then
    echo -e "${RED}Ошибка: неожиданный код ответа API — $http_code${RESET}"
    exit 1
fi

# --- Разбор JSON без jq: grep + sed ---
# Функция ищет значение по одному из возможных названий ключа
# (точные имена полей в GitFlic API официально не задокументированы
#  в открытом виде — при необходимости скорректируйте список ключей
#  под реальный ответ, который можно посмотреть командой:
#  curl -s "$url" )
extract_field() {
    local json="$1"
    shift
    local key
    for key in "$@"; do
        local val
        val=$(echo "$json" | grep -oE "\"$key\"[[:space:]]*:[[:space:]]*(\"[^\"]*\"|[0-9]+)" | head -n1 | sed -E "s/\"$key\"[[:space:]]*:[[:space:]]*//; s/^\"//; s/\"$//")
        if [ -n "$val" ]; then
            echo "$val"
            return 0
        fi
    done
    echo ""
}

name=$(extract_field "$body" "name" "title")
stars=$(extract_field "$body" "starCount" "stars_count" "star_count" "stars")
forks=$(extract_field "$body" "forkCount" "forks_count" "fork_count" "forks")
issues=$(extract_field "$body" "openIssueCount" "open_issues_count" "openIssuesCount" "issues")
description=$(extract_field "$body" "description")

if [ -z "$name" ]; then
    echo -e "${RED}Не удалось разобрать ответ API. Проверьте название репозитория и формат ответа:${RESET}"
    echo "$body"
    exit 1
fi

# --- Значения по умолчанию, если поле не найдено ---
stars=${stars:-0}
forks=${forks:-0}
issues=${issues:-0}

# --- Цвет issues: красный если > 100, иначе жёлтый ---
if [ "$issues" -gt 100 ] 2>/dev/null; then
    issues_color="$RED"
else
    issues_color="$YELLOW"
fi

echo -e "📦 Репозиторий: ${BOLD}${owner}/${project}${RESET}"
[ -n "$name" ] && echo -e "📝 Название:    $name"
[ -n "$description" ] && echo -e "ℹ️  Описание:    $description"
echo -e "⭐ Звёзды:       ${YELLOW}${stars}${RESET}"
echo -e "🔀 Форки:        ${GREEN}${forks}${RESET}"
echo -e "🐛 Open Issues:  ${issues_color}${issues}${RESET}"
