unit UFMemoryStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, ExtCtrls, ComCtrls, Menus;

type
  TFMemoryStatus = class(TForm)
    dwTotalPhys: TEdit;
    dwAvailPhys: TEdit;
    dwTotalPageFile: TEdit;
    dwAvailPageFile: TEdit;
    dwAvailVirtual: TEdit;
    dwTotalVirtual: TEdit;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    dwLength: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    m1: TMenuItem;
    m2: TMenuItem;
    m3: TMenuItem;
    Info1: TMenuItem;
    oprogramie1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure m1Click(Sender: TObject);
    procedure m2Click(Sender: TObject);
    procedure m3Click(Sender: TObject);
    procedure oprogramie1Click(Sender: TObject);
  private
    procedure setMenu;
  public
    { Public declarations }
  end;

var
  FMemoryStatus: TFMemoryStatus;

implementation

{$R *.DFM}

var divideBy : integer;

function ff ( Value: Extended ) : string;
begin
 result := formatFloat('###,###,###,###', value );
 while length(result) < 40 do result := ' ' + result;
end;

procedure TFMemoryStatus.setMenu;
begin
  m1.Checked := false;
  m2.Checked := false;
  m3.Checked := false;
  if divideBy = 1         then m1.Checked := true;
  if divideBy = 1024      then m2.Checked := true;
  if divideBy = 1024*1024 then m3.Checked := true;
end;

procedure TFMemoryStatus.Timer1Timer(Sender: TObject);
Var lpBuffer : TMemoryStatus;
begin
 lpBuffer.dwLength := SizeOf(TMemoryStatus);
 GlobalMemoryStatus(lpBuffer);
 dwLength.Progress    := 100 - lpBuffer.dwMemoryLoad;
 dwTotalPhys.Text     := ff ( lpBuffer.dwTotalPhys div divideBy);
 dwAvailPhys.Text     := ff ( lpBuffer.dwAvailPhys div divideBy);
 dwTotalPageFile.Text := ff ( lpBuffer.dwTotalPageFile div divideBy);
 dwAvailPageFile.Text := ff ( lpBuffer.dwAvailPageFile div divideBy);
 dwTotalVirtual.Text  := ff ( lpBuffer.dwTotalVirtual div divideBy);
 dwAvailVirtual.Text  := ff ( lpBuffer.dwAvailVirtual div divideBy);
end;

procedure TFMemoryStatus.FormCreate(Sender: TObject);
begin
 divideBy := 1024;
 setMenu;
end;

procedure TFMemoryStatus.m1Click(Sender: TObject);
begin
  divideBy := 1;
  setMenu;
end;

procedure TFMemoryStatus.m2Click(Sender: TObject);
begin
  divideBy := 1024;
  setMenu;
end;

procedure TFMemoryStatus.m3Click(Sender: TObject);
begin
 divideBy := 1024 * 1024;
 setMenu;
end;

procedure TFMemoryStatus.oprogramie1Click(Sender: TObject);
begin
 showmessage('2004.10.10 Monitor pamiêci - public domain version. Maciej Szymczak, tel +48 604.22.46.58');
end;

end.
