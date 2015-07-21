# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n

. /opt/devstack/openrc admin admin

function osadmin {
        source /opt/devstack/openrc admin admin
}

function osdemo {
        source /opt/devstack/openrc demo demo
}
