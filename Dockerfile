FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    rclone \
    openssh \
    git \
    jq \
    tzdata \
    ca-certificates \
    tar \
    unzip \
    && rm -rf /var/cache/apk/*

# Install OpenList/AList
RUN wget -q -O /tmp/openlist.tar.gz \
    "https://github.com/OpenListTeam/OpenList/releases/latest/download/openlist-linux-amd64.tar.gz" && \
    tar -xzf /tmp/openlist.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/openlist && \
    rm /tmp/openlist.tar.gz

# Create openbox user
RUN adduser -D -h /opt/openbox openbox

# Create directories
RUN mkdir -p /opt/openbox/configs /opt/openbox/data /opt/openbox/logs /opt/openbox/tmp

# Copy configuration
COPY configs/config.json /opt/openbox/configs/config.json

# Copy scripts
COPY scripts/* /opt/openbox/scripts/
RUN chmod +x /opt/openbox/scripts/*.sh

# Set permissions
RUN chown -R openbox:openbox /opt/openbox

# Switch to openbox user
USER openbox
WORKDIR /opt/openbox

# Set environment variables
ENV ALIST_CONFIG=/opt/openbox/configs/config.json
ENV OPENLIST_CONFIG=/opt/openbox/configs/config.json
ENV ALIST_PORT=2232
ENV OPENLIST_PORT=2232

# Expose ports
EXPOSE 2232 5244

# Start OpenBox
CMD ["/opt/openbox/scripts/start.sh"]
