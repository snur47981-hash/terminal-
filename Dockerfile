FROM kalilinux/kali-rolling

# ============ ENVIRONMENT ============
ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=admin
ENV PASSWORD=Kali@2026#Secure
ENV TZ=Asia/Kolkata
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color

# ============ BASE SYSTEM ============
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Core
        wget curl git python3 python3-pip python3-venv \
        fastfetch neofetch screenfetch \
        # Networking
        net-tools iproute2 iputils-ping dnsutils \
        traceroute mtr whois \
        # Editors
        vim nano micro emacs-nox \
        # System
        htop btop glances \
        tree unzip zip p7zip-full \
        build-essential gcc g++ make cmake \
        openssh-client openssh-server \
        telnet netcat-openbsd \
        jq yq xmlstarlet \
        less man-db manpages \
        sudo lsof strace ltrace \
        procps file ca-certificates \
        locales tzdata \
        # Libraries
        libssl-dev zlib1g-dev libffi-dev \
        libsqlite3-dev libreadline-dev libncurses-dev \
        libxml2-dev libxslt1-dev \
        libpq-dev default-libmysqlclient-dev \
        libyaml-dev libpng-dev libjpeg-dev \
        linux-libc-dev \
        # Security Tools (Essential)
        nmap masscan rustscan \
        sqlmap \
        hydra john hashcat \
        metasploit-framework \
        exploitdb searchsploit \
        nikto wpscan \
        gobuster dirb ffuf \
        wireshark-common tshark tcpdump \
        # OSINT
        theharvester \
        recon-ng \
        # Web
        burpsuite \
        zaproxy \
        # Misc
        screen tmux \
        ranger ncdu \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ============ TTYD (Latest) ============
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.arm64 && \
    chmod +x /bin/ttyd

# ============ PYTHON PACKAGES ============
RUN pip3 install --no-cache-dir \
        flask django fastapi \
        requests beautifulsoup4 selenium \
        pandas numpy matplotlib \
        scipy scikit-learn \
        jupyter notebook \
        pwntools \
        paramiko \
        scapy \
        impacket \
        mitm6 \
        crackmapexec \
        && \
    pip3 cache purge

# ============ TOOLS (Manual Install) ============
RUN git clone https://github.com/bleachbit/bleachbit.git /opt/bleachbit || true

# ============ BASH CONFIGURATION ============
RUN echo "# ===== Kali Custom Profile =====" >> /root/.bashrc && \
    echo "fastfetch" >> /root/.bashrc && \
    echo "cd /root" >> /root/.bashrc && \
    echo "alias ll='ls -alF'" >> /root/.bashrc && \
    echo "alias la='ls -A'" >> /root/.bashrc && \
    echo "alias l='ls -CF'" >> /root/.bashrc && \
    echo "alias grep='grep --color=auto'" >> /root/.bashrc && \
    echo "alias egrep='egrep --color=auto'" >> /root/.bashrc && \
    echo "alias fgrep='fgrep --color=auto'" >> /root/.bashrc && \
    echo "export PS1='\\[\\033[01;31m\\]\\u@kali\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '" >> /root/.bashrc && \
    echo "export EDITOR=vim" >> /root/.bashrc && \
    echo "export PATH=\$PATH:/opt/tools" >> /root/.bashrc && \
    echo "" >> /root/.bashrc && \
    echo "# ===== Welcome Message =====" >> /root/.bashrc && \
    echo 'echo "🔥 Welcome to Kali Linux on Railway"' >> /root/.bashrc && \
    echo 'echo "📅 Date: $(date)"' >> /root/.bashrc && \
    echo 'echo "💻 Hostname: $(hostname)"' >> /root/.bashrc && \
    echo 'echo "🔐 Username: $USERNAME"' >> /root/.bashrc && \
    echo 'echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"' >> /root/.bashrc

# ============ VIM CONFIG ============
RUN echo "syntax on" > /root/.vimrc && \
    echo "set number" >> /root/.vimrc && \
    echo "set mouse=a" >> /root/.vimrc

# ============ CREATE STRUCTURE ============
RUN mkdir -p /root/{tools,projects,wordlists,logs,data,scripts} && \
    chmod 755 /root/{tools,projects,wordlists,logs,data,scripts}

# ============ SERVICES ============
EXPOSE 7681

# ============ HEALTH CHECK ============
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:7681 || exit 1

# ============ STARTUP ============
CMD ["/bin/bash", "-c", "\
    /bin/ttyd -p 7681 \
        --port 7681 \
        --credential ${USERNAME}:${PASSWORD} \
        --writable \
        --once \
        /bin/bash"]
