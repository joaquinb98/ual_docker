# https://hub.docker.com/_/ros   Choose your favourite
FROM ros:melodic-perception

RUN apt update -y && apt-get install -y dbus-x11 --no-install-recommends && \
    apt install -y terminator --no-install-recommends && \
    apt install -y libeigen3-dev && \
    apt install -y ros-$(rosversion -d)-joy && \
    apt install -y ros-$(rosversion -d)-geodesy && \
    apt install -y ros-$(rosversion -d)-mavros && \
    apt install -y ros-$(rosversion -d)-mavros-extras && \
    apt install -y ros-$(rosversion -d)-xacro && \
    apt install -y ros-$(rosversion -d)-gazebo* && \
    apt install -y libgstreamer1.0-dev python-jinja2 python-pip && \
    pip install numpy toml && \
    geographiclib-get-geoids egm96-5 && \
    usermod -a -G dialout root && \
    rm -rf /var/lib/apt/lists/*
    
# Copy Terminator Configuration file
RUN mkdir -p /root/.config/terminator/
COPY config/terminator_config /root/.config/terminator/config


# Configure .bashrc
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc


# Setup workspace
ARG UAL_WS=/root/ual_ws
RUN mkdir -p $UAL_WS/src
WORKDIR $UAL_WS/src

# Setup UAL
RUN git clone -b catec_uad https://github.com/fada-catec/grvc-ual.git
RUN touch grvc-ual/ual_backend_crazyflie/CATKIN_IGNORE && \
    touch grvc-ual/ual_backend_gazebo_light/CATKIN_IGNORE && \
    touch grvc-ual/ual_backend_dji_ros/CATKIN_IGNORE && \
    touch grvc-ual/ual_backend_mavlink/CATKIN_IGNORE && \
    touch grvc-ual/ual_backend_ue/CATKIN_IGNORE 

RUN git clone https://github.com/PX4/Firmware.git && \ 
    cd Firmware && \
    git checkout v1.10.2 && \
    git submodule update --init --recursive && \
    make && \
    make px4_sitl_default gazebo || true

WORKDIR ${UAL_WS}
RUN /bin/bash -c '. /opt/ros/$ROS_DISTRO/setup.bash; \
                  catkin_make'

# setup entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# set environment variables
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
