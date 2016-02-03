#sudo rm -rfv /opt/stack/data/nova/instances/_base/*
find /opt/stack/data/nova/instances/_base/* -maxdepth 0 -not -name cloudius -exec rm -rf {} \;
sudo rm -rfv /opt/stack/data/unikernel/*
#sudo rm -rfv /opt/stack/data/glance/images/*
