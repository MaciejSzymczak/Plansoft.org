unit UFMessageBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFMessageBox = class(TFormConfig)
    Panel1: TPanel;
    BClose: TBitBtn;
    Message: TMemo;
    BitBtn1: TBitBtn;
    procedure BCloseClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMessageBox: TFMessageBox;

implementation

Uses UUtilityParent;

{$R *.dfm}

procedure TFMessageBox.BCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFMessageBox.BitBtn1Click(Sender: TObject);
begin
  CopyToClipboard(Message.Text);
end;

end.
