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
        nova list | awk '$2 && $2 != "ID" {print $2}' | xargs -n1 nova delete
}
