for i in `echo unikernel{01,02,03,04,05,06,07,08,09,10,11,12,13,14,15}`;do
	glance image-create --name $i --is-public True --disk-format qcow2 --container-format bare --file /opt/osv_images/$i/$i.qemu
	glance_unikernel.sh git@10.32.45.217:/opt/git/$i
done

