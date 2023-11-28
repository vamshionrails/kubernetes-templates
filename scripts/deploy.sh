#!/bin/bash

# GitHub credentials
USERNAME="$GITHUB_ACTOR"
TOKEN="$GITHUB_TOKEN"  # Access the GITHUB_TOKEN directly

# Repository details
REPO_NAME="your-repo-name"
DESCRIPTION="Your repository description"
PRIVATE=false
INITIALIZE_README=true

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a new repository
curl -u "$USERNAME:$TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$REPO_NAME\",\"description\":\"$DESCRIPTION\",\"private\":$PRIVATE,\"auto_init\":$INITIALIZE_README}"

echo "Repository created successfully: $USERNAME/$REPO_NAME"
