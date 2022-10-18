#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

echo ""
echo "---------------------------------------------------------"
echo "-----------------   UAL DOCKER    -----------------------"
echo "---------------------------------------------------------"
echo ""

# Useful to run any command when container starts
exec "bash"
