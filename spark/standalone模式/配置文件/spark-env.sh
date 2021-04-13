
# java 环境
export JAVA_HOME=/opt/module/jdk1.8.0_192

# 单 Master 配置
# SPARK_MASTER_HOST=liu1
# SPARK_MASTER_PORT=7077

# 历史服务器配置 需要 hdfs 提前建立目录
export SPARK_HISTORY_OPTS="
-Dspark.history.ui.port=18080
-Dspark.history.fs.logDirectory=hdfs://liu1:8020/directory
-Dspark.history.retainedApplications=30"

# 多 Master 配置 需要 zookeeper
SPARK_MASTER_WEBUI_PORT=8989
export SPARK_DAEMON_JAVA_OPTS="
-Dspark.deploy.recoveryMode=ZOOKEEPER
-Dspark.deploy.zookeeper.url=liu1,liu2,liu3
-Dspark.deploy.zookeeper.dir=/spark"
