var shell = WScript.CreateObject("WScript.Shell");
var WINSCP = "c:\\Program Files (x86)\\winscp\\winscp.com";
var exec = shell.Exec("\"" + WINSCP + "\" /script=%sftpbin%\\sftp.txt /log=%sftpdata%\\sftp.xml" + "\"");
var output = exec.StdOut.ReadAll();

var ForAppending = 8;
var objFSO = WScript.CreateObject("Scripting.FileSystemObject");
var fileName = 'sftp.log';
var objTextFile = objFSO.OpenTextFile (fileName, ForAppending, true);
objTextFile.WriteLine(output);
objTextFile.close();
