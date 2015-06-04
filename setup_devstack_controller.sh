BRANCH=stable/kilo
STACK_USER=openstack

useradd -m $STACK_USER
#echo "openstack	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
#echo "Defaults:openstack !requiretty" >> /etc/sudoers
DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update || sudo yum update -qy
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy git || sudo yum install -qy git
cd /home/openstack
sudo -u $STACK_USER git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
git checkout $BRANCH

cat << EOT > local.conf
[[local|localrc]]

HOST_IP=10.32.45.201

FLAT_INTERFACE=em2
FIXED_RANGE=192.168.11.128/29
FIXED_NETWORK_SIZE=128
MULTI_HOST=1
LOGFILE=/opt/stack/logs/stack.sh.log

ADMIN_PASSWORD=password
MYSQL_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=tokentoken

STACK_USER=openstack

enable_service ceilometer-acompute ceilometer-acentral ceilometer-anotification ceilometer-collector ceilometer-alarm-evaluator ceilometer-alarm-notifier ceilometer-api
enable_service heat h-api h-api-cfn h-api-cw h-eng

CEILOMETER_NOTIFICATION_TOPICS=notifications,profiler

RECLONE=yes

BRANCH=stable/kilo

GIT_BASE=${GIT_BASE:-https://git.openstack.org}

REQUIREMENTS_REPO=https://github.com/openstack/requirements.git
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
