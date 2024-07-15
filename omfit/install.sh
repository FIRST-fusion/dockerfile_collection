#!/bin/bash
# Script to install OMFIT, uses defaults read in from install_defaults.sh

echo "Starting OMFIT installation script..."

# 1. Configure

# So this doesn't show up twice in the log.
if [ ! -z $OMI_ALREADY_LOGGING ]; then
    echo "============= Stage 1: Configure ============="
fi 

# Find where this OMFIT installation resides
export OMFIT_ROOT=$(readlink -f $0 | xargs dirname | xargs dirname)
echo "OMFIT_ROOT set to $OMFIT_ROOT"

INSTALL_HELPERS_DIR=${INSTALL_HELPERS_DIR:=$OMFIT_ROOT/install/install_helpers}
echo "INSTALL_HELPERS_DIR set to $INSTALL_HELPERS_DIR"

# Load default settings
if [ -f $INSTALL_HELPERS_DIR/install_defaults.sh ]; then
    source $INSTALL_HELPERS_DIR/install_defaults.sh
else
    echo "ERROR: $INSTALL_HELPERS_DIR/install_defaults.sh not found."
    exit 1
fi

function display_all_configs() {
    # Print all variables in scope starting with OMI
    for var in $(set | grep --color=never ^OMI | cut -d= -f1); do
        echo $var=${!var}
    done
}

function select_package_manager() {
    if [ $# -eq 0 ]; then
        echo "No arguments provided, using defaults in $INSTALL_HELPERS_DIR/install_defaults.sh"
    elif [[ " ${@} " =~ " -m conda " ]]; then
        OMI_PACKAGE_MANAGER='conda'
    fi

    case "$OMI_PACKAGE_MANAGER" in
        "conda")
            OMI_MANAGER_TEXT="mamba/conda"
            if [ -f $INSTALL_HELPERS_DIR/configure_conda.sh ]; then
                source $INSTALL_HELPERS_DIR/configure_conda.sh
            else
                echo "ERROR: $INSTALL_HELPERS_DIR/configure_conda.sh not found."
                exit 1
            fi
            ;;
        *)
            echo "ERROR: No package manager specified"
            exit 1
            ;;
    esac
}

if [[ " ${@} " =~ " -h " ]]; then
    echo "OMFIT Installer:"
    echo "$OMI_HELP_TEXT_BASE"
    if [ -f $INSTALL_HELPERS_DIR/configure.sh ]; then
        source $INSTALL_HELPERS_DIR/configure.sh
    else
        echo "ERROR: $INSTALL_HELPERS_DIR/configure.sh not found."
        exit 1
    fi
    select_package_manager $@
    echo "$OMI_HELP_TEXT"
    echo "Additional options can be configured via environment variables described in $INSTALL_HELPERS_DIR/install_defaults.sh"
    exit 0
fi

echo "OMFIT ROOT AT $OMFIT_ROOT"

mkdir -p $OMI_SCRATCH_DIRECTORY || exit 1

if [ $OMI_LOG_INSTALL == true ] && [ -z $OMI_ALREADY_LOGGING ]; then
    export OMI_ALREADY_LOGGING=true
    echo "Logging install to $OMI_LOG_INSTALL_FILE"
    echo $(readlink -f $0) $@
    $(readlink -f $0) $@ 2>&1 | tee $OMI_LOG_INSTALL_FILE
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "Install issue(s) detected. $OMI_LOG_INSTALL_FILE contains a log of the install."
        echo "Consider re-running with '-n' to run interactively and be prompted for additional options."
        if [ $OMI_SUBMIT_INSTALL_INFO == "error" ]; then
            OMI_SUBMIT_INSTALL_INFO="true"
        fi
        export RET_VAL=1
    else
        echo "Install complete."
    fi
    if [ $OMI_SUBMIT_INSTALL_INFO == "true" ]; then
        echo "Submitting install information to OMFIT server as requested."
        if [ -f $INSTALL_HELPERS_DIR/configure.sh ]; then
            source $INSTALL_HELPERS_DIR/configure.sh || echo "Unable to gather some data for submission"
        fi
        OMI_ISSUE_FIELDS="-F user=\"$USER@$(hostname)\" -F version=\"$OMI_ENV_VERSION_FULL\""
        SUBMIT_INSTALL_INFO_COMMAND=${OMI_SUBMIT_INFO_COMMAND:="curl $OMI_SUBMIT_INSTALL_ISSUE_URL $OMI_ISSUE_FIELDS -F install_log=@$OMI_LOG_INSTALL_FILE"}
        echo $SUBMIT_INSTALL_INFO_COMMAND
        $SUBMIT_INSTALL_INFO_COMMAND
    fi
    exit $RET_VAL
fi

set -e
set -o pipefail

if [ -f $INSTALL_HELPERS_DIR/configure.sh ]; then
    source $INSTALL_HELPERS_DIR/configure.sh
else
    echo "ERROR: $INSTALL_HELPERS_DIR/configure.sh not found."
    exit 1
fi

echo "Configuring base installer"
configure_installer

select_package_manager $@
echo "$OMI_MANAGER_TEXT selected as package manager"

handle_command_line_parameters_base $@
handle_command_line_parameters $@

OMI_MAKE_ENV_LINKS_SUFFIX_LIST+=(miniconda_${OMI_SUB_ENVIRONMENT_NAME})
if [ $OMI_DISPLAY_ALL_CONFIGS == true ]; then
    echo "
Displaying all configuration settings:"
    display_all_configs
    echo ""
fi

printf "\n%s\n" "============= Stage 2: Prechecks ============="
pre_install_checks_base
pre_install_checks

printf "\n%s\n" "============= Stage 3: Fetch ============="
fetch_items_base 
fetch_items

printf "\n%s\n" "============= Stage 4: Install ============="
install_omfit

printf "\n%s\n" "============= Stage 5: Post-config ============="
post_install_config_base
post_install_config

printf "\n%s\n" "============= Stage 6: Report ============="
post_install_report_base
post_install_report

echo "OMFIT installation script completed successfully."
