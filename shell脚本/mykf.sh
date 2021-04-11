#! /bin/bash

case $1 in

"start"){
	for i in liu1 liu2 liu3
	do
		echo " -------- 启动 $i Kafka --------"
		ssh $i "/opt/module/kafka_2.11-2.4.1/bin/kafka-server-start.sh -daemon /opt/module/kafka_2.11-2.4.1/config/server.properties"
	done
};;


"stop"){
	for i in liu1 liu2 liu3
	do
		echo " -------- 停止 $i Kafka --------"
		ssh $i "/opt/module/kafka_2.11-2.4.1/bin/kafka-server-stop.sh stop"
	done
};;
esac