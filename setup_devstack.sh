BRANCH=stable/kilo

useradd -m stack
echo "stack	ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "Defaults:stack !requiretty" >> /etc/sudoers
DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update || sudo yum update -qy
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy git || sudo yum install -qy git
cd /home/stack
sudo -u stack git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
git checkout $BRANCH
