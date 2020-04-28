#!/usr/bin/env bash

#update yum repos
sudo yum update -y

#remove docker old installs
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine             

#install development tools
sudo yum groupinstall "Development Tools" -y

#install pre-reques
sudo yum install yum-utils device-mapper-persistent-data lvm2 curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker -y

#add docker repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#update yum repos
sudo yum update -y

#install, configure, enable & start docker-ce
sudo yum -y install docker-ce
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker $USER

#remove old version of git
sudo yum remove git -y

#install git from source
sudo wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.2.tar.gz -O /usr/src/git-2.26.2.tar.gz
cd /usr/src/ && sudo tar xzf /usr/src/git-2.26.2.tar.gz
cd /usr/src/git-2.26.2 && sudo make prefix=/usr/local/git all ; cd /usr/src/git-2.26.2 && sudo make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin/" >> ~/.bashrc
source ~/.bashrc

#install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

