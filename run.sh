#!/usr/bin/env bash

NVIDIA_DRIVERS="False"

CONTAINER_NAME=${1:-"ual"}
DOCKER_IMG_NAME=${2:-"ual_image"}

# ----------------------------------------------------------------------------------------------------------------------------

function configure_xserver()
{
    XAUTH=/tmp/.docker.xauth
    if [ ! -f $XAUTH ]
    then
        xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
        if [ ! -z "$xauth_list" ]
        then
            echo $xauth_list | xauth -f $XAUTH nmerge -
        else
            touch $XAUTH
        fi
        chmod a+r $XAUTH
    fi
}
# --------------------------------------------------------------

function main()
{

    REQUIRED_PKG="nvidia-container-toolkit"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
    echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
        echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        bash -c "./install_nvidia-docker2.sh"
    fi

    # Make sure processes in the container can connect to the x server
    configure_xserver

    docker build -t $DOCKER_IMG_NAME . && \

    # Run docker image "catecupia/ual" in container
    docker container run -it --rm \
    --gpus all \
    --security-opt apparmor:unconfined \
    --privileged \
    --ipc host \
    --network host \
    --env="DISPLAY=$DISPLAY" \
    --env QT_X11_NO_MITSHM=1 \
    --env XAUTHORITY=$XAUTH \
    --volume "$XAUTH:$XAUTH" \
    --volume "/tmp/.X11-unix:/tmp/.X11-unix" \
    $DOCKER_IMG_NAME
}
# --------------------------------------------------------------

main "$@"
