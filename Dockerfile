FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y curl openssh-server git ca-certificates curl gnupg lsb-release software-properties-common vim

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update \
    && apt-get install -y python3.13 python3.13-venv

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile ~/.ssh/id_git" >> /root/.bash

# Configure SSH
RUN mkdir /var/run/sshd

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Add git to ssh hosts
RUN echo "alias python=python3.13" >> /root/.bash_aliases

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN /bin/bash -c "source /root/.nvm/nvm.sh \
    && nvm install --lts \
    && npm install --global yarn"

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 22
# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]