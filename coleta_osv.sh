#/bin/bash

for i in `find /opt/stack/data/nova/instances -name console.log`

do

   boottime=`grep "Total time:" $i | awk '{print $3}' | egrep -o '[0-9.]*'`
   tomcattime=`egrep -o 'Server startup in [0-9]*' $i | egrep -o '[0-9.]*'`

   echo $boottime";"$tomcattime

done
