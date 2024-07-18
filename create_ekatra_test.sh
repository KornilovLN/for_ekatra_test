#!/bin/bash

# Понадобиться установить утилиту jq
# sudo apt-get install jq

# Переходим в /mnt/poligon
cd /mnt/poligon

# Создаем папку ekatra-test
mkdir -p ekatra-test
cd ekatra-test

# Копируем JSON файл с конфигурацией
cp /path/to/config.json ./

# Читаем данные из JSON файла
components=$(jq -c '.components[]' config.json)

# Клонируем проекты из GitLab
for component in $components; do
    name=$(echo $component | jq -r '.name')
    git_url=$(echo $component | jq -r '.git_url')
    
    echo "Клонирование $name из $git_url"
    git clone $git_url $name
done

# Настройка /etc/hosts
echo "Настройка /etc/hosts"
while IFS= read -r component; do
    ip=$(echo $component | jq -r '.ip')
    dns=$(echo $component | jq -r '.dns')
    
    # Добавляем запись в /etc/hosts (потребуются права sudo)
    echo "$ip $dns" | sudo tee -a /etc/hosts
done <<< "$components"

echo "Настройка завершена"
