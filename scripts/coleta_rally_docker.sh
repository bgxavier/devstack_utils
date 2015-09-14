virt_type=$1
num_instances=$2

IMAGE="ubuntu-teste"

FLAVOR="m1.micro"

OUTPUT_TEMP='osprofiler.txt'
OUTPUT_TIMES='ostimes.csv'
BOOT_JSON_FILE='boot.json'

RALLY="/usr/local/bin/rally"

BOOT_JSON='{"NovaServers.boot_server":[{"args":{"flavor":{"name":"'$FLAVOR'"},"image":{"name":"'$IMAGE'"}},"runner":{"type":"constant","times":'$num_instances',"concurrency":'$num_instances'},"context":{"users":{"tenants":1,"users_per_tenant":1}}}]}'

source /opt/devstack/openrc admin admin

#echo "Cleaning cache.. Ensure you are in COMPUTE NODE"

#sudo rm -f /opt/stack/data/nova/instances/_base/* 

#docker stop $(docker ps -a -q) > /dev/null 2>&1 
#docker rm $(docker ps -a -q) > /dev/null 2>&1 
#docker rmi $(docker images -q) > /dev/null 2>&1 

echo "Running rally and collecting data to ./$OUTPUT_TEMP"

echo $BOOT_JSON > $BOOT_JSON_FILE

$RALLY task start ./$BOOT_JSON_FILE | grep osprofiler | awk '{print $5}' > $OUTPUT_TEMP
echo "total_time;spawn_time;image_time;domain_time;instances" > $OUTPUT_TIMES

sleep 10

for i in `cat $OUTPUT_TEMP`; do

	TOTAL_TIME=`osprofiler trace show --html $i | grep -o '"started": 0, "finished": [0-9]*, "name": "total"' | egrep -o '"finished": [0-9]*' | egrep -o '[0-9]*'`

	SPAWN_START_TIME=`osprofiler trace show --html $i | grep -o '"novadocker.virt.docker.driver.DockerDriver.spawn", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
	SPAWN_STOP_TIME=`osprofiler trace show --html $i | grep -o '"novadocker.virt.docker.driver.DockerDriver.spawn", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
	SPAWN_TIME=$(expr $SPAWN_STOP_TIME - $SPAWN_START_TIME)

	CREATE_IMAGE_START_TIME=`osprofiler trace show --html $i | grep -o '"novadocker.virt.docker.driver.DockerDriver._pull_missing_image", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
	CREATE_IMAGE_STOP_TIME=`osprofiler trace show --html $i | grep -o '"novadocker.virt.docker.driver.DockerDriver._pull_missing_image", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
	CREATE_IMAGE_TIME=$(expr $CREATE_IMAGE_STOP_TIME - $CREATE_IMAGE_START_TIME)
	
	CREATE_DOMAIN_START_TIME=`osprofiler trace show --html $i | grep -o '"novadocker.virt.docker.driver.DockerDriver._start_container", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
	CREATE_DOMAIN_STOP_TIME=`osprofiler trace show --html $i | grep -o '"novadocker.virt.docker.driver.DockerDriver._start_container", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
	CREATE_DOMAIN_TIME=$(expr $CREATE_DOMAIN_STOP_TIME - $CREATE_DOMAIN_START_TIME)

	echo $TOTAL_TIME';'$SPAWN_TIME';'$CREATE_IMAGE_TIME';'$CREATE_DOMAIN_TIME';'$num_instances >> $OUTPUT_TIMES

done

rm -f $OUTPUT_TEMP
rm -f $BOOT_JSON_FILE

source /opt/devstack/openrc demo demo

echo "Done."
