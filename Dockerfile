FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
ENV HELM_HOME="/root/.helm"

# Install basic packages

RUN apt-get update && apt-get install -y \
    apt-transport-https curl git jq ncat pwgen python3-pip software-properties-common sudo wget unzip

# Install PIP packages

RUN pip3 install yq

# Install Kubectl

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl

# Install Helm

ARG HELM_VERSION=3.6.1
RUN wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -O /tmp/helm.tgz --no-verbose \
    && tar zxf /tmp/helm.tgz --strip-components 1 -C /usr/local/bin/ && rm /tmp/*

# Install Helmfile

ARG HELMFILE_VERSION=0.139.9
RUN wget "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" -O /usr/local/bin/helmfile --no-verbose \
    && chmod +x /usr/local/bin/helmfile

# Install vault

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install -y vault

# Fix vault permission problem - only do that when not running vault as server,
# see https://stackoverflow.com/q/64284884/4278102

RUN setcap cap_ipc_lock= /usr/bin/vault

# Install Helm plugins

RUN helm plugin install https://github.com/databus23/helm-diff
