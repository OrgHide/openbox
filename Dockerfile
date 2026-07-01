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

# Create openbox user and directories
RUN adduser -D -h /opt/openbox openbox && \
    mkdir -p /opt/openbox/configs /opt/openbox/data /opt/openbox/logs /opt/openbox/tmp && \
    chown -R openbox:openbox /opt/openbox

# Switch to openbox user
USER openbox
WORKDIR /opt/openbox

# Copy files
COPY --chown=openbox:openbox configs/config.json /opt/openbox/configs/config.json
COPY --chown=openbox:openbox scripts/* /opt/openbox/scripts/
RUN chmod +x /opt/openbox/scripts/*.sh

# Install OpenList using Go (more reliable)
USER root
RUN apk add --no-cache go git && \
    go install github.com/alist-org/alist/v3@latest && \
    mv /root/go/bin/alist /usr/local/bin/openlist && \
    chmod +x /usr/local/bin/openlist && \
    apk del go git && \
    rm -rf /root/go

# Switch back to openbox user
USER openbox

# Set environment
ENV ALIST_CONFIG=/opt/openbox/configs/config.json
ENV OPENLIST_CONFIG=/opt/openbox/configs/config.json
ENV ALIST_PORT=2232
ENV OPENLIST_PORT=2232

# Expose ports
EXPOSE 2232 5244

# Start OpenBox
CMD ["/opt/openbox/scripts/start.sh"]
