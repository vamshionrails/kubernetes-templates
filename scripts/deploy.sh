#!/bin/bash

# GitHub credentials
USERNAME="$GITHUB_ACTOR"
TOKEN="$GITHUB_TOKEN"  # Access the GITHUB_TOKEN directly

# Repository details
PRIVATE=$PRIVATE
INITIALIZE_README=$INITIALIZE_README

# Set the repository name and description
REPO_NAME=${REPO_NAME:-"your-repo-name"}
DESCRIPTION=${DESCRIPTION:-"Your repository description"}

# Set global git configurations
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Check if the DELETE_REPO variable is set
if [[ "$DELETE_REPO" == "true" ]]; then
  # Delete the repository
  curl -L -X DELETE -u "$USERNAME:$TOKEN" "https://api.github.com/repos/$USERNAME/$REPO_NAME"
  echo "Repository deleted successfully: $USERNAME/$REPO_NAME"
else
  # Create a new repository
  curl -u "$USERNAME:$TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$REPO_NAME\",\"description\":\"$DESCRIPTION\",\"private\":$PRIVATE,\"auto_init\":$INITIALIZE_README}"
  echo "Repository created successfully: $USERNAME/$REPO_NAME"

  # Copy contents of local 'template' folder to the repository
  mkdir -p helmcharts
  mkdir -p scripts
  mkdir -p configs
  touch helmfile.yaml

  # Add and commit changes
  git add .
  git commit -m "Add 'test' folder with README.md"
  git push origin main
fi
