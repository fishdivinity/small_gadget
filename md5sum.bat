@echo off & setlocal
goto :start
=生成MD5的脚本
:start
CHCP 936 >nul
if [%1%] == [] ( 
	echo 传参错误，请传文件的绝对地址，如果省略默认当前地址
	goto :EOF
)
certutil -hashfile %1% MD5