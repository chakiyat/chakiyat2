FROM ubuntu:23.04

#TZ fix for no console/headless
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set path
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # mandatory
    bash \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    fluxbox \
    xterm \
    # firefox
    wget tar bzip2 libgtk-3-0 libdbus-glib-1-2 libxt6 libasound2\
    # extra
    python3 \
    pip \
    && rm -rf /var/lib/apt/lists/*

# Download the latest version of Firefox
RUN wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
RUN tar xvf /tmp/firefox.tar.bz2 -C /opt
RUN ln -s /opt/firefox/firefox /usr/local/bin/firefox
RUN rm /tmp/firefox.tar.bz2
CMD ["firefox"]

# Set up path and make script executable
WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Expose ports for NoVNC and VNC
EXPOSE 8080
EXPOSE 5900

# Begin running entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]