FROM alpine:3.6

ENV TARGET_DIRECTORY "/downloads/landfiles/dst/"

RUN apk add --no-cache python3

ADD reaper.py /usr/bin/

CMD ["/usr/bin/reaper.py"]
