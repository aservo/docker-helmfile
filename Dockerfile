FROM ubuntu:20.04

# Run noninteractive

ARG DEBIAN_FRONTEND=noninteractive

# Export Helm home variables

ENV HELM_CACHE_HOME="/root/.cache/helm"
ENV HELM_CONFIG_HOME="/root/.config/helm"
ENV HELM_DATA_HOME="/root/.local/share/helm"

# Export Helm variable to enable experimental OCI features

ENV HELM_EXPERIMENTAL_OCI=1

# Install basic packages (seperation not necessary anymore with podman available in Ubuntu 20.10 or higher)

RUN \
    apt-get update && \
    apt-get install -y curl gnupg

# Configure repository for podman (will not be needed with Ubuntu 20.10 or higher anymore)

RUN \
    . /etc/os-release && \
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
    curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | apt-key add -

# Install main packages

RUN \
    apt-get update && \
    apt-get install -y git jq ncat podman pwgen python3-pip sudo unzip wget && \
    apt-get clean

# Install PIP packages

ARG AZ_VERSION=2.29.0
RUN pip3 install -Iv azure-cli==${AZ_VERSION}

RUN pip3 install yq

# Install Kubectl

ARG KUBECTL_VERSION=1.20.5
RUN wget "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -O /usr/local/bin/kubectl --no-verbose \
    && chmod +x /usr/local/bin/kubectl

# Install Helm

ARG HELM_VERSION=3.7.0
RUN wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -O /tmp/helm.tgz --no-verbose \
    && tar zxf /tmp/helm.tgz --strip-components 1 -C /usr/local/bin/ && rm /tmp/*

# Install Helmfile

ARG HELMFILE_VERSION=0.143.0
RUN wget "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" -O /usr/local/bin/helmfile --no-verbose \
    && chmod +x /usr/local/bin/helmfile

# Install Helm plugins

RUN \
    helm plugin install https://github.com/databus23/helm-diff && \
    helm plugin install https://github.com/futuresimple/helm-secrets && \
    helm plugin install https://github.com/aslafy-z/helm-git.git

# Create Docker alias for Podman

RUN alias docker=podman
