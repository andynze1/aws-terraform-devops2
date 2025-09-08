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
- `eks-cluster.tf`: Provisions and configures EKS (managed node groups, addons).
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
- `examples/k8s/echoserver.yaml`: A basic echo service with ALB ingress.
- `examples/k8s/nginx.yaml`: A multi-replica nginx deployment.
- `crd-grafana.yaml`: (Commented out) Custom Resource Definition for Grafana dashboards.

---

## 🛠 Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- `kubectl` configured for EKS
- `helm` for Helm chart deployments
- Valid AWS IAM credentials with permission to create infrastructure

---

## ☸️ Kubernetes Cluster with EKS

Provisioned using:
- `eks-cluster.tf`
- `eks-securitygroups.tf`
  (kubectl context managed by Terraform providers; no local-exec)

**Features:**
- Managed node groups
- Custom security groups
- IRSA for Kubernetes pods
- `context-k8s.sh` to automatically update kubeconfig

---

## ⚙️ Jenkins VM Setup

Jenkins is installed on an EC2 instance provisioned via Terraform and bootstrapped using shell scripts.

### Files:
- `main.tf`, `variables.tf`, `outputs.tf`: Define EC2 instance, security groups, EBS volume, key pairs.
- `install.sh`: Jenkins setup for Ubuntu/Debian-based systems.
- `install-redhat.sh`: Jenkins setup for RHEL-based systems.

### Features:
- Installs Jenkins, Docker, Java, AWS CLI, kubectl, eksctl, helm, Trivy, and Snyk.
- Adds necessary users to the Docker group.

### Access:
- Jenkins UI available via public IP or Route 53 DNS.
- Credentials: admin (set during setup)
- To retrieve Nexus admin password:
  ```bash
  docker exec nexus cat /nexus-data/admin.password

📊 Monitoring Stack

Includes:
	•	Prometheus: Cluster metrics and scraping configuration.
	•	Grafana: Dashboards with sidecar-enabled dynamic loading.
	•	Uses:
	•	grafana-values.yaml
	•	grafana-dashboard.yaml
	•	Storage class via prometheus-stoageclass.yaml

Access Grafana via ingress and authenticate with the credentials defined in the values file.

⸻

🧪 Sample Applications

Echoserver
	•	K8s service with ALB ingress
	•	Accessible at: echo.devopsbyexample.io

NGINX
	•	4 replica deployment with ClusterIP service

⸻

🌐 Networking & DNS
	•	VPC, subnets, and route tables defined via network-module.
	•	DNS entries for ArgoCD, Jenkins, and Grafana created in route-53-dns-records.tf.

⸻

📦 Storage
	•	storage-class.yaml and prometheus-stoageclass.yaml define gp2 storage classes.
	•	Separate classes for monitoring workloads and general use.

⸻

🔐 IAM & Autoscaling
	•	IAM roles defined in:
	•	iam-roles.tf: For EKS nodes and workloads.
	•	iam-autoscaler.tf: Cluster Autoscaler support.

**🚀 Deployment Steps**
1.	Initialize Terraform
    ```bash
    terraform init

2.	Plan the Infrastructure
    ```bash
    terraform plan -out=tfplan

3.	Apply the Plan
    ```bash
    terraform apply tfplan

4.	Configure kubectl
    ```bash
    bash context-k8s.sh

5.	Destroy Infrastructure (if needed)
    ```bash
    terraform destroy

6. Access Jenkins & Grafana
Jenkins: Use EC2 public IP or Route 53
Grafana: Via ALB ingress


🔐 Remote State Management

Terraform state is managed remotely using:
	•	S3 bucket for storing state files
	•	DynamoDB for state locking

Configuration: s3-backend.tf

⸻

📤 Outputs

Post-deployment, the following outputs are available:
	•	EKS cluster name and kubeconfig setup
	•	ArgoCD, Jenkins, and Grafana URLs
	•	IAM role ARNs and resource IDs


**📁 Directory Structure**
    ├── modules
        ├── eks-module/                        # EKS cluster & node groups
            ├── (Helm + manifests for addons)
        ├── examples/
            ├── k8s/                        # Example Kubernetes deployments (not managed by TF)
        ├── network-module/                    # VPC, subnets, DNS
        ├── vm-module/                    # EC2 VM and Jenkins setup
    ├── main.tf/                    # Bash scripts (kubectl config, Jenkins install)
    ├── outputs.tf/                 # Example applications (nginx, echoserver)
    ├── provider.tf
    ├── README.md
    ├── s3-backend.tf
    ├── variables.tf




Terraform VPC and EC2 Module for Workspaces Prod and Stage Environment. With Statefile stored securely in AWS S3. 

🚀 GitOps with ArgoCD
	•	Deployed to argocd namespace.
	•	Accessible via ALB/Ingress configured in k8s-argocd.tf.
	•	Port-forward locally:

To access Nexus Password: docker exec nexus cat /nexus-data/admin.password
nohup kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443 > argo-portforward.log 2>&1 &

#######
