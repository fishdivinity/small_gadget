@echo off
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
chcp 936 >nul
cd /d "%~dp0"
echo 当前运行路径是：%CD%
echo 已获取管理员权限

set account[0]=
set account[1]=
set account[2]=

rem 杀死steam进程
taskkill /f /im steam.exe
taskkill /f /im SteamService.exe
echo 请输入Steam登录地区(1.中国；2.俄罗斯；3.香港)：
rem 根据输入来判断登录账号
set /p area=
rem 修改steam默认账户注册表。如果输入为1，则登录Steam账号为：fishdivinity
if /i %area% == 1 (REG ADD HKEY_CURRENT_USER\SOFTWARE\Valve\Steam /v AutoLoginUser /t REG_SZ /d %account[0]% /f)
if /i %area% == 2 (REG ADD HKEY_CURRENT_USER\SOFTWARE\Valve\Steam /v AutoLoginUser /t REG_SZ /d %account[1]% /f)
if /i %area% == 3 (REG ADD HKEY_CURRENT_USER\SOFTWARE\Valve\Steam /v AutoLoginUser /t REG_SZ /d %account[2]% /f)

rem 启动steam。路径可从 “右键steam快捷键->快捷键方式->目标” 获取
start D:\Steam\Steam.exe