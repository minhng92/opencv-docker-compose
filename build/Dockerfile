# https://hub.docker.com/_/ubuntu/
ARG UBUNTU_VERSION=22.04
ARG OPENCV_VERSION=4.5.4+dfsg-9ubuntu4

FROM ubuntu:$UBUNTU_VERSION

ENV PYTHONIOENCODING=utf-8

# -------------------
# | INSTALL PYTHON3 |
# -------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip
RUN echo "alias python='python3'\nalias pip='pip3'" >> ~/.bashrc
RUN pip3 install -U pip

# ------------------
# | INSTALL FFMPEG |--------------------------
# | https://packages.ubuntu.com/focal/ffmpeg |
# --------------------------------------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ffmpeg

# ------------------
# | INSTALL OPENCV |
# ------------------
# RUN pip3 install numpy
# COPY opencv.sh /
# RUN sh /opencv.sh
# RUN pip3 install opencv-python
RUN apt install -y python3-opencv=$OPENCV_VERSION
RUN pip3 install numpy opencv-python

# ---------------------------
# | INSTALL ADDITIONAL APTs |
# ---------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    ca-certificates \
    ssh \
    nano \
    htop \
    unzip \
    wget \
    apt-transport-https \
    ca-certificates

# -------------------
# | SETUP WORKSPACE |
# -------------------
WORKDIR /workspace
ENV JP_PASS=minh@23
ENV JP_BASE_URL=/

# ----------------------
# | INSTALL JUPYTERLAB |
# ----------------------
RUN pip3 install jupyterlab \
    pandas \
    scikit-learn \
    imageio \
    Pillow \
    imutils \    
    ffmpy \    
    requests \
    termcolor \
    prettytable \
    seaborn \
    bokeh \
    pyyaml \
    omegaconf \
    easydict \
    lxml \
    scake \
    plazy \
    attis

RUN printf "import os,json\nfrom notebook.auth import passwd\npass_wd=os.environ.get(\"JP_PASS\", \"pass\")\nbase_url=os.environ.get(\"JP_BASE_URL\", \"/base/url/\")\nos.system(\"jupyter notebook --generate-config\")\npasswd_hash=passwd(pass_wd, 'sha1')\nos.system(\"jupyter lab --NotebookApp.base_url={} --NotebookApp.disable_check_xsrf='True' --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.password={} --NotebookApp.terminado_settings={}\".format(base_url, passwd_hash, '\\\'{\"shell_command\":[\"/bin/bash\"]}\\\''))\n" > /root/jupyter_setup.py
CMD "/workspace/run.sh"
