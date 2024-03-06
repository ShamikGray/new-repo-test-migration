#!/bin/bash

# Function to extract username from repository URL
extract_username() {
    local repository_url="$1"
    # Extract username using awk
    local username=$(echo "$repository_url" | awk -F ':' '{split($2, a, "/"); print a[1]}')
    echo "$username"
}

# Function to create repositories
create_repository() {
    local repo_name="$1"
    
    # Check if repository already exists
    if ! git ls-remote "git@bitbucket.org:$BITBUCKET_USERNAME/$repo_name.git" &> /dev/null; then
        echo "Creating repository $repo_name on Bitbucket..."
        # Create repository on Bitbucket
        curl -X POST -u "$BITBUCKET_USERNAME:$BITBUCKET_PASSWORD" "https://api.bitbucket.org/2.0/repositories/$BITBUCKET_USERNAME/$repo_name" -H "Content-Type: application/json" -d '{"scm": "git", "is_private": true, "fork_policy": "no_public_forks"}'
        echo "Repository $repo_name created."
    else
        echo "Repository $repo_name already exists on Bitbucket."
    fi
}

# Function to push repositories to Bitbucket
push_to_bitbucket() {
    local repo_name="$1"
    
    echo "Pushing repository $repo_name to Bitbucket..."
    
    # Navigate to repository directory
    cd "$repo_name"
    
    # Initialize repository if not already initialized
    if [ ! -d ".git" ]; then
        git init
        git remote add origin "git@bitbucket.org:$BITBUCKET_USERNAME/$repo_name.git"
    fi
    
    # Add and commit changes
    git add .
    git commit -m "Initial commit"
    
    # Push changes to Bitbucket
    git push -u origin master
    
    # Navigate back to original directory
    cd ..
    
    echo "Repository $repo_name pushed to Bitbucket."
}

# Prompt user for Bitbucket password
read -s -p "Enter your Bitbucket password: " BITBUCKET_PASSWORD
echo

# Set Bitbucket username
BITBUCKET_USERNAME="ShamikGuhaRay"

# Read input from user
read -p "Enter the number of repositories to create: " num_repositories
read -p "Enter the number of pull requests per repository: " num_pull_requests

# Loop through repositories
for ((repo_index = 1; repo_index <= num_repositories; repo_index++)); do
    repo_name="gh-migration-repo-test-$repo_index"
    
    # Create repository
    create_repository "$repo_name"
    
    # Loop through pull requests for each repository
    for ((pr_index = 1; pr_index <= num_pull_requests; pr_index++)); do
        echo "Creating pull request $pr_index for repository $repo_name..."
        # Your code to create pull requests goes here
    done
    
    # Push repository to Bitbucket
    push_to_bitbucket "$repo_name"
done

