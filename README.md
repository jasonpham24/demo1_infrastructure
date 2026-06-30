# Demo1 Infrastructure

A comprehensive infrastructure-as-code (IaC) project using **Terraform** and **Ansible** to build, deploy, and manage modern application stacks on AWS.

## 📋 Overview

Demo1 Infrastructure provides a complete automated infrastructure solution, including:

- **Compute**: EC2 instance running Ubuntu 22.04
- **Database**: RDS PostgreSQL for data storage
- **Monitoring**: Prometheus & Grafana for system monitoring
- **Automation**: N8N for workflow automation
- **Reverse Proxy**: Nginx configured as a subdomain-based reverse proxy for services
- **CDN**: CloudFront + S3 for static assets
- **DNS**: Cloudflare DNS management
- **Containers**: Docker & Docker Compose for running services

---

## 🛠️ Technologies Used

### Infrastructure & IaC
- **Terraform** (~> 5.0): AWS resource provisioning
- **AWS Services**:
  - EC2 (t3.medium instance)
  - RDS PostgreSQL
  - S3 buckets
  - CloudFront CDN
  - IAM roles & policies
  - Security Groups

### Configuration Management & Deployment
- **Ansible**: Configuration management and deployment automation
- **Docker** & **Docker Compose**: Container orchestration

### Monitoring & Observability
- **Prometheus**: Metrics collection
- **Grafana**: Data visualization
- **Node Exporter**: System metrics

### Application & Services
- **N8N**: Workflow automation engine
- **Nginx**: Reverse proxy & load balancer

### DNS & CDN
- **Cloudflare**: DNS management
- **CloudFront**: AWS CDN

---

## 📁 Project Structure

```
demo1_infrastructure/
├── terraform/                      # IaC using Terraform
│   ├── main.tf                    # Main configuration
│   ├── variables.tf               # Variable definitions
│   ├── outputs.tf                 # Output definitions
│   ├── terraform.tfvars           # Variable values
│   ├── terraform.tfstate          # State file (local)
│   ├── terraform.tfvars.example   # Example variables
│   └── modules/                   # Terraform modules
│       ├── ec2/                   # EC2 instance
│       ├── rds/                   # RDS database
│       ├── s3/                    # S3 bucket
│       ├── cloudfront/            # CloudFront distribution
│       ├── cloudflare/            # Cloudflare DNS
│       ├── iam/                   # IAM roles
│       └── beanstalk/             # Elastic Beanstalk
│
├── ansible/                       # Configuration Management
│   ├── ansible.cfg                # Ansible configuration
│   ├── inventory/
│   │   ├── inventory.ini          # Inventory file
│   │   └── group_vars/
│   │       └── all.yml            # Group variables
│   ├── playbooks/
│   │   └── deploy.yml             # Main deployment playbook
│   └── roles/
│       ├── docker/                # Docker installation
│       ├── monitoring/            # Prometheus & Grafana setup
│       └── nginx/                 # Nginx configuration
│
└── README.md                       # This file
```

---

## 🚀 Installation & Setup

### Prerequisites

- **Terraform** >= 1.0.0
- **Ansible** >= 2.9
- **AWS Account** with configured credentials
- **Git** to clone the repository
- **Docker** (optional, for local testing)

### Step 1: Clone the Repository

```bash
git clone https://github.com/jasonpham24/demo1_infrastructure.git
cd demo1_infrastructure
```

### Step 2: Configure Terraform

#### 2.1 Create `terraform.tfvars` file

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

#### 2.2 Edit `terraform/terraform.tfvars`

```hcl
# AWS Configuration
aws_region    = "region_name"
instance_name = "instance_name_of_ec2"
instance_type = "instance_type_of_ec2"

# SSH Configuration
create_ssh_key   = true
private_key_path = "key.pem"
ssh_user         = "ubuntu"

# Cloudflare Configuration
cloudflare_zone_id        = "YOUR_ZONE_ID"      # Get from Cloudflare
cloudflare_zone           = "example.com"       # Your domain
cloudflare_record_name    = "dns_record_example"             # Subdomain
cloudflare_record_type    = "CNAME"             # or "A"
cloudflare_api_token      = "YOUR_API_TOKEN"    # Cloudflare token
cloudflare_record_proxied = false

# Database
db_password = "YOUR_SECURE_PASSWORD"

# S3 Bucket
bucket_name = "your_bucket_name"

# Elastic Beanstalk
beanstalk_application_name = "example-app"
beanstalk_environment_name = "example-env"
```

#### 2.3 Configure AWS Credentials

Generate Access Key from AWS Console:
1. Go to [AWS IAM Console](https://console.aws.amazon.com/iam/home)
2. Navigate to **Users** → Select your user → **Security credentials**
3. Click **Create access key** and download the credentials

Then configure AWS credentials using the CLI:

```bash
aws configure
```

You will be prompted to enter:
- **AWS Access Key ID**: `your-access-key-id`
- **AWS Secret Access Key**: `your-secret-access-key`
- **Default region name**: `ap-southeast-1`
- **Default output format**: `json` (or leave blank)

Credentials will be saved to `~/.aws/credentials` and `~/.aws/config` files automatically.

### Step 3: Run Terraform

#### 3.1 Initialize Terraform

```bash
cd terraform
terraform init
```

#### 3.2 View Plan

```bash
terraform plan
```

#### 3.3 Apply Configuration

```bash
terraform apply
```

Terraform will:
- Create EC2 instance
- Create RDS database
- Create S3 bucket & CloudFront
- Create IAM roles
- Create DNS record on Cloudflare
- Generate `ansible/inventory/inventory.ini` automatically

### Step 4: Run Ansible

#### 4.1 Verify inventory

```bash
cat ansible/inventory/inventory.ini
```

#### 4.2 Run deployment playbook

```bash
cd ../ansible
ansible-playbook -i inventory/inventory.ini playbooks/deploy.yml
```

Ansible will:
- Install Docker
- Configure Prometheus & Grafana
- Configure Nginx reverse proxy
- Deploy N8N workflow engine
- Start all services

---

## 📊 Accessing Services

After deployment is complete, you can access services via their respective subdomains. Ensure your Cloudflare DNS is correctly configured to point these subdomains to your EC2 instance or CloudFront distribution.

### Via DNS (if Cloudflare configured for subdomains)

- **Grafana**: `http://grafana.<your-domain>`
  - Default: admin / admin

- **Prometheus**: `http://prometheus.<your-domain>`
  - Metrics database

- **N8N**: `http://n8n.<your-domain>`
  - Workflow automation

*Note: Replace `<your-domain>` with the domain configured in your `terraform/terraform.tfvars` (e.g., `example.com`).*

---
## 🔧 Advanced Configuration

### Change Instance Type

Edit `terraform/terraform.tfvars`:

```hcl
instance_type = "t3.large"  # Upgrade from t3.medium
```

Then:
```bash
terraform plan
terraform apply
```

### Change Database Password

```bash
export TF_VAR_db_password="new-password"
terraform apply
```

### Change Region

```hcl
aws_region = "us-east-1"  # Change region
```

Restart entire infrastructure.

---

## 📝 Important Terraform Variables

| Variable | Description | 
|----------|-------------|
| `aws_region` | AWS region |
| `instance_type` | EC2 instance type |
| `cloudflare_zone_id` | Cloudflare Zone ID |
| `cloudflare_record_name` | DNS record name | 
| `db_password` | RDS password | 
| `bucket_name` | S3 bucket name | 

---

## 🧹 Cleanup & Destroy

### Delete entire infrastructure

```bash
cd terraform
terraform destroy
```

> ⚠️ **Warning**: This will delete all AWS resources. Ensure before running.

### Delete state file (reset)

```bash
rm terraform.tfstate terraform.tfstate.backup
```

---

## 🐛 Troubleshooting

### Nginx fails to start (404 error)

**Cause**: Port 80 conflict or misconfiguration.

**Solution**:
```bash
ssh -i key.pem ubuntu@<ec2-public-ip>
sudo systemctl status nginx
sudo nginx -t
```

### N8N database connection fails

**Cause**: Wrong database credentials or RDS not ready.

**Solution**:
```bash
docker logs n8n
```

### Prometheus not collecting metrics

**Cause**: Node Exporter not running or Prometheus misconfigured.

**Solution**:
```bash
docker exec prometheus curl http://node-exporter:9100/metrics
```

---

## 📚 References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Ansible Documentation](https://docs.ansible.com/)
- [Prometheus Setup](https://prometheus.io/docs/prometheus/latest/installation/)
- [Grafana Getting Started](https://grafana.com/docs/grafana/latest/getting-started/)
- [N8N Documentation](https://docs.n8n.io/)



---

## 👤 Author

**Jason Pham**  
GitHub: [@jasonpham24](https://github.com/jasonpham24)

---

## 🤝 Contributing

If you have suggestions or find bugs, please open an **Issue** or **Pull Request** on GitHub.
