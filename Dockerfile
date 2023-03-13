ARG HELMFILE_VERSION=0.151.0

FROM ghcr.io/helmfile/helmfile-ubuntu:v${HELMFILE_VERSION}

# Run noninteractive

ARG DEBIAN_FRONTEND=noninteractive

# Install main packages

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
        curl \
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

ARG AZ_VERSION=2.46.0
RUN pip3 install -Iv azure-cli==${AZ_VERSION}

RUN pip3 install yq

# Disable Helmfile upgrade check

ENV HELMFILE_UPGRADE_NOTICE_DISABLED="true"

RUN groupadd -g 1000 helmfile && \
    useradd -m -u 1000 -g helmfile helmfile

USER helmfile

# Remove WORKDIR and ENTRYPOINT FROM base image

WORKDIR /
ENTRYPOINT []
