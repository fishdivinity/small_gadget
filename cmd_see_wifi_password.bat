@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
chcp 936 >nul
:start
cls
netsh wlan show profile
set /p name=请输入你要查看密码的WIFI名称：
netsh wlan show profile name="%name%" key=clear

call :ColorText 4e "关键信息就是WIFI密码"
echo.

set /p area=是否重新执行（1.是；2.否）：
if /i %area% == 1 (goto :start)
if /i %area% == 2 (goto :eof)

goto :eof

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof