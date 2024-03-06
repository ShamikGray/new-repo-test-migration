#!/bin/bash

# Function to create repositories
create_repository() {
    local repo_name="$1"
    
    # Check if repository already exists
    if ! git ls-remote "git@bitbucket.org:$BITBUCKET_USERNAME/$repo_name.git" &> /dev/null; then
        echo "Creating repository $repo_name on Bitbucket..."
        # Create repository on Bitbucket
        curl -X POST -u "$BITBUCKET_USERNAME" "https://api.bitbucket.org/2.0/repositories/$BITBUCKET_USERNAME/$repo_name" -H "Content-Type: application/json" -d '{"scm": "git", "is_private": true, "fork_policy": "no_public_forks"}'
        echo "Repository $repo_name created."
    else
        echo "Repository $repo_name already exists on Bitbucket."
    fi
}

# Function to create pull requests
create_pull_requests() {
    local repo_name="$1"
    local pr_count="$2"
    local contributor_count="$3"
    
    echo "Creating $pr_count pull requests for repository $repo_name..."
    
    # Create dummy pull requests
    for ((i = 1; i <= pr_count; i++)); do
        # Simulate pull request creation
        echo "Creating pull request $i for repository $repo_name..."
        # Your code to create pull requests goes here
    done
    
    echo "Pull requests created for repository $repo_name."
}

# Set Bitbucket username
BITBUCKET_USERNAME="ShamikGuhaRay"

# Loop through repositories
for ((repo_index = 1; repo_index <= 10; repo_index++)); do
    repo_name="gh-migration-repo-test-$repo_index"
    
    # Create repository
    create_repository "$repo_name"
    
    # Create pull requests
    create_pull_requests "$repo_name" 100 50
done

