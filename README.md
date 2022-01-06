# small_gadget

### mysqlbak.sh

- 为了更方便的备份数据库所编写的shell脚本
- 有全量备份和选择具体数据库备份的功能



**mysqlbak.sh脚本内的帮助手册**

> mysqlbak --help || mysqlbak -H	# 帮助手册

**直接备份所有数据库，适合配合定时服务定期全量备份数据库（cron）**

> mysqlbak --all || mysqlbak -A	# 备份所有数据库

**备份部分数据库，--databases 后面可以跟着多个数据库的名称，但是如果写错了，后果自负**

> mysqlbak --databases || mysqlbak -B	#备份部分数据库，由你选

**直接回车，会让你选择是全量备份还是备份部分，备份部分的话，会帮你把mysql中所有的数据库打印出来，目前不支持以数字的方式选数据库，需要指定哪个数据库需要全名手敲**

> mysqlbak



### make.bat

- 用过linux下的make工具，喜欢这个功能，Windows下的gcc编译过程中需要手输的指令太多了
- make 然后后面跟上文件的名字，包括后缀，就通过bat脚本自动切割拼接，并直接执行该编译出来的exe文件
- make脚本会校验文件的后缀，合法才会执行

**添加到环境变量中，可以直接在cmd里以make命令使用**

> make main.c

**c++文件也可以编译并执行，都会自动转成GBK编码，windows一般都是GBK编码**

> make main.cpp