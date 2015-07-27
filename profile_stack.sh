alias ls="ls --color"

. /opt/devstack/openrc admin admin

export LC_ALL=en_US.utf8
export LANG=en_US.utf8


function osadmin {
        source /opt/devstack/openrc admin admin
}

function osdemo {
        source /opt/devstack/openrc demo demo
}

function nova-delete-all {
        nova list --all | awk '$2 && $2 != "ID" {print $2}' | xargs -n1 nova delete
}

function up-utils {
        cd /opt/devstack_utils; git pull; git add --all; git commit -am "vai utils" ; git push
}

function up-benchmark {
        cd /opt/openstack_benchmarks; git pull; git add --all;  git commit -am "vai benchmark" ; git push
}
