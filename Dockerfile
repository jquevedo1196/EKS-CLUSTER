FROM python:3.10-alpine
WORKDIR /usr/automator

COPY . .

# En el siguiente bloque se instalanm todas las dependencias necesarias para ejecutar el proyecto
RUN apk add curl\
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && apk add poetry \
    && poetry install \
    && apk add terraform \
    && apk add aws-cli
