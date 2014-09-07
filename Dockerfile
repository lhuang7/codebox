FROM ubuntu:latest

MAINTAINER lingpo.huang@plwotech.net
ENV DEBIAN_FRONTEND noninteractive

# Add the base user
RUN adduser --disabled-password --gecos '' plow
RUN adduser plow sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER plow

# Install basic needed packages
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential libedit2 libglu1-mesa-dev libgmp3-dev zlib1g-dev curl
RUN sudo apt-get install -y freeglut3-dev wget ncurses-dev libcurl4-gnutls-dev git autoconf subversion 
RUN sudo apt-get install -y libtool

# Install libgmp3c2
RUN wget -c launchpadlibrarian.net/70575439/libgmp3c2_4.3.2%2Bdfsg-2ubuntu1_amd64.deb
RUN dpkg -i libgmp3c2_4.3.2*.deb

# Install ghc7.8.3
RUN wget -O ghc.tar.bz2 http://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
RUN tar xvfj ghc.tar.bz2
RUN cd ghc-7.8.3 && ./configure
RUN cd ghc-7.8.3 && make install
RUN rm -rf ghc.tar.bz2 ghc-7.8.3

# Install cabal1.20.0.1
RUN wget -O cabal.tar.gz http://hackage.haskell.org/package/cabal-install-1.20.0.1/cabal-install-1.20.0.1.tar.gz
RUN tar xvfz cabal.tar.gz
RUN cd cabal-install-1.20.0.1 && ./bootstrap.sh
RUN rm -rf cabal-install-1.20.0.1 cabal.tar.gz
ENV PATH /.cabal/bin:$PATH