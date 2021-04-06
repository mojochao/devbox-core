# This dockerfile is intended for use in starting Kubernetes pods useful for
# application development of network services written in golang from within
# Kubernetes itself.

# These pods are more "pets" than "cattle" and are expected to be used
# interactively by developers during the development lifecycle.

# Developers will need to be able to:
# - pull from and push to Bitbucket repositories
# - access AWS cloud resources with their IAM user
# - edit, run and debug Golang service code in the pod
# - expose ports listened to by running service code

# Note that this dockerfile does not use multi-stage builds. Everything
# needed is added in a single stage.

FROM golang:1.16.2-buster

# Install things as root user.
RUN apt-get update && apt-get upgrade -y \
    # Install core packages and clean up after.
    && apt-get install -y --no-install-recommends \
        build-essential \
        dnsutils \
        emacs-nox \
        fish \
        fzf \
        git \
        htop \
        jq \
        less \
        libpq-dev \
        net-tools \
        netcat \
        openssh-client \
        postgresql-client \
        python3 \
        python3-dev \
        python3-pip \
        python3-pkg-resources \
        python3-psycopg2 \
        python3-setuptools \
        readline-common \
        ripgrep \
        socat \
        sudo \
        tmux \
        tree \
        unzip \
        vim \
        zip \
        zsh \
        man \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*s
    # Install Python tools.
RUN pip3 install httpie pgcli
    # Add developer user with sudo access.
RUN useradd -ms /usr/bin/zsh developer \
    && usermod -aG sudo developer \
    && echo 'developer:changeme' | chpasswd

# Install things as developer user.
USER developer
WORKDIR /home/developer
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.39.0 \
    && go get github.com/go-delve/delve/cmd/dlv@latest \
    && go get golang.org/x/tools/gopls@latest \
    && go get github.com/rakyll/hey@latest \
    && go get github.com/mikefarah/yq/v4@latest

# As this image needs to always run as a server, sleep forever so clients can
# open shells in it.
ENTRYPOINT ["sleep", "infinity"]
