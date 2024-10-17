#!/bin/bash

# Directory containing the YAML files
WORKFLOW_DIR=".github/workflows"

echo "Domains in the workflow files:"

# Initialize an empty array to hold all domains
all_domains=()

# Find all YAML files in the directory
for file in $(find "$WORKFLOW_DIR" -name "*.yml" -o -name "*.yaml"); do
  # Extract the domain array from each file
  domains=$(yq e '.jobs.*.strategy.matrix.domain[]' "$file" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error processing $file. Skipping..."
    continue
  fi
  if [ -n "$domains" ]; then
    # Append domains to the all_domains array
    for domain in $domains; do
      all_domains+=("$domain")
    done
  fi
done

# Sort and print all domains
for domain in $(printf "%s\n" "${all_domains[@]}" | sort); do
  echo "$domain"
done