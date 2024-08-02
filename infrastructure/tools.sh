#!/bin/bash

set -e # exit script when the first error occurs

exec >> /var/log/init-script.log 2>&1 # log all outputs to specified file

echo "Starting installation script..."

echo "Updating system..."
sudo apt-get update -y # system update

# AWS CLI installation
echo "Installing AWS CLI..."
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sleep 30

# Terraform installation
echo "Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install terraform -y

# Docker installation
echo "Installing Docker..."
sudo apt-get install docker.io -y
sudo usermod -aG docker ubuntu
sudo systemctl enable --now docker 

sleep 30 # wait for Docker to init

# AWS Configure setup
aws configure set default.region eu-north-1
aws configure set default.output json

# EKSctl installation
echo "Installing EKSctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Kubectl installation
echo "Installing Kubectl..."
sudo apt-get install curl -y
sudo curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
sleep 30

# Ensure .kube directory exists
mkdir -p /home/ubuntu/.kube

# Update kubeconfig to connect to EKS cluster
echo "Updating kubeconfig to connect to EKS cluster..."
aws eks update-kubeconfig --region eu-north-1 --name cointracker-cluster --kubeconfig /home/ubuntu/.kube/config
sleep 10

# Verify kubeconfig file exists
if [ ! -f /home/ubuntu/.kube/config ]; then
    echo "Kubeconfig file not found!"
    exit 1
fi

# Set KUBECONFIG environment variable
export KUBECONFIG=/home/ubuntu/.kube/config

# Verify kubectl is configured correctly
echo "Verifying kubectl configuration..."
kubectl config get-contexts
kubectl config use-context arn:aws:eks:eu-north-1:376801182676:cluster/cointracker-cluster || { echo "Context not found"; exit 1; }
sleep 30

# ArgoCD installation
echo "Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
sudo apt-get install jq -y
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# Helm installation
echo "Installing Helm..."
sudo snap install helm --classic

# Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Trivy installation
echo "Installing Trivy..."
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

# Prometheus installation
echo "Installing Prometheus..."
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

# Grafana installation
echo "Installing Grafana..."
helm install grafana grafana/grafana --namespace monitoring --create-namespace

# ingress-nginx installation
echo "Installing NGINX..."
helm install ingress-nginx ingress-nginx/ingress-nginx

echo "Installation completed without errors."




