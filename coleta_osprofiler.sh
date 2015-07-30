virt_type=$1
num_instances=$2

KVM_IMAGE="32a54fbf-8a22-489c-8eb5-bf51f85112fa"
DOCKER_IMAGE="00f9dd6d-3d96-4fc2-85c8-02caf0d553da"
OSV_IMAGE="4eec9e83-15b9-4a3d-8641-c79544d2f2e5"

case $1 in

kvm)
        IMAGE=$KVM_IMAGE
;;

docker)

        IMAGE=$DOCKER_IMAGE
;;

osv)
        IMAGE=$OSV_IMAGE

;;

*)
  echo "kvm, osv or docker"
  ;;

esac

echo "Changing to admin tenant.."

source /opt/devstack/openrc admin admin

echo "Removing _base cache.. Ensure you are in COMPUTE NODE"

sudo rm -fv /opt/stack/data/nova/instances/_base/*

echo "Collecting data to $1_osprofiler.csv"

for i in $( seq 1 5 ); do nova --profile SECRET_KEY boot --image $IMAGE --flavor 6 --num-instances $num_instances test | egrep -o "html.*" | osprofiler trace show --html `awk '{print $2}'` | grep -o '"started": 0, "finished": [0-9]*, "name": "total"' | egrep -o '"finished": [0-9]*' | egrep -o [0-9]* | tee -a $1_osprofiler.csv; nova list --all | awk '$2 && $2 != "ID" {print $2}' | xargs -n1 nova delete; done

echo "Done."

#echo "Removing instances..."
#nova list --all | awk '$2 && $2 != "ID" {print $2}' | xargs -n1 nova delete

echo "Going back to demo tenant."

source /opt/devstack/openrc demo demo

echo "Done."
