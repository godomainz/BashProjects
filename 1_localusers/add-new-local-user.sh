#!/bin/bash

# Make sure the script is being executed with superuser privileges.
echo "Your UID is ${UID}"


if [[ ${UID} -ne 0 ]]
then
    echo "You are NOT root"
    exit 1
else
    echo "You are root. Lets continue !!!!!!!!!!"
fi

NUMBER_OF_PARAMETERS="${#}"
echo "You supplied ${NUMBER_OF_PARAMETERS} argument(s) on the command line."

# If the user doesn't supply at least one argument, then give them help.
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [COMMENT]..."
    exit 1
fi

# The first parameter is the user name.
USER_NAME="${1}"

# The rest of the parameters are for the account comments.
shift
COMMENT="${*}"
echo "USER_NAME ${USER_NAME}"
echo "COMMENT ${COMMENT}"

# Generate a password.
PASSWORD_TMP=$(date +%s%N${RANDOM}${RANDOM}${RANDOM}| sha256sum | head -c48)

# Append a special character to the password
SPECIAL_CHARACTER=$(echo '~`!@#$%^&*()_+=-[]\|}{":;?/>.<,' | fold -w1 | shuf | head -c1 )
PASSWORD=${PASSWORD_TMP}${SPECIAL_CHARACTER}

# Create the user with the password.
if [[ "${?}" -eq 0 ]]
then
    useradd -c "${COMMENT}" -m ${USER_NAME}
fi


# Check to see if the useradd command succeeded.
if [[ "${?}" -eq 0 ]]
then
    echo "Your user account has been created with the USERNAME ${USER_NAME} and account name ${COMMENT}"
else
    echo "Your user account has NOT been created with the USERNAME ${USER_NAME} and account name ${COMMENT}"
    exit 1
fi

# Set the password.
echo "${USER_NAME}:${PASSWORD}" | chpasswd

# Check to see if the passwd command succeeded.
if [[ "${?}" -eq 0 ]]
then
    echo "Your password has been set to ${PASSWORD}"
else
    echo "Your password has NOT been set to ${PASSWORD}"
fi

# Force password change on first login.
if [[ "${?}" -eq 0 ]]
then
    passwd -e ${USER_NAME}
fi

# Display the username, password, and the host where the user was created.
if [[ "${?}" -eq 0 ]]
then
    echo "Your USERNAME : ${USER_NAME} "
    echo "Your PASSWORD : ${PASSWORD} "
    echo "HOSTNAME of the account : ${HOSTNAME} "
fi