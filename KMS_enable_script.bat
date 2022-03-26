@ECHO off & setlocal
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"
CHCP 936 >nul
ECHO 这是KMS激活脚本
ECHO 是为了方便激活Winwodows系统编写的
ECHO 内置了一部分KMS激活地址，如果全部无法使用
ECHO 请到KMS服务器列表上面找一下可用的
ECHO https://www.coolhub.top/tech-articles/kms_list.html
ECHO 替换一下可用的服务器域名到脚本即可
ECHO.
ECHO 请等待一段时间，正在检测可用的KMS激活域名

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
  ECHO 脚本内的域名都无法使用，请搜索可用域名
  ECHO https://www.coolhub.top/tech-articles/kms_list.html
  GOTO :END
  )

SET kms_Current.Value=0

FOR /F "usebackq delims==* tokens=1-3" %%I IN (`SET kms_List[%Kms_Index%]`) DO (
  SET kms_Current.%%J=%%K
)

ping %kms_Current.Value% -n 1 >nul
IF %ERRORLEVEL%==0 GOTO :KmsStart

SET /A Kms_Index=%Kms_Index% + 1

GOTO LoopStart

:KmsStart
echo %kms_Current.Value%
echo 这个KMS激活地址可用使用
SET /p choose=是否开始激活[y/n]:
IF "%choose%" equ "Y" (
  slmgr /skms %kms_Current.Value%
  slmgr /ato
  GOTO :END
  )
IF "%choose%" equ "y" (
  slmgr /skms %kms_Current.Value%
  slmgr /ato
  GOTO :END
  )

ECHO 退出激活
:END
endlocal
timeout /T 3 /NOBREAK
EXIT