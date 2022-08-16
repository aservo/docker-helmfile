FROM ghcr.io/helmfile/helmfile-ubuntu:v0.145.3

# Run noninteractive

ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages

RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg lsb-release

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

# Install main packages

RUN apt-get update && \
    apt-get install -y containerd.io docker-ce docker-ce-cli git jq ncat pwgen python3-pip sudo unzip wget && \
    apt-get clean

# Install PIP packages

ARG AZ_VERSION=2.38.0
RUN pip3 install -Iv azure-cli==${AZ_VERSION}

RUN pip3 install yq

# Remove WORKDIR and ENTRYPOINT FROM base image

WORKDIR /
ENTRYPOINT []
