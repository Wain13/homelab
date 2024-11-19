#!/bin/bash
# Copies the public key from root to another user for ssh login

username="$1"

if id -u "$username" &> /dev/null; then
    mkdir -p /home/$username/.ssh
    chown $username:$username /home/$username/.ssh
    cp /root/.ssh/authorized_keys /home/$username/.ssh/
    chown $username:$username /home/$username/.ssh/authorized_keys

    echo "Authorized keys copied to $username account from root"
else
    echo "$username doesn't exist"
    exit 1
fi
