@echo off & setlocal
goto :start
=c/c++�������Ľű�
=������̼���һ����������֤������GBK�����ϵͳ�����л�ΪUTF-8���ǵ��޸�һ�±������
=�߼���
=��ȡ����(%1% ��һ������)
=����һ���жϺ�������ֹ���Ǵ��Σ����½ű�����
=ͨ��"."���������ж���c����cpp�ļ�(c�ļ���.c��β��c++�ļ���.cpp��β)
=֧�ִ��ļ��ľ��Ե�ַ�����ǲ�֧���ж���"."��û�����ⷽ����ж�
=�������û�д���׺��ֱ���������
=����ͨ����ֱ��ִ��
=���һ���жϺ������ж��Ƿ����ɹ�������ɹ��Ž���ִ��
=���һ��%2���жϣ�����һ���̶��ϵĴ���
:start
if [%1%] == [] ( 
	echo ���δ����봫�ļ��ľ��Ե�ַ�����ʡ��Ĭ�ϵ�ǰ��ַ
	goto :end
)
set file_name=%1%
set temp=%file_name%

for /f "tokens=1,2 delims=��." %%a in ("%temp%") do (
	if "%%b" equ "cpp" (
		g++ %file_name% -fexec-charset=GBK -o %CD%\%%a.exe
		if exist %CD%\%%a.exe (
			echo ����ɹ���
			%CD%\%%a.exe
		)
	goto :end
	)^
	else if "%%b" equ "c" (
		gcc %file_name% -fexec-charset=GBK -o %CD%\%%a.exe
		if exist %CD%\%%a.exe (
			echo ����ɹ���
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
		echo �ļ���ʽ��֧��
	)
)
:end
endlocal
