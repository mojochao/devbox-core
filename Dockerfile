FROM golang:1.16.3-buster

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
    # Install yq.
RUN wget -q https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_amd64.tar.gz -O - | \
    tar xz && mv yq_linux_amd64 /usr/local/bin/yq
    # Add developer user with sudo access.
RUN useradd -ms /usr/bin/zsh developer \
    && usermod -aG sudo developer \
    && echo 'developer:changeme' | chpasswd

# Switch to developer user.
USER developer
WORKDIR /home/developer
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# As this image needs to always run as a server, sleep forever so clients can
# open shells in it.
ENTRYPOINT ["sleep", "infinity"]
