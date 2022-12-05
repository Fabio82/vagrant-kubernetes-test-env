# vagrant-kubernetes-test-env
> Create a kubernetes cluster with kubeadm on virtualbox with Vagrant. It uses ``containerd`` and ``calico``

## Installation and configuration:

You need Vagrant and virtualbox. For example on my machine these versions are installed:
```sh
fabio@BMO:~/code/vagrant-kubernetes-test-env$ git --version
git version 2.34.1

fabio@BMO:~/code/vagrant-kubernetes-test-env$ vagrant --version
Vagrant 2.2.19

fabio@BMO:~/code/vagrant-kubernetes-test-env$ VBoxManage --version
6.1.38_Ubuntur153438
```
* **git clone this repo**
```sh
git clone https://github.com/Fabio82/vagrant-kubernetes-test-env.git
cd vagrant-kubernetes-test-env
```

* **Edit Vagrantfile**
Here you can chose version of software components ...

```ruby
K8S_VERSION="1.25.4-00"
CONTAINERD_VERSION="1.6.10"
RUNC_VERSION="1.1.4"
CNI_PLUGIN_VERSION="1.1.1"
POD_CIDR="10.255.0.0/16"
```

... and hostnames/IP for the cluster nodes. Restrictions are that you must chose a hostname that contains the word ``"master"`` (yes I know, it has to be changed, perhaps in the feauture ...) 
but for worker nodes there are none. 
Ip addresses have to be chosen accordingly to the private address space of your Vagrant installation.
Avoid any ip that finish with ``.1`` because it's generally taken by the router of the virtual network.

```ruby
cluster_nodes = { 
    "master-foo" => "192.168.56.11", 
    "foo-01" => "192.168.56.12",
    "bar-02" => "192.168.56.13"
  }
```

## Usage:

```sh
vagrant up
```

  wait untill all the nodes are up and then:
  
```sh
export KUBECONFIG=kubeconfig.yaml
```

 
```sh
kubectl get nodes
NAME         STATUS   ROLES           AGE    VERSION
bar-02       Ready    <none>          12s    v1.25.4 
foo-01       Ready    <none>          76s    v1.25.4
master-foo   Ready    control-plane   172m   v1.25.4
```
