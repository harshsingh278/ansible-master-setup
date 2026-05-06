#!/bin/bash

echo "============================================"
echo "Ansible Master Node Setup Script"
echo "Author: Harsh Singh"
echo "============================================"

LOG_FILE="/tmp/ansible_master_setup.log"

# Redirect output to log file
exec > >(tee -a $LOG_FILE) 2>&1

echo "=== Logging to: $LOG_FILE ==="

# Check root user
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo"
  exit 1
fi

echo "==============================================="
echo "******** Step 1: Updating system ************"
echo "==============================================="
apt update -y
apt upgrade -y
echo "==============================================="
echo "********* Step 2: Installing Ansible ********* "
echo "==============================================="
# Install required package
apt install software-properties-common -y

# Install Ansible from Ubuntu repo
apt install ansible -y

echo ""
echo "=== Ansible Version ==="
ansible --version

echo "==============================================="
echo "********* Step 3: SSH Configuration ********** "
echo "==============================================="


# Install SSH client/server
apt install openssh-client openssh-server -y

systemctl enable ssh
systemctl restart ssh

echo "==============================================="
echo "******* Step 4: Creating Ansible User ******** "
echo "==============================================="


# Create ansible user if not exists
if id "ansible" &>/dev/null; then
    echo "User ansible already exists"
else
    useradd -m -s /bin/bash ansible
    echo "ansible:1234" | chpasswd
    echo "User 'ansible' created with password '1234'."
fi

echo "==============================================="
echo "***** Step 5: Granting Sudo Permissions *******"
echo "==============================================="


# Install sudo if missing
apt install sudo -y

# Grant passwordless sudo
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
chmod 440 /etc/sudoers.d/ansible

cat /etc/sudoers.d/ansible

echo "========================================================="
echo "***** Step 6: Generating SSH Key for ansible user ****** "
echo "========================================================="


# Create SSH key
sudo -u ansible mkdir -p /home/ansible/.ssh

if [ ! -f /home/ansible/.ssh/id_rsa ]; then
    sudo -u ansible ssh-keygen -t rsa -b 4096 -N "" -f /home/ansible/.ssh/id_rsa
else
    echo "SSH key already exists"
fi

echo "==============================================="
echo "****** Step 7: Ansible Inventory Setup ******** "
echo "==============================================="


mkdir -p /etc/ansible
touch /etc/ansible/hosts

# Clear old inventory
> /etc/ansible/hosts

read -p "Enter number of groups: " GROUP_COUNT

for ((i=1; i<=GROUP_COUNT; i++))
do
    read -p "Enter name for group $i: " GROUP_NAME

    echo "[$GROUP_NAME]" >> /etc/ansible/hosts

    read -p "How many IPs in group '$GROUP_NAME': " IP_COUNT

    for ((j=1; j<=IP_COUNT; j++))
    do
        read -p "Enter IP $j for group '$GROUP_NAME': " IP

        echo "$IP" >> /etc/ansible/hosts
    done

    echo "" >> /etc/ansible/hosts
done

echo ""
echo "=== Inventory saved to /etc/ansible/hosts ==="
cat /etc/ansible/hosts

echo ""
echo "=== COPY THIS KEY TO WORKER NODES ==="
echo ""

cat /home/ansible/.ssh/id_rsa.pub

echo ""
echo "====================================="

echo ""
echo "=== Completed Ansible Master node setup ==="
echo "=== Script by Harsh Singh ==="
