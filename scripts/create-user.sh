#!/bin/bash

if [ "$#" -eq 0 ]
then
  echo "Please run with the username as an argument"
  exit 1
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

username="$1"

# Check if user already exists
if id -u "$username" &> /dev/null; then
  echo "User '$username' already exists."
  exit 1
else
  # Verify home directory and profile, add if missing
  useradd -m -s /bin/bash "$username" 
  usermod -aG sudo,adm,www-data "$username"

  # Create a profile file if it doesn't exist
  if [ ! -f "/home/$username/.bashrc" ]; then
    cp /etc/skel/.bashrc "/home/$username/"
    cp /etc/skel/.profile "/home/$username/"
    chown "/home/$username/.bashrc" "$username"
    chown "/home/$username/.profile"
  fi

  echo "User '$username' created successfully."
  echo "Use 'passwd $username' form an admin or root account to set the user password."
fi
