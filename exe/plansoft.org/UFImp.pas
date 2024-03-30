unit UFImp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit;

type
  TFImp = class(TFormConfig)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    EFilename: TFilenameEdit;
    Label2: TLabel;
    ELOGON: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ECommand1: TEdit;
    ECommand2: TEdit;
    ECommand3: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    bsql: TEdit;
    bimp: TEdit;
    Label8: TLabel;
    bplanner: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EFilenameChange(Sender: TObject);
    procedure ELOGONChange(Sender: TObject);
    procedure bsqlChange(Sender: TObject);
    procedure bimpChange(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure RefreshFields;
  end;

var
  FImp: TFImp;

implementation

{$R *.DFM}

Uses DM, UUtilityParent;

procedure TFImp.BitBtn1Click(Sender: TObject);
begin
  inherited;
  If isBlank(EFilename.Text) Then Begin
    Info('Wybierz plik do zaimportowania');
    Exit;
  End;
  ExecuteFileAndWait(ECommand1.Text);
  ExecuteFileAndWait(ECommand2.Text);
  ExecuteFileAndWait(ECommand3.Text);
  Info('Czynnoœæ zakoñczy³a siê. Zosta³ ponownie utworzony u¿ytkownik '+BPLANNER.Text+' z has³em PLANNER');
end;

procedure TFImp.FormCreate(Sender: TObject);
begin
  inherited;
  dmodule.CloseDBConnection(true);
  RefreshFields;
end;

Procedure TFImp.RefreshFields;
Begin
  ECommand1.Text := BSQL.Text+' '+ELOGON.Text+' @'+ApplicationDir+'\PRE_IMPORT.SQL';
  ECommand2.Text := BIMP.Text+' '+BPLANNER.Text+' FILE='+EFilename.Text+' FULL=Y';
  ECommand3.Text := BSQL.Text+' '+BPLANNER.Text+' @'+ApplicationDir+'\POST_IMPORT.SQL';
End;

procedure TFImp.EFilenameChange(Sender: TObject);
begin
  inherited;
 RefreshFields;
end;

procedure TFImp.ELOGONChange(Sender: TObject);
begin
  inherited;
 RefreshFields;
end;

procedure TFImp.bsqlChange(Sender: TObject);
begin
  inherited;
RefreshFields;
end;

procedure TFImp.bimpChange(Sender: TObject);
begin
  inherited;
RefreshFields;
end;

end.
