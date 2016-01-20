for i in `glance image-list  | egrep -o "([a-z0-9])+-([a-z0-9])+-([a-z0-9])+-([a-z0-9])+-([a-z0-9])+"`; do glance image-delete $i; done
