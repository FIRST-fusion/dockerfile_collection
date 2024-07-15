FROM ubuntu:20.04
# Set the working directory to /app
WORKDIR /install
# Expects current version of conda install script in Docker directory
ADD ./install/install-conda-3.sh /install/install-conda-3.sh
ADD ./install/install.sh /install/install.sh
ADD ./install/omfit_environment_version_tag /install/omfit_environment_version_tag
ADD ./install/install_helpers /install/install_helpers
ADD ./install/install-conda-py37.sh /install/install-conda-py37.sh


ENV PATH=/opt/conda/envs/omfit/bin:/opt/conda/bin:${PATH}
ENV USER=root
ENV SHELL=/bin/bash
ENV LD_LIBRARY_PATH=/opt/conda/envs/omfit/lib
ENV INSTALL_HELPERS_DIR=/omfit/install_helpers

RUN apt-get update
RUN apt-get install -y \
    xterm \
    libgl1-mesa-glx \
    tcsh \  
    procps \
    curl \
    openssh-server

# Work around an issue with recent versions of conda-build 
RUN apt-get update && apt-get install -y binutils
RUN ls -l /install
RUN ls -l /install/install_helpers

# Ensure install.sh is executable
RUN chmod +x /install/install.sh

# Install omfit prereqs using conda package
RUN cd /install/ && export INSTALL_HELPERS_DIR=/install/install_helpers && bash ./install.sh -p /opt/conda
RUN mamba install -y boa
# omas not part of env any longer, but self test needs it installed.
# Regular pip install since OMFIT-Source is not included in the image.
RUN pip install --no-deps omas
RUN ln -s /opt/conda/lib/libcrypto.so.1.0.0 /opt/conda/lib/libcrypto.so.10
RUN ln -s /opt/conda/lib/libssl.so.1.0.0 /opt/conda/lib/libssl.so.10
RUN conda clean --all
RUN rm -rf /install

WORKDIR /workspace
COPY . /workspace

# Run bash when the container launches
CMD ["bash"]
