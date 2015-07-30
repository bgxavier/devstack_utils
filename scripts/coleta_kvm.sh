#/bin/bash

for i in `find /opt/stack/data/nova/instances -name console.log`
do

    tomcattime=`grep "Initialization processed in" $i | awk '{ print $5}'`
    boottime=`grep "modules:config" $i | grep -o 'Up [0-9.]*' | grep -o '[0-9.]*'`
 
    boottimemilis=`echo $boottime*1000 | bc`

    echo $boottimemilis";"$tomcattime

done
