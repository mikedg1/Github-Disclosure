# GitHub Disclosure Script

## Overview
This script fetches your GitHub repositories using the GitHub CLI (`gh`) and formats them into two output files:
- **inventions.txt**: Contains all repositories with details such as name, creation date, description, and repository name.
- **opensource.txt**: Contains public repositories only, with their name and URL.

You can override the default output file names by providing them as arguments.

## Features
- Fetches up to 1000 repositories from your GitHub account.
- Outputs repository details in a structured format.
- Filters and lists public repositories separately.
- Capitalizes repository names for better readability.

## Prerequisites
- **GitHub CLI (`gh`)**: Ensure it is installed and authenticated.
  - Installation instructions: [GitHub CLI](https://cli.github.com/)
  - macOS: `brew install gh`
  - Ubuntu: `sudo apt install gh`
- **jq**: A lightweight JSON processor.

## Usage
Run the script with optional arguments for output file names:
```bash
./inventions.sh [inventions_output_file] [opensource_output_file]