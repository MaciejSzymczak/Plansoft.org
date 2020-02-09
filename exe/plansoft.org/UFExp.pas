unit UFExp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFExp = class(TFormConfig)
    BRun: TButton;
    EFolderName: TEdit;
    ECommand: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    procedure BRunClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EProgramChange(Sender: TObject);
    procedure ELoginChange(Sender: TObject);
    procedure EFolderNameChange(Sender: TObject);
    procedure EFolderNameDblClick(Sender: TObject);
  private
    filename : string;
  public
    Procedure RefreshCommand;
  end;

var
  FExp: TFExp;

implementation

{$R *.DFM}

Uses UUtilityParent, DM;

Procedure TFExp.RefreshCommand;
var connString : string;
Begin
 connString :=  dm.UserName+'/'+ dm.Password + '@' + dm.DBname;
 ECommand.Text := 'EXP '+connString+' file='+EFolderName.Text+filename;
 BRun.Caption   := 'Zapisz dane w pliku '+EFolderName.Text+filename;
End;

procedure TFExp.BRunClick(Sender: TObject);
begin
  inherited;
  ExecuteFileAndWait(ECommand.Text);
  If FileExists(EFolderName.Text+filename) Then Info('Czynnoœæ zosta³a zakoñczona, plik zosta³ utworzony')
                                Else Info('Czynnoœæ zosta³a zakoñczona, ale pliku nie odnaleziono ' + EFolderName.Text+filename);
end;

procedure TFExp.FormShow(Sender: TObject);
begin
  inherited;
  filename := Application.Title+'.'+StringToValidFileName(DateTimeToStr(now))+'.dmp';
  RefreshCommand;
end;

procedure TFExp.EProgramChange(Sender: TObject);
begin
  inherited;
  RefreshCommand;
end;

procedure TFExp.ELoginChange(Sender: TObject);
begin
  inherited;
  RefreshCommand;
end;

procedure TFExp.EFolderNameChange(Sender: TObject);
begin
  inherited;
  RefreshCommand;
end;

procedure TFExp.EFolderNameDblClick(Sender: TObject);
begin
  inherited;
  ECommand.Visible := true;
  Label4.Visible := true;
end;

end.
