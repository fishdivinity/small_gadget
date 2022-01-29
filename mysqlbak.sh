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
bakdir="/home/lighthouse/mysql_bak/soft_backup"
# 备份日期格式
bakdate=`date +'%Y%m%d%H%M%S'`
# 备份的文件名（tar进行打包）
bakfile="mysql_$bakdate.tar"
# 总压缩指令
a_compress_order="xz $bakfile"
# 分压缩指令
b_compress_order="gzip"
# 总解压指令
a_restore_order="xz -d"
# 分解压指令
b_restore_order="gzip -d"
# mysql用户名
# 格式如下：-umysql_user
# 例如：-proot
mysql_user=""
# mysql用户密码
# 格式如下：-puser_password
# 例如：-p123456
mysql_password=""
# 系统当前用户名
whoami=`whoami`
# 希望输出的备份文件的用户所有者（如果不是root用户执行该脚本，此参数不生效）
bakowner="lighthouse:lighthouse"
# 还原时会创建的临时文件夹，用于存储解压的临时数据
restore_folder=$bakdir"/.restore_"$bakdate
# 还原数据库时需要输入的确认密码（还原数据库原则上不允许自动任务执行，只能手动执行）
restore_password="Tq1314520Jbh@123[]"
# 存储所有数据库名称的变量
database_all_name=`mysql $mysql_user $mysql_password -e "show databases;"|grep -Evi "database|infor|perfor"`
# 删除过期的文件（七天）
# find $bakdir/ -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
# 因为我已经cd 到备份的目录了，所以这里直接 . 就好
# find . -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;

# shell脚本执行中可能用到的临时变量
# ***********************
choose=""
choose_b=""
choose_file=""
database_name_array=""
database_name=""
dbname_all=""
dbname=""
# restore_file_suffix=".*sql$"
backup_while_number=0
gunzip_file_name=""
restore_function_parameter=""
# ***********************


# 备份所有数据库的函数
backup_all(){
	# backup all databases
	cd "$bakdir"
	touch "$bakfile"
	for dbname in ${database_all_name[@]}
	do
		# 因为已经在mysqldump.cnf里面添加了user和password，这里不需要明文表示用户和密码
		mysqldump $mysql_user $mysql_password -q -B $dbname | $b_compress_order >${dbname}.sql.gz
		tar -rvf "$bakfile" ${dbname}.sql.gz
	done
	echo -e "\033[33mclear all file about *.sql.gz\033[0m"
	rm "$bakdir"/*.sql.gz
	$a_compress_order
	# chown命令需要root权限
	if [ "$whoami" == "root" ];then
		chown "$bakowner" "$bakfile".xz
	fi
	echo -e "\033[33mtar all databases to $bakfile.xz\033[0m"
	# delete seven days ago mysql backup file
	find . -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
	cd "$pwddir"
}

# 备份部分数据库的函数，允许传参
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
			for dbname_all in ${database_all_name[@]}
			do
				if [ $dbname_all == $dbname ];then
					# 因为已经在mysqldump.cnf里面添加了user和password，这里不需要明文表示用户和密码
					mysqldump $mysql_user $mysql_password -q -B $dbname | $b_compress_order >${dbname}.sql.gz
					tar -rvf "$bakfile" ${dbname}.sql.gz
					let backup_while_number=backup_while_number+1
				fi
			done
		done
		if [ $backup_while_number -ne 0 ];then
			echo -e "\033[33mclear all file about *.sql.gz\033[0m"
			rm "$bakdir"/*.sql.gz
			$a_compress_order
			# chown命令需要root权限
			if [ "$whoami" == "root" ];then
				chown "$bakowner" "$bakfile".xz
			fi
			echo -e "\033[33mtar all databases to $bakfile.xz\033[0m"
			# delete seven days ago mysql backup file
			find . -type f -mtime +7 -name "mysql_*.tar.xz" -exec rm -rf {} \;
		else
			echo -e "\033[33m$1 not exist\033[0m"
			rm $bakfile
		fi
		cd "$pwddir"
	fi
}

# 密码校验
# 还原备份需要先提前校验一下
# 有三次输错机会
# 输错三次程序退出
restore_confirmation(){
	echo -n "please enter password:"
	for i in {1..3};do
		if read -s -t 15 restore_function_parameter;then
			if [ $restore_function_parameter != $restore_password ];then
				sleep 1s
				echo -e "\033[31;1m\nSorry, try again.\033[0m"
				if [ $i -eq 3 ];then
					exit 0;
				fi
			else
				echo -e "\n"
				break;
			fi
		else
			echo -e "\nsorry,the time has expired"
			exit 0;
		fi
	done
}

# 解压文件
# 全解压，解压成对应的各个sql文件
# 可以传参指定文件
# 默认是最新的文件
gunzip(){
	# gunzip all  
	cd "$bakdir"
	gunzip_file_name=$1
	if [ ! -n "$gunzip_file_name" ];then
		gunzip_file_name=`ls -t | grep ".*xz" | head -n 1`
	fi
	mkdir $restore_folder&&cd $restore_folder
	cp ../$gunzip_file_name .
	$a_restore_order $gunzip_file_name
	gunzip_file_name=`ls -t | grep ".*tar" | head -n 1`
	tar -xvf $gunzip_file_name&&rm $gunzip_file_name
	$b_restore_order `ls | grep ".*gz"`
}

# 还原数据库
# 允许传参
# 若不传参则默认全部
# 该函数在调用前，需要进行对应备份文件的解压缩，这个shell脚本是一套的
restore_databases(){
	# restore some databases or restore all databases
	if [ ! -n "$1" ];then
		for dbname_all in `ls`
		do
			echo -e "\033[34mmysql < $dbname_all\033[0m"
			mysql $mysql_user $mysql_password < $dbname_all
			echo -e "\033[33m$dbname_all OK!\033[0m"
		done
	else
		database_name_array=$1
		database_name=(${database_name_array//,/ })
		database_name_array=`ls`
		for dbname in ${database_name[@]}
		do
			# 判断结果取反
			# if [[ ! $dbname =~ $restore_file_suffix ]];then
			if [[ ! $dbname =~ .*sql$ ]];then
				dbname=$dbname.sql
			fi
			for dbname_all in ${database_name_array[@]}
			do
				if [ $dbname_all == $dbname ];then
					echo -e "\033[34mmysql < $dbname_all\033[0m"
					mysql $mysql_user $mysql_password < $dbname_all
					echo -e "\033[33m$dbname_all OK!\033[0m"
				fi
			done
		done
	fi
	cd "$bakdir"
	rm $restore_folder -rf
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
elif [ "$1" == "--restore" ] || [ "$1" == "-R" ];then
	if [ "$2" == "-A" ] || [ "$1" == "--all" ];then
		restore_confirmation
		if [ "$3" == "-F" ] || [ "$3" == "--file" ];then
			if test -f "$bakdir/$4";then
				gunzip $4
				restore_databases
			elif [ ! -n "$4" ];then
				echo -e "\033[31myou have not input files name!\033[0m"
				exit 0;
			else
				echo -e "\"$4\" not exists."
				exit 0;
			fi
		else
			gunzip
			restore_databases
		fi
	elif [ "$2" == "-S" ] || [ "$2" == "--some" ];then
		restore_confirmation
		if [ "$3" == "-F" ] || [ "$3" == "--file" ];then
			if test -f "$bakdir/$4";then
				if [ ! -n "$5" ];then
					echo -e "\033[31myou have not input sql files name!\033[0m"
					exit 0;
				fi
				gunzip $4
				restore_databases $5
			elif [ ! -n "$4" ];then
				echo -e "\033[31myou have not input files name!\033[0m"
				exit 0;
			else
				echo -e "\"$4\" not exists."
				exit 0;
			fi
		else
			if [ ! -n "$3" ];then
					echo -e "\033[31myou have not input sql files name!\033[0m"
					exit 0;
			fi
			gunzip
			restore_databases $3
		fi
	else
		stty erase '^H'
		restore_confirmation
		echo "所有数据库都进行还原？"
		read -p "All databases restore?[y/n]:" choose
		# 是否还原所有的数据库，y=全部，n=让用户选择
		if [ "$choose" = "y" ] || [ "$choose" = "Y" ];then
			echo "你需要指定某个备份文件来还原吗？"
			read -p "Do you need to specify a backup file to restore?[y/n]:" choose_b
			# 是否需要指定某个备份文件来还原，y=是的，n=打印所有的备份文件，让用户选择
			if [ "$choose_b" = "y" ] || [ "$choose_b" = "Y" ];then
				ls -t -l $bakdir | grep --color=never ".*xz$"
				echo "请选择备份文件（输入文件名）"
				read -p "Please input the file name:" choose_file
				if test -f "$bakdir/$choose_file";then
					gunzip $choose_file
					restore_databases
				elif [ ! -n "$choose_file" ];then
					echo -e "\033[31myou have not input files name!\033[0m"
					exit 0;
				else
					echo -e "\"$choose_file\" not exists."
					exit 0;
				fi
			elif [ "$choose_b" = "n" ] || [ "$choose_b" = "N" ];then
				gunzip
				restore_databases
			fi
		elif [ "$choose" = "n" ] || [ "$choose" = "N" ];then
			echo "你需要指定某个备份文件来还原吗？"
			read -p "Do you need to specify a backup file to restore?[y/n]:" choose_b
			# 是否需要指定某个备份文件来还原，y=是的，n=打印所有的备份文件，让用户选择
			if [ "$choose_b" = "y" ] || [ "$choose_b" = "Y" ];then
				ls -t -l $bakdir | grep --color=never ".*xz$"
				echo "请选择备份文件（输入文件名）"
				read -p "Please input the file name:" choose_file
				if test -f "$bakdir/$choose_file";then
					gunzip $choose_file
				elif [ ! -n "$choose_file" ];then
					echo -e "\033[31myou have not input files name!\033[0m"
					exit 0;
				else
					echo -e "\"$choose_file\" not exists."
					exit 0;
				fi

				ls -t -l | grep --color=never ".*sql$"
				echo "选择需要还原执行的SQL（多个SQL，则使用英文逗号隔开）"
				read -p "choose restore sql files(seperate sql_files with comma):" choose_file
				restore_databases $choose_file
			elif [ "$choose_b" = "n" ] || [ "$choose_b" = "N" ];then
				gunzip
				ls -t -l | grep --color=never ".*sql$"
				echo "选择需要还原执行的SQL（多个SQL，则使用英文逗号隔开）"
				read -p "choose restore sql files(seperate sql_files with comma):" choose_file
				restore_databases $choose_file
			fi
		fi
	fi
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
a_compress_order=""
b_compress_order=""
a_restore_order=""
b_restore_order=""
mysql_user=""
mysql_password=""
whoami=`whoami`
bakowner=""
restore_folder=""
restore_password=""
database_all_name=""

choose=""
choose_b=""
choose_file=""
database_name_array=""
database_name=""
dbname_all=""
dbname=""
# restore_file_suffix=""
backup_while_number=0
restore_function_parameter=""
