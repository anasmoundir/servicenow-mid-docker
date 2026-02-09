FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    openjdk-17-jre-headless \
    xmlstarlet \
    && rm -rf /var/lib/apt/lists/*

# Create MID directory
RUN mkdir -p /opt/servicenow/mid

WORKDIR /opt/servicenow/mid

# Copy install script and config template
COPY ../mid/config.xml.template /tmp/config.xml.template
COPY ../scripts/healthcheck.sh /healthcheck.sh

RUN chmod +x /healthcheck.sh

# Download MID installer dynamically
ARG MID_INSTALLER_URL
RUN curl -L "$MID_INSTALLER_URL" -o mid-installer.deb \
    && dpkg -i mid-installer.deb \
    && rm mid-installer.deb

# Expose logs & agent folder
VOLUME ["/opt/servicenow/mid/agent"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD /healthcheck.sh

CMD ["/opt/servicenow/mid/agent/start.sh"]

