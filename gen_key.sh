#!/bin/bash

# Check if the .ssh directory exists
if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
fi

# Set the filename for the keypair
if [ -n "$1" ]; then
  filename="$1"
else
  filename="id_ed25519"
fi

# Generate a new SSH keypair with a strong passphrase
ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/"$filename" -N ""

# Print the public key
cat ~/.ssh/"$filename".pub
