#!/usr/bin/env bash

#docker repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#update yum repos
sudo yum clean all
sudo rm -rf /var/cache/yum
sudo yum makecache
sudo yum update -y

#install development tools
sudo yum groupinstall "Development Tools" -y

#install pre-reqisites
sudo yum -y install gcc python3 python3-devel jq wget tar git vim nano curl less libffi-devel zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel yum-utils device-mapper-persistent-data lvm2 curl-devel expat-devel gettext-devel zlib-devel perl-ExtUtils-MakeMaker

#remove old version of git
sudo yum erase git -y

#install git from source
sudo mkdir -p $HOME/src/git-2.26.2
sudo wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.2.tar.gz -O $HOME/src/git-2.26.2.tar.gz
sudo cd $HOME/src/ && sudo tar xzf $HOME/src/git-2.26.2.tar.gz --strip 1 -C $HOME/src/git-2.26.2
sudo cd $HOME/src/git-2.26.2 && sudo make prefix=/usr/local/git all ; cd $HOME/src/git-2.26.2 && sudo make prefix=/usr/local/git install
sudo rm -rf /usr/bin/git
sudo ln -s /usr/local/git/bin/git /usr/bin/git
echo "export PATH=$PATH:/usr/local/git/bin/" >> ~/.bash_profile
source ~/.bash_profile

#install, configure, enable & start docker-ce
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y
sudo yum -y install docker-ce docker-ce-cli
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

#install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Install & Configure ChefDK
cd $HOME/src
sudo wget https://packages.chef.io/files/stable/chefdk/4.7.73/el/8/chefdk-4.7.73-1.el7.x86_64.rpm

sudo rpm -Uvh $HOME/src/chefdk-4.7.73-1.el7.x86_64.rpm

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile

echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#Install Go
sudo yum module -y install go-toolset

#Install pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv && echo "cloned"

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile

echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile

echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

source ~/.bash_profile

#Install latest python3
pyenv install 3.8.2

pyenv global 3.8.2

pyenv shell 3.8.2


#Install required Python packages

python3 -m pip install --upgrade pip
sudo python3 -m pip install --upgrade pip

python3 -m pip install wheel
sudo python3 -m pip install wheel

python3 -m pip install ansible boto boto3 tox pypsrp pywinrm requests-credssp requests-ntlm awscli
sudo python3 -m pip install ansible boto boto3 tox pypsrp pywinrm requests-credssp requests-ntlm awscli

#Install latest version of Packer
sudo mkdir -p $HOME/src/github.com/hashicorp && cd $_
sudo git clone https://github.com/hashicorp/packer.git && echo "cloned"
cd $HOME/src/github.com/hashicorp/packer && sudo make dev
sudo chmod +x $HOME/src/github.com/hashicorp/packer/bin/packer
sudo ln -s $HOME/src/github.com/hashicorp/packer/bin/packer /usr/bin/packer

#Install latest version of Terraform
cd $HOME/src
sudo curl -O https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
sudo unzip terraform_0.12.25_linux_amd64.zip
sudo cp terraform /usr/bin/terraform

#Install NodeJS - pre-requisite for Cloud9
cd $HOME/src
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && echo "nvm installed"
cat >> nodejs_export.txt <<EOL
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOL
cat nodejs_export.txt >> ~/.bash_profile
source ~/.bash_profile
sudo nvm install node


echo "$(tput setaf 7)###############Installed Development Tools Details:################# $(tput sgr 0)"
echo "$(tput setaf 2)`git --version`$(tput sgr 0)"
echo "$(tput setaf 2)`python -V`$(tput sgr 0)"
echo "$(tput setaf 2)`chef --version`$(tput sgr 0)"
echo "$(tput setaf 2)`go version`$(tput sgr 0)"
echo "$(tput setaf 2)`terraform --version`$(tput sgr 0)"
echo "$(tput setaf 2)`docker --version`$(tput sgr 0)"
echo "$(tput setaf 2)`docker-compose --version`$(tput sgr 0)"
echo "$(tput setaf 2)PACKER `packer --version`$(tput sgr 0)"
echo "$(tput setaf 2)`ansible --version`$(tput sgr 0)"
echo "$(tput setaf 2)NODEJS `node --version`$(tput sgr 0)"
