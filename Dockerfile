FROM xhofe/alist:latest

# Install additional tools
RUN apk add --no-cache \
    bash \
    curl \
    rclone \
    openssh \
    git \
    jq \
    tzdata \
    && rm -rf /var/cache/apk/*

# Create directories
RUN mkdir -p /opt/openbox/configs /opt/openbox/data /opt/openbox/logs /opt/openbox/tmp

# Copy configuration
COPY configs/config.json /opt/openbox/configs/config.json

# Copy scripts
COPY scripts/start.sh /opt/openbox/start.sh
RUN chmod +x /opt/openbox/start.sh

# Set environment
ENV ALIST_PORT=2232
ENV ALIST_CONFIG=/opt/openbox/configs/config.json
ENV OPENLIST_CONFIG=/opt/openbox/configs/config.json
ENV ALIST_ADMIN=OpenClose
ENV ALIST_PASSWORD=Openpassword

# Expose port
EXPOSE 2232

# Start
CMD ["/opt/openbox/start.sh"]
