#!/usr/bin/env python3
# filename as argument

import re
import sys
import string

with open(sys.argv[1], 'r') as f:
	data=f.read()

data = re.sub(r'\[  .] ', '', data)
data = re.sub(r' sec  ', ', ', data)
data = re.sub(r' MBytes  ', ', ', data)
data = re.sub(r' Mbits.*', '', data)
data = re.sub(r'local.*', '', data)
data = re.sub(r'.*\n', '', data, 7)
data = re.sub(r'-', ', ', data)

name = sys.argv[1]
name = re.sub(r'txt', 'csv', name)

#print(name)
with open(name, "w") as csv_file:
	csv_file.write(data)

#print(data)
