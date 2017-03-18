unit UFInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFInfoParent, StdCtrls, Buttons, ExtCtrls;

type
  TFInfo = class(TFInfoParent)
    procedure BOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInfo: TFInfo;

Procedure ShowModal;

implementation

{$R *.DFM}

Procedure ShowModal;
Begin
 With TFInfo.Create(Application) Do Begin
  ShowModal;
  Free;
 End;
End;


procedure TFInfo.BOKClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
