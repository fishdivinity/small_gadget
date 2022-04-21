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
echo 已获取管理员权限
taskkill /f /im explorer.exe
attrib -s -h -i %userprofile%AppDataLocalIconCache.db
del %userprofile%AppDataLocalIconCache.db /a
attrib +h +s %userprofile%AppDataLocalIconCache.db
start explorer