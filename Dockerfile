FROM ubuntu:20.04

# Run noninteractive

ARG DEBIAN_FRONTEND=noninteractive

# Create Helm user and home directory for Helm data

ARG HELMUSER=helm
ARG HELMID=1000
ARG HELMDIR=/${HELMUSER}
RUN groupadd -g ${HELMID} -o ${HELMUSER} && \
    useradd -m -u ${HELMID} -g ${HELMID} -o -d ${HELMDIR} -s /bin/bash ${HELMUSER}

# Add Helm user to Docker group

RUN groupadd docker && \
    usermod -aG docker ${HELMUSER}

# Export Helm home variables

ENV HELM_CACHE_HOME=${HELMDIR}/.cache/helm
ENV HELM_CONFIG_HOME=${HELMDIR}/.config/helm
ENV HELM_DATA_HOME=${HELMDIR}/.local/share/helm

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

ARG AZ_VERSION=2.34.1
RUN pip3 install -Iv azure-cli==${AZ_VERSION}

RUN pip3 install yq

# Install Kubectl

ARG KUBECTL_VERSION=1.21.11
RUN wget "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -O /usr/local/bin/kubectl --no-verbose \
    && chmod +x /usr/local/bin/kubectl

# Install Helm

ARG HELM_VERSION=3.8.1
RUN wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -O /tmp/helm.tgz --no-verbose \
    && tar zxf /tmp/helm.tgz --strip-components 1 -C /usr/local/bin/ && rm /tmp/*

# Install Helmfile

ARG HELMFILE_VERSION=0.144.0
RUN wget "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" -O /usr/local/bin/helmfile --no-verbose \
    && chmod +x /usr/local/bin/helmfile

# Install Helm plugins

RUN helm plugin install https://github.com/databus23/helm-diff && \
    helm plugin install https://github.com/futuresimple/helm-secrets && \
    helm plugin install https://github.com/aslafy-z/helm-git.git

RUN chown -R ${HELMUSER}:root ${HELMDIR} && \
    chmod -R 777 ${HELMDIR}
