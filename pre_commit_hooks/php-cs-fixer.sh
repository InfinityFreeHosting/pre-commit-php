#!/bin/bash
################################################################################
#
# Bash PHP Coding Standards Fixer
#
# This will prevent a commit if the tool has made changes to the files. This
# allows a develop to look at the diff and make changes before doing the
# commit.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None
#
################################################################################

# Plugin title
title="PHP Code Fixer"

# Possible command names of this tool
local_command="php-cs-fixer.phar"
vendor_command="vendor/bin/php-cs-fixer"
global_command="php-cs-fixer"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/helpers/colors.sh
source $DIR/helpers/formatters.sh
source $DIR/helpers/welcome.sh
source $DIR/helpers/locate.sh

# Build our list of files, and our list of args by testing if the argument is
# a valid path
args=""
files=()
for arg in ${*}
do
    if [ -e $arg ]; then
        files+=("$arg")
    else
        args+=" $arg"
    fi
done;

# php-cs-fixer requires a config file if multiple paths are presented.
# So if no config was specified, use an empty one.
if [[ "$args" != *"--config"* ]]; then
  args+=" --config $DIR/config/.php-cs-fixer.dist.php"
fi

${exec_command} fix${args} ${files[@]}

if [ $? -ne 0 ]; then
    echo -en "\n${bldred}Please review and commit.${txtrst}\n"
    exit 1
fi

exit 0
