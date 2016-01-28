alias ls="ls --color"

. /opt/devstack/openrc admin admin

export LC_ALL=en_US.utf8
export LANG=en_US.utf8
export CAPSTAN_ROOT='/opt/osv_images'

# Capstan wget installation
export PATH=$PATH:/opt/stack/bin

# Capstan installation from source 
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

RALLY_HOME='/opt/stack/rally'
alias initrally='source $RALLY_HOME/bin/activate'
alias rally='$RALLY_HOME/bin/rally'

PATH=$PATH:/opt/devstack_utils/scripts

function osadmin {
        source /opt/devstack/openrc admin admin
}

function osdemo {
        source /opt/devstack/openrc demo demo
}

function nova-delete-all {
        nova list --all | awk '$2 && $2 != "ID" {print $2}' | xargs -n1 nova delete
}

function docker-delete-all {
        docker stop $(docker ps -a -q)
        docker rm $(docker ps -a -q)
	docker rmi $(docker images -q)
}

function up-utils {
        cd /opt/devstack_utils; git pull; git add --all;  git commit -am "vai utils" ; git push
}

function up-benchmark {
        cd /opt/openstack_benchmarks; git pull; git add --all; git commit -am "vai benchmark" ; git push
}
