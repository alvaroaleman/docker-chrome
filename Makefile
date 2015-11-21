IMAGENAME = chrome
CONTAINERNAME = chrome
AUDIOGROUPNAME = audio
VIDEGROUPNAME = video
GETENT = /usr/bin/getent
GROUPCUT = /usr/bin/cut -d':' -f3
AUDIOGROUPID =  `$(GETENT) group $(AUDIOGROUPNAME) | $(GROUPCUT)`
VIDEGROUPID = `$(GETENT) group $(VIDEGROUPNAME) | $(GROUPCUT)`

build: clean-image
	docker build -t $(IMAGENAME) .

clean-image:
	- docker rmi $(IMAGENAME)

clean-container:
	- docker stop $(CONTAINERNAME)
	- docker rm $(CONTAINERNAME)

clean: clean-image clean-container

run: clean-container
	docker run -d \
        --memory 3gb \
        --net host \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=unix$(DISPLAY) \
        -v $(HOME)/Downloads:/Downloads \
        -v /dev/shm:/dev/shm \
        -v /etc/hosts:/etc/hosts \
        -v $(HOME)/.config/google-chrome/:/data \
        -u `/usr/bin/id -u` \
        --device /dev/snd \
        --device /dev/dri \
        --device /dev/video0 \
        --group-add $(AUDIOGROUPID) \
        --group-add $(VIDEGROUPID) \
        --name $(CONTAINERNAME) \
       $(IMAGENAME) --user-data-dir=/data --force-device-scale-factor=1

enter: run
	docker exec -it $(CONTAINERNAME) bash

test: build run enter
