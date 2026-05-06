#!/bin/bash

echo "============================================"
echo "Ansible Worker Node Setup Script"
echo "Author: Harsh Singh"
echo "============================================"

LOG_FILE="/tmp/ansible_worker_setup.log"

# Redirect output to log file
exec > >(tee -a $LOG_FILE) 2>&1

echo "=== Logging to: $LOG_FILE ==="

# Check root user
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo"
  exit 1
fi
echo ""
echo "============================================"
echo "=== Step 1: System Update ==="
echo "============================================"
echo ""
apt update -y
apt upgrade -y
echo ""
echo "============================================"
echo "=== Step 2: Configure SSH ==="
echo "============================================"
echo ""
# Install SSH server
apt install openssh-server -y

# Enable password authentication if needed
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

systemctl enable ssh
systemctl restart ssh
echo ""
echo "============================================"
echo "=== Step 3: Create ansible user ==="
echo "============================================"
echo ""
# Create ansible user if not exists
if id "ansible" &>/dev/null; then
    echo "User ansible already exists"
else
    useradd -m -s /bin/bash ansible
    echo "ansible:ansible123" | chpasswd
    echo "User ansible created"
fi
echo ""
echo "============================================"
echo "=== Step 4: Grant Sudo Permission to ansible user ==="
echo "============================================"
echo ""
# Install sudo if missing
apt install sudo -y

# Add sudo permission
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/ansible

cat /etc/sudoers.d/ansible
echo ""
echo "============================================"
echo "=== Step 5: Prepare .ssh directory ==="
echo "============================================"
echo ""
# Create SSH directory
mkdir -p /home/ansible/.ssh

# Create authorized_keys file
touch /home/ansible/.ssh/authorized_keys

# Set permissions
chmod 700 /home/ansible/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys

# Ownership
chown -R ansible:ansible /home/ansible/.ssh

echo ""
echo "============================================"
echo "****** MANUAL STEP REQUIRED *******"
echo "============================================"
echo ""
echo "Paste the master's public SSH key into:"
echo "/home/ansible/.ssh/authorized_keys"
echo ""
echo "Run:"
echo "sudo vi /home/ansible/.ssh/authorized_keys"
echo ""
echo "Then restart SSH:"
echo "sudo systemctl restart ssh"
echo ""
echo "============================"
echo ""
echo "=== Script done by Harsh Singh ==="
