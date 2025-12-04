unit FVersions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFVersion = class(TFormConfig)
    Main: TPageControl;
    Tab1: TTabSheet;
    tab2: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Confirm: TCheckBox;
    Memo1: TMemo;
    Run: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ver_name: TEdit;
    PeriodName: TEdit;
    OwnerName: TEdit;
    Tab3: TTabSheet;
    BitBtn3: TBitBtn;
    details: TPanel;
    Label4: TLabel;
    name: TEdit;
    Label5: TLabel;
    per: TEdit;
    Label6: TLabel;
    date_from: TEdit;
    Label7: TLabel;
    date_to: TEdit;
    Label8: TLabel;
    planners: TEdit;
    Label9: TLabel;
    Role: TEdit;
    ver_id: TEdit;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ConfirmClick(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    procedure showReport;
  public
    { Public declarations }
  end;

var
  FVersion: TFVersion;

implementation

uses UFMain, UUtilityParent, DM, UProgress, UFLookupWindow, adodb;

{$R *.dfm}

procedure TFVersion.FormShow(Sender: TObject);
begin
  inherited;
  Main.ActivePage := tab1;
  tab1.Visible := true;
  tab2.Visible := false;
  tab3.Visible := false;
  PeriodName.Text := Fmain.CONPERIOD_VALUE.text;
  OwnerName.Text := CurrentUserName;
  ver_name.Text := Fmain.CONPERIOD_VALUE.text + ' | ' + FormatDateTime('yyyy-mm-dd hh:nn', Now);
end;

procedure TFVersion.BitBtn1Click(Sender: TObject);
begin
  inherited;
  Main.ActivePage := tab2;
  tab1.Visible := false;
  tab2.Visible := true;
  tab3.Visible := false;
end;


procedure TFVersion.ConfirmClick(Sender: TObject);
begin
  inherited;
  Run.Enabled := Confirm.Checked;
end;

procedure TFVersion.RunClick(Sender: TObject);
begin
try
  FProgress.Show;
  FProgress.ProgressBar.Position :=  50;
  FProgress.Refresh;
  with dmodule.QWork do begin
      SQL.Clear;
      SQL.Add('begin version_pkg.createVersion (:ver_name, :per_id, :planners, :userOrRoleID); end;');
      Parameters.ParamByName('ver_name').value := ver_name.Text;
      Parameters.ParamByName('per_id').value := fmain.conPeriod.Text;
      Parameters.ParamByName('planners').value := OwnerName.Text;
      Parameters.ParamByName('userOrRoleID').value := fmain.getUserOrRoleID();
      execSQL;
  end;
  FProgress.Hide;
  dmodule.CommitTrans;
  Info('Wersja '+ver_name.Text+' utworzona!');
  Close;
except
  on E:exception do Begin
     FProgress.Hide;
     dmodule.errorMessage(-1, Self, E.Message);
  End Else begin
     FProgress.Hide;
     raise;
  end;
end;
end;

procedure TFVersion.BitBtn3Click(Sender: TObject);
var id : shortString;
begin
  inherited;
  If LookupWindow(false, DModule.ADOConnection, 'versions','ID','name','Nazwa','Name','CREATED_BY = user','',id,'500,100') = mrOK Then Begin
    Dmodule.SingleValue('select id, name, date_from, date_to, planners, (select name from periods where id=per_id), (select name from planners where id=userorroleid) from versions where id='+id);
    ver_id.Text :=  dmodule.QWork.Fields[0].AsString;
    name.Text := dmodule.QWork.Fields[1].AsString;
    per.Text :=  dmodule.QWork.Fields[2].AsString;
    date_from.Text := dmodule.QWork.Fields[3].AsString;
    date_to.Text := dmodule.QWork.Fields[4].AsString;
    planners.Text := dmodule.QWork.Fields[5].AsString;
    Role.Text := dmodule.QWork.Fields[6].AsString;
    details.Visible := true;
  end;
end;

procedure TFVersion.BitBtn2Click(Sender: TObject);
begin
  Main.ActivePage := tab3;
  tab1.Visible := false;
  tab2.Visible := false;
  tab3.Visible := true;
  details.Visible := false;
end;

procedure TFVersion.BitBtn4Click(Sender: TObject);
var id : shortString;
begin
try
  FProgress.Show;
  FProgress.ProgressBar.Position :=  50;
  FProgress.Refresh;
  with dmodule.QWork do begin
      SQL.Clear;
      SQL.Add('begin version_pkg.restoreVersion (:ver_id); end;');
      Parameters.ParamByName('ver_id').value := ver_id.Text;
      execSQL;
  end;
  FProgress.Hide;

  dmodule.SingleValue('select count(1) from version_restore_messages where ver_id = ' + ver_id.Text);
  if dmodule.QWork.Fields[0].AsInteger>0 then
   showReport
  else begin
    dmodule.CommitTrans;
    Info('Wersja zosta³a przywrócona');
    FMain.deepRefreshDelayed;
    Close;
  end;
except
  on E:exception do Begin
     FProgress.Hide;
     dmodule.errorMessage(-1, Self, E.Message);
  End Else begin
     FProgress.Hide;
     raise;
  end;
end;
end;

procedure TFVersion.showReport;
var tmpFile : textfile;
    sqlstmt : string;
    query : tadoquery;
begin
  query := tadoquery.Create(self);
  dmodule.resetConnection ( query );

  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'version_restore_messages.html');
  rewrite(tmpFile);

  query.SQL.Clear;
  query.SQL.Add( 'select version_pkg.getReport('+ver_id.Text+') from dual' );
  query.Open;
  writeln(tmpFile, UTF8Encode (query.Fields[0].AsString));

  closeFile(tmpFile);
  ExecuteFile(uutilityParent.ApplicationDocumentsPath +'version_restore_messages.html','','',SW_SHOWMAXIMIZED);
end;

procedure TFVersion.BitBtn5Click(Sender: TObject);
begin
try
  FProgress.Show;
  FProgress.ProgressBar.Position :=  50;
  FProgress.Refresh;
  with dmodule.QWork do begin
      SQL.Clear;
      SQL.Add('begin delete from versions where id = :ver_id; end;');
      Parameters.ParamByName('ver_id').value := ver_id.Text;
      execSQL;
  end;
  FProgress.Hide;
  details.Visible := false;
  dmodule.CommitTrans;
  Info('Wersja '+name.text+' zosta³a skasowana');
except
  on E:exception do Begin
     FProgress.Hide;
     dmodule.errorMessage(-1, Self, E.Message);
  End Else begin
     FProgress.Hide;
     raise;
  end;
end;
end;


end.
