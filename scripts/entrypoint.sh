#!/bin/bash
set -e

echo "=== Starting MID Server ==="

# Find the MID installation directory
if [ -d "/opt/servicenow/agent" ]; then
    MID_HOME="/opt/servicenow/agent"
elif [ -d "/opt/servicenow/mid/agent" ]; then
    MID_HOME="/opt/servicenow/mid/agent"
else
    echo "ERROR: MID Server installation not found!"
    find /opt/servicenow -type d 2>/dev/null || true
    exit 1
fi

echo "MID_HOME: $MID_HOME"
cd "$MID_HOME"

# Configure MID server if config.xml doesn't exist
if [ ! -f "config.xml" ] && [ -f "/tmp/config.xml.template" ]; then
    echo "Copying config template..."
    cp /tmp/config.xml.template config.xml

    # Replace placeholders with environment variables
    if [ -n "$MID_INSTANCE_URL" ]; then
        xmlstarlet ed -L -u "//parameter[@name='url']/@value" -v "$MID_INSTANCE_URL" config.xml
    fi
    if [ -n "$MID_USERNAME" ]; then
        xmlstarlet ed -L -u "//parameter[@name='mid.instance.username']/@value" -v "$MID_USERNAME" config.xml
    fi
    if [ -n "$MID_PASSWORD" ]; then
        xmlstarlet ed -L -u "//parameter[@name='mid.instance.password']/@value" -v "$MID_PASSWORD" config.xml
    fi
    if [ -n "$MID_NAME" ]; then
        xmlstarlet ed -L -u "//parameter[@name='name']/@value" -v "$MID_NAME" config.xml
    fi
fi

# Start MID server in foreground
echo "Starting MID Server..."
if [ -f "bin/mid.sh" ]; then
    exec ./bin/mid.sh console
elif [ -f "start.sh" ]; then
    exec ./start.sh
else
    echo "ERROR: Cannot find startup script!"
    ls -la bin/ 2>/dev/null || ls -la . || true
    exit 1
fi
