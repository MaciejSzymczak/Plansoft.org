unit UFModuleSummarySQL;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TFModuleSummarySQL = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    FunkcjaSQL: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Etykietafun: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MyShowWMKolumn(Tryb : String; var E1,E2 : string) : Boolean;

var
  FModuleSummarySQL: TFModuleSummarySQL;

implementation

{$R *.DFM}

function MyShowWMKolumn(Tryb : String; var E1,E2 : string) : Boolean;
var
 w : integer;
 A1,A2 : string;
begin
 try
  FModuleSummarySQL:=TFModuleSummarySQL.Create(nil);
  if Tryb='W' then
   FModuleSummarySQL.Caption:='Wprowad¿ kolumnê'
  else
   begin
    FModuleSummarySQL.Caption:='Edytuj kolumnê';
    FModuleSummarySQL.Etykietafun.Text:=E1;
    FModuleSummarySQL.FunkcjaSQL.Text:=E2;
   end;
  w:=FModuleSummarySQL.ShowModal;
  A1:=FModuleSummarySQL.Etykietafun.Text;
  A2:=FModuleSummarySQL.FunkcjaSQL.Text;
  if (A1='') or (A2='') then
   w:=mrCancel;
  FModuleSummarySQL.Destroy;
  if w=mrOk then
   begin
    E1:=A1;
    E2:=A2;
    Result:=True;
   end
  else
   Result:=False;
 except
  FModuleSummarySQL.Destroy;
  Result:=False;
 end;
end;

end.
