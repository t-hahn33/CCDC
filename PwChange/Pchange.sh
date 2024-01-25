#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Prompt for the new password
read -sp "Enter the new password: " new_password
echo

# Loop through all regular users with UID >= 1000
for username in $(awk -F':' '{ if ($3 >= 1000 && $1 != "nobody") print $1 }' /etc/passwd); do
  echo "Changing password for user: $username"
  echo -e "$new_password\n$new_password" | passwd --stdin $username
done

echo "Password change script completed."
