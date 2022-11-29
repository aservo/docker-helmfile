FROM ghcr.io/helmfile/helmfile-ubuntu:v0.148.1

# Run noninteractive

ARG DEBIAN_FRONTEND=noninteractive

# Allow running with any other user than root.
# TODO: Remove again when https://github.com/helmfile/helmfile/pull/546 has been merged and released!

ARG HELM_CACHE_HOME="/root/.cache/helm"
ENV HELM_CACHE_HOME="${HELM_CACHE_HOME}"
ARG HELM_CONFIG_HOME="/root/.config/helm"
ENV HELM_CONFIG_HOME="${HELM_CONFIG_HOME}"
ARG HELM_DATA_HOME="/root/.local/share/helm"
ENV HELM_DATA_HOME="${HELM_DATA_HOME}"

# Install basic packages

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

# Install main packages

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        containerd.io \
        docker-ce \
        docker-ce-cli \
        git \
        jq \
        make \
        ncat \
        postgresql-client \
        pwgen \
        python3-pip \
        sudo \
        unzip \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PIP packages

ARG AZ_VERSION=2.42.0
RUN pip3 install -Iv azure-cli==${AZ_VERSION}

RUN pip3 install yq

# Disable Helmfile upgrade check

ENV HELMFILE_UPGRADE_NOTICE_DISABLED="true"

# Remove WORKDIR and ENTRYPOINT FROM base image

WORKDIR /
ENTRYPOINT []
