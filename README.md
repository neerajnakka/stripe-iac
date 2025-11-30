# Strapi CMS Deployment on AWS with Terraform

This project contains the Infrastructure as Code (IaC) configuration to deploy  **Strapi Headless CMS** on AWS using **Terraform**.

The infrastructure is designed to be cost-effective and simple, utilizing a single EC2 instance with a self-hosted SQLite database, enclosed within a secure Virtual Private Cloud (VPC).

## 🏗️ Architecture Overview

The Terraform configuration provisions the following AWS resources:

*   **VPC**: A custom Virtual Private Cloud in `us-east-1` with a single public subnet.
*   **Security Groups**: A strict firewall configuration allowing:
    *   `SSH (22)`: For server management.
    *   `HTTP (80) / HTTPS (443)`: For web traffic.
    *   `Strapi (1337)`: For accessing the API and Admin Panel.
*   **EC2 Instance**: An `Ubuntu 24.04` server (t3.small) pre-configured with:
    *   Node.js (LTS)
    *   PM2 (Process Manager)
    *   Build tools (gcc, make, etc.)

## 📂 File Structure

*   `providers.tf`: Configures the AWS Provider (v6.0+) and sets the region.
*   `vpc.tf`: Defines the network infrastructure (VPC, Subnets, Internet Gateway) using the official AWS VPC module.
*   `security-groups.tf`: Defines the firewall rules for the application.
*   `ec2.tf`: Provisions the compute instance and includes a `user_data` script to automate the installation of system dependencies (Node.js, PM2).
*   `variables.tf`: Contains configurable parameters (Region, Instance Type, Key Pair Name) to make the code reusable.
*   `outputs.tf`: Outputs critical connection information (Public IP, SSH Command) after deployment.

## 🚀 Prerequisites

Before running this project, ensure you have:

1.  **Terraform installed** on your local machine.
2.  **AWS CLI configured** with valid credentials (`aws configure`).
3.  **An AWS Key Pair** created in the AWS

## 🛠️ Deployment Guide

### Step 1: Initialize Terraform
Download the required providers and modules:
```bash
terraform init
```

### Step 2: Review and Apply
Preview the changes and apply the configuration to your AWS account:
```bash
terraform plan
terraform apply
```
*Type `yes` when prompted.*

### Step 3: Server Configuration
Once the deployment finishes, Terraform will output your **Public IP** and **SSH Command**.

1.  **SSH into the server:**
    ```bash
    ssh -i "path/to/your-key.pem" ubuntu@<EC2_PUBLIC_IP>
    ```

2.  **Configure Swap Space (Critical for t3.small):**
    Strapi's build process requires significant memory. To prevent "Out of Memory" errors on a `t3.small` instance, you **must** enable swap space:
    ```bash
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    ```

### Step 4: Install Strapi
Now that the server is ready, install Strapi using the Quickstart (SQLite) method:

```bash
cd ~
npx create-strapi-app@latest my-project --quickstart
```

*   **Note:** If the build fails with a memory error, run this command instead:
    ```bash
    NODE_OPTIONS="--max-old-space-size=3072" npm run build
    ```

### Step 5: Start the Application
Use PM2 to keep Strapi running in the background:

```bash
cd my-project
pm2 start npm --name "strapi" -- run start
```

## 🌐 Accessing the Application

**Cloud-deployed version (Admin Panel):**
`http://98.94.26.234:1337/admin`

*   **Username**: `demo_user` (or create your own)
*   **Password**: `Password123`

*(The API is also available at `http://98.94.26.234:1337/api`, but requires authentication/configuration).*
