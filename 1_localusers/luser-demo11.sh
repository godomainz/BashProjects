#!/bin/bash

# This generate a password
# This user can set the password length with -l and add a special charcter with -s
# Verbose mode can be enabled with -v

# Set a default password length
usage(){
    echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
    echo "Generate a random password."
    echo " -l LENGTH Specify the password length."
    echo " -s        Append a special character to the password"
    echo " -v        Increase verbosity"
    exit 1
}

log(){
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo ${MESSAGE}
    fi
}

LENGTH=48

while getopts vl:s OPTION
do
    case ${OPTION} in
    v)
        OPTS=1
        VERBOSE='true'
        log 'Verbose mode on.'
        ;;
    l)
        OPTS=2
        LENGTH=${OPTARG}
        ;;
    s)
        OPTS=3
        USE_SPECIAL_CHARACTER='true'
        ;;
    ?)
        OPTS=4
        usage
        ;;
    esac
done
if [ -z "${OPTS}" ]
then
    usage
fi

log 'Generating a password'
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})
# Append a special character is requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
    log 'Selecting a random random special character.'
    SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
    PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password:'

# Display the password.
echo ${PASSWORD}
exit 0