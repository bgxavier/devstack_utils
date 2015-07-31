for i in {1..5}; do /usr/bin/time --format "%e" -a -o docker_boot_os.csv docker run tomcat uptime ; done
