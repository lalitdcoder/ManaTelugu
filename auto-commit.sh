#!/bin/bash

# Auto-commit script for ManaTelugu app
# This script will automatically commit any changes to the git repository

# Change to the project directory
cd "$(dirname "$0")"

# Check if there are any changes to commit
if [[ -n $(git status --porcelain) ]]; then
    # Add all changes
    git add .
    
    # Create commit with timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Auto-commit: Changes made at $timestamp"
    
    echo "✅ Auto-committed changes at $timestamp"
else
    echo "ℹ️  No changes to commit"
fi
