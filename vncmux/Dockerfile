FROM archlinux

RUN pacman --noconfirm -Syu git make gcc pkgconf libvncserver

RUN git clone https://github.com/tobleminer/vncmux && \
    cd vncmux && \
    make
