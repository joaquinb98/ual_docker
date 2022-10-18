
# UAL DOCKER

Dockerization of [grvc_ual](https://github.com/fada-catec/grvc-ual) for sitl with [Px4](https://px4.io/)

# USAGE

    > ./run.sh

## Troubleshooting on Ubuntu
---

### Docker daemon permissions

```
docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/create": dial unix /var/run/docker.sock: connect: permission denied.
See 'docker run --help'.
```
The following command should solve the problem:
```
sudo chmod 666 /var/run/docker.sock
```
### X Display authorization error

```
Authorization required, but no authorization protocol specified
qt.qpa.screen: QXcbConnection: Could not connect to display :0
Could not connect to any X display.
```

The following command should solve the problem:
```
xhost +local:docker
```

### Problems with xauth

```
docker: Error response from daemon: OCI runtime create failed: container_linux.go:380: starting container process caused: process_linux.go:545: container init caused: rootfs_linux.go:76: mounting "/tmp/.docker.xauth" to rootfs at "/tmp/.docker.xauth" caused: mount through procfd: not a directory: unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified host path exists and is the expected type.
```

A possible solution is to comment out the  function *"configure_xserver"* from the  script *"run.sh"*.