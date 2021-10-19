Helmfile
========

This is a Docker image that has been "optimized" to run with GitHub Actions.
This means:

* it is run with the `root` user
* it does not declare an own workdir

See https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions

## Binaries

This Docker image contains the following primary binaries:

* `az` (Azure CLI)
* `git`
* `helm`
* `helmfile`
* `kubectl` (Kubernetes client)

## Example:

```
on:
  push:
    branches: [ main ]

jobs:
  helmfile:
    runs-on: ubuntu-20.04
    container:
      image: ghcr.io/aservo/helmfile:0.0.11
    steps:
    - name: Helmfile Help
      uses: helmfile --help
```
