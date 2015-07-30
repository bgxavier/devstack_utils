#/bin/bash

for i in `docker ps -a -q`

do

   tomcattime=`docker logs $i 2>&1 | grep -o "Initialization processed in [0-9]*" | grep -o '[0-9.]*'`

   echo $tomcattime

done
