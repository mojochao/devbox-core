## Devbox for Golang

Interactively running and debugging in a Docker or Kubernetes environment is
hell. In such environments a development host, or "devbox", running inside 
Docker or Kubernetes is useful.

This git repository contains the artifacts necessary to build a containerized,
terminal-based Golang development environment Docker image and push it to AWS
ECR for use run locally in a Docker container or run remotely in a Kubernetes
cluster pod.

Note that once started the devbox container is intended to be more "pet" than
"cattle", more persistent than ephemeral.  Any files copied to the devbox
container or pod will be lost once it has been stopped.

This development environment is a bit opinionated about the tools installed.
These currently include:

- Golang 1.16.2 toolchain on Debian 10 (Buster) base
- Python 2.7.16 and 3.7.3
- network utilities like ifconfig, ping, dig, netcat, traceroute, socat, ssh, etc
- Bash and Zsh
- Emacs and Vim

It is intended that this image can be used as a base for more customized
project-specific needs.

This repository also contains a [devbox script](bin/devbox) that is useful for
working with devbox containers.

## Organization

This git repository is organized as follows:

- [devbox script](bin/devbox) providing easy management of devbox containers in
  Docker or Kubernetes
- [bitbucket-pipelines.yml](bitbucket-pipelines.yml) defining devbox-golang
  image build pipelines for this repository
- [Dockerfile](Dockerfile) defining the devbox-golang image build
- [Makefile](Makefile) providing automation for development and build pipeline tasks
- [README.md](README.md) this document
- [RELEASES.md](RELEASES.md) providing release notes for image build versions
- [VERSION](VERSION) defining the image build version

## Build and push images

The [Makefile](Makefile) provides automation to build docker images and push
them to ECR.  The `make` command with no targets specified will list available
build targets.

    $ make
    help                           Show this help
    docker-build                   Build docker image
    ecr-login                      Login to ECR for pushing docker images.
    ecr-tag                        Tag docker image with with $TAG to ECR (default: latest)
    ecr-push                       Push docker image with $TAG to ECR (default: latest)

The typical workflow is to build an image, login to the ECR repository, tag the
built image with tags for ECR, and push those tagged images to ECR.

    $ make docker-build
    $ make ecr-login
    $ make ecr-tag
    $ make ecr-push

You can also provide multiple targets at once.

    $ make docker-build ecr-login ecr-tag ecr-push

## Use images

A devbox build can be used locally in a Docker container.

    $ bin/devbox start
    f647f23f3151a9025e197cc6abaf188a2248d0cb296a65622d713328a687b816
    
    $ docker ps
    CONTAINER ID   IMAGE                          COMMAND            CREATED         STATUS         PORTS     NAMES
    f647f23f3151   sambatv/devbox-golang:latest   "sleep infinity"   5 seconds ago   Up 4 seconds             devbox-allengooch

Once started, a devbox shell can be opened.

