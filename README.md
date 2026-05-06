📌 Project Title

Automated Ansible Master–Worker Node Setup

📖 Description

This project automates the complete setup of an Ansible environment, including both the Master Node (Control Node) and Worker Nodes (Managed Nodes) using shell scripts. It eliminates manual configuration and ensures a fast, consistent, and error-free setup.

🚀 Features
Automated setup for both Master and Worker nodes
One-command installation using shell scripts
SSH-based secure communication
Ready-to-use Ansible environment
Beginner-friendly and reusable


🛠️ Technologies Used
Ansible
Linux (Ubuntu / Amazon Linux / CentOS)
Shell Scripting (Bash)


⚙️ Architecture Overview
Master Node → Controls and sends commands
Worker Nodes → Execute tasks sent by Master


🧑‍💻 Master Node Setup

🔹 Step 1: Run Setup Script

bash <(curl -sL https://tinyurl.com/ansible-master-node-setup)


🔹 Step 2: Verify Installation
--> ansible --version


⚙️ What Master Script Does
Updates system packages
Installs Ansible
Configures Ansible environment
Prepares control node for managing workers


🖥️ Worker Node Setup

🔹 Step 1: Run Setup Script

bash <(curl -sL https://tinyurl.com/ansible-worker-node-setup)

⚙️ What Worker Script Does
Updates system packages
Installs required dependencies (Python, SSH)
Configures system for Ansible communication
Prepares node to be managed by Master


🔗 Connect Master to Worker Nodes

🔹 Step 1: SSH from Master to Worker
ssh user@worker-node-ip

🔹 Step 2: Add Worker Nodes in Inventory (Master Node)
[servers]
eg 192.168.1.10
eg 192.168.1.11

🔹 Step 3: Test Connection
ansible all -m ping

✅ Expected Output:
"ping": "pong"

🔒 Prerequisites

Linux system (Ubuntu / Amazon Linux / CentOS)

Sudo privileges

Internet connection

Basic knowledge of Linux commands
