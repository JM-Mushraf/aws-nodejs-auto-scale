# AWS Node.js Deployment 🚀

A cloud-native Node.js deployment on AWS using **Terraform** for infrastructure automation, **PM2** for process management, and **Application Load Balancer (ALB)** for seamless traffic distribution.

---

## 🔥 Features

- **Resilient Node.js backend** with PM2 process management
- **EC2 instances** across multiple Availability Zones
- **Application Load Balancer** to distribute traffic intelligently
- **Custom VPC & Security Groups** for hardened security
- **Automated provisioning** using `server.sh`
- **Global accessibility** through ALB DNS, no port forwarding needed

---

## 📦 Architecture Overview

```
+-----------------+       +------------------+
|   Internet      |       |   ALB            |
|   Clients       | <-->  |  (Load Balancer) |
+-----------------+       +------------------+
                                 |
                                 |
                     +----------------------+
                     | EC2 Instances Pool   |
                     |  (Node.js + PM2)    |
                     +----------------------+
```

- **VPC & Subnets**: Custom VPC spanning multiple AZs  
- **EC2 Instances**: Dual-instance setup for cost-conscious fault tolerance  
- **Load Balancing**: ALB routes traffic to healthy instances  
- **Security**: Custom SGs and health checks  

---

## ⚙️ Setup & Deployment

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/aws-nodejs-deployment.git
cd aws-nodejs-deployment
```

2. Configure Terraform variables in `variables.tf`  

3. Initialize Terraform:

```bash
terraform init
```

4. Apply Terraform infrastructure:

```bash
terraform apply
```

5. Deploy Node.js backend:

```bash
bash server.sh
```

6. Access your app via ALB DNS provided in Terraform outputs.

---

## 🔐 Security & Best Practices

- Custom **Security Groups** for inbound/outbound rules  
- Health checks to maintain instance health in ALB  
- Minimal permissions in IAM roles for EC2  

---

## 💡 Notes

- Designed for **high availability**, **fault tolerance**, and **cloud-native deployment**.  
- Dual-instance setup balances **cost vs. availability**.  

---

## ⚡ Tech Stack

- Node.js + Express  
- AWS EC2, VPC, ALB  
- Terraform for infrastructure-as-code  
- PM2 for Node.js process management  

---

## 📄 License

MIT License

