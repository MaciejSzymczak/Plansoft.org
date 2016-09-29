unit UGGMainDll;

interface
 uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons,Db,DBTables,DBGrids;

procedure MainExportuj( MQ : TQuery; MG : TDBGrid; MT : String; MP : String);
procedure MainMyShowChart( MQ : TQuery; MG : TDBGrid; MT : String; MP : String);
procedure MainDBOpenDll(USER : string; PASS : String; SERVICE : String; H : String);
procedure MainDBCloseDll;

var
 GlobalHandle : THandle;
implementation

procedure MainExportuj( MQ : TQuery; MG : TDBGrid; MT : String; MP : String);
type
 TExportuj = procedure(Q : TQuery;G : TDBGrid; T : string; P : String);
var
 Exportuj : TExportuj;
begin
 try
 if UGGMainDll.GlobalHandle <> 0 then
  begin
   @Exportuj := GetProcAddress(UGGMainDll.GlobalHandle, 'Exportuj');
   if @Exportuj <> nil then
    begin
       Exportuj(MQ,MG,MT,MP);
    end;
  end;
  except
   ShowMessage('B³¹d inicjowania biblioteki dll !');
  end;
end;

procedure MainMyShowChart( MQ : TQuery; MG : TDBGrid; MT : String; MP : String);
type
 TMyShowChart = procedure(Q : TQuery;G : TDBGrid; T : string; P : String);
var
 MyShowChart : TMyShowChart;
begin
 try
 if UGGMainDll.GlobalHandle <> 0 then
  begin
   @MyShowChart := GetProcAddress(UGGMainDll.GlobalHandle, 'MyShowChart');
   if @MyShowChart <> nil then
    begin
       MyShowChart(MQ,MG,MT,MP);
    end;
  end;
  except
   ShowMessage('B³¹d inicjowania biblioteki dll !');
  end;
end;

procedure MainDBOpenDll(USER : string; PASS : String; SERVICE : String; H : String);
type
 TDBOpenDll = function(USER : string; PASS : String; SERVICE : String; H : String) : Boolean;
var
 DBOpenDll : TDBOpenDll;
begin
 try
 UGGMainDll.GlobalHandle := LoadLibrary('exportdll.DLL');
 if UGGMainDll.GlobalHandle <> 0 then
  begin
   @DBOpenDll := GetProcAddress(UGGMainDll.GlobalHandle, 'DBOpenDll');
   if @DBOpenDll <> nil then
    begin
       DBOpenDll(USER,PASS,SERVICE,H);
    end;
  end;
  except
   FreeLibrary(UGGMainDll.GlobalHandle);
   ShowMessage('B³¹d inicjowania biblioteki dll !');
  end;
end;

procedure MainDBCloseDll;
type
 TDBCloseDll = procedure;
var
 DBCloseDll : TDBCloseDll;
begin
 try
 if UGGMainDll.GlobalHandle <> 0 then
  begin
   @DBCloseDll := GetProcAddress(UGGMainDll.GlobalHandle, 'DBCloseDll');
   if @DBCloseDll <> nil then
    begin
       DBCloseDll;
    end;
   FreeLibrary(UGGMainDll.GlobalHandle);
  end;
  except
   FreeLibrary(UGGMainDll.GlobalHandle);
   ShowMessage('B³¹d inicjowania biblioteki dll !');
  end;
end;
end.
