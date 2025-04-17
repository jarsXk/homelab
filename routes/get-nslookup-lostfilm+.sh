#!/bin/bash

filename="nslookup"
suffix="-lostfilm+"
prefix="old-"

domainList=(
  lostfilm.tv
  nnmclub.to
  kinozal.tv
  radarr.video
)
listIp=()
listDomain=()
listUniqueIp=()
listUniqueDomain=()

# Подготовка файлов для результата
if [ -f ./${filename}${suffix}.txt ]; then
  if [ -f ./${prefix}${filename}${suffix}.txt ]; then
    rm ./${prefix}${filename}${suffix}.txt
  fi

  mv ./${filename}${suffix}.txt ./${prefix}${filename}${suffix}.txt
fi

# Определение ip для доменов domainList
for domain in "${domainList[@]}"; do

  isCheck="false"
  rawLookup=$(nslookup "$domain")

  while IFS= read -r line; do

    if [[ $isCheck == "false" && $line == *"Name:"* ]]; then
      isCheck="true"
    fi

    if [[ $isCheck == "true" && $line == *"Address:"* ]]; then

      ip=$(cut -d : -f 2 <<< "$line" | xargs)

      # Массив ip
      listIp+=("$ip")
      # Массив доменов
      listDomain+=("$domain")
    fi
  done <<< $rawLookup
done

# Сборка массива уникальных ip
for element in "${!listIp[@]}"; do
  # Если ip раньше не попадался - сохранить
  if [[ ! "${listUniqueIp[@]}" =~ "${listIp[$element]}" ]]; then
    listUniqueIp+=("${listIp[$element]}")
    listUniqueDomain+=(${listDomain[$element]})
  # Если ip встречался - добавить его домен к ранее найденному домену
  else
    for element2 in "${!listUniqueIp[@]}"; do
      if [[ "${listUniqueIp[element2]}" == "${listIp[$element]}" ]]; then
        listUniqueDomain[$element2]="${listUniqueDomain[$element2]}/${listDomain[$element]}"
      fi
    done
  fi
done

for element in "${!listUniqueIp[@]}"; do
  echo "route ADD ${listUniqueIp[$element]} MASK 255.255.255.255 0.0.0.0 ${listUniqueDomain[$element]}" >> ./${filename}${suffix}.txt
done
