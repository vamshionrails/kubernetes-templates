#!/bin/bash

# GitHub credentials
USERNAME="$GITHUB_ACTOR"
TOKEN="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"  # Access the GITHUB_TOKEN directly

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

  git clone https://$USERNAME:$TOKEN@github.com/$USERNAME/$REPO_NAME.git
  cd $REPO_NAME

  git remote add origin https://$USERNAME:$TOKEN@github.com/$USERNAME/$REPO_NAME.git

  # Set the remote URL (origin)
  git remote set-url origin https://$USERNAME:$TOKEN@github.com/$USERNAME/$REPO_NAME.git

  rm -rf * 
  cp -a ../template/. ../$REPO_NAME

  # Add and commit changes
  git add .
  git commit -m "Initializing"
  git branch -M main
  git push origin main

  echo "Additional folders and files added to the repository."
 

 
 
fi
