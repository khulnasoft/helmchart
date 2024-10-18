#!/bin/bash

# Ensure agent version is passed as a parameter
if [ -z "$1" ]; then
  echo "Usage: ./agent_version_pr.sh <agent_version>"
  exit 1
fi

AGENT_VERSION=$1

# Prepare the environment
pip3 install ruamel-yaml semver

# Configure git
git config --global user.name "Khulnasoftbot"
git config --global user.email "bot@cloud.khulnasoft.com"

# Create a new branch
BRANCH_NAME="agent-${AGENT_VERSION}"
git checkout -b $BRANCH_NAME
git push -u origin $BRANCH_NAME

# Update files using your Python script
.github/scripts/update_versions.py set_app_version --version $AGENT_VERSION

# Commit the changes
git add charts/khulnasoft/Chart.yaml charts/khulnasoft/README.md
git commit -m "Update agent version to $AGENT_VERSION"
git push origin $BRANCH_NAME

# Create a pull request
gh pr create --base main --head $BRANCH_NAME --title "Update agent version to $AGENT_VERSION" --body "See https://github.com/khulnasoft/khulnasoft/releases/tag/$AGENT_VERSION for release notes."
