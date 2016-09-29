unit UFCreatingUniqueIndexes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFCreatingUniqueIndexes = class(TForm)
    Label1: TLabel;
    T_N: TEdit;
    Label2: TLabel;
    C_N: TEdit;
    Label3: TLabel;
    PK: TEdit;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    AN: TEdit;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCreatingUniqueIndexes: TFCreatingUniqueIndexes;

implementation

{$R *.DFM}

procedure TFCreatingUniqueIndexes.BitBtn1Click(Sender: TObject);
begin
 Memo1.Lines.Clear;
 Memo1.Lines.Add('UPDATE '+T_N.Text+' SET '+C_N.Text+' = '+C_N.Text+'||'+PK.Text+' WHERE '+C_N.Text+' IN (SELECT '+C_N.Text+' FROM (SELECT '+C_N.Text+', COUNT(*) FROM '+T_N.Text+' GROUP BY '+C_N.Text+' HAVING COUNT(*) > 1));');
 Memo1.Lines.Add('CREATE UNIQUE INDEX '+AN.Text+'_'+C_N.Text+'_I ON '+T_N.TEXT+' ('+C_N.Text+');');
end;

end.
