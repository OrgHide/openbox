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
    gzip \
    libc6-compat \
    && rm -rf /var/cache/apk/*

# Download OpenList binary
RUN wget -q -O /tmp/alist.tar.gz \
    "https://github.com/alist-org/alist/releases/download/v3.40.0/alist-linux-arm64.tar.gz" && \
    tar -xzf /tmp/alist.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/alist && \
    ln -sf /usr/local/bin/alist /usr/local/bin/openlist && \
    rm /tmp/alist.tar.gz

# Create openbox user
RUN adduser -D -h /opt/openbox openbox && \
    mkdir -p /opt/openbox/configs /opt/openbox/data /opt/openbox/logs /opt/openbox/tmp && \
    chown -R openbox:openbox /opt/openbox

# Copy files
COPY --chown=openbox:openbox configs/config.json /opt/openbox/configs/config.json
COPY --chown=openbox:openbox scripts/start.sh /opt/openbox/start.sh
RUN chmod +x /opt/openbox/start.sh

# Switch to openbox user
USER openbox
WORKDIR /opt/openbox

# Set environment
ENV ALIST_CONFIG=/opt/openbox/configs/config.json
ENV OPENLIST_CONFIG=/opt/openbox/configs/config.json
ENV ALIST_PORT=2232
ENV OPENLIST_PORT=2232
ENV ALIST_ADMIN=OpenClose
ENV ALIST_PASSWORD=Openpassword

# Expose port
EXPOSE 2232

# Start
CMD ["/opt/openbox/start.sh"]
