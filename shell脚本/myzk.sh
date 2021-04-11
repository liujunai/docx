#!/bin/bash

case $1 in
"start"){
	for i in liu1 liu2 liu3
	do
		echo ---------- zookeeper $i 启动 ------------
		ssh $i "/opt/module/zookeeper-3.6.2/bin/zkServer.sh start"
	done
};;

"stop"){
	for i in liu1 liu2 liu3
	do
		echo ---------- zookeeper $i 停止 ------------
		ssh $i "/opt/module/zookeeper-3.6.2/bin/zkServer.sh stop"
	done
};;

"status"){
	for i in liu1 liu2 liu3
	do
		echo ---------- zookeeper $i 状态 ------------
		ssh $i "/opt/module/zookeeper-3.6.2/bin/zkServer.sh status"
	done
};;
esac