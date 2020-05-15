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
mkdir -p $HOME/src/git-2.26.2
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.2.tar.gz -O $HOME/src/git-2.26.2.tar.gz
cd $HOME/src/ && tar xzf $HOME/src/git-2.26.2.tar.gz --strip 1 -C $HOME/src/git-2.26.2
cd $HOME/src/git-2.26.2 && make prefix=/usr/local/git all ; cd $HOME/src/git-2.26.2 && make prefix=/usr/local/git install
rm -rf /usr/bin/git
ln -s /usr/local/git/bin/git /usr/bin/git
echo "export PATH=$PATH:/usr/local/git/bin/" >> ~/.bash_profile
source ~/.bash_profile

#install, configure, enable & start docker-ce
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y
yum -y install docker-ce docker-ce-cli
systemctl start docker && systemctl enable docker
usermod -a -G docker ec2-user
newgrp docker


#install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#Install & Configure ChefDK
cd $HOME/src
wget https://packages.chef.io/files/stable/chefdk/4.7.73/el/8/chefdk-4.7.73-1.el7.x86_64.rpm

rpm -Uvh $HOME/src/chefdk-4.7.73-1.el7.x86_64.rpm

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile

echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#Install Go
yum module -y install go-toolset

#Install pyenv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

pid=$!
wait $pid

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile

echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile

echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

source ~/.bash_profile

#Install latest python3
$HOME/.pyenv/bin/pyenv install 3.8.2

$HOME/.pyenv/bin/pyenv global 3.8.2

$HOME/.pyenv/bin/pyenv shell 3.8.2


#Install required Python packages

python3 -m pip install --upgrade pip

python3 -m pip install wheel

python3 -m pip install ansible boto boto3 tox pypsrp pywinrm requests-credssp requests-ntlm awscli

#Install latest version of Packer
mkdir -p $HOME/src/github.com/hashicorp && cd $_
git clone https://github.com/hashicorp/packer.git
pid=$!
wait $pid
cd $HOME/src/github.com/hashicorp/packer && make dev
chmod +x $HOME/src/github.com/hashicorp/packer/bin/packer
ln -s $HOME/src/github.com/hashicorp/packer/bin/packer /usr/bin/packer

#Install latest version of Terraform
cd $HOME/src
curl -O https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
unzip terraform_0.12.25_linux_amd64.zip
cp terraform /usr/bin/terraform

#Install NodeJS - pre-requisite for Cloud9
cd $HOME/src
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
pid=$!
wait $pid
cat >> nodejs_export.txt <<EOL
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOL


cat nodejs_export.txt >> ~/.bash_profile
source ~/.bash_profile
nvm install node

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
