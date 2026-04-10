On Error Resume Next

retryhome=getEnv("RETRYHOME")
statusMessage=SFTPStatus(retryhome&"\Retry.txt",retryhome&"\Retry.Process.sftp.xml")

writeLog("Start...")
if statusMessage<>"OK" then
    writeLog("Upload failed, retry will resolve the issue")	
else
   Set obj = CreateObject("Scripting.FileSystemObject")
   obj.DeleteFile(retryhome&"\*.csv") 'Deletes all files with the extension .csv in the folder MyFolder    
   If Err.Number <> 0 Then
       writeLog("Delete csv: " & Err.Number & " Error (Hex): " & Hex(Err.Number) & " Source: " &  Err.Source & " Description: " &  Err.Description)
       Err.Clear
   End If
   obj.DeleteFile(retryhome&"\*.utf8")  
   If Err.Number <> 0 Then
       writeLog("Delete utf8: " & Err.Number & " Error (Hex): " & Hex(Err.Number) & " Source: " &  Err.Source & " Description: " &  Err.Description)
       Err.Clear
   End If
   writeLog("Upload OK.")	
end if
writeLog("End...")


'----------------------------------
Function getFileName (filePath)
	rem p = "C:\Automation\results\file.txt"
	rem i = instrrev(p, "\", -1)
	rem d = left(p, i-1)
	rem f = mid(p, i+1)
	rem p=C:\Automation\results\file.txt
	rem d=C:\Automation\results
	rem f=file.txt
	p = filePath
	i = instrrev(p, "\", -1)
	d = left(p, i-1)
	f = mid(p, i+1)
	getFileName = f
End Function

'----------------------------------
Function FileExists (fileName)
    Set fso = CreateObject("Scripting.FileSystemObject")
    If (fso.FileExists(fileName)) Then
	    FileExists= True
    Else
	    FileExists= False
	End if
	Set fso = Nothing
End Function


'----------------------------------
Function FileIsEmpty (fileName)
    Set fso = CreateObject("Scripting.FileSystemObject")
	rem WScript.Echo "FileIsEmpty: " & fileName
    If fso.GetFile(fileName).size = 0 Then
	    FileIsEmpty= True
    Else
	    FileIsEmpty= False
	End if
	Set fso = Nothing
End Function


'----------------------------------
Function FileContains (fileName, findString)
    if not FileExists(fileName) then
	  FileContains= false
	  Exit Function
	end if
    if FileIsEmpty(fileName) then
	  FileContains= false
	  Exit Function
	end if
	Dim objFSO, strData
	CONST ForReading = 1
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	strData = objFSO.OpenTextFile(fileName,ForReading).ReadAll
	FileContains = InStr(strData, findString)<>0
	Set objFSO = Nothing
End Function


'----------------------------------
Function SFTPStatus(sftpLog, sftpXmlLog)
    If not FileExists(sftpLog) Then
	    SFTPStatus = "FATAL ERROR: No log: " & getFileName(sftpLog)
		Exit Function
    End If	
    If FileContains(sftpLog," does not exist.") Then
	    SFTPStatus = "FATAL ERROR: Connection problems: " & getFileName(sftpLog)
		Exit Function
    End If	
    If FileExists(sftpXmlLog) Then
		If FileContains(sftpXmlLog,"<failure>") Then
			SFTPStatus = "FATAL ERROR: " & getFileName(sftpXmlLog)
			Exit Function
		End If	
    End If	
	SFTPStatus = "OK"	
End Function

'----------------------------------
Function getEnv (varName)
	Set WshShell = CreateObject("WScript.Shell")
	Set objEnv = WshShell.Environment("Process")
	getEnv = objEnv(varName)
	Set WshShell = Nothing
	Set objEnv = Nothing
	'the other method: CreateObject("WScript.Shell").ExpandEnvironmentStrings("%CONFHOME%")
End Function

'----------------------------------
Sub writeLog(m)
    curDate = Year(Now) & "_" & Month(Now) & "_" & Day(Now) & "_" & Time
    outFile=retryhome&"\errors.log"
    Dim fso, MyFile
	Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set MyFile = fso.OpenTextFile(outFile, ForAppending, True)
    MyFile.WriteLine(curDate & " " & m)
    MyFile.Close
End Sub
