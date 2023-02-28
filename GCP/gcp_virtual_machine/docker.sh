#!/bin/sh
echo "========================================Start========================================="

sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# Add package signing key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add repository
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Install docker stable version
sudo apt-get update
sudo apt-get -y install docker-ce

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/2.6.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod a+x /usr/local/bin/docker-compose
# Start docker
sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -a -G docker ${USER}
echo "========================================Finish========================================="