import os

from keystoneclient.auth.identity import v2
from keystoneclient import session
from novaclient import client
from oslo_utils import importutils
import osprofiler.profiler

import threading

osprofiler_profiler = importutils.try_import("osprofiler.profiler")

AUTH_URL = os.environ['OS_AUTH_URL']
USERNAME = os.environ['OS_USERNAME']
PASSWORD = os.environ['OS_PASSWORD']
PROJECT_ID = os.environ['OS_TENANT_NAME']

auth = v2.Password(auth_url=AUTH_URL,
                       username=USERNAME,
                       password=PASSWORD,
                       tenant_name=PROJECT_ID)
sess = session.Session(auth=auth)
nova = client.Client(2, session=sess)


image = nova.images.find(name="cirros-0.3.2-x86_64-uec")
flavor = nova.flavors.find(name="m1.tiny")
network = nova.networks.find(label="private")

def worker():

	if osprofiler_profiler:
	 osprofiler_profiler.init('SECRET_KEY')
	 trace_id = osprofiler_profiler.get().get_base_id()
	 print("Profiling trace ID: %s" % trace_id)
	 print("To display trace use next command:\n"
	    "osprofiler trace show --html %s " % trace_id)

	server = nova.servers.create(name = "debian-test", 
	                                 image = image.id, 
	                                 flavor = flavor.id, 
	                                 network = network.id)

threads = []
for i in range(3):
    t = threading.Thread(target=worker)
    threads.append(t)
    t.start()