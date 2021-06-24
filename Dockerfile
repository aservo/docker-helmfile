FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive  
ENV TZ=Europe/Berlin

# Install basic packages

RUN apt-get update && apt-get install -y \
    apt-transport-https curl git jq ncat pwgen python3-pip software-properties-common wget unzip

# Install PIP packages

RUN pip3 install yq

# Install Kubectl

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl

# Install Helm

RUN curl -s https://baltocdn.com/helm/signing.asc | apt-key add - \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update && apt-get install -y helm

# Install Helmfile

RUN wget https://github.com/roboll/helmfile/releases/download/v0.139.9/helmfile_linux_amd64 -O /usr/local/bin/helmfile --no-verbose \
    && chmod +x /usr/local/bin/helmfile

# Install vault

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install -y vault

# Only do that when not running vault as server

RUN setcap cap_ipc_lock= /usr/bin/vault

# Install Helm plugins in entrypoint as otherwise they somehow cannot be used

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
