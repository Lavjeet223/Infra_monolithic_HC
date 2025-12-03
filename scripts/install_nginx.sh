#! /usr/bin/env bash

# Fail on Errors
set -euo pipefail # Exit on error, undefined variable, or error in a pipeline command

# Install Nginx
echo "[INFO] Installing Nginx" # Installing Nginx web server

# Update package lists and install Nginx
sudo apt update # Update package lists
sudo apt install nginx -y # Install Nginx