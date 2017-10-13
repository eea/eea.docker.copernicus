FROM alpine:3.6

ENV TARGET_DIRECTORY="/downloads/landfiles/src/"

ENV RCLONE_CONFIG_REMOTE_TYPE=http
ENV RCLONE_CONFIG_REMOTE_URL="https://localhost/"


RUN apk add --no-cache curl unzip && \
    curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    mv rclone-*-linux-amd64/rclone /usr/bin/ && \
    rm -rf rclone*

CMD ["sh", "-c", "rclone sync -v remote: $TARGET_DIRECTORY"]
