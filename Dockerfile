FROM ubuntu:14.10

MAINTAINER lingpo.huang@plwotech.net
ENV DEBIAN_FRONTEND noninteractive

# Add the base user
RUN adduser --disabled-password --gecos '' plow
RUN adduser plow sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to new User
RUN su plow

# Switch to user directory
WORKDIR /home/plow

ENV HOME /home/plow
 	
ENV LC_ALL en_US.UTF8

# Set up basic folders
RUN mkdir Desktop
RUN mkdir Documents
RUN mkdir Downloads
RUN mkdir Music
RUN mkdir Pictures
RUN mkdir Videos
RUN mkdir Public
RUN mkdir Share
RUN mkdir temp

# Install basic needed packages
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential libedit2 libglu1-mesa-dev libgmp3-dev zlib1g-dev curl
RUN sudo apt-get install -y freeglut3-dev wget ncurses-dev libcurl4-gnutls-dev git autoconf subversion 
RUN sudo apt-get install -y libtool

# Install other tool
RUN sudo apt-get install -y zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /home/plow/.oh-my-zsh
# RUN mv ~/.zshrc  ~/.zshrc.bkp
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN sudo chsh -s $(which zsh) plow
ADD ./.zshrc /home/plow/
RUN zsh

# Install libgmp3c2
RUN wget -c launchpadlibrarian.net/70575439/libgmp3c2_4.3.2%2Bdfsg-2ubuntu1_amd64.deb
RUN sudo dpkg -i libgmp3c2_4.3.2*.deb

# Install ghc7.8.3
RUN wget -O ghc.tar.bz2 http://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
RUN tar xvfj ghc.tar.bz2
RUN cd ghc-7.8.3 && ./configure --prefix=/home/plow/.ghc-7.8.3-rc11 
RUN cd ghc-7.8.3 && make install
RUN rm -rf ghc.tar.bz2 ghc-7.8.3

RUN export PATH=$PATH:$HOME/.ghc-7.8.3-rc11/bin:$PATH
RUN ghc --version
RUN su plow
RUN ghc --version

# Install cabal1.20.0.3
#RUN wget -O cabal.tar.gz http://hackage.haskell.org/package/cabal-install-1.20.0.3/cabal-install-1.20.0.3.tar.gz
#RUN tar xvfz cabal.tar.gz
#RUN cd cabal-install-1.20.0.3 && ./bootstrap.sh
#RUN rm -rf cabal-install-1.20.0.3 cabal.tar.gz
#ENV PATH /home/plow/.cabal/bin:$PATH

CMD su plow