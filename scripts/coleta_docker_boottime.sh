for i in {1..30}; do /usr/bin/time --format "%e %U %S" -a -o docker_boot_os.csv docker run tomcat uptime; done
