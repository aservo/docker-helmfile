FROM ubuntu:20.04

# Install basic packages

RUN apt-get update && apt-get install -y curl git jq ncat pwgen python3-pip sudo unzip wget

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

ARG HELMFILE_VERSION=0.141.0
RUN wget "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" -O /usr/local/bin/helmfile --no-verbose \
    && chmod +x /usr/local/bin/helmfile

# Install Helm plugins

RUN \
    helm plugin install https://github.com/databus23/helm-diff && \
    helm plugin install https://github.com/futuresimple/helm-secrets && \
    helm plugin install https://github.com/aslafy-z/helm-git.git
