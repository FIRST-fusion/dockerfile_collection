FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y wget gnupg

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    lsb-release \
    sudo \
    csh \
    libncurses5 \
    lib32z1 \
    libssl-dev \
    curl \
    gfortran \
    cmake \
    cmake-curses-gui \
    python3 \
    libblas-dev \
    liblapack-dev \
    libnetcdff-dev \
    libnetcdf-dev \
    libscalapack-mpi-dev \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -Lo- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | sudo gpg --dearmor -o /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list && \
    apt-get update && \
    apt-get install -y intel-oneapi-compiler-fortran

RUN echo "source /opt/intel/oneapi/setvars.sh" >> /etc/profile.d/oneapi.sh

WORKDIR /workspace

COPY . /workspace

RUN cd Stellarator-Tools && mkdir -p build && cd build && \
    cmake -DBLAS_LIBRARIES=/usr/lib/x86_64-linux-gnu/libblas.so \
          -DLAPACK_LIBRARIES=/usr/lib/x86_64-linux-gnu/liblapack.so \
          -DNetCDF_C_LIBRARY=/usr/lib/x86_64-linux-gnu/libnetcdf.so \
          -DNetCDF_Fortran_LIBRARY=/usr/lib/x86_64-linux-gnu/libnetcdff.so \
          -DSCALAPACK_LIBRARY=/usr/lib/x86_64-linux-gnu/libscalapack.so .. && \
    make

RUN /bin/bash -c "source /opt/intel/oneapi/setvars.sh"

CMD ["bash"]
