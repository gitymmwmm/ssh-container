FROM alpine:latest

# Аргумент для задания порта SSH (по умолчанию 22)
ARG SSH_PORT=22

# Обновляем сертификаты и устанавливаем OpenSSH сервер
RUN apk add --no-cache ca-certificates && \
    apk add --no-cache openssh-server

# Создаём директорию для ключей пользователя root
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Копируем файл с публичными ключами
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Настраиваем sshd: разрешаем вход только по ключам для root
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Устанавливаем порт SSH через аргумент сборки
RUN sed -i "/^#*Port /d" /etc/ssh/sshd_config && \
    echo "Port ${SSH_PORT}" >> /etc/ssh/sshd_config

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
