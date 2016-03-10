glance image-create --name "bxavier/activemq" --is-public True --disk-format raw --container-format docker --file /opt/docker_images/shared_base_image/bxavier_activemq

glance image-create --name "bxavier/haproxy" --is-public True --disk-format raw --container-format docker --file /opt/docker_images/shared_base_image/bxavier_haproxy

glance image-create --name "bxavier/memcached" --is-public True --disk-format raw --container-format docker --file /opt/docker_images/shared_base_image/bxavier_memcached

glance image-create --name "bxavier/redis" --is-public True --disk-format raw --container-format docker --file /opt/docker_images/shared_base_image/bxavier_redis

glance image-create --name "bxavier/tomcat" --is-public True --disk-format raw --container-format docker --file /opt/docker_images/shared_base_image/bxavier_tomcat

