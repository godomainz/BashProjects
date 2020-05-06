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


# Get the username (login).
read -p "Enter the username to create: " USER_NAME

# Get the real name (contents for the description field).
read -p "Enter the name of the person who is account is for : " COMMENT

# Get the password.
read -p "Enter the password to use for the account : " PASSWORD

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