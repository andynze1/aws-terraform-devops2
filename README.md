# 🌐 AWS Cloud Infrastructure with Terraform, EKS, GitOps, Monitoring & Jenkins

This Terraform project provisions a complete AWS infrastructure stack including:

- 🔧 Amazon EKS cluster (managed node groups, addons)
- 🚀 Optional GitOps with ArgoCD
- 📊 Optional Monitoring with Prometheus & Grafana
- ⚙️ Optional Jenkins deployment on EC2
- 🗂️ StorageClasses (EBS CSI)
- 🔐 IAM via IRSA (ALB Controller, Autoscaler)
- 🌐 VPC, subnets, and security groups (NAT toggle)
- 🧪 Example apps (NGINX, Echo Server)

---

## 📦 Components

### ✅ Core (root) stack
- `main.tf`, `variables.tf`, `outputs.tf`: VPC + EKS only.
- `provider.tf`, `s3-backend.tf`: Cloud provider + remote backend (S3).
- Deploys a VPC, subnets, optional NAT, and an EKS cluster with managed addons.

### ☸️ Kubernetes Cluster
- `modules/eks-module/main.tf`: EKS cluster and node groups.
- `modules/eks-module/aws-helm-lb-controller.tf`: IRSA + Helm for AWS LB Controller (optional).
- `modules/eks-module/iam-autoscaler.tf`: IRSA for Cluster Autoscaler (optional).
- `modules/eks-module/kubeconfig-update.tf`: Optional local kubeconfig update and API readiness wait.

### 📊 Monitoring Stack (independent)
- Folder: `stacks/monitoring`
- Module: `modules/monitoring-module`
- Installs Prometheus & Grafana via Helm. Grafana is exposed as `ClusterIP` by default (no external LB).

### 🚀 GitOps with ArgoCD (independent)
- Folder: `stacks/argocd`
- Module: `modules/argocd-module`
- ArgoCD server is exposed via `Service type: LoadBalancer` and outputs the external hostname/URL.

### 🌐 Networking
- `modules/eks-module/namespace.tf`: Defines the `dev` namespace.
- `modules/vpc-module/main.tf`: VPC, subnets, routes, NAT (gated), SGs.

### 📡 Example Applications
- `examples/k8s/echoserver.yaml`: Basic echo service with ALB ingress.
- `examples/k8s/nginx.yaml`: Multi-replica nginx deployment.

---

## 🛠 Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- `kubectl` configured for EKS
- `helm` for Helm chart deployments
- Valid AWS IAM credentials with permission to create infrastructure

---

## ☸️ Kubernetes Cluster with EKS

Provisioned with `terraform-aws-modules/eks` in `modules/eks-module/main.tf`.

Highlights:
- Managed node groups with configurable size and instance types.
- Managed Addons: vpc-cni, coredns, kube-proxy, aws-ebs-csi-driver.
- IRSA for AWS LB Controller and (optionally) Cluster Autoscaler.
- Default Kubernetes version: `1.33` (override via `cluster_version`).
- Optional local kubeconfig update: set `enable_kubeconfig_update = true` in the root module call to run `aws eks update-kubeconfig` and wait for API readiness.

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

📊 Monitoring Stack (optional)

Enable with `enable_monitoring = true`.
- Prometheus + Grafana installed via Helm.
- Grafana dashboards loaded via ConfigMaps in `monitoring` namespace.

⸻

🧪 Sample Applications

Echoserver
	•	K8s service with ALB ingress
	•	Accessible at: echo.devopsbyexample.io

NGINX
	•	4 replica deployment with ClusterIP service

⸻

🌐 Networking
	•	VPC, subnets, route tables, and optional NAT via `modules/vpc-module`.
	•	Cost-saving: `vpc_enable_nat_gateway = false` by default (no NAT charges).
	•	Training-friendly: when NAT is disabled, nodes are placed in public subnets automatically.

⸻

📦 Storage
	•	storage-class.yaml and prometheus-stoageclass.yaml define gp2 storage classes.
	•	Separate classes for monitoring workloads and general use.

⸻

🔐 IAM & Autoscaling
	•	IAM roles defined in:
	•	iam-roles.tf: For EKS nodes and workloads.
	•	iam-autoscaler.tf: Cluster Autoscaler support.

## 🚀 How to Apply (by stack)

Root (VPC + EKS)
- cd .
- terraform init -upgrade
- terraform apply
- Optional: add to `module "eks-module"` in `main.tf`:
  - `enable_kubeconfig_update = true`

ArgoCD (independent)
- cd stacks/argocd
- terraform init
- terraform apply
- Outputs: `argocd_url`, `argocd_lb_hostname`

Monitoring (Prometheus + Grafana, independent)
- cd stacks/monitoring
- terraform init
- terraform apply
- Grafana is `ClusterIP` (no LB). Port-forward locally:
  - `kubectl -n monitoring port-forward svc/grafana 3000:80`
  - Open http://localhost:3000

Jenkins (independent)
- cd stacks/jenkins
- terraform init
- terraform apply
- Outputs: `public_ip`


🔐 Remote State Management

Remote state via S3 backend (see `s3-backend.tf`). For workspaces, prefer workspace-aware keys and DynamoDB locking via `-backend-config` at `terraform init` time.

⸻

📤 Outputs (root)

Key outputs:
- `eks_cluster_name`, `eks_cluster_endpoint`, `eks_cluster_id`
- `oidc_issuer_url` (for IRSA)
- `aws_load_balancer_controller_role_arn` (when enabled)
- `node_subnet_type` and `node_subnet_ids` (public vs private and the chosen IDs)


**📁 Directory Structure**
    ├── modules/
    │   ├── eks-module/                 # EKS cluster & addons (Helm IRSA, monitoring, gitops)
    │   ├── vpc-module/                 # VPC, subnets, routes, SGs (NAT toggle)
    │   └── jenkins-module/             # Optional EC2/Jenkins
    ├── examples/
    │   └── k8s/                        # Example Kubernetes manifests (not managed by TF)
    ├── main.tf                   # Root stack: VPC + EKS only
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf
    ├── s3-backend.tf
    ├── stacks/
    │   ├── argocd/               # Independent ArgoCD stack
    │   ├── monitoring/           # Independent Monitoring stack
    │   └── jenkins/              # Independent Jenkins stack
    └── README.md




Terraform VPC and EC2 Module for Workspaces Prod and Stage Environment. With Statefile stored securely in AWS S3. 

### Feature Flags (EKS module)
- `enable_aws_load_balancer_controller` (default: true)
- `enable_cluster_autoscaler` (default: false)
- `enable_kubeconfig_update` (default: false)

### Cost-Saving & Node Placement
- `vpc_enable_nat_gateway` (root var, default: false): disables NAT to avoid hourly charges.
- When NAT is disabled, nodes automatically use public subnets for internet access.
- To force placement, set `use_public_subnets_for_nodes` in the EKS module call.
- Monitoring uses `ClusterIP` for Grafana to avoid extra LBs.
