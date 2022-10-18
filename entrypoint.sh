#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/root/ual_ws/devel/setup.bash"

echo ""
echo "---------------------------------------------------------"
echo "-----------------   UAL DOCKER    -----------------------"
echo "---------------------------------------------------------"
echo ""

# Useful to run any command when container starts
roslaunch ual_backend_mavros simulation.launch --wait
