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
ECHO ����KMS����ű�
ECHO ��Ϊ�˷��㼤��Winwodowsϵͳ��д��
ECHO ������һ����KMS�����ַ�����ȫ���޷�ʹ��
ECHO �뵽KMS�������б�������һ�¿��õ�
ECHO https://www.coolhub.top/tech-articles/kms_list.html
ECHO �滻һ�¿��õķ������������ű�����
ECHO.
ECHO ��ȴ�һ��ʱ�䣬���ڼ����õ�KMS��������

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
  ECHO �ű��ڵ��������޷�ʹ�ã���������������
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
echo ���KMS�����ַ����ʹ��
SET /p choose=�Ƿ�ʼ����[y/n]:
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

ECHO �˳�����
:END
endlocal
timeout /T 3 /NOBREAK
EXIT