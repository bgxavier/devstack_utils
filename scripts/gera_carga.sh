#!/bin/bash

for i in {0..30}
do
	rally task start /opt/openstack_benchmarks/boot.json;
	sleep 10;
	ssh stack@10.32.45.217 'rm -f /opt/stack/data/nova/instances/_base/*';
done
