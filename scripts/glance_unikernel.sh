#!/bin/bash

REPO=$1

glance image-create --name $REPO --is-public True --disk-format qcow2 --container-format bare 
