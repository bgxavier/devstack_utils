glance image-create --name "apache-spark" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/apache-spark/apache-spark.qemu

glance image-create --name "apache-zookeeper" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/apache-zookeeper/apache-zookeeper.qemu

glance image-create --name "solr" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/solr/solr.qemu

glance image-create --name "cassandra" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/cassandra/cassandra.qemu

glance image-create --name "haproxy" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/haproxy/haproxy.qemu

glance image-create --name "memcached" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/memcached/memcached.qemu

glance image-create --name mysql41 --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/mysql41/mysql41.qemu

glance image-create --name "redis-memonly" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/redis-memonly/redis-memonly.qemu

glance image-create --name "apache-activemq" --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/apache-activemq/apache-activemq.qemu

glance image-create --name tomcat --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/tomcat/tomcat.qemu


glance_unikernel.sh git@10.32.45.217:/opt/git/apache-activemq
glance_unikernel.sh git@10.32.45.217:/opt/git/apache-spark
glance_unikernel.sh git@10.32.45.217:/opt/git/apache-zookeeper
glance_unikernel.sh git@10.32.45.217:/opt/git/cassandra
glance_unikernel.sh git@10.32.45.217:/opt/git/haproxy
glance_unikernel.sh git@10.32.45.217:/opt/git/memcached
glance_unikernel.sh git@10.32.45.217:/opt/git/mysql41
glance_unikernel.sh git@10.32.45.217:/opt/git/redis-memonly
glance_unikernel.sh git@10.32.45.217:/opt/git/solr
glance_unikernel.sh git@10.32.45.217:/opt/git/tomcat
