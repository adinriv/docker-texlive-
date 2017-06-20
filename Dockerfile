FROM ubuntu:rolling
MAINTAINER adin

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq &&\
    apt-get install -y \
      equivs \
      fontconfig \
      git \
      gcc \
      libfile-fcntllock-perl \
      libwww-perl \
      parallel \
      unzip \
      wget \
    &&\
    apt-get autoclean &&\
    apt-get autoremove &&\
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/*

COPY install-tl-ubuntu.patch .

RUN git clone --depth=1 https://github.com/scottkosty/install-tl-ubuntu.git &&\
    chmod +x ./install-tl-ubuntu/install-tl-ubuntu &&\
    patch ./install-tl-ubuntu/install-tl-ubuntu < install-tl-ubuntu.patch &&\
    ./install-tl-ubuntu/install-tl-ubuntu &&\

    /opt/texbin/tlmgr option docfiles 0 &&\
    /opt/texbin/tlmgr update --all &&\

    apt-get autoclean &&\
    apt-get autoremove &&\
    rm -rf `/opt/texbin/kpsewhich -var-value TEXMFDIST`/doc \
           `/opt/texbin/kpsewhich -var-value TEXMFDIST`/source \
           install-tl-* \
           /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/*

ENV PATH /opt/texbin:$PATH

VOLUME /var/texlive

WORKDIR /var/texlive

