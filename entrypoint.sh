#!/bin/sh

# Генерируем хост-ключи, если их нет (ssh-keygen -A создаёт только отсутствующие)
ssh-keygen -A

# Запускаем sshd на переднем плане с выводом логов в stderr
exec /usr/sbin/sshd -D -e