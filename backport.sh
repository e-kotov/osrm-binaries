#!/bin/bash

# List of all the historical versions you want to automatically build
VERSIONS=(
  "v5.27.1"
  "v6.0.0"
  "v26.4.0"
  "v26.4.1"
  "v26.5.0"
  "v26.6.0"
  "v26.6.1"
  "v26.6.2"
  "v26.6.3"
  "v26.6.4"
  "v26.6.5"
  "v26.7.0"
  "v26.7.1"
  "v26.7.2"
)

echo "Starting automated backporting process..."

for tag in "${VERSIONS[@]}"; do
  echo "Triggering GitHub Action build for $tag..."
  gh workflow run build.yml -f version_tag="$tag"
  sleep 5 # Prevents hitting GitHub API rate limits
done

echo "All builds have been sent to GitHub! Check the Actions tab to watch them build in parallel."
