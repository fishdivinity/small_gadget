' encoding:GBK
Option Explicit
' WScript.Shell��WshShell�����ProgID
Dim WshShell,ObjShell,ExecObject
Dim vbHide
Dim FinishAddress, FinishFileName
Dim WslIpv4,NetshChangeString
Dim MsgString

FinishAddress = "E:\wsl_bak\"
FinishFileName = "wsl_startup_completed"

' WScript.Shell��WshShell�����ProgID
Set WshShell = WScript.CreateObject("WScript.Shell") 
If WScript.Arguments.Length = 0 Then 
  Set ObjShell = CreateObject("Shell.Application") 
  ObjShell.ShellExecute "wscript.exe" _ 
  , """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1 
  WScript.Quit 
End if

WshShell.Run "wsl -d Ubuntu -u root /etc/init.wsl start", vbHide ,True

Do
If IsExitAFile(FinishAddress + FinishFileName) Then
    WslIpv4 = ReadAFile(FinishAddress + FinishFileName, True)
    DeleteAFile(FinishAddress + FinishFileName)
    Exit Do
Else WScript.Sleep 500
End If
Loop

' ɾ��80�˿�
WshShell.Run "netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0", vbHide ,True
' ���80�˿�
WshShell.Run "netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress="+WslIpv4+" protocol=tcp", vbHide ,True

' ɾ��443�˿�
WshShell.Run "netsh interface portproxy delete v4tov4 listenport=443 listenaddress=0.0.0.0", vbHide ,True
' ���443�˿�
WshShell.Run "netsh interface portproxy add v4tov4 listenport=443 listenaddress=0.0.0.0 connectport=443 connectaddress="+WslIpv4+" protocol=tcp", vbHide ,True

' ɾ��3306�˿�
WshShell.Run "netsh interface portproxy delete v4tov4 listenport=3306 listenaddress=0.0.0.0", vbHide ,True
' ���3306�˿�
WshShell.Run "netsh interface portproxy add v4tov4 listenport=3306 listenaddress=0.0.0.0 connectport=3306 connectaddress="+WslIpv4+" protocol=tcp", vbHide ,True

' ��ӡnetsh interface portproxy show all
Set ExecObject = WshShell.Exec("netsh interface portproxy show all")
MsgString = ExecObject.StdOut.ReadAll()
MsgBox MsgString

' Do
' If IsExitAFile(FinishAddress + FinishFileName) Then
    ' MsgString = ReadAFile(FinishAddress + FinishFileName, False)
    ' DeleteAFile(FinishAddress + FinishFileName)
    ' Exit Do
' Else WScript.Sleep 500
' End If
' Loop

Function CreateAFile(filespec)
	Dim fso,fp
	' ָ��һ������
	Set fso = CreateObject("scripting.filesystemobject")
	' ָ������Ŀ¼���ļ�����
	Set fp = fso.CreateTextFile(filespec, true)
	fp.close
End Function

Function IsExitAFile(filespec)
    Dim fso
    Set fso = CreateObject("Scripting.FileSystemObject")        
    If fso.fileExists(filespec) Then         
	    IsExitAFile = True        
	Else IsExitAFile = False        
    End If
End Function 

Function ReadAFile(filespec,status)
    Dim fso,fp,value
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set fp = fso.OpenTextFile(filespec, 1, False)
	If status = True Then
		value = fp.ReadLine
	Else value = fp.ReadAll
	End If
	ReadAFile = value
	fp.Close()
End Function
	
Sub DeleteAFile(filespec)
    Dim fso
    Set fso = CreateObject("Scripting.FileSystemObject")
    fso.DeleteFile(filespec)
End Sub