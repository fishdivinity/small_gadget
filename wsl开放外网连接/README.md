两个文件配合起来使用。

`wsl-start.vbs`：此文件建议放置在启动文件夹里，电脑开启就会启动

> 快捷键：win+r
>
> input：shell:startup

需要调整一下`wsl-start.vbs`里的一些参数

```vbscript
' 此为和init.wsl联动使用的，当init.wsl执行完毕之后，会写一个文件告知wsl-start.vbs，请写一个合法的地址
FinishAddress = "E:\wsl_bak\"
FinishFileName = "wsl_startup_completed"
```

脚本内是开了80，443，3306端口，如需增加，格式可以参考下面的。

```vbscript
' 删除3308端口
WshShell.Run "netsh interface portproxy delete v4tov4 listenport=3308 listenaddress=0.0.0.0", vbHide ,True
' 添加3308端口
WshShell.Run "netsh interface portproxy add v4tov4 listenport=3308 listenaddress=0.0.0.0 connectport=3308 connectaddress="+WslIpv4+" protocol=tcp", vbHide ,True
```

`init.wsl`放置在linux虚拟机的`/etc`路径下

需要调整一下`init.wsl`里的一些参数

```shell
# 改一下合法路径即可，文件名不需要改
# wsl里可以直接访问windows的文件，都是挂载在/mnt目录下
finish_file=/mnt/e/wsl_bak/wsl_startup_completed
```

