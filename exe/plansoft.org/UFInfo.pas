unit UFInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFInfoParent, StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TFInfo = class(TFInfoParent)
    Label1: TLabel;
    lversion: TLabel;
    Label2: TLabel;
    procedure BOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInfo: TFInfo;

Procedure ShowModal;

implementation

uses DM;

{$R *.DFM}

Procedure ShowModal;
Begin
 FInfo := TFInfo.Create(Application);
 FInfo.ShowModal;
 FInfo.Free;
End;

procedure TFInfo.BOKClick(Sender: TObject);
begin
  inherited;
  Close;         
end;

procedure TFInfo.FormShow(Sender: TObject);
begin
  inherited;
  lversion.caption := dmodule.dbGetSystemParam( 'PLANOWANIE.VERSION_INFO' );
  mlicencja.Text   := dmodule.dbGetSystemParam( 'PLANOWANIE.LICENCE_FOR'  );
end;

end.
