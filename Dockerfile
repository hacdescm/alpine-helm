FROM alpine:latest

ENV HELM_VERSION 2.11.0
ENV KUBERNETES_VERSION 1.10.9

RUN apk update && \
    apk add -U openssl curl tar gzip bash ca-certificates git wget unzip; \
    curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk; \
    apk add glibc-2.28-r0.apk; \
    rm glibc-2.28-r0.apk

RUN curl -L "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar zx; \
    mv linux-amd64/helm /usr/bin/; \
    mv linux-amd64/tiller /usr/bin/; \
    helm version --client; \
    tiller -version

RUN curl -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl"; \
    chmod +x /usr/bin/kubectl; \
    kubectl version --client

RUN cd /usr/local/share/ca-certificates; \
    curl -L -O "https://github.com/hacdescm/certs/archive/master.zip"; \
    unzip -j master.zip; \
    rm master.zip; \ 
    update-ca-certificates