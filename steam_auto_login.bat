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
echo ��ǰ����·���ǣ�%CD%
echo �ѻ�ȡ����ԱȨ��

set account[0]=
set account[1]=
set account[2]=

rem ɱ��steam����
taskkill /f /im steam.exe
taskkill /f /im SteamService.exe
echo ������Steam��¼����(1.�й���2.����˹��3.���)��
rem �����������жϵ�¼�˺�
set /p area=
rem �޸�steamĬ���˻�ע����������Ϊ1�����¼Steam�˺�Ϊ��fishdivinity
if /i %area% == 1 (REG ADD HKEY_CURRENT_USER\SOFTWARE\Valve\Steam /v AutoLoginUser /t REG_SZ /d %account[0]% /f)
if /i %area% == 2 (REG ADD HKEY_CURRENT_USER\SOFTWARE\Valve\Steam /v AutoLoginUser /t REG_SZ /d %account[1]% /f)
if /i %area% == 3 (REG ADD HKEY_CURRENT_USER\SOFTWARE\Valve\Steam /v AutoLoginUser /t REG_SZ /d %account[2]% /f)

rem ����steam��·���ɴ� ���Ҽ�steam��ݼ�->��ݼ���ʽ->Ŀ�ꡱ ��ȡ
start D:\Steam\Steam.exe