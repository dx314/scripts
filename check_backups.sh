#!/bin/bash

# The directory containing the subfolders
PARENT_DIR="$HOME/backups"

# The script to run when the parent folder size exceeds 50 GB
SCRIPT_TO_RUN="$HOME/clean_folders.sh"

# Calculate the total size of the parent folder in gigabytes
FOLDER_SIZE_GB=$(du -s --block-size=1G "$PARENT_DIR" | awk '{print $1}')

# Check if the folder size is greater than 50 GB
if [ "$FOLDER_SIZE_GB" -gt 50 ]; then
  # Run the script
  "$SCRIPT_TO_RUN"
else
  echo "The folder size is less than or equal to 50 GB. The script will not run."
fi

