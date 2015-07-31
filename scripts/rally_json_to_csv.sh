#/bin/bash
for i in `find . -name "*_rally.json"`; do egrep nova.boot_server $i | tr -d '[:blank:]' > $i.csv; done

