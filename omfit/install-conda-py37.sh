#!/bin/bash
#==========================================================================================================#
# script to setup OMFIT and requirements assuming a anaconda Python installation                           #
# It is now assumed that this script is run indirectly via install.sh                                      #
#==========================================================================================================#
# DO NOT EDIT - This file is automatically generated, if you wish to change this file                      #
# Instead update ./install_helpers/install_conda_template.sh and then run                                #
# generate_install_files.py                                                                                #
#                                                                                                          #
# In addition to the command line arguments accepted by install.sh, the conda installer also accepts:      #                            #
# Use -B to use the beta omfit channel for the install.                                                     #
# Use -s for to use a Static (pre-solved) OMFIT environment                                                #
#==========================================================================================================#

# TODO: Just switch everything to using functions and source them since most of the rest
# of the new components already do that.

if [ OMI_PROMPT_USER == "true" ];then
  SKIP_CONFIRM_PROMPT=''
else
  SKIP_CONFIRM_PROMPT='-y'
fi

# Hash and PYTHONPATH changes still needed?
export PYTHONPATH=''
hash -r
# Are these still needed?
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Install mambaforge if needed.
if [ $OMI_CONDA_COMPATIBLE_ENVIRONMENT == "false" ]; then
  $OMI_RUN_COMMAND bash $CONDA_INSTALLER_FILE -p $OMI_PREFIX -b || exit 1
  OMI_CONDA_COMPATIBLE_ENVIRONMENT=$OMI_PREFIX
  if [ $OMI_SUB_ENVIRONMENT_CUSTOM_PREFIX == "false" ]; then
    OMI_SUB_ENVIRONMENT_PREFIX=$OMI_PREFIX/envs
  fi
  OMI_OMFIT_ENV=$OMI_SUB_ENVIRONMENT_PREFIX/$OMI_SUB_ENVIRONMENT_NAME
fi
CONDA=$OMI_CONDA_COMPATIBLE_ENVIRONMENT/bin/mamba

# It is expected that configure_conda.sh has already taken care of prep work
# Like checking for a valid base environment and deleting/moving conflicting
# sub-environments

$OMI_RUN_COMMAND $CONDA create $SKIP_CONFIRM_PROMPT --prefix $OMI_OMFIT_ENV python=$OMI_PYTHON_VERSION || exit 1

$OMI_RUN_COMMAND source ${OMI_PREFIX}/bin/activate $OMI_OMFIT_ENV
CONDA_CONFIG=${OMI_PREFIX}/condabin/conda
echo "Installer is: $CONDA"
echo "Config tasks handled by: $CONDA_CONFIG"

# Setup channels
$OMI_RUN_COMMAND ${CONDA_CONFIG} config --env --add channels conda-forge --add channels aaronkho --add channels omfit

if [ ! -z $OMI_USE_BETA_CHANNEL ]
then
  echo "Using beta channel: $OMI_USE_BETA_CHANNEL"
  TAGGED_BETA_CHANNEL="-c $OMI_USE_BETA_CHANNEL"
  $OMI_RUN_COMMAND ${CONDA_CONFIG} config --add channels $OMI_USE_BETA_CHANNEL
fi

CHANNEL_TAGS=(${TAGGED_BETA_CHANNEL} -c omfit -c aaronkho -c conda-forge)

# Install dependencies
echo "Solving environment and installing $OMI_CONDA_PACKAGE"
$OMI_RUN_COMMAND $CONDA install $SKIP_CONFIRM_PROMPT ${CHANNEL_TAGS[@]} $OMI_CONDA_PACKAGE$OMI_CONDA_VERSION || exit 1

# # make omfit framework and classes available as libraries, skip docker as files don't exist there to install
if [ $OMI_OS_HYPERVISOR != 'docker' ] ; then
  pushd . >/dev/null
  cd ${OMFIT_ROOT}/omfit
  $OMI_RUN_COMMAND ${OMI_OMFIT_ENV}/bin/pip install --no-deps -e .
  popd >/dev/null
fi
