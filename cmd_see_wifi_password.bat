@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
chcp 936 >nul
:start
cls
netsh wlan show profile
set /p name=��������Ҫ�鿴�����WIFI���ƣ�
netsh wlan show profile name="%name%" key=clear

call :ColorText 4e "�ؼ���Ϣ����WIFI����"
echo.

set /p area=�Ƿ�����ִ�У�1.�ǣ�2.�񣩣�
if /i %area% == 1 (goto :start)
if /i %area% == 2 (goto :eof)

goto :eof

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof