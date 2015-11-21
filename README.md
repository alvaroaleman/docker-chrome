# docker-chrome

## Synopsis

A simple container to run the Google Chrome Browser from

## Quickstart

```bash
AUDIOGROUPID=$(getent group audio|cut -d':' -f3)
VIDEGROUPID=$(getent group video|cut -d':' -f3)
docker run -d \
      --memory 3gb \
      --net host \
      -v /etc/localtime:/etc/localtime:ro \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -e DISPLAY=unix$DISPLAY \
      -v $HOME/Downloads:/Downloads \
      -v /dev/shm:/dev/shm \
      -v /etc/hosts:/etc/hosts \
      -v $HOME/.config/google-chrome/:/data \
      -u `/usr/bin/id -u` \
      --device /dev/snd \
      --device /dev/dri \
      --device /dev/video0 \
      --group-add $AUDIOGROUPID \
      --group-add $VIDEGROUPID \
      --name chrome \
     alvaroaleman/chrome --user-data-dir=/data --force-device-scale-factor=1
```

## License

AGPL v3

## Author

Alvaro Aleman
