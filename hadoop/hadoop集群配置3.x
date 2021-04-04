1.安装 epel-release
    1.Extra Packages for Enterprise Linux 是为“红帽系”的操作系统提供额外的软件包, 适用于 RHEL、CentOS 和 Scientific Linux。相当于是一个软件仓库,大多数 rpm 包在官方 repository 中是找不到的)
        [root@liu ~]# yum install -y epel-release
    2.如果 Linux 安装的是最小系统版,还需要安装如下工具;如果安装的是 Linux 桌面标准版,不需要执行如下操作
        net-tool:工具包集合,包含 ifconfig 等命令
        [root@liu ~]# yum install -y net-tools
    3.vim:编辑器
        [root@liu ~]# yum install -y vim
2.关闭防火墙,关闭防火墙开机自启
    [root@liu ~]# systemctl stop firewalld
    [root@liu ~]# systemctl disable firewalld.service
3.创建 liu 用户,并修改 liu 用户的密码
    [root@liu ~]# useradd liu
    [root@liu ~]# passwd liu
4.配置 liu 用户具有 root 权限,方便后期加 sudo 执行 root 权限的命令
    修改/etc/sudoers 文件,在%wheel 这行下面添加一行:vim /etc/sudoers
    ## Allow root to run any commands anywhere
    root  ALL=(ALL)    ALL
    ## Allows people in group wheel to run all commands
    %wheel ALL=(ALL)  ALL
    liu   ALL=(ALL)    NOPASSWD:ALL (添加行)
    注意:liu 这一行不要直接放到 root 行下面,因为所有用户都属于 wheel 组,你先配置了 liu 具有免密功能,但是程序执行到%wheel 行时,该功能又被覆盖回需要密码。所以 liu 要放到%wheel 这行下面。
5.在/opt 目录下创建文件夹,并修改所属主和所属组
    1.在/opt 目录下创建 module、software 文件夹
    [root@liu ~]# mkdir /opt/module
    [root@liu ~]# mkdir /opt/software
    2.修改 module、software 文件夹的所有者和所属组均为 liu 用户
    [root@liu ~]# chown liu:liu /opt/module
    [root@liu ~]# chown liu:liu /opt/software
    3.查看 module、software 文件夹的所有者和所属组
    [root@liu ~]# cd /opt/
    [root@liu opt]# ll
6.卸载虚拟机自带的 JDK
    查看相关java文件: rpm -qa | grep java
    注意:如果你的虚拟机是最小化安装不需要执行这一步。
    [root@liu ~]# rpm -qa | grep -i java | xargs -n1 rpm -e --nodeps
------------------------------------------------------------------------------------------------------------------------
7.配置hosts(IP和主机名映射)
    1.修改主机名称
    [root@liu ~]# vim /etc/hostname
    liu2
    2.配置 Linux 克隆机主机名称映射 hosts 文件,打开/etc/hosts
    [root@liu ~]# vim /etc/hosts
    添加如下内容
    192.168.1.150  liu
    192.168.122.51  liu1
    192.168.122.52  liu2
    192.168.122.53  liu3
8.安装 JDK
    1.解压 JDK 到/opt/module 目录下
        [liu@liu1 software]$ tar -zxvf jdk-8u212-linux-x64.tar.gz -C /opt/module/
    2.新建/etc/profile.d/my_env.sh 文件
        [liu@liu1 ~]$ sudo vim /etc/profile.d/my_env.sh
        #JAVA_HOME
        export JAVA_HOME=/opt/module/jdk1.8.0_192
        export PATH=$PATH:$JAVA_HOME/bin
    3.source 一下/etc/profile 文件,让新的环境变量 PATH 生效
        [liu@liu1 ~]$ source /etc/profile
    4.测试 JDK 是否安装成功
        [liu@liu1 ~]$ java -version
9.安装 Hadoop
    1.解压安装文件到/opt/module 下面
        [liu@liu1 software]$ tar -zxvf hadoop-3.2.0.tar.gz -C /opt/module/
    2.打开/etc/profile.d/my_env.sh 文件
        [liu@liu1 hadoop-3.1.3]$ sudo vim /etc/profile.d/my_env.sh
    3.在 my_env.sh 文件末尾添加如下内容:(shift+g)
        #HADOOP_HOME
        export HADOOP_HOME=/opt/module/hadoop-3.2.0
        export PATH=$PATH:$HADOOP_HOME/bin
        export PATH=$PATH:$HADOOP_HOME/sbin
    4.source 一下/etc/profile 文件,让新的环境变量 PATH 生效
        [liu@liu1 ~]$ source /etc/profile
    5.测试是否安装成功
        [liu@liu1 hadoop-3.1.3]$ hadoop version
        Hadoop 3.1.3
    /**
        1.重要目录
            (1)bin 目录:存放对 Hadoop 相关服务(hdfs,yarn,mapred)进行操作的脚本
            (2)etc 目录:Hadoop 的配置文件目录,存放 Hadoop 的配置文件
            (3)lib 目录:存放 Hadoop 的本地库(对数据进行压缩解压缩功能)
            (4)sbin 目录:存放启动或停止 Hadoop 相关服务的脚本
            (5)share 目录:存放 Hadoop 的依赖 jar 包、文档、和官方案例
        2.Hadoop 运行模式
            本地模式:单机运行,只是用来演示一下官方案例。生产环境不用。
            伪分布式模式:也是单机运行,但是具备 Hadoop 集群的所有功能,一台服务器模拟一个分布式的环境。个别缺钱的公司用来测试,生产环境不用。
            完全分布式模式:多台服务器组成分布式环境。生产环境使用。
    */
------------------------------------------------完全分布式运行模式---------------------------------------------------------
1.SSH 无密登录配置
    1.生成公钥和私钥
        ssh-keygen -t rsa
    2.将公钥拷贝到要免密登录的目标机器上
        ssh-copy-id liu1
        ssh-copy-id liu2
        ssh-copy-id liu3
2.配置集群
    1.配置 core-site.xml
    2.配置 hdfs-site.xml
    3.配置 yarn-site.xml
    4.配置 mapred-site.xml
    5.配置 workers
3.启动集群
    1.如果集群是第一次启动，需要在 liu1 节点格式化 NameNode
        hdfs namenode -format
    2.启动 HDFS
        sbin/start-dfs.sh
    3.在配置了 ResourceManager 的节点启动 YARN
        sbin/start-yarn.sh
    4.启动历史服务器
        mapred --daemon start historyserver


























