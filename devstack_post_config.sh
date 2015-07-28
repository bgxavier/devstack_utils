. /opt/devstack/openrc admin admin

nova quota-class-update --instances -1 --cores -1 --ram -1 --fixed-ips -1 --floating-ips -1 default
nova flavor-create --ephemeral 0  m1.micro 6 512 4 1
nova-manage service disable --host=controller --service=nova-compute 
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

glance image-create --name “osv-tomcat” --is-public True --disk-format qcow2 --container-format bare --file /opt/images/osv-tomcat-resized.qcow2

glance image-create --name “osv-tomcat” --is-public True --disk-format qcow2 --container-format bare --file /opt/images/ubuntu-tomcat.qcow2

sudo cp /opt/devstack_utils/controller/etc/neutron/api-paste.ini /etc/neutron/
