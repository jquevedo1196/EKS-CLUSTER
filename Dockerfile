FROM python:3.10-alpine
WORKDIR /usr/automator

COPY . .

# En el siguiente bloque se instalan todas las dependencias necesarias para ejecutar el proyecto
RUN apk add curl\
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && apk add poetry \
    && poetry install \
    && apk add terraform \
    && apk add aws-cli \
    && curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" \
    && tar -xzf eksctl_Linux_amd64.tar.gz -C /tmp && rm eksctl_Linux_amd64.tar.gz \
    && mv /tmp/eksctl /usr/local/bin \
    && apk add helm \
    && apk add envsubst
