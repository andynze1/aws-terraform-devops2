#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y openjdk-17-jre-headless curl apt-transport-https gnupg2 ca-certificates software-properties-common

# Install Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu || true

# Install Jenkins (LTS)
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins

# Ensure Jenkins listens on all interfaces (not just localhost)
if grep -q '^HTTP_HOST=' /etc/default/jenkins; then
  sed -i 's/^HTTP_HOST=.*/HTTP_HOST=0.0.0.0/' /etc/default/jenkins
else
  echo 'HTTP_HOST=0.0.0.0' >> /etc/default/jenkins
fi
systemctl daemon-reload || true
systemctl enable jenkins || true
systemctl restart jenkins || true

echo "Jenkins installed. Access on port 8080."
