unit UFGoogleMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, DB, ADODB, dm, uutilityParent;

type
  TFGoogleMap = class(TFormConfig)
    topPanel: TPanel;
    BCreate: TSpeedButton;
    BClose: TSpeedButton;
    googleMap: TADOQuery;
    showAll: TCheckBox;
    markerwithlabeljs: TMemo;
    map: TMemo;
    pmapTypeId: TComboBox;
    Label3: TLabel;
    procedure BCreateClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGoogleMap: TFGoogleMap;

implementation

uses UFMain;

{$R *.dfm}

procedure TFGoogleMap.BCreateClick(Sender: TObject);
var tmpFile : textfile;
    sqlstmt : string;
begin
  if not elementEnabled('"Tworzenie mapy"','2014.01.15', false) then exit;

  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'markerwithlabel.js');
  rewrite(tmpFile);
  writeln(tmpFile, markerwithlabeljs.lines.Text );
  closeFile(tmpFile);

  googleMap.SQL.Clear;
  sqlstmt := format('select google_map.getMap(''%s'', ''%s'', ''%s'', ''%s'') from dual',
                 [
                  FMain.getUserOrRoleID
                , iif(showAll.Checked,'Y','N')
                , '16'
                , map.Lines.Values[pmapTypeId.Text]
                ]);
  googleMap.SQL.Add( sqlstmt );
  try
  googleMap.Open;
  except
   on e:exception do begin
       copyToClipboard( sqlstmt );
       info('Ups.. Wygl¹da na to, ¿e modu³ generowania mapy Google nie zosta³ zainstalowany, skontaktuj siê administratorem systemu.'+cr+'Je¿eli posiadasz aktywn¹ umowê serwisow¹ firma Software Factory pomo¿e w rozwi¹zaniu problemu, zadzwoñ pod numer +48 604224658. '+cr+cr+e.message);
       exit;
   end;
  end;
  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'tmpgooglemap.html');
  rewrite(tmpFile);
  writeln(tmpFile, googleMap.Fields[0].AsString);
  closeFile(tmpFile);

  ExecuteFile(uutilityParent.ApplicationDocumentsPath +'tmpgooglemap.html','','',SW_SHOWMAXIMIZED);
end;

procedure TFGoogleMap.BCloseClick(Sender: TObject);
begin
  Close;
end;

end.
