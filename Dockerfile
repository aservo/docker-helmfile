FROM ubuntu:20.04

ENV HELM_HOME="/home/helm/.helm"

# Install basic packages

RUN apt-get update && apt-get install -y git jq ncat pwgen python3-pip wget unzip

# Install PIP packages

RUN pip3 install yq

# Install Kubectl

ARG KUBECTL_VERSION=1.18.2
RUN wget "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -O /usr/local/bin/kubectl --no-verbose \
    && chmod +x /usr/local/bin/kubectl

# Install Helm

ARG HELM_VERSION=3.6.1
RUN wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -O /tmp/helm.tgz --no-verbose \
    && tar zxf /tmp/helm.tgz --strip-components 1 -C /usr/local/bin/ && rm /tmp/*

# Install Helmfile

ARG HELMFILE_VERSION=0.139.9
RUN wget "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" -O /usr/local/bin/helmfile --no-verbose \
    && chmod +x /usr/local/bin/helmfile

# Install vault

ARG VAULT_VERSION=1.7.3
RUN wget "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -O /tmp/vault.zip --no-verbose \
    && unzip /tmp/vault.zip -d /usr/local/bin/ && rm /tmp/*

RUN adduser --disabled-password --uid 1000 helm

USER helm

WORKDIR /home/helm

# Install Helm plugins

RUN \
  helm plugin install https://github.com/databus23/helm-diff && \
  helm plugin install https://github.com/futuresimple/helm-secrets && \
  helm plugin install https://github.com/aslafy-z/helm-git.git
