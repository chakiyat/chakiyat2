#!/bin/bash

# Set the password from "docker run -e VNC_PASSWORD"
echo "VNC_PASSWORD: $VNC_PASSWORD"
if [ -n "$VNC_PASSWORD" ]; then
  echo "$VNC_PASSWORD" > /etc/x11vnc.pass
  echo "$VNC_PASSWORD" > /usr/share/novnc/vnc_password.txt
fi

# Start the Xvfb server
if [ -z "$VNC_RESOLUTION" ]; then
  VNC_RESOLUTION="800x600"
fi

echo "VNC_RESOLUTION: $VNC_RESOLUTION"
Xvfb :1 -screen 0 $VNC_RESOLUTION &
export DISPLAY=:1.0

# Create the fluxbox menu
mkdir -p /root/.fluxbox/
echo -e "[begin] (fluxbox)\n\
[exec] (Firefox) {/usr/local/bin/firefox}\n\
[exec] (Bash) { x-terminal-emulator -T \"Bash\" -e /bin/bash --login} <>\n\
[end]" > /root/.fluxbox/menu

# Start Fluxbox window manager
fluxbox &

# Start x11vnc server
#11vnc -display :1.0 -rfbauth /etc/x11vnc.pass -forever &
x11vnc -passwdfile /etc/x11vnc.pass -display :1.0 -forever &

# Start the NoVNC server
websockify --web /usr/share/novnc/ --wrap-mode=ignore 0.0.0.0:8080 localhost:5900