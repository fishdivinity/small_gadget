@echo off & setlocal
goto :start
=c/c++方便编译的脚本
=编译过程加入一个参数，保证编码是GBK，如果系统编码切换为UTF-8，记得修改一下编译参数
=逻辑：
=获取传参(%1% 第一个参数)
=加入一个判断函数，防止忘记传参，导致脚本错误
=通过"."拆解参数，判断是c还是cpp文件(c文件以.c结尾，c++文件以.cpp结尾)
=支持传文件的绝对地址，但是不支持有多余"."，没有做这方面的判断
=如果传参没有传后缀会直接输出错误
=编译通过会直接执行
=添加一个判断函数，判断是否编译成功，编译成功才进行执行
=添加一个%2的判断，允许一定程度上的传参
:start
if [%1%] == [] ( 
	echo 传参错误，请传文件的绝对地址，如果省略默认当前地址
	goto :end
)
set file_name=%1%
set temp=%file_name%

for /f "tokens=1,2 delims=：." %%a in ("%temp%") do (
	if "%%b" equ "cpp" (
		g++ %file_name% -fexec-charset=GBK -o %CD%\%%a.exe
		if exist %CD%\%%a.exe (
			echo 编译成功！
			%CD%\%%a.exe
		)
	goto :end
	)^
	else if "%%b" equ "c" (
		gcc %file_name% -fexec-charset=GBK -o %CD%\%%a.exe
		if exist %CD%\%%a.exe (
			echo 编译成功！
			%CD%\%%a.exe
		)
	goto :end
	)^
	else if "%%b" equ "cxx" (
		g++ %file_name% -fexec-charset=GBK -o %CD%\%%a.exe
		if exist %CD%\%%a.exe (
			%CD%\%%a.exe
		)
	goto :end
	)^
	else (
		echo 文件格式不支持
	)
)
:end
endlocal
