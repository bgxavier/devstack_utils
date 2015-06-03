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

cat << EOT > local.conf
[[local|localrc]]

HOST_IP=10.32.45.201

FLAT_INTERFACE=em2
FIXED_RANGE=192.168.0.0/24
FIXED_NETWORK_SIZE=128
FLOATING_RANGE=192.168.0.128/25
MULTI_HOST=1
LOGFILE=/opt/stack/logs/stack.sh.log

ADMIN_PASSWORD=password
MYSQL_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=tokentoken

enable_service ceilometer-acompute ceilometer-acentral ceilometer-anotification ceilometer-collector ceilometer-alarm-evaluator ceilometer-alarm-notifier ceilometer-api
enable_service heat h-api h-api-cfn h-api-cw h-eng

CEILOMETER_NOTIFICATION_TOPICS=notifications,profiler

RECLONE=yes

BRANCH=stable/kilo

REQUIREMENTS_BRANCH=$BRANCH
CINDER_BRANCH=$BRANCH
HEAT_BRANCH=$BRANCH
CEILOMETER_BRANCH=$BRANCH

GLANCE_REPO=https://github.com/bgxavier/glance.git
GLANCE_BRANCH=osprofile

HORIZON_BRANCH=$BRANCH
KEYSTONE_BRANCH=$BRANCH
KEYSTONECLIENT_BRANCH=$BRANCH

NOVA_REPO=https://github.com/bgxavier/nova.git
NOVA_BRANCH=osprofile

LIBS_FROM_GIT=python-novaclient
NOVACLIENT_BRANCH=osprofile
NOVACLIENT_REPO=https://github.com/bgxavier/python-novaclient.git

NEUTRON_BRANCH=$BRANCH
SWIFT_BRANCH=$BRANCH

EOT
