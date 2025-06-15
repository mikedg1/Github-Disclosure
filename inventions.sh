#!/bin/bash

# -----------------------------------------------
# GitHub Repo Exporter Script
# -----------------------------------------------
# This script fetches your GitHub repositories using the GitHub CLI (`gh`),
# formats them into two files:
#   - inventions.txt: All repos (name, date, description, repo name)
#   - opensource.txt: Public repos only (name, URL)
# You can override output file names via arguments.
# -----------------------------------------------

# -------- CONFIG --------
INVENTIONS_FILE="${1:-inventions.txt}"
OPENSOURCE_FILE="${2:-opensource.txt}"

# -------- CHECK FOR gh CLI --------
if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI (gh) is not installed." >&2
  echo "Install it via: https://cli.github.com/" >&2
  echo "Or, on macOS: brew install gh" >&2
  echo "Or, on Ubuntu: sudo apt install gh" >&2
  exit 1
fi

# -------- UTIL: Capitalize repo name --------
capitalize_words() {
  echo "$1" |
    tr '-' ' ' |
    sed 's/[^a-zA-Z0-9 ]//g' |
    awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1'
}

# -------- Clear output files --------
> "$INVENTIONS_FILE"
> "$OPENSOURCE_FILE"

# -------- Fetch and process repos --------
gh repo list --limit 1000 --json name,description,createdAt,visibility,url --jq '
  .[] | {
    name,
    description,
    createdAt,
    repo: .name,
    url,
    visibility
  }
' | jq -c '.' | while read -r repo; do
  # Extract fields
  NAME=$(echo "$repo" | jq -r '.name')
  DESC=$(echo "$repo" | jq -r '.description // ""')
  DATE=$(echo "$repo" | jq -r '.createdAt' | cut -d'T' -f1)
  REPO=$(echo "$repo" | jq -r '.repo')
  URL=$(echo "$repo" | jq -r '.url')
  VISIBILITY=$(echo "$repo" | jq -r '.visibility')

  # Format name
  PROJECT_NAME=$(capitalize_words "$NAME")

  # Append to inventions.txt (or $1)
  echo -e "${PROJECT_NAME}\t${DATE}\t${DESC}\t${REPO}" >> "$INVENTIONS_FILE"

  # Append to opensource.txt (or $2) if public
  if [[ "$VISIBILITY" == "PUBLIC" ]]; then
    echo -e "${PROJECT_NAME}\t${URL}" >> "$OPENSOURCE_FILE"
  fi
done

# -------- Optional: Sort files --------
# sort "$INVENTIONS_FILE" -o "$INVENTIONS_FILE"
# sort "$OPENSOURCE_FILE" -o "$OPENSOURCE_FILE"