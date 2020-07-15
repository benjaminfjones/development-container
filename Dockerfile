FROM ubuntu:focal

ENV DOCKER_USER bfj

ENV TZ=America/Los_Angeles

# Configure tzdata manually so that the build doesn't fail at an interactive
# prompt
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create user with passwordless sudo
RUN apt-get update && \
    apt-get install -y sudo && \
    adduser --disabled-password --gecos '' "$DOCKER_USER" && \
    adduser "$DOCKER_USER" sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    touch /home/$DOCKER_USER/.sudo_as_admin_successful && \
    rm -rf /var/lib/apt/lists/*

USER "$DOCKER_USER"

WORKDIR "/home/$DOCKER_USER"

# Basic tools
RUN yes | sudo unminimize && \
    sudo apt-get install -y man-db build-essential curl openssh-client git && \
    sudo rm -rf /var/lib/apt/lists/*

# Shell / terminal tools
RUN sudo apt-get update && \
    sudo apt-get install -y zsh tmux neovim && \
    sudo rm -rf /var/lib/apt/lists/*

# Compilers, runtimes
RUN sudo apt-get update && \
    sudo apt-get install -y python3 python3-venv openjdk-11-jdk gradle libssl-dev zlib1g-dev unzip file && \
    sudo rm -rf /var/lib/apt/lists/*

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN /home/$DOCKER_USER/.cargo/bin/rustup component add rust-src rls rust-analysis clippy && \
    mkdir /home/$DOCKER_USER/.zfunc && \
    /home/$DOCKER_USER/.cargo/bin/rustup completions zsh > ~/.zfunc/_rustup

# SSH keys and config
RUN sudo ssh-keygen -A
RUN mkdir -p /home/$DOCKER_USER/.ssh && sudo chown bfj:bfj .ssh
COPY --chown=bfj:bfj id_rsa /home/$DOCKER_USER/.ssh/id_rsa
COPY --chown=bfj:bfj id_rsa.pub /home/$DOCKER_USER/.ssh/id_rsa.pub
RUN sudo chmod 600 /home/$DOCKER_USER/.ssh/id_rsa && \
    sudo chmod 644 /home/$DOCKER_USER/.ssh/id_rsa.pub

# Personal dotfiles
RUN git clone https://github.com/benjaminfjones/dotfiles
WORKDIR /home/$DOCKER_USER/dotfiles
RUN ./boot.sh
COPY --chown=bfj:bfj gitconfig /home/$DOCKER_USER/.gitconfig
COPY --chown=bfj:bfj zshrc_local /home/$DOCKER_USER/.zshrc_local

WORKDIR "/home/$DOCKER_USER"
