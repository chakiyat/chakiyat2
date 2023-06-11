FROM ubuntu:23.04
#TZ fix for no console/headless
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set path
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    #mandatory stuff
    bash \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    fluxbox \
    xterm \
    # firefox
    wget tar bzip2 libgtk-3-0 libdbus-glib-1-2 libxt6 libasound2\
    #extra junk
    python3 \
    pip \
    && rm -rf /var/lib/apt/lists/*

# Download the latest version of Firefox
RUN wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
RUN tar xvf /tmp/firefox.tar.bz2 -C /opt
RUN ln -s /opt/firefox/firefox /usr/local/bin/firefox
RUN rm /tmp/firefox.tar.bz2
CMD ["firefox"]

# Create a Fluxbox menu
RUN mkdir -p /root/.fluxbox/ \
    && echo '[begin] (fluxbox) \n \
[exec] (Firefox) {/usr/local/bin/firefox}\n \
[exec] (Bash) { x-terminal-emulator -T "Bash" -e /bin/bash --login} <>\n \
[end]' > /root/.fluxbox/menu

# how do i override this in docker-run? 
ENV VNC_PASSWORD=default_password
RUN echo "VNC_PASSWORD: $VNC_PASSWORD"

# Set the VNC password
RUN x11vnc -storepasswd mypass /etc/x11vnc.pass
#RUN printf "%s\n" "${VNC_PASSWORD}" | x11vnc -storepasswd - /etc/x11vnc.pass
# one of these should make a text file with the -e arg for vnc password
CMD printf "%s\n" "${VNC_PASSWORD}" | tee /usr/share/novnc/CMD_vnc_password.txt && cat /usr/share/novnc/CMD_vnc_password.txt
CMD printf "%s\n" "${VNC_PASSWORD}" | tee /usr/share/novnc/RUN_vnc_password.txt && cat /usr/share/novnc/RUN_vnc_password.txt

# Expose ports for NoVNC and VNC
EXPOSE 8080
EXPOSE 5900

# Start the NoVNC server
CMD bash -c "Xvfb :1 -screen 0 1280x960x16 & \
             DISPLAY=:1.0 fluxbox & \
             x11vnc -display :1.0 -rfbauth /etc/x11vnc.pass -forever & \
             websockify --web /usr/share/novnc/ --wrap-mode=ignore 0.0.0.0:8080 localhost:5900"
