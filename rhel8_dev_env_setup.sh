#!/usr/bin/env bash

#docker repo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#update yum repos
yum clean all
rm -rf /var/cache/yum
yum makecache
yum update -y

#install development tools
yum groupinstall "Development Tools" -y

#install pre-reqisites
yum -y install gcc python3 python3-devel jq wget tar git vim nano curl less libffi-devel zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel yum-utils device-mapper-persistent-data lvm2 curl-devel expat-devel gettext-devel zlib-devel perl-ExtUtils-MakeMaker

#remove old version of git
yum erase git -y

#install git from source
mkdir -p /usr/src/git-2.26.2
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.2.tar.gz -O /usr/src/git-2.26.2.tar.gz
cd /usr/src/ && tar xzf /usr/src/git-2.26.2.tar.gz --strip 1 -C /usr/src/git-2.26.2
cd /usr/src/git-2.26.2 && make prefix=/usr/local/git all ; cd /usr/src/git-2.26.2 && make prefix=/usr/local/git install
rm -rf /usr/bin/git
ln -s /usr/local/git/bin/git /usr/bin/git
echo "export PATH=$PATH:/usr/local/git/bin/" >> /etc/profile
source /etc/profile
echo "export PATH=$PATH:/usr/local/git/bin/" >> ~/.bash_profile
source ~/.bash_profile

#install, configure, enable & start docker-ce
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y
yum -y install docker-ce docker-ce-cli
mkdir -p /etc/docker/
cat >> /etc/docker/daemon.json <<EOL
{
  "storage-driver": "overlay2"
}
EOL
systemctl start docker && systemctl enable docker
usermod -a -G docker ec2-user
newgrp docker


#install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#Install & Configure ChefDK
cd /usr/src
wget https://packages.chef.io/files/stable/chefdk/4.7.73/el/8/chefdk-4.7.73-1.el7.x86_64.rpm

rpm -Uvh /usr/src/chefdk-4.7.73-1.el7.x86_64.rpm

echo 'eval "$(chef shell-init bash)"' >> /etc/profile

echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> /etc/profile
source /etc/profile

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile

echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#Install Go
yum module -y install go-toolset


#Install pyenv
git clone https://github.com/pyenv/pyenv.git /usr/src/.pyenv

sleep 5

echo 'export PYENV_ROOT="/usr/src/.pyenv"' >> /etc/profile

echo 'export PATH="/usr/src/.pyenv/bin:$PATH"' >> /etc/profile

echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> /etc/profile

source /etc/profile

echo 'export PYENV_ROOT="/usr/src/.pyenv"' >> ~/.bash_profile

echo 'export PATH="/usr/src/.pyenv/bin:$PATH"' >> ~/.bash_profile

echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

source ~/.bash_profile

#Install latest python3
/usr/src/.pyenv/bin/pyenv install 3.8.3

/usr/src/.pyenv/bin/pyenv install 2.7.18

pyenv init

pyenv shell 2.7.18 3.8.3

#Install required Python packages

pip install --upgrade pip

pip install wheel

pip install ansible boto boto3 tox pypsrp pywinrm requests-credssp requests-ntlm awscli aws-cfn-bootstrap

#Install latest version of Packer
rm -f /usr/sbin/packer
export PACKER_URL="https://releases.hashicorp.com/packer/1.5.6/packer_1.5.6_linux_amd64.zip"

export PACKER_SHA256="2abb95dc3a5fcfb9bf10ced8e0dd51d2a9e6582a1de1cab8ccec650101c1f9df"

curl -fsSL "$PACKER_URL" -o /packer.zip \
  && echo "$PACKER_SHA256 /packer.zip" | sha256sum -c - \
  && gunzip -c -S zip /packer.zip >/usr/local/bin/packer \
  && chmod 755 /usr/local/bin/packer \
  && rm -f /packer.zip

echo 'export PATH=/usr/local/bin/:$PATH' >> /etc/profile
source /etc/profile

echo 'export PATH=/usr/local/bin/:$PATH' >> ~/.bash_profile
source ~/.bash_profile

#Install latest version of Terraform
cd /usr/src
curl -O https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
unzip terraform_0.12.25_linux_amd64.zip
cp terraform /usr/bin/terraform

#Install NodeJS - pre-requisite for Cloud9
mkdir -p /usr/src/local/lib/nodejs
cd /usr/src && curl -O https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.xz
cd /usr/src && tar -xJf node-v12.16.3-linux-x64.tar.xz -C /usr/src/local/lib/nodejs --strip 1
chmod +x /usr/src/local/lib/nodejs/bin/node
echo 'export PATH=/usr/src/local/lib/nodejs/bin/:$PATH' >> /etc/profile
source /etc/profile

echo 'export PATH=/usr/src/local/lib/nodejs/bin/:$PATH' >> ~/.bash_profile
source ~/.bash_profile


echo "$(tput setaf 7)###############Installed Development Tools Details:################# $(tput sgr 0)"
echo "$(tput setaf 2)`git --version`$(tput sgr 0)"
echo "$(tput setaf 2)`python -V`$(tput sgr 0)"
echo "$(tput setaf 2)`chef --version`$(tput sgr 0)"
echo "$(tput setaf 2)`go version`$(tput sgr 0)"
echo "$(tput setaf 2)`terraform --version`$(tput sgr 0)"
echo "$(tput setaf 2)`docker --version`$(tput sgr 0)"
echo "$(tput setaf 2)`docker-compose --version`$(tput sgr 0)"
echo "$(tput setaf 2)packer:`packer --version`$(tput sgr 0)"
echo "$(tput setaf 2)`ansible --version`$(tput sgr 0)"
echo "$(tput setaf 2)NODEJS:`node --version`$(tput sgr 0)"
