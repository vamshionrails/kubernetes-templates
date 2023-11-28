#!/bin/bash

# Function to create a new template
create_template() {
  # Get the project name and GitHub username from the user
  read -p "Enter your GitHub username: " GITHUB_USERNAME
  read -p "Enter the project name: " PROJECT_NAME

  # Create a copy of the template directory
  cp -r template_project "$PROJECT_NAME"

  # Replace placeholders in files
  find "$PROJECT_NAME" -type f -exec sed -i "s/{project-name}/$PROJECT_NAME/g" {} +

  # Initialize a Git repository
  git init "$PROJECT_NAME"

  # Commit the initial changes
  cd "$PROJECT_NAME" || exit
  git add .
  git commit -m "Initialize project from template"

  # Create a new GitHub repository
  curl -u "$GITHUB_USERNAME" https://api.github.com/user/repos -d "{\"name\":\"$PROJECT_NAME\"}"

  # Add the GitHub remote and push to the repository
  git remote add origin "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
  git branch -M main  # If using 'master', replace with 'master'
  git push -u origin main  # If using 'master', replace with 'master'

  echo "Template created for project: $PROJECT_NAME"
}

# Function to configure Helm values
configure_helm_values() {
  echo "Configuring Helm values..."

  # Example: Set Helm values for Cilium
  echo "cilium:" > ./configs/cilium-values.yaml
  echo "  replicaCount: 2" >> ./configs/cilium-values.yaml
  # Add more configurations as needed

  # Example: Set Helm values for Kubernetes Dashboard
  echo "kubernetes-dashboard:" > ./configs/k8s-dashboard-values.yaml
  echo "  replicaCount: 3" >> ./configs/k8s-dashboard-values.yaml
  # Add more configurations as needed

  echo "Helm values configured."
}

# Function to generate Helmfile
generate_helmfile() {
  echo "Generating Helmfile..."
  # ... (Same as before)
}

# Main deployment logic
echo "Starting deployment..."

# Check if template creation is requested
if [ "$1" == "--create-template" ]; then
  create_template
else
  # Set up environment
  source ./scripts/setup_environment.sh

  # Configure Helm values
  configure_helm_values

  # Generate Helmfile
  generate_helmfile

  # Apply Helmfile
  helmfile apply

  echo "Deployment complete."
fi
