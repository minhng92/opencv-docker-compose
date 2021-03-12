#!/bin/bash

set -e
: ${OPENCV_DIR:='/opencv'}
# option to choose OpenCV version @ https://github.com/opencv/opencv/releases
: ${OPENCV_VERSION:='4.5.1'}

apt-get update && \
    apt-get -y install software-properties-common wget unzip cmake

add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" && \
    apt-get update && \
    apt-get -y install pkg-config yasm gfortran && \
    apt-get -y install libjpeg8-dev libjasper1 libjasper-dev libpng-dev

apt-get -y install libtiff5-dev libtiff-dev

apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev && \
    apt-get -y install libxine2-dev libv4l-dev

cd /usr/include/linux
ln -s -f ../libv4l1-videodev.h videodev.h

apt-get -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev && \
    apt-get -y install libgtk-3-dev libtbb-dev qt5-default && \
    apt-get -y install libatlas-base-dev && \
    apt-get -y install libfaac-dev libmp3lame-dev libtheora-dev && \
    apt-get -y install libvorbis-dev libxvidcore-dev && \
    apt-get -y install libopencore-amrnb-dev libopencore-amrwb-dev && \
    apt-get -y install libavresample-dev && \
    apt-get -y install x264 v4l-utils libglib2.0-0

# Optional dependencies
apt-get -y install libprotobuf-dev protobuf-compiler && \
    apt-get -y install libgoogle-glog-dev libgflags-dev && \
    apt-get -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

# add java which tf uses
apt-get -y install openjdk-8-jdk

cd /opt

# build opencv
wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv-$OPENCV_VERSION.zip \
&& wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib-$OPENCV_VERSION.zip \
&& unzip opencv-$OPENCV_VERSION.zip \
&& unzip opencv_contrib-$OPENCV_VERSION.zip \
&& mkdir -p /opt/opencv-$OPENCV_VERSION/build

cd /opt/opencv-$OPENCV_VERSION/build

cmake -DBUILD_TIFF=ON \
  -DENABLE_PRECOMPILED_HEADERS=OFF \
  -DBUILD_opencv_java=ON \
  -DBUILD_OPENCV_PYTHON=ON \
  -DWITH_CUDA=OFF \
  -DCUDA_FAST_MATH=ON \
  -DCUDA_ARCH_BIN=7.5 \
  -DOPENCV_ENABLE_NONFREE=ON \
  -DENABLE_FAST_MATH=1 \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$OPENCV_VERSION/modules \
  -DBUILD_opencv_python2=OFF \
  -DBUILD_opencv_python3=ON \
  -DCMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=/usr/bin/python3  \
  -DPYTHON_DEFAULT_EXECUTABLE=$(which python3) \
  -DOPENCV_GENERATE_PKGCONFIG=ON \
  -DWITH_FFMPEG=ON \
  -DWITH_GSTREAMER=ON \
  ..

make install -j8
# https://docs.opencv.org/4.5.1/db/d05/tutorial_config_reference.html

rm /opt/*.zip
