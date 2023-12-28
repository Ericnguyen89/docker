#!/bin/bash

# Check package manager
if command -v yum &> /dev/null; then
    # Using yum (Red Hat, CentOS, Fedora)
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io

elif command -v apt-get &> /dev/null; then
    # Using apt (Debian, Ubuntu)
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

elif command -v dnf &> /dev/null; then
    # Using dnf (Fedora 22+)
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io

else
    echo "Unsupported package manager. Please install Docker manually for your system."
    exit 1
fi

# Add the current user to the docker group to run Docker commands without sudo
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Give execute permissions to Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Display Docker and Docker Compose versions
docker --version
docker-compose --version

# Prompt the user to log out and log back in for group changes to take effect
echo "Please log out and log back in to apply group changes for Docker."
