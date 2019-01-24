#
# A container to run Z-Tree and access it through a web browser with noVNC
#
# This container description is based on the dockerfile 
# from https://github.com/epfl-sti/octave-x11-novnc-docker
#

FROM phusion/baseimage:0.11
MAINTAINER Gerald Oster <gerald.oster@loria.fr>

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TZ=Europe/Paris
ENV SCREEN_RESOLUTION 1024x768
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installing apps (Note: git is here just in case noVNC needs it in launch.sh
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install \
	xvfb \
	x11vnc \
	supervisor \
	fluxbox \
	net-tools \
	git-core \
	git \
    wine-development \
    wine32-development \
    wine64-development \
    libwine-development \
    fonts-wine

# House cleaning
RUN apt-get autoclean

# Docker's supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set display
ENV DISPLAY :0

# Change work directory to add novnc files
WORKDIR /root/
ADD noVNC /root/novnc/
RUN ln -s /root/novnc/vnc_lite.html /root/novnc/index.html 


# Wine configuration
RUN mkdir -p /home/ztree && \
    groupadd -g 1010 ztree && \
    useradd -s /bin/bash -u 1010 -g 1010 ztree && \
    chown -R ztree:ztree /home/ztree

WORKDIR /home/ztree

ADD ./ztree/ztree.exe /home/ztree/
ADD ./ztree/zleaf.exe /home/ztree/
ADD ./ztree/*.ztt /home/ztree/
ADD ./ztree/*.txt /ztree/
ADD ./ztree/random_games_order.py /ztree/

#USER ztree

# Expose Port (Note: if you change it do it as well in surpervisord.conf)
EXPOSE 8081

CMD ["/usr/bin/supervisord"]