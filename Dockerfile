FROM alpine:latest

Install dependencies

RUN apk add --no-cache 
    bash 
    curl 
    rclone 
    openssh 
    git 
    jq 
    py3-pip 
    tzdata 
    && rm -rf /var/cache/apk/*

Create openbox user

RUN adduser -D -h /opt/openbox openbox

Copy files

COPY --chown=openbox:openbox configs/rclone/rclone.conf /etc/openbox/rclone.conf
COPY --chown=openbox:openbox configs/openlist/config.json /etc/openbox/openlist.json
COPY --chown=openbox:openbox scripts/* /opt/openbox/scripts/
COPY --chown=openbox:openbox . /opt/openbox/

Set permissions

RUN chmod +x /opt/openbox/scripts/*.sh

Set up services

USER openbox
WORKDIR /opt/openbox

EXPOSE 5244 5245 8080 8022

Start services

CMD ["/opt/openbox/scripts/start.sh"]
