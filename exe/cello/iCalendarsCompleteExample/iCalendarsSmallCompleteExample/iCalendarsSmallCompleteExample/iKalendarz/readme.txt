How to install

0/ Create period name iKalendarz
   Create authorization iKalendarz
   Setup automatic publication into folder: c:\plansoftOrg\iKalendarz\bin (and /data)
   Generate json file
1/ Copy files bin/data/doc
   ! update conf.bat
   ! sftp.bat (paths and replace wme with your_folder_name)
   ! sftp.txt (replace wme with your_folder_name)
2/ Schedule publikacja.exe, sftp.exe and sync.exe
   ! Instruct user there must be 3 items in tryicons
3/ copy "copy_it_on_ftp_server"
	edit file wme.html -> replace wme with your_folder_name (line <script src="wme.js"></script>)
	rename file wme.html -> your_folder_name.html
