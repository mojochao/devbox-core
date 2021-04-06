## Devbox Core

Interactively running and debugging in a Docker or Kubernetes environment is
hell. In such environments a development host, or "devbox", running inside 
Docker or Kubernetes is useful.

This git repository contains the artifacts necessary to build a containerized,
terminal-based Golang development environment Docker image and push it to
Dockerhub for use run locally in a Docker container or run remotely in a
Kubernetes cluster pod.

Note that once started the devbox container is intended to be more "pet" than
"cattle", more persistent than ephemeral.  Any files copied to the devbox
container or pod will be lost once it has been stopped.

This development environment is a bit opinionated about the tools installed.
These currently include:

- Debian 10 distribution (Buster)
- Build essentials (gcc, gdb, make, etc)
- Python (2.7.16 and 3.7.3)
- Network essentials (ifconfig, ping, dig, ssh, traceroute, etc)
- Shells (bash, fish, zsh)
- git
- Editors (emacs, vim)

It is intended that this image can be used as a base for more customized
language and project-specific needs.

## Build and push images

The [Makefile](Makefile) provides automation to build docker images and push
them to ECR.  The `make` command with no targets specified will list available
build targets.

  $ make
  help                           Show this help
  docker-build                   Build docker image
  docker-push                    Push docker image to Dockerhub

The typical workflow is to build an image, login to the ECR repository, tag the
built image with tags for ECR, and push those tagged images to ECR.

    $ make docker-build
    $ make docker-login
    $ make docker-tag
    $ make docker-push

You can also provide multiple targets at once.

    $ make docker-build ecr-login ecr-tag ecr-push

## Use images

The [devbox CLI](https://github.com/mojochao/devbox-cli) eases use of devbox
images.

    $ devbox add demo --name my-devbox --image mojochao/devbox-core --shell zsh
    f647f23f3151a9025e197cc6abaf188a2248d0cb296a65622d713328a687b816
    
    $ docker ps
    CONTAINER ID   IMAGE                          COMMAND            CREATED         STATUS         PORTS     NAMES
    f647f23f3151   sambatv/devbox-core:latest     "sleep infinity"   5 seconds ago   Up 4 seconds             devbox-allengooch

Once started, a devbox shell can be opened.

