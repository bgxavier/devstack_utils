#!/bin/bash

grep _create_domain_and_network /opt/stack/logs/n-cpu.log | egrep -o [0-9.]* > ./instance_time.csv
grep create_cow_image /opt/stack/logs/n-cpu.log | egrep -o [0-9.]* > ./create_qcow2_image_time.csv
grep cabeca /opt/stack/logs/n-cpu.log | grep copy_qcow2_image | awk '{ print $3}' |  egrep -o [0-9.]* > ./copy_qcow2_image_time.csv
grep cabeca /opt/stack/logs/n-cpu.log | grep convert_image |  egrep -o [0-9.]* > ./convert_image_time.csv
grep cabeca /opt/stack/logs/n-cpu.log | grep -v "fetch_to_raw" | grep fetch | egrep -o [0-9.]* > ./fetch_image_time.csv
grep cabeca /opt/stack/logs/n-cpu.log | grep _get_guest_xml | egrep -o [0-9.]* > ./get_xml_time.csv
grep cabeca /opt/stack/logs/n-cpu.log | grep get_disk_info | egrep -o [0-9.]* > ./get_diskinfo_time.csv
