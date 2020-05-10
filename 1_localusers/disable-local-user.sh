#!/bin/bash

# Run as root.
if [[ "${UID}" -ne 0 ]]
then
    echo "Please run with sudo or as root" >&2
    exit 1
fi

log(){
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo ${MESSAGE}
    fi
}
usage(){
    echo "Usage: ${0} [-dra] [-u USER_ACCOUNT_NAME]" >&2
    echo "Disables/Delete user account(Default is Disabling)"
    echo " -u  USER_ACCOUNT_NAME      Specify user account name to delete(Mandatory)"
    echo " -d                         Deletes accounts instead of disabling them(Default is Disabling)"
    echo " -r                         Removes the home directory associated with the account(s)"
    echo " -a                         Creates an archive of the home directory associated with the accounts(s) and stores the archive in the /archives directory"
    exit 1
}
U_FLAG=0
DISABLE="true"

delete_or_disable_user(){
    USER_ID=$(id -u $1)
    if [[ USER_ID -lt 1000 ]]
    then
        echo "$1 is a system account. You can't delete this account " >&2
        exit 1
    fi
    if [[ ${DISABLE} = "true" ]]
    then
        echo "Disabling the user"
        chage -E 0 $1
    else
        echo "Deleting the user"
        
        userdel $1
        if [[ "${?}" -ne 0 ]]
        then
            echo "The account ${1} was NOT deleted." >&2
            exit 1
        else
            echo "The account ${1} was deleted."
            if [[ ${ARCHIVE_HOME_DIR} = "true" ]]
            then
                echo "Archiving home directory of $1"
                mkdir -p /archives
                tar -zcvf /archives/${1}.tar.gz /home/$1
            fi

            if [[ ${REMOVE_HOME_DIR} = "true" ]]
            then
                echo "Removing home directory of $1"
                rm -rf /home/$1
            fi
        fi
    fi
}


while getopts vu:dra OPTION
do
    case ${OPTION} in
    v)
        VERBOSE='true'
        log 'Verbose mode on.'
        ;;
    u)
        U_FLAG=1
        USER=${OPTARG}
        echo "Option U"
        ;;
    d)
        DISABLE="false"
        echo "Option d"
        ;;
    r)
        REMOVE_HOME_DIR="true"
        echo "Option R"
        ;;
    a)
        ARCHIVE_HOME_DIR="true"
        echo "Option A"
        ;;
    ?)
        usage
        ;;
    esac
done
if [[ $# = 0 ]]
then
    usage
fi
if [[ U_FLAG -eq 0 ]]
then
    usage
fi

shift "$(( OPTIND - 1 ))"

if [[ $# -gt 0 ]]
then
    usage
fi

delete_or_disable_user ${USER}