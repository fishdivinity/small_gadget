@echo off & setlocal
goto :start
=����MD5�Ľű�
:start
CHCP 936 >nul
if [%1%] == [] ( 
	echo ���δ����봫�ļ��ľ��Ե�ַ�����ʡ��Ĭ�ϵ�ǰ��ַ
	goto :EOF
)
certutil -hashfile %1% MD5