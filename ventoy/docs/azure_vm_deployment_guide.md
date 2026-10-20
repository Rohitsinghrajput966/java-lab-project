# shopsphere Production Deployment Guide: Azure Virtual Machine

This guide details the complete process for deploying the **shopsphere Enterprise Platform** to an **Azure Linux Virtual Machine** using **Docker Compose** and automated **GitHub Actions CI/CD**.

---

## 1. Azure Virtual Machine Provisioning

### Recommended Specifications:
- **Cloud Provider:** Microsoft Azure
- **Operating System:** Ubuntu Server 22.04 LTS or 24.04 LTS (x86_64)
- **VM Size:** `Standard_B2s` (2 vCPUs, 4 GiB Memory) or `Standard_D2s_v5`
- **Authentication:** SSH Public Key (`azureuser` or `ubuntu`)
- **OS Disk:** 30 GiB Premium SSD (LRS)

### Network Security Group (NSG) Inbound Port Rules:
Configure the following inbound rules under **Networking > Inbound port rules**:

| Priority | Name | Port Range | Protocol | Source | Action | Purpose |
|---|---|---|---|---|---|---|
| 300 | `Allow-SSH` | `22` | TCP | Any / CI/CD IP | Allow | Secure Remote Shell |
| 310 | `Allow-HTTP` | `80` | TCP | Any (`*`) | Allow | Web Traffic (Nginx) |
| 320 | `Allow-HTTPS` | `443` | TCP | Any (`*`) | Allow | Encrypted Traffic (SSL) |

---

## 2. One-Time Azure VM Server Preparation

Connect to your Azure VM via SSH:
```bash
ssh -i /path/to/private_key.pem azureuser@<YOUR_AZURE_VM_PUBLIC_IP>
```

Run the automated host setup script to install **Docker Engine** and **Docker Compose Plugin**:
```bash
# Update repositories
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Install Docker's official GPG key & repository
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Grant current user permission to run docker without sudo
sudo usermod -aG docker $USER

# Prepare application directory
sudo mkdir -p /opt/shopsphere
sudo chown -R $USER:$USER /opt/shopsphere
```

Log out and re-connect via SSH for the group permissions to take effect:
```bash
docker --version
docker compose version
```

---

## 3. Configuring GitHub Actions CI/CD Secrets

To enable zero-touch continuous deployment, configure the following repository secrets in GitHub:
Navigate to: **Your GitHub Repository > Settings > Secrets and variables > Actions > New repository secret**.

| Secret Name | Example Value | Description |
|---|---|---|
| `AZURE_VM_HOST` | `20.198.120.45` | Public IP or DNS address of your Azure VM |
| `AZURE_VM_USER` | `azureuser` | Admin username of the Azure VM |
| `AZURE_SSH_KEY` | `-----BEGIN OPENSSH PRIVATE KEY...` | Private key corresponding to the VM's authorized key |
| `DB_ROOT_PASSWORD` | `ProductionRootPass#2026` | MySQL root database password |
| `DB_PASSWORD` | `shopsphereSecurePass#2026` | MySQL application user password |

---

## 4. Triggering Deployment

1. **Automatic Deployment:**  
   Every `git push origin main` triggers the workflow `.github/workflows/deploy.yml`.
   - Compiles and runs all JUnit unit tests.
   - Builds the Docker image.
   - Securely connects to your Azure VM via SSH.
   - Starts containers with healthcheck verification.

2. **Manual Trigger:**  
   Go to the **Actions** tab in GitHub > select **shopsphere CI/CD** > click **Run workflow**.

---

## 5. Setting Up Free SSL/HTTPS with Let's Encrypt Certbot

Once your domain name (e.g. `store.yourdomain.com`) points to the Azure VM Public IP:
```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d store.yourdomain.com
```
Certbot will automatically configure HTTPS certificates and set up automatic renewal cron jobs!

