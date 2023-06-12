# Ubuntu23-VNC-docker
 Ubuntu-23 dockerfile provides VNC over 5900 & web vnc host at 8080
 
 
 Uses docker-23.04 
 firefox, fluxbox
 python3 & pip3 installed 
 NoVNC on port 8080 for web app (optional)
 and VNC on port 5900 
 605MB in size from du -h / 


How to use this
* You must specify a password with -e VNC_PASSWORD= 
* You can leave -e VNC_RESOLUTION blank and it defaults to 800x600


1) Get the files
 $ ```git clone https://github.com/xp5-org/Docker-Ubuntu23-VNC.git```

2) build dockerfile 
 $ ```cd Docker-Ubuntu23-VNC ```
 $ ```docker build ./ -t imagename```
 
3) Start the container:
 $ ```docker run -d -p 8080:8080 -p 5900:5900 -e VNC_PASSWORD=1234 -e VNC_RESOLUTION=640x480x16 imagename:latest```


