#!/usr/bin/env bash

lang=$(locale | grep '^LANG=' | sed 's/^LANG=//')

# 判断语言环境变量是否包含zh
if [[ "$lang" == *zh* ]]; then
  lang=zh
else
  lang=en
fi

name=i18nsite
docker ps --format "{{.Names}}" | grep $name || docker start $name >/dev/null 2>&1 || (
  docker run \
    -d \
    -p 8222:22 \
    -v ./mnt/var/log:/var/log \
    -v ./mnt/root:/root \
    --name $name \
    --hostname=$name \
    $name/dev_$lang && timeout 2s docker logs -f $name
)

docker exec -it $name bash -c "cd /root && exec /root/.tmux_default"
