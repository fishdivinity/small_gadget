@ECHO off & setlocal
REM author：fishdivinity
REM https://github.com/fishdivinity/small_gadget/blob/master/KMS_enable_script.bat
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"
reg add HKEY_CURRENT_USER\Console /v QuickEdit /t REG_DWORD /d 00000000 /f > nul
CHCP 936 >nul
ECHO 这是KMS激活脚本
ECHO 是为了方便激活Winwodows系统编写的
ECHO 内置了一部分KMS激活地址，如果全部无法使用
ECHO 请到KMS服务器列表上面找一下可用的
ECHO https://www.coolhub.top/tech-articles/kms_list.html
ECHO 替换一下可用的服务器域名到脚本即可
ECHO.

ECHO 如果之前激活时有0xC0020036错误：在Windows非核心版本的计算机上
ECHO 可以选择卸载密钥并重新安装密钥
ECHO.

SET /p choose=是否选择重装密钥[y/n]:
REM 激活码是网上找的win10专业版
IF "%choose%" equ "Y" (
  slmgr /upk
  slmgr /ipk TPYNC-4J6KF-4B4GP-2HD89-7XMP6
  )
IF "%choose%" equ "y" (
  slmgr /upk
  slmgr /ipk TPYNC-4J6KF-4B4GP-2HD89-7XMP6
  )
ECHO 请等待一段时间，正在检测可用的KMS激活域名地址

SET kms_List[0]*Value=kms.loli.beer
SET kms_List[1]*Value=kms.loli.best
SET kms_List[2]*Value=kms.03k.org
SET kms_List[3]*Value=kms.cangshui.net
SET kms_List[4]*Value=kms.cary.tech
SET kms_List[5]*Value=kms.catqu.com
SET kms_List[6]*Value=kms.cgtsoft.com
SET kms_List[7]*Value=kms.ghpym.com
SET kms_List[8]*Value=kms.mc06.net
SET kms_List[9]*Value=kms.moeyuuko.top

SET Kms_Length=10
SET Kms_Index=0


:LoopStart
IF %Kms_Index% EQU %Kms_Length% (
  ECHO 脚本内的域名都无法使用，请搜索可用域名地址
  ECHO https://www.coolhub.top/tech-articles/kms_list.html
  GOTO :END
  )

SET kms_Current.Value=0

FOR /F "usebackq delims==* tokens=1-3" %%I IN (`SET kms_List[%Kms_Index%]`) DO (
  SET kms_Current.%%J=%%K
)

REM 如果出现假死，则是因为cmd的快速编辑模式愿意
REM 解决方案一：执行过程中，出现假死，随便输入一个字符
REM 解决方案二：将下面的stdout重定向到nul的代码删掉

REM ping %kms_Current.Value% -n 1
ping %kms_Current.Value% -n 1 >nul

IF %ERRORLEVEL%==0 GOTO :KmsStart

SET /A Kms_Index=%Kms_Index% + 1

GOTO LoopStart

:KmsStart
echo %kms_Current.Value%
echo 这个KMS激活地址可以使用
SET /p choose=是否开始激活[y/n]:
IF "%choose%" equ "Y" (
  REM 解决部分用户KMS激活时的错误：0x80072EE2在运行Microsoft Windows非核心版本的计算上，运行slui.exe
  REM 大部分介绍，0x80072EE2错误码皆是因为Windows Update服务没有开启导致的
  REM 下面的代码分别是启动了Windows Update服务、BITS (后台智能传送服务) 、DCOM Server Process Launcher协议
  sc config wuauserv start=auto >nul
  sc config bits start=auto >nul
  sc config DcomLaunch start=auto >nul
  net stop wuauserv >nul
  net start wuauserv >nul
  net stop bits >nul
  net start bits >nul
  net stop DcomLaunch >nul
  net start DcomLaunch >nul
  REM 开始激活
  slmgr /skms %kms_Current.Value%
  slmgr /ato
  GOTO :END
  )
IF "%choose%" equ "y" (
  REM 解决部分用户KMS激活时的错误：0x80072EE2在运行Microsoft Windows非核心版本的计算上，运行slui.exe
  REM 大部分介绍，0x80072EE2错误码皆是因为Windows Update服务没有开启导致的
  REM 下面的代码分别是启动了Windows Update服务、BITS (后台智能传送服务) 、DCOM Server Process Launcher协议
  sc config wuauserv start=auto >nul
  sc config bits start=auto >nul
  sc config DcomLaunch start=auto >nul
  net stop wuauserv >nul
  net start wuauserv >nul
  net stop bits >nul
  net start bits >nul
  net stop DcomLaunch >nul
  net start DcomLaunch >nul
  REM 开始激活
  slmgr /skms %kms_Current.Value%
  slmgr /ato
  GOTO :END
  )

ECHO 退出激活
:END
endlocal
timeout /T 3 /NOBREAK
EXIT