#!/bin/bash

# Configuration flags (set to false to skip installation)
INSTALL_SUBSET=${INSTALL_SUBSET:-true}
INSTALL_ANONYMIZE=${INSTALL_ANONYMIZE:-true}

# URLs
SUBSET_URL="https://download.red-gate.com/EAP/SubsetterLinux64.zip"
ANONYMIZE_URL="https://download.red-gate.com/EAP/AnonymizeLinux64.zip"

# Install directories
SUBSET_DIR="/opt/rgsubset"
ANONYMIZE_DIR="/opt/rganonymize"

# Temporary ZIP paths
SUBSET_ZIP="/tmp/SubsetterLinux64.zip"
ANONYMIZE_ZIP="/tmp/AnonymizeLinux64.zip"

# Profile file to update PATH
PROFILE_FILE="$HOME/.bashrc"

# Function to add directory to PATH if not already present
add_to_path() {
  local dir="$1"
  if ! grep -q "$dir" "$PROFILE_FILE"; then
    echo "Adding $dir to PATH in $PROFILE_FILE..."
    echo "export PATH=\$PATH:$dir" >> "$PROFILE_FILE"
    echo "Please run: source $PROFILE_FILE or restart your shell to apply changes."
  else
    echo "$dir is already in PATH."
  fi
}

# Ensure unzip is installed
if ! command -v unzip &> /dev/null; then
  echo "Installing unzip..."
  sudo apt-get update
  sudo apt-get install -y unzip
else
  echo "unzip is already installed."
fi

# Install rgsubset
if [ "$INSTALL_SUBSET" = true ]; then
  echo "Installing rgsubset..."
  curl -L "$SUBSET_URL" -o "$SUBSET_ZIP"
  sudo mkdir -p "$SUBSET_DIR"
  sudo unzip -o "$SUBSET_ZIP" -d "$SUBSET_DIR"
  sudo chmod +x "$SUBSET_DIR"/*
  add_to_path "$SUBSET_DIR"
else
  echo "Skipping rgsubset installation."
fi

# Install rganonymize
if [ "$INSTALL_ANONYMIZE" = true ]; then
  echo "Installing rganonymize..."
  curl -L "$ANONYMIZE_URL" -o "$ANONYMIZE_ZIP"
  sudo mkdir -p "$ANONYMIZE_DIR"
  sudo unzip -o "$ANONYMIZE_ZIP" -d "$ANONYMIZE_DIR"
  sudo chmod +x "$ANONYMIZE_DIR"/*
  add_to_path "$ANONYMIZE_DIR"
else
  echo "Skipping rganonymize installation."
fi

echo "Installation script complete."
