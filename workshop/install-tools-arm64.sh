#!/bin/bash

set -e  # Exit immediately on error

echo "🚀 Installing Kubernetes & DevSecOps tools for Kali Linux ARM64"

# Ensure /usr/local/bin exists and is writable
mkdir -p /usr/local/bin

# Define architecture
ARCH="linux_arm64"
BIN_DIR="/usr/local/bin"

# ========== System Packages ==========
echo "📦 Installing system dependencies..."
sudo apt update && sudo apt install -y jq curl wget unzip tar gnupg2 libnss3-tools

# ========== Docker ==========
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh

# ========== kubectl ==========
echo "📦 Installing kubectl..."
sudo apt install kubectl

# ========== kind ==========
echo "📦 Installing kind..."
curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-arm64
chmod +x kind && sudo mv kind $BIN_DIR/

# ========== kustomize ==========
echo "📦 Installing kustomize..."
sudo apt install kustomize

# ========== k9s ==========
echo "📦 Installing k9s..."
curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_arm64.tar.gz
tar -xzf k9s_Linux_arm64.tar.gz
chmod +x k9s && sudo mv k9s $BIN_DIR/

# ========== mkcert ==========
echo "🔐 Installing mkcert..."
sudo apt install mkcert

# ========== kube-bench ==========
echo "🔍 Installing kube-bench..."
KB_URL=$(curl -s https://api.github.com/repos/aquasecurity/kube-bench/releases/latest \
 | grep browser_download_url | grep "$ARCH.tar.gz" | grep "linux" | head -n1 | cut -d '"' -f 4)
curl -LO "$KB_URL"
tar -xzf kube-bench_*_linux_arm64.tar.gz
chmod +x kube-bench && sudo mv kube-bench $BIN_DIR/

# ========== kube-hunter ==========
echo "🔍 Installing kube-hunter..."
pip install --no-cache-dir kube-hunter

# ========== kube-linter ==========
echo "🧼 Installing kube-linter..."
KL_URL=$(curl -s https://api.github.com/repos/stackrox/kube-linter/releases/latest \
 | grep browser_download_url | grep "$ARCH" | grep -v ".tar.gz" | grep -v ".sig" | cut -d '"' -f 4)
curl -LO "$KL_URL"
chmod +x kube-linter-linux_arm64 && sudo mv kube-linter-linux_arm64 $BIN_DIR/kube-linter

# ========== terrascan ==========
echo "🔍 Installing terrascan..."
TS_URL=$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest \
 | grep browser_download_url | grep "Linux_arm64.tar.gz" | head -n1 | cut -d '"' -f 4)
curl -LO "$TS_URL"
tar -xzf terrascan_*.tar.gz
chmod +x terrascan && sudo mv terrascan $BIN_DIR/

# ========== kubeaudit ==========
echo "🔐 Installing kubeaudit..."
KA_URL=$(curl -s https://api.github.com/repos/Shopify/kubeaudit/releases/latest \
 | grep browser_download_url | grep "linux_arm64.tar.gz" | cut -d '"' -f 4)
curl -LO "$KA_URL"
tar -xzf kubeaudit_*_linux_arm64.tar.gz
chmod +x kubeaudit && sudo mv kubeaudit $BIN_DIR/

# ========== nuclei ==========
echo "🧨 Installing nuclei..."
sudo apt install nuclei

# ========== Clean Up ==========
echo "🧹 Cleaning up leftover files..."
rm -f *.tar.gz *.zip *linux_arm64 kubeaudit kube-linter terrascan kube-bench k9s kustomize nuclei
rm -rf __MACOSX

echo "✅ All tools installed and ready on Kali ARM64!"
echo "⚠️ Please restart your terminal or run 'newgrp docker' if Docker was just installed."