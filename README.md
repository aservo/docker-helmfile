Helmfile
========

This is a Docker image that has been "optimized" to run with GitHub Actions.
This means:

* it can be run with the `root` user
* it does not declare an own workdir

See https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions

## Binaries

This Docker image contains the following primary binaries:

* [`az`](https://pypi.org/project/azure-cli/) (Azure CLI)
* `git`
* [`helm`](https://github.com/helm/helm/releases)
* [`helmfile`](https://github.com/roboll/helmfile/releases)
* [`kubectl`](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.22.md) (Kubernetes client)
* `docker`

## Example:

```
on:
  push:
    branches: [ main ]

jobs:
  helmfile:
    runs-on: ubuntu-20.04
    container:
      image: ghcr.io/aservo/helmfile:latest
    steps:
    - name: Helmfile Help
      uses: helmfile --help
```

## Development

Build image:

```
docker build .
...
Successfully built a123b4c567de
```

Run image:

```
$ docker run -it a123b4c567de bash
root@a123b4c567de:/#
```

Execute commands inside the container:

```
root@a123b4c567de:/# helmfile -v
helmfile version X.Y.Z
```
