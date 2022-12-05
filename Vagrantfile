# -*- mode: ruby -*-
# vi: set ft=ruby :

K8S_VERSION="1.25.4-00"
CONTAINERD_VERSION="1.6.10"
RUNC_VERSION="1.1.4"
CNI_PLUGIN_VERSION="1.1.1"
POD_CIDR="10.255.0.0/16"

cluster_nodes = { 
    "master-foo" => "192.168.56.11", 
    "foo-01" => "192.168.56.12",
    "bar-02" => "192.168.56.13"
  }

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.provision "shell",  path: "scripts/common.sh", env:{ \
  "K8S_VERSION" => K8S_VERSION, \
  "CONTAINERD_VERSION" => CONTAINERD_VERSION, \
  "RUNC_VERSION" => RUNC_VERSION, \
  "CNI_PLUGIN_VERSION" => CNI_PLUGIN_VERSION
  }

  cluster_nodes.each do | hostname, ip |

    # set /etc/hosts file
    config.vm.provision "shell", inline: <<-SHELL
    echo ""#{ip}" "#{hostname}"" >> /etc/hosts
    SHELL
    
    if "#{hostname}".include? "master"
      config.vm.define "#{hostname}" do |master|
        master.vm.provision "shell", path: "scripts/master.sh", env: { \
        "MASTER_NODENAME" => "#{hostname}", \
        "MASTER_IP" => "#{ip}", \
        "POD_CIDR" => POD_CIDR \
        }
        master.vm.network "private_network", ip: "#{ip}"
        master.vm.provider "virtualbox" do |v|
          v.memory = 4048
          v.cpus = 2      
        end
      end
    
    else
      config.vm.define "#{hostname}" do |worker|
        worker.vm.hostname = "#{hostname}"
        worker.vm.network "private_network", ip: "#{ip}"
        worker.vm.provision "shell", path: "scripts/worker.sh"
        worker.vm.provider "virtualbox" do |v|
          v.memory = 2048
          v.cpus = 2
        end
      end

    end
  end
end