FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Sirf basic packages (jo error nahi de)
RUN apt-get update && \
    apt-get install -y \
        wget curl git \
        python3 python3-pip \
        net-tools iputils-ping dnsutils \
        vim nano htop \
        unzip zip \
        sudo \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ttyd download
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.arm64 && \
    chmod +x /bin/ttyd

# Bash prompt
RUN echo "PS1='\\[\\033[01;31m\\]kali\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '" >> /root/.bashrc

EXPOSE 7681

CMD ["/bin/ttyd", "-p", "7681", "-c", "admin:admin123", "/bin/bash"]
