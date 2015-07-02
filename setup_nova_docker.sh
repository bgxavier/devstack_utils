sudo apt-get update
sudo apt-get install -y python-pip python-dev

rm -rf /opt/stack/nova-docker
sudo mkdir -p /opt/stack
sudo git clone https://git.openstack.org/stackforge/nova-docker /opt/stack/nova-docker
cd /opt/stack/nova-docker
# Check out a different version if not using master, i.e:
# sudo git checkout stable/kilo && sudo git pull --ff-only origin stable/kilo
sudo pip install .
[ -d /etc/nova ] || mkdir /etc/nova
sudo cp etc/nova/rootwrap.d/docker.filters \
  /etc/nova/rootwrap.d/
