#!/bin/bash
for i in `echo /opt/unikernels_workload/unikernel{01,02,03,04,05,06,07,08,09,10,11,12,13,14,15}`; do
   cd $i
   make clean
   echo "bla2" >> README.md
   git add --all
   git commit -m "vai"
   git push origin master
done;

