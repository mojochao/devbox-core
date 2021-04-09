FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install things as root user.
RUN apt-get update && apt-get upgrade -y \
# Install core packages and clean up after.
    && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        cmake \
        cmdtest \
        curl \
        dnsutils \
        fd-find \
        file \
        finger \
        fzf \
        git \
        gpg \
        gpg-agent \
        gnutls-bin \
        hdparm \
        htop \
        httpie \
        iptables \
        jq \
        keychain \
        kmod \
        less \
        liblua5.3-dev \
        libpq-dev \
        libreadline-dev \
        libssl-dev \
        libtool \
        libvterm-dev \
        locate \
        lshw \
        lsof \
        lua5.3 \
        man \
        multitail \
        nano \
        neovim \
        net-tools \
        netcat \
        nftables \
        nodejs \
        npm \
        openssh-client \
        pgcli \
        pkg-config \
        postgresql-client \
        psmisc \
        python3 \
        python3-dev \
        python3-pip \
        python3-pkg-resources \
        python3-psycopg2 \
        python3-setuptools \
        readline-common \
        ripgrep \
        shellcheck \
        siege \
        silversearcher-ag \
        socat \
        software-properties-common \
        sudo \
        sysstat \
        texinfo \
        tmux \
        tree \
        unzip \
        wget \
        vim \
        yarnpkg \
        zip \
        zsh \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*s
# Install Emacs 27
RUN add-apt-repository ppa:kelleyk/emacs \
    && apt-get update \
    && apt-get install emacs27-nox -y
# Install hey.
RUN curl -s https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 -o /usr/local/bin/hey \
    && chmod +x /usr/local/bin/hey
# Install wrk.
RUN git clone https://github.com/wg/wrk.git /tmp/wrk \
    && cd /tmp/wrk \
    && make \
    && cp wrk /usr/local/bin \
    && rm -rf /tmp/wrk
# Install yq.
RUN wget -q https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_amd64.tar.gz -O - | tar xz \
    && mv yq_linux_amd64 /usr/local/bin/yq
# Update locate database.
RUN updatedb
# Add developer user with sudo access.
RUN useradd -ms /usr/bin/zsh developer \
    && usermod -aG sudo developer \
    && echo 'developer:changeme' | chpasswd

# Switch to developer user.
USER developer
WORKDIR /home/developer

# As this image needs to always run as a server, sleep forever so clients can
# open shells in it.
ENTRYPOINT ["sleep", "infinity"]
