---

## **📌 Strapi CMS Deployment on AWS using Terraform**

This project contains the **Infrastructure as Code (IaC)** configuration to deploy a **Strapi Headless CMS** on AWS using **Terraform**.
The infrastructure is designed to be **simple, cost-effective and production-ready**, using a single EC2 instance running Strapi with PM2 and a self-hosted SQLite database inside a secure VPC.

---

## **🏗️ Architecture Overview**

Terraform provisions the following AWS resources automatically:

| Component            | Description                                                                    |
| -------------------- | ------------------------------------------------------------------------------ |
| **VPC**              | Custom Virtual Private Cloud (CIDR: `10.0.0.0/16`)                             |
| **Public Subnet**    | Enables Strapi to be accessed from the internet                                |
| **Internet Gateway** | Created automatically via VPC module when public subnet is enabled             |
| **Security Group**   | Allows SSH (22), HTTP (80/443), and Strapi port (1337)                         |
| **EC2 Instance**     | Ubuntu 24.04 (t3.small) with Node.js, npm, and PM2 pre-installed via user_data |

This design suits **demo, learning, and low-traffic CMS environments** while keeping AWS costs minimal.

---

## **📂 Repository Structure**

| File                 | Purpose                                                                              |
| -------------------- | ------------------------------------------------------------------------------------ |
| `providers.tf`       | Configures Terraform and AWS Provider                                                |
| `vpc.tf`             | Creates VPC, subnet, route table, and internet gateway using official AWS VPC module |
| `security-groups.tf` | Defines firewall rules permitting 22, 80, 443 and 1337                               |
| `ec2.tf`             | Provisions EC2 instance and installs dependencies via `user_data`                    |
| `variables.tf`       | Stores configurable deployment parameters (region, key pair, instance type)          |
| `outputs.tf`         | Prints Public IP and SSH command after deployment                                    |

---

## **🚀 Prerequisites**

Before deploying:

* Terraform installed
* AWS CLI configured (`aws configure`)
* An AWS EC2 Key Pair created in the selected region

---

## **🛠️ Deployment Guide**

### **Step 1 — Initialize Terraform**

```bash
terraform init
```

### **Step 2 — Preview & Deploy**

```bash
terraform plan
terraform apply
```

Type `yes` when prompted.

### **Step 3 — SSH into the EC2 Instance**

After apply finishes, Terraform prints the Public IP.

```bash
ssh -i "path/to/your-key.pem" ubuntu@<EC2_PUBLIC_IP>
```

### **Step 4 — Configure Swap Space (Critical for t3.small)**

Strapi uses heavy memory during the build phase. Add swap to prevent crashes:

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## **📦 Installing & Starting Strapi in Production**

### Install Strapi

```bash
cd ~
npx create-strapi-app my-project --quickstart
```

> If the build fails due to memory limits:

```bash
NODE_OPTIONS="--max-old-space-size=3072" npm run build
```

### Build Strapi for Production

```bash
cd my-project
npm run build
```

### Start Strapi with PM2 (Production Mode)

```bash
pm2 start npm --name strapi -- run start
pm2 save
pm2 startup
```

Strapi will now **automatically restart** on system boot.

---

## **🌍 Accessing the Application**

| Component                             | URL                                  |
| ------------------------------------- | ------------------------------------ |
| **Admin Panel**                       | `http://98.94.26.234:1337/admin`     |
| **REST API**                          | `http://98.94.26.234:1337/api`       |
| **Sample Public Collection Endpoint** | `http://98.94.26.234:1337/api/tests` |

### API Example Response

```json
{
  "data": [
    {
      "id": 2,
      "title": "Neeraj  Chandra",
      "description": "Strapi deployment using iac",
      "publishedAt": "...",
      "createdAt": "...",
      "updatedAt": "..."
    }
  ],
  "meta": { ... }
}
```

---

## **🔑 Notes on Strapi Modes**

| Development                  | Production                        |
| ---------------------------- | --------------------------------- |
| `npm run develop`            | `npm run build` + `npm run start` |
| Hot reload enabled           | Optimized and fast                |
| Content-Type Builder enabled | Schema locked for safety          |
| Not for live deployments     | Recommended for EC2               |

> For schema edits: temporarily run `npm run develop` → create content types → rebuild → restart PM2.

---

## **💡 Next Steps / Possible Enhancements**

Future improvements could include:

* Reverse Proxy with **Nginx**
* **RDS PostgreSQL** instead of SQLite
* **Autoscaling with Load Balancer**
* **S3 Bucket + CloudFront for media storage**

---

## **📌 Summary**

✔ Fully automated infrastructure provisioning using Terraform
✔ Strapi CMS deployed in **production mode** on AWS EC2
✔ PM2 ensures **automatic restarts and process monitoring**
✔ Public REST API successfully exposed at `/api/tests`

---

## **📎 Author**

**Neeraj Chandra Nakka**
Cloud Deployment & Infrastructure-as-Code

---
