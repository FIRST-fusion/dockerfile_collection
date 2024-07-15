#!/bin/bash
# Script to install conda, uses defaults read in from install_defaults.sh

echo "Starting install-conda-3.sh script..."

# Check if install-conda-py37.sh is present
if [ ! -f /install/install-conda-py37.sh ]; then
    echo "ERROR: /install/install-conda-py37.sh not found."
    exit 1
fi

# Source the install-conda-py37.sh script
source /install/install-conda-py37.sh

# Rest of the script...
