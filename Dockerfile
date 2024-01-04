FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

ENV CUDA_HOME=/usr/local/cuda-12.1
ENV LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH

ENV TZ=Etc/UTC
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt upgrade -y

RUN apt install -y --no-install-recommends python3-pip build-essential
RUN pip3 install -U pip setuptools wheel
RUN pip3 install matplotlib numpy
RUN pip3 install torch==2.1.2+cu121 torchvision==0.16.2+cu121 torchaudio==2.1.2+cu121 -f https://download.pytorch.org/whl/torch_stable.html


# for OpenSeeD
ENV FORCE_CUDA=1
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX"

RUN apt install -y --no-install-recommends python-is-python3 python3-dev libopenmpi-dev libgl1 libglib2.0-0 git
RUN pip3 install -U cython

RUN pip3 install 'git+https://github.com/MaureenZOU/detectron2-xyz.git'
RUN pip3 install 'git+https://github.com/cocodataset/panopticapi.git'

COPY . /OpenSeeD
RUN pip3 install -r /OpenSeeD/requirements.txt
RUN cd /OpenSeeD/openseed/body/encoder/ops && sh make.sh

RUN mkdir /datasets
ENV DATASET=/datasets


RUN apt clean -y
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=newt
