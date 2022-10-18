
# UAL DOCKER

Dockerization of [grvc_ual](https://github.com/fada-catec/grvc-ual) for sitl with [Px4](https://px4.io/)

# USAGE

Due to px4 build launch sitl directly we have to ctrl+c process. Then

    > cd /root/ual_ws
    > catkin_make
    > roslaunch ual_backend_mavros simulation.launch