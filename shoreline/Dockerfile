FROM debian

RUN apt update && \
    apt install -y git make gcc build-essential libsdl2-dev libpthread-stubs0-dev libvncserver-dev libnuma-dev libfreetype6-dev && \
    git clone https://github.com/tobleminer/shoreline && \
    cd shoreline && \
    make

ADD arial.ttf /
