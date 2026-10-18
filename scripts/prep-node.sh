#!/usr/bin/env bash
set -euo pipefail
K8S_MINOR="v1.33"

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

printf "overlay\nbr_netfilter\nnvme_tcp\n" | sudo tee /etc/modules-load.d/k8s-mayastor.conf >/dev/null
sudo modprobe overlay; sudo modprobe br_netfilter; sudo modprobe nvme_tcp

sudo tee /etc/sysctl.d/99-k8s-mayastor.conf >/dev/null <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
vm.nr_hugepages = 1024
EOF
sudo sysctl --system >/dev/null

sudo apt-get update
sudo apt-get install -y containerd apt-transport-https ca-certificates curl gpg
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo sed -i 's/device_ownership_from_security_context = false/device_ownership_from_security_context = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_MINOR}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet
echo "Prep done. Reboot now."
