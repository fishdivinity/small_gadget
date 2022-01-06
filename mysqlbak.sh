#!/bin/bash

#
# author:fishdivinity
#

# 如果普通用户使用发生问题，可以切换到root权限试试
#sudo su

# 为避免出现以下警告
# mysql: [Warning] Using a password on the command line interface can be insecure.
# 使用以下命令，在用户的家目录下生成隐藏文件".mylogin.cnf"
# mysql_config_editor set --user=root --host=localhost --port=3306 --password

# 当前目录
pwddir=`pwd`
# 备份目录
bakdir="/home/ubuntu/mysql_bak/soft_backup"
# 备份日期格式
bakdate=`date +'%Y%m%d%H%M%S'`
# 备份的文件名（tar进行打包）
bakfile="mysql_$bakdate.tar"
# 压缩指令
compress_order="xz $bakfile"
# mysql用户名
# 格式如下：-umysql_user
# 例如：-proot
export mysql_user=""
# mysql用户密码
# 格式如下：-puser_password
# 例如：-p123456
export mysql_password=""
# 系统当前用户名
whoami=`whoami`
# 希望输出的备份文件的用户所有者（如果不是root用户执行该脚本，此参数不生效）
bakowner="ubuntu:ubuntu"
# 删除过期的文件（七天）
# find $bakdir/ -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
# 因为我已经cd 到备份的目录了，所以这里直接 . 就好
# find . -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
# shell脚本执行中可能用到的临时变量
database_name_array=""

backup_all(){
	# backup all databases
	cd "$bakdir"
	touch "$bakfile"
	for dbname in `mysql $mysql_user $mysql_password -e "show databases;"|grep -Evi "database|infor|perfor"`
	do
		# 因为已经在mysqldump.cnf里面添加了user和password，这里不需要明文表示用户和密码
		# mysqldump $mysql_user $mysql_password -q -B $dbname|gzip >${dbname}.sql.gz
		mysqldump -q -B $dbname|gzip >${dbname}.sql.gz
		tar -rvf "$bakfile" ${dbname}.sql.gz
	done
	echo -e "\033[33mclear all file about *.sql.gz\033[0m"
	rm "$bakdir"/*.sql.gz
	$compress_order
	# chown命令需要root权限
	if [ "$whoami" == "root" ];then
		chown "$bakowner" "$bakfile".xz
	fi
	echo -e "\033[33mtar all databases to $bakfile.xz\033[0m"
	# delete seven days ago mysql backup file
	find . -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
	cd "$pwddir"
}

backup_some_databases(){
	# backup some databases
	if [ ! -n "$1" ];then
		echo -e "\033[31myou have not input database!\033[0m"
	else
		cd "$bakdir"
		touch "$bakfile"
		database_name_array=$1
		database_name=(${database_name_array//,/ })
		for dbname in ${database_name[@]}
		do
			# 因为已经在mysqldump.cnf里面添加了user和password，这里不需要明文表示用户和密码
			# mysqldump $mysql_user $mysql_password -q -B $dbname|gzip >${dbname}.sql.gz
			mysqldump -q -B $dbname|gzip >${dbname}.sql.gz
			tar -rvf "$bakfile" ${dbname}.sql.gz
		done
		echo -e "\033[33mclear all file about *.sql.gz\033[0m"
		rm "$bakdir"/*.sql.gz
		$compress_order
		# chown命令需要root权限
		if [ "$whoami" == "root" ];then
			chown "$bakowner" "$bakfile".xz
		fi
		echo -e "\033[33mtar all databases to $bakfile.xz\033[0m"
		# delete seven days ago mysql backup file
		find . -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
		cd "$pwddir"
	fi
}

if [ "$1" == "--all" ] || [ "$1" == "-A" ];then
	backup_all
elif [ "$1" == "--databases" ] || [ "$1" == "-B" ];then
	backup_some_databases $2
elif [ "$1" == "--help" ] || [ "$1" == "-H" ];then
	echo "mysqlbak --help"
	echo "mysqlbak -H"
	echo "* Help manual"
	echo "* 帮助手册"
	echo "mysqlbak --all"
	echo "mysqlbak -A"
	echo "* backup all databases"
	echo "* 备份所有的数据库"
	echo "mysqlbak --databases"
	echo "mysqlbak -B"
	echo "* backup some databases"
	echo "* 备份一些数据库，由用户指定"
	echo "* choose databases(seperate database_name with comma)"
	echo "* 选择的数据库（多个数据库，则使用英文逗号隔开）"
elif [ ! -n "$1" ];then
	stty erase '^H'
	echo "数据库整表备份？"
	read -p "All databases backup?[y/n]:" choose
	if [ "$choose" = "y" ] || [ "$choose" = "Y" ];then
		backup_all
	elif [ "$choose" = "n" ] || [ "$choose" = "N" ];then
		echo -e "databases:\033[33m\r"
		echo `mysql $mysql_user $mysql_password -e "show databases;"|tail +2`
		echo -e "\033[0m选择的数据库（多个数据库，则使用英文逗号隔开）"
		read -p "choose databases(seperate database_name with comma):" database_name_array
		backup_some_databases $database_name_array
	fi
else
	echo -e "\033[31mmysqlbak --help\033[0m"
fi

# 变量值清空，以免影响到shell

pwddir=""
bakdir=""
bakdate=""
bakfile=""
compress_order=""
mysql_user=""
mysql_password=""
whoami=`whoami`
bakowner=""
database_name_array=""
