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

# Check if a passphrase was provided
if [ -n "$2" ]; then
  ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/"$filename" -N $2
else
  yes "" | ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/"$filename" -N "" >&- 2>&-
fi

# Generate a new SSH keypair with an optional passphrase


# Add an entry for github.com to the SSH config file
echo "Host github.com
  IdentityFile ~/.ssh/$filename" >> ~/.ssh/config

# Print the public key
cat ~/.ssh/"$filename".pub

echo "Go to https://github.com/settings/keys and add the public key."
