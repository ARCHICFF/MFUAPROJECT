#!/bin/bash
# Скрипт создаёт структуру папок для веб-проекта
#
# Структура:
# my-project/
# ├── index.html
# ├── css/
# │   └── style.css
# └── js/
#     └── script.js

read -p "Введите название проекта (по умолчанию my-project): " project_name
project_name=${project_name:-my-project}

if [ -d "$project_name" ]; then
    echo "Ошибка: папка '$project_name' уже существует."
    exit 1
fi

mkdir -p "$project_name/css" "$project_name/js"

touch "$project_name/index.html"
touch "$project_name/css/style.css"
touch "$project_name/js/script.js"

cat <<EOF > "$project_name/index.html"
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>$project_name</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>$project_name</h1>
    <script src="js/script.js"></script>
</body>
</html>
EOF

echo "Структура проекта '$project_name' создана:"
find "$project_name" -print
