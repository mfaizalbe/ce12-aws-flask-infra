# AWS High-Availability (HA) Flask Deployment
This repository documents the infrastructure setup for a highly available and fault-tolerant Python Flask application hosted on AWS. By leveraging EC2 Auto Scaling Groups (ASG) and Launch Templates, this project ensures the application can automatically scale to meet demand and "self-heal" in the event of instance failure.

## 🏗️ Architecture Overview
- Application Layer: A Python Flask web application served via Gunicorn.
- Compute: AWS EC2 instances running Amazon Linux 2023.
- Automation: EC2 Launch Templates provide consistent configuration for new instances.
- Orchestration: Auto Scaling Group (ASG) manages instance lifecycle and availability.
- Scaling Policy: Target Tracking Policy maintains average CPU utilization below 50%.

## 🚀 Deployment Workflow
### 1. Launch Template Configuration
The foundation of the setup is a Launch Template (t3.micro) containing the following "User Data" script. This script automates the installation of dependencies and pulls the application code from my [flask-app repository](https://github.com/mfaizalbe/flask-app).
```bash
#!/bin/bash
# System updates and package installation
yum update -y
yum install python3-pip git -y
pip3 install flask gunicorn

# Clone application code
git clone https://github.com/mfaizalbe/flask-app
cd flask-app

# Start application on port 8080
gunicorn -b 0.0.0.0:8080 app:app
```

### 2. Auto Scaling Group Setup
The ASG was configured with the following capacity settings to ensure high availability:
- Desired Capacity: 1
- Minimum Capacity: 1
- Maximum Capacity: 2

## 🧪 Testing & Validation
### Load Testing (Scale-Out)
To verify the Target Tracking Policy, I performed a load test using the stress-ng tool.
- Command: <code>stress-ng --cpu 2 --cpu-load 70 --timeout 1200</code>
- Observation: As CPU utilization exceeded the 50% threshold, the ASG successfully triggered a scale-out event, launching a second EC2 instance to distribute the load.

### Fault Tolerance (Auto-Healing)
To simulate a production failure, I manually terminated a running instance.
- Result: The ASG detected the unhealthy state and automatically provisioned a replacement instance, maintaining the Desired Capacity of 1.

## 🛠️ Tech Stack

- Cloud: AWS (EC2, ASG, CloudWatch)
- App Framework: Flask
- Production Server: Gunicorn
- OS: Amazon Linux 2023
- Testing: <code>stress-ng</code>

## 🧹 Cleanup
To avoid unnecessary AWS costs, the following resources are deleted after testing:
- Auto Scaling Group 
- EC2 Launch Template

## 🧠 What I Learned
### 1. Infrastructure Automation
- Launch Templates: Learned to create "blueprints" for EC2 instances to ensure consistent deployments.
- User Data Scripting: Automated the installation of Python, Flask, and Gunicorn using Bash scripts, eliminating manual server configuration .
- Resource Selection: Configured cost-effective t3.micro instances using the Amazon Linux 2023 AMI.

### 2. High Availability & Scalability
- Auto Scaling Groups (ASG): Implemented ASGs to manage instance lifecycles and ensure high availability.
- Self-Healing: Tested fault tolerance by terminating instances and observing the ASG automatically provision replacements.
- Dynamic Scaling: Configured Target Tracking Policies to automatically "scale out" (add servers) when CPU utilization exceeded 50%.

### 3. Monitoring & Validation
- Load Testing: Used stress-ng to simulate a 70% CPU load, forcing the system to react to high traffic.
- Performance Monitoring: Leveraged CloudWatch metrics to track CPU spikes and trigger scaling events.
- Cluster Management: Successfully validated the transition from 1 to 2 running instances during peak demand.

## 🛠️ Advanced Automation: AWS CLI
While I initially used the AWS Console for this project, I also explored Infrastructure as Code (IaC) by scripting the deployment process.
- CLI Provisioning: I created <code>scripts/provision.sh</code> to automate the creation of the Launch Template and the Auto Scaling Group via the terminal.
- Efficiency: This approach demonstrates how to manage cloud resources programmatically, making deployments faster and more repeatable.
