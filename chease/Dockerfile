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

CMD ["bash"]
