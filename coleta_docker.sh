#/bin/bash

for i in `docker ps -a -q`

do

   tomcattime=`docker logs $i 2>&1 | egrep -o 'Server startup in [0-9]*' | egrep -o '[0-9.]*'`

   echo $tomcattime

done
