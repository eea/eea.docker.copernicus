FROM alpine:3

ENV SOURCE_DIRECTORY="/"
ENV TARGET_DIRECTORY="/downloads/landfiles/src/"

ENV RCLONE_CONFIG_REMOTE_TYPE=http
ENV RCLONE_CONFIG_REMOTE_URL="https://localhost/"


RUN apk add --no-cache curl unzip mailx && \
    curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    mv rclone-*-linux-amd64/rclone /usr/bin/ && \
    rm -rf rclone*


VOLUME /logs

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

