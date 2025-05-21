# 🌐 AWS Cloud Infrastructure with Terraform, EKS, GitOps, Monitoring & Jenkins

This Terraform project provisions a complete AWS infrastructure stack including:

- 🔧 **Amazon EKS cluster**
- 🚀 **GitOps with ArgoCD**
- 📊 **Monitoring with Prometheus & Grafana**
- ⚙️ **Jenkins deployment on EC2**
- 🗂️ **StorageClasses & DNS**
- 🔐 **IAM roles & autoscaler**
- 🌍 **Route 53 DNS integration**
- 🌐 **VPC, subnets, and security groups**
- 🧪 **Sample apps (NGINX, Echo Server)**


---

## 📦 Components

### ✅ Core Modules
- `main.tf`, `variables.tf`, `outputs.tf`: Core Terraform infrastructure logic.
- `provider.tf`, `s3-backend.tf`: Cloud provider and backend configuration (S3 + DynamoDB).
- `terraform.tfvars`, `vpc.auto.tfvars`: Parameter values.

### ☸️ Kubernetes Cluster
- `eks-cluster.tf`, `eks-securitygroups.tf`, `update-kubeconfig.tf`: Provisions and configures EKS.
- `iam-roles.tf`, `iam-autoscaler.tf`: Creates required IAM roles and bindings.

### 📊 Monitoring Stack
- `k8s-prometheus.tf`, `k8s-grafana.tf`: Deploys Prometheus & Grafana via Helm.
- `grafana-dashboard.yaml`, `grafana-values.yaml`: Custom dashboards and config.
- `prometheus-stoageclass.yaml`, `storage-class.yaml`: Persistent storage using AWS EBS.

### 🚀 GitOps with ArgoCD
- `k8s-argocd.tf`, `argocd.json`: Installs ArgoCD using Helm and sets up the namespace.

### 🌐 Networking & DNS
- `namespace.tf`: Defines `monitoring`, `argocd`, and other namespaces.
- `route-53-dns-records.tf`: Creates DNS records in Route 53.
- `aws-data-sources.tf`: Looks up existing VPCs, subnets, and Route 53 zones.

### 📡 Sample Applications
- `echoserver.yaml`: A basic echo service with ALB ingress.
- `nginx.yaml`: A multi-replica nginx deployment.
- `crd-grafana.yaml`: (Commented out) Custom Resource Definition for Grafana dashboards.

---

## 🛠 Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- `kubectl` configured for EKS
- `helm` for Helm chart deployments
- Valid AWS IAM credentials with permission to create infrastructure

---

---

## ☸️ Kubernetes Cluster with EKS

Provisioned using:
- `eks-cluster.tf`
- `eks-securitygroups.tf`
- `update-kubeconfig.tf`

Features:
- Node groups
- Security groups
- IAM roles for service accounts (IRSA)
- `context-k8s.sh` script to configure `kubectl`

---

## ⚙️ Jenkins VM Setup

Jenkins is installed on a provisioned EC2 instance using Terraform + shell automation.

### Files:
- `main.tf`, `variables.tf`, `outputs.tf` – Define the VM infrastructure (AMIs, security groups, etc.)
- `install.sh` – Automates Jenkins setup (Ubuntu/Debian-based)
- `install-redhat.sh` – Jenkins setup for RHEL/CentOS

### VM Features:
- Auto-installs Java, Jenkins, Docker, AWS CLI, kubectl, eksctl, helm, and monitoring tools.
- Installs Trivy, Snyk, ArgoCD CLI (customizable).
- Adds Jenkins and system users to the Docker group.

### Access Jenkins:
Once applied, Jenkins will be accessible via the EC2 public IP or a custom Route 53 DNS record.

---

## 🚀 GitOps with ArgoCD

- Provisioned in the `argocd` namespace
- Helm chart deployed via `k8s-argocd.tf`
- Uses ingress (ALB) with Route 53 DNS support

---

## 📊 Monitoring Stack

- **Prometheus** (`k8s-prometheus.tf`)
- **Grafana** (`k8s-grafana.tf`)
- Uses:
  - `grafana-values.yaml`
  - `grafana-dashboard.yaml`
  - `prometheus-stoageclass.yaml`
- Dashboards are auto-loaded using config maps and labels.

---

## 🧪 Sample Applications

### Echoserver
- Kubernetes service & ingress (`echoserver.yaml`)
- Exposed via ALB at `echo.devopsbyexample.io`

### NGINX
- Simple deployment with 4 replicas (`nginx.yaml`)

---

## 🌐 Networking & DNS

### VPC & Subnets
- Managed in `network/` and `aws-data-sources.tf`
- Supports custom subnet lookups and route tables

### Route 53
- DNS records for applications & Jenkins (`route-53-dns-records.tf`)

---

## 📦 Storage

- `storage-class.yaml`, `prometheus-stoageclass.yaml`
- AWS EBS-based `gp2` and custom dynamic provisioning
- Separate classes for Prometheus, Grafana

---

## 🔐 IAM & Autoscaling

- `iam-roles.tf`, `iam-autoscaler.tf`
- Includes:
  - IAM roles for EKS and workloads
  - Role for Cluster Autoscaler

---

## 🚀 Deployment Steps

1. **Initialize Terraform**
   ```bash
   terraform init


2.	Plan the Infrastructure
    ```bash
    terraform plan -out=tfplan

3.	Apply the Plan
   ```bash
    terraform apply tfplan
