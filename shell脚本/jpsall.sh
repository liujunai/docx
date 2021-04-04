#!/bin/bash

for host in liu1 liu2 liu3
do
	echo =============== $host ===============
	ssh $host jps
done