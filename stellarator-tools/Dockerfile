FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
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

WORKDIR /app

COPY . /app

RUN mkdir -p build && cd build && \
    cmake -DBLAS_LIBRARIES=/usr/lib/x86_64-linux-gnu/libblas.so \
          -DLAPACK_LIBRARIES=/usr/lib/x86_64-linux-gnu/liblapack.so \
          -DNetCDF_C_LIBRARY=/usr/lib/x86_64-linux-gnu/libnetcdf.so \
          -DNetCDF_Fortran_LIBRARY=/usr/lib/x86_64-linux-gnu/libnetcdff.so \
          -DSCALAPACK_LIBRARY=/usr/lib/x86_64-linux-gnu/libscalapack.so .. && \
    make

CMD ["bash"]
