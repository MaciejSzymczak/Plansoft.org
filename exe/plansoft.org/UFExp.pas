unit UFExp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit;

type
  TFExp = class(TFormConfig)
    BRun: TButton;
    ECommand: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    EFolderName: TDirectoryEdit;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    procedure BRunClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EProgramChange(Sender: TObject);
    procedure ELoginChange(Sender: TObject);
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure DirectoryEdit1DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
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
 ECommand.Text := 'EXP '+connString+' file='+EFolderName.Text+'\'+filename;
End;

procedure TFExp.BRunClick(Sender: TObject);
begin
  inherited;
  ExecuteFileAndWait(ECommand.Text);
  If FileExists(EFolderName.Text+'\'+filename) Then begin
      Info('Utworzono plik');
      ShowFolder(EFolderName.Text);
  end
  Else Info('Pliku nie utworzono, coœ posz³o nie tak. ' + EFolderName.Text+'\'+filename);
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

procedure TFExp.DirectoryEdit1Change(Sender: TObject);
begin
  RefreshCommand;
end;

procedure TFExp.DirectoryEdit1DblClick(Sender: TObject);
begin
  ECommand.Visible := true;
  Label4.Visible := true;
end;

procedure TFExp.SpeedButton2Click(Sender: TObject);
begin
  ShowFolder(EFolderName.text);
end;

procedure TFExp.BitBtn1Click(Sender: TObject);
begin
  close;

end;

end.
