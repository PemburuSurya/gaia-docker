# Use Ubuntu 22.04 as base image (pinned version)
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required system dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        tar \
        git \
        openssl \
        wget \
        python3 \
        lsof \
        python3-pip \
        build-essential \
        libssl-dev \
        pciutils \
        libwebkit2gtk-4.0-dev \
        libgtk-3-dev \
        libayatana-appindicator3-dev && \
    rm -rf /var/lib/apt/lists/*

# Create gaianet user and directories
RUN useradd -m gaianet20 && \
    mkdir -p /home/gaianet20/gaianet && \
    chown -R gaianet20:gaianet20 /home/gaianet20

# Switch to gaianet user
USER gaianet20
WORKDIR /home/gaianet20

# Set environment variables
ENV HOME=/home/gaianet20
ENV GAIANET_BASE_DIR=/home/gaianet20/gaianet
ENV PATH="/home/gaianet20/gaianet/bin:${PATH}"

# Create necessary directories
RUN mkdir -p $GAIANET_BASE_DIR/{bin,log,qdrant,gaia-frp,tmp}

# Download and run the install script (with retry mechanism)
RUN for i in {1..5}; do \
      curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --base $GAIANET_BASE_DIR && break || \
      sleep 15; \
    done

# Source .bashrc and verify installation
RUN echo 'source ~/.bashrc' >> ~/.bash_profile && \
    sleep 2 && \
    /bin/bash -c "source ~/.bashrc && which gaianet && gaianet --version"

# Initialize with the provided config (fixed URL)
RUN /bin/bash -c "source ~/.bashrc && \
    gaianet init --config https://raw.githubusercontent.com/PemburuSurya/gaianet/main/qwen1.5/config.json"

# Copy entrypoint script
COPY --chown=gaianet20:gaianet20 entrypoint.sh /home/gaianet20/entrypoint.sh
RUN chmod +x /home/gaianet20/entrypoint.sh

# Expose necessary ports
EXPOSE 8080 8081 8082 6333 6334

# Set entrypoint
ENTRYPOINT ["/bin/bash", "-c", "source ~/.bashrc && /home/gaianet20/entrypoint.sh"]
