#!/bin/bash
set -euxo pipefail

kubeadm config images pull

kubeadm init \
--apiserver-advertise-address=$MASTER_IP \
--apiserver-cert-extra-sans=$MASTER_IP \
--pod-network-cidr=$POD_CIDR \
--node-name "$MASTER_NODENAME" \
--ignore-preflight-errors Swap \
| tee -a /vagrant/kubeadm-init.out

export KUBECONFIG=/etc/kubernetes/admin.conf
cp $KUBECONFIG /vagrant/kubeconfig.yaml

echo "downloading calico manifest"
wget https://docs.projectcalico.org/manifests/calico.yaml
kubectl create -f calico.yaml

echo  "creating join command for worker nodes"
kubeadm token create --print-join-command > /vagrant/scripts/join.sh
chmod +x /vagrant/scripts/join.sh

# Initially I thinked about join others control plane nodes, I leave commented for future developments ...
#echo  "creating join command for control plane nodes"
#echo `kubeadm token create --print-join-command` --control-plane  --certificate-key \"`kubeadm certs certificate-key`\" > /vagrant/scripts/join-master.sh
#chmod +x /vagrant/scripts/join-master.sh
