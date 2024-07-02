FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y wget gnupg

RUN apt-get install -y \
    build-essential \
    lsb-release \
    sudo \
    csh \
    libncurses5 \
    lib32z1 \
    libssl-dev \
    curl \
    gfortran

RUN curl -Lo- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | sudo gpg --dearmor -o /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list && \
    apt-get update && \
    apt-get install -y intel-oneapi-compiler-fortran

# RUN apt-get install -y intel-oneapi-mkl

RUN echo "source /opt/intel/oneapi/setvars.sh" >> /etc/profile.d/oneapi.sh

WORKDIR /workspace

COPY . /workspace

RUN /bin/bash -c "source /opt/intel/oneapi/setvars.sh"

CMD ["bash"]
