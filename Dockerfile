FROM debian:buster-slim

RUN apt-get -y update &&\
    apt-get -y install alsa-utils sox && \
    mkdir /opt/packet-sounds

COPY ./packet-sounds.sh /opt/packet-sounds
COPY ./sounds /opt/packet-sounds/sounds/

WORKDIR /opt/packet-sounds

CMD ["bash", "packet-sounds.sh"]

