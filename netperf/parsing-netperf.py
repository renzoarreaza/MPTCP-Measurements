#!/usr/bin/env python3

import re
import sys
import string
import os

#with open(sys.argv[1], 'r') as f:
#	data=f.read()


mptcp = [filename for filename in os.listdir('.') if filename.startswith("result_netperf_mptcp")]
tcp = [filename for filename in os.listdir('.') if filename.startswith("result_netperf_tcp")]

mptcp.sort()
tcp.sort()

result_mptcp = ''
for x in mptcp:
	with open(x, 'r') as f:
		data=f.read()
		data = re.sub(r'.*\n', '', data, 6)
		data = re.sub(r'.*30.0.', '', data)
		data = re.sub(r'\n.*', '', data)
		data = re.sub(r' ', '', data)
		
		name = x[21:38]
		result_mptcp = result_mptcp + name + ', ' + data + '\n'
#print(result_mptcp)
with open("netperf_mptcp.csv", "w") as csv_file:
	csv_file.write(result_mptcp)



result_tcp = ''
for x in tcp:
	with open(x, 'r') as f:
		data=f.read()
		data = re.sub(r'.*\n', '', data, 6)
		data = re.sub(r'.*30.0.', '', data)
		data = re.sub(r'\n.*', '', data)
		data = re.sub(r' ', '', data)
		
		name = x[19:36]
		result_tcp = result_tcp + name + ', ' + data + '\n'
#print(result_tcp)
with open("netperf_tcp.csv", "w") as csv_file:
	csv_file.write(result_tcp)
