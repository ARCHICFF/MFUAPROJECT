#!/bin/bash
# GitHub Repository Analyzer (без сторонних библиотек — только curl, grep, sed)
# Использование: ./github-stats.sh owner/repo
# Пример:        ./github-stats.sh tensorflow/tensorflow

# --- Цвета ---
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Проверка зависимостей (только curl, jq не нужен) ---
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Ошибка: команда 'curl' не найдена. Установите её (sudo apt install curl).${RESET}"
    exit 1
fi

# --- Проверка аргумента ---
if [ -z "$1" ]; then
    echo -e "${RED}Ошибка: укажите репозиторий в формате owner/repo${RESET}"
    echo "Пример: ./github-stats.sh tensorflow/tensorflow"
    exit 1
fi

repo="$1"

echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  🚀 GitHub Repository Analyzer            ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# --- Запрос к API ---
url="https://api.github.com/repos/${repo}"
response=$(curl -s -w "\n%{http_code}" "$url")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" -eq 404 ]; then
    echo -e "${RED}Ошибка: репозиторий '$repo' не найден.${RESET}"
    exit 1
elif [ "$http_code" -eq 403 ]; then
    echo -e "${RED}Ошибка: превышен лимит запросов к GitHub API. Попробуйте позже.${RESET}"
    exit 1
elif [ "$http_code" -ne 200 ]; then
    echo -e "${RED}Ошибка: неожиданный код ответа API — $http_code${RESET}"
    exit 1
fi

# --- Разбор JSON без jq: grep + sed ---
# Поля GitHub API документированы и стабильны, поэтому имена берём точные.
extract_field() {
    local json="$1"
    local key="$2"
    echo "$json" | grep -oE "\"$key\"[[:space:]]*:[[:space:]]*(\"[^\"]*\"|[0-9]+|null)" \
        | head -n1 \
        | sed -E "s/\"$key\"[[:space:]]*:[[:space:]]*//; s/^\"//; s/\"$//"
}

name=$(extract_field "$body" "full_name")
stars=$(extract_field "$body" "stargazers_count")
forks=$(extract_field "$body" "forks_count")
issues=$(extract_field "$body" "open_issues_count")
updated=$(extract_field "$body" "updated_at")
# owner.login встречается несколько раз (owner и, например, license), берём первое совпадение "login"
owner=$(echo "$body" | grep -oE '"login"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n1 | sed -E 's/.*:[[:space:]]*"//; s/"$//')

if [ -z "$name" ]; then
    echo -e "${RED}Не удалось разобрать ответ API.${RESET}"
    exit 1
fi

stars=${stars:-0}
forks=${forks:-0}
issues=${issues:-0}

# --- Цвет issues: красный если > 100, иначе жёлтый ---
if [ "$issues" -gt 100 ] 2>/dev/null; then
    issues_color="$RED"
else
    issues_color="$YELLOW"
fi

echo -e "📦 Репозиторий: ${BOLD}$name${RESET}"
echo -e "⭐ Звёзды:       ${YELLOW}${stars}${RESET}"
echo -e "🔀 Форки:        ${GREEN}${forks}${RESET}"
echo -e "🐛 Open Issues:  ${issues_color}${issues}${RESET}"
[ -n "$owner" ] && echo -e "👤 Автор:        $owner"
[ -n "$updated" ] && echo -e "📊 Обновлён:     $updated"
