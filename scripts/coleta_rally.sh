virt_type=$1
num_instances=$2

KVM_IMAGE="ubuntu-tomcat"
OSV_IMAGE="osv-tomcat"
DOCKER_IMAGE="tomcat"

FLAVOR="m1.micro"

RALLY_OUTPUT='rally_output.txt'
OUTPUT_TEMP='osprofiler.txt'
OUTPUT_TIMES="ostimes_$virt_type.csv"
BOOT_JSON_FILE='boot.json'

RALLY="/usr/local/bin/rally"

case $1 in

kvm)
        BOOT_YAML=$KVM_BOOT
        IMAGE=$KVM_IMAGE
;;

docker)

        BOOT_YAML=$DOCKER_BOOT
        IMAGE=$DOCKER_IMAGE
;;

osv)
        BOOT_YAML=$OSV_BOOT
        IMAGE=$OSV_IMAGE
;;

*)
  echo "kvm, osv or docker"
  ;;

esac

BOOT_JSON='{"NovaServers.boot_server":[{"args":{"flavor":{"name":"'$FLAVOR'"},"image":{"name":"'$IMAGE'"}},"runner":{"type":"constant","times":'$num_instances',"concurrency":'$num_instances'},"context":{"users":{"tenants":1,"users_per_tenant":1}}}]}'

source /opt/devstack/openrc admin admin

echo "Running rally and collecting data to ./$OUTPUT_TEMP"

echo $BOOT_JSON > $BOOT_JSON_FILE

$RALLY task start ./$BOOT_JSON_FILE | tee $RALLY_OUTPUT | grep osprofiler | awk '{print $5}' > $OUTPUT_TEMP

LOAD_DURATION=`grep "Load duration" $RALLY_OUTPUT | awk '{print $3}'`

echo "Load Duration: $LOAD_DURATION" >> $OUTPUT_TIMES
echo "total_time;spawn_time;disk_info_time;get_xml_time;image_download_time;image_convert_time;image_copy_time;image_create_time;instance_time;concurrent_instances" >> $OUTPUT_TIMES


sleep 260

for i in `cat $OUTPUT_TEMP`; do

    TOTAL_TIME=`osprofiler trace show --html $i | grep -o '"started": 0, "finished": [0-9]*, "name": "total"' | egrep -o '"finished": [0-9]*' | egrep -o '[0-9]*'`

    SPAWN_START_TIME=`osprofiler trace show --html $i | grep -o 'spawn", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    SPAWN_STOP_TIME=`osprofiler trace show --html $i | grep -o 'spawn", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    SPAWN_TIME=$(expr $SPAWN_STOP_TIME - $SPAWN_START_TIME)


    GET_DISK_INFO_START=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.blockinfo.get_disk_info", "name": "get_disk_info", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*' | tail -1`
    GET_DISK_INFO_STOP=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.blockinfo.get_disk_info", "name": "get_disk_info", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*' | tail -1`
    GET_DISK_INFO_TIME=$(expr $GET_DISK_INFO_STOP - $GET_DISK_INFO_START)


    GET_GUEST_XML_START=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.driver._get_guest_xml", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    GET_GUEST_XML_STOP=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.driver._get_guest_xml", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    GET_GUEST_XML_TIME=$(expr $GET_GUEST_XML_STOP - $GET_GUEST_XML_START)


#    CREATE_IMAGE_START_TIME=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.driver._create_image", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
#    CREATE_IMAGE_STOP_TIME=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.driver._create_image", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
#    CREATE_IMAGE_TIME=$(expr $CREATE_IMAGE_STOP_TIME - $CREATE_IMAGE_START_TIME)

    IMAGE_DOWNLOAD_START=`osprofiler trace show --html $i | grep -o '"nova.virt.images.fetch", "name": "image_download", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    IMAGE_DOWNLOAD_STOP=`osprofiler trace show --html $i | grep -o '"nova.virt.images.fetch", "name": "image_download", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    IMAGE_DOWNLOAD_TIME=$(expr $IMAGE_DOWNLOAD_STOP - $IMAGE_DOWNLOAD_START)


    IMAGE_CONVERT_START=`osprofiler trace show --html $i | grep -o '"nova.virt.images.convert_image", "name": "image_convert_to_raw", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    IMAGE_CONVERT_STOP=`osprofiler trace show --html $i | grep -o '"nova.virt.images.convert_image", "name": "image_convert_to_raw", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    IMAGE_CONVERT_TIME=$(expr $IMAGE_CONVERT_STOP - $IMAGE_CONVERT_START)


    IMAGE_COPY_START=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.imagebackend.copy_qcow2_image", "name": "qcow2_copy_image", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    IMAGE_COPY_STOP=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.imagebackend.copy_qcow2_image", "name": "qcow2_copy_image", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    IMAGE_COPY_TIME=$(expr $IMAGE_COPY_STOP - $IMAGE_COPY_START)

    IMAGE_CREATE_START=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.utils.create_cow_image", "name": "utils_create_cow_image", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    IMAGE_CREATE_STOP=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.utils.create_cow_image", "name": "utils_create_cow_image", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    IMAGE_CREATE_TIME=$(expr $IMAGE_CREATE_STOP - $IMAGE_CREATE_START)


    CREATE_DOMAIN_START_TIME=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.driver._create_domain_and_network", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $7}' | egrep -o '[0-9]*'`
    CREATE_DOMAIN_STOP_TIME=`osprofiler trace show --html $i | grep -o '"nova.virt.libvirt.driver._create_domain_and_network", "name": "driver", "service": "nova-compute", "started": [0-9]*, "finished": [0-9]*' | awk '{print $9}' | egrep -o '[0-9]*'`
    CREATE_DOMAIN_TIME=$(expr $CREATE_DOMAIN_STOP_TIME - $CREATE_DOMAIN_START_TIME)

    echo $TOTAL_TIME';'$SPAWN_TIME';'$GET_DISK_INFO_TIME';'$GET_GUEST_XML_TIME';'$IMAGE_DOWNLOAD_TIME';'$IMAGE_CONVERT_TIME';'$IMAGE_COPY_TIME';'$IMAGE_CREATE_TIME';'$CREATE_DOMAIN_TIME';'$num_instances >> $OUTPUT_TIMES

done

#rm -f $OUTPUT_TEMP
#rm -f $BOOT_JSON_FILE

source /opt/devstack/openrc demo demo

echo "Done."
