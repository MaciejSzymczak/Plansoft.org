unit UFCopyClasses;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFCopyClasses = class(TFormConfig)
    source_date_from: TDateTimePicker;
    Label1: TLabel;
    source_date_to: TDateTimePicker;
    dest_date_from: TDateTimePicker;
    Label4: TLabel;
    dest_date_to: TDateTimePicker;
    Panel1: TPanel;
    Anuluj: TBitBtn;
    BExecute: TBitBtn;
    OwnClasses: TRadioGroup;
    dest_period_must_be_empty: TCheckBox;
    whichSheets: TRadioGroup;
    BSelectSheet: TBitBtn;
    BSelectPeriodFrom: TBitBtn;
    BSelectPeriodTo: TBitBtn;
    Label2: TLabel;
    procedure dest_date_fromChange(Sender: TObject);
    procedure BExecuteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AnulujClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure whichSheetsClick(Sender: TObject);
    procedure BSelectSheetClick(Sender: TObject);
    procedure BSelectPeriodFromClick(Sender: TObject);
    procedure BSelectPeriodToClick(Sender: TObject);
  private
    gCanCloseQuery : boolean;
    keyValue    : shortString;
    keyValueDsp : shortString;
    procedure refreshButtonCaption;
  public
  end;

var
  FCopyClasses: TFCopyClasses;

implementation

{$R *.dfm}

uses uutilityparent, DM, DB, UFMain, autocreate, UFProgramSettings;

procedure TFCopyClasses.FormShow(Sender: TObject);
begin
  inherited;
  whichSheets.Items.CommaText := FProgramSettings.translateMessages ( whichSheets.Items.CommaText );

  gCanCloseQuery := true;
  whichSheetsClick(nil);
end;


procedure TFCopyClasses.dest_date_fromChange(Sender: TObject);
begin
  dest_date_to.DateTime := dest_date_from.DateTime + (source_date_to.DateTime - source_date_from.DateTime);
end;

procedure TFCopyClasses.BExecuteClick(Sender: TObject);
var error_message : string;
    cnt           : string;
begin
 source_date_from.Time := 0;
 source_date_to.Time   := 0;
 dest_date_from.Time   := 0;

 gCanCloseQuery := false;

 if (whichSheets.ItemIndex <> 3) and (keyValue = '') then
 begin
  info('W celu kontynuacji wybierz arkusz do skopiowania');
  exit;
 end;

 if dayOfWeek(source_date_from.datetime) <> dayOfWeek(dest_date_from.datetime) then
   if question('Zwróæ uwagê, ¿e okres Ÿród³owy i docelowy zaczynaj¹ siê w ró¿nych dniach tygodnia. Czy chcesz kontynuowaæ ?') <> id_yes then exit;

 try
  with dmodule.QWork do begin
    SQL.Clear;
    SQL.Add('begin planner_utils.copy_data(:source_date_from, :source_date_to, :dest_date_from, :dest_period_must_be_empty, :own_classes, :planner_id, :selected_lec_id, :selected_gro_id, :selected_res_id); end;');
    //it was:   ParamByName('source_date_from').asDateTime    := source_date_from.datetime; @@@test it
    parameters.ParamByName('source_date_from').value      := source_date_from.datetime;
    parameters.ParamByName('source_date_to').value        := source_date_to.datetime;
    parameters.ParamByName('dest_date_from').value        := dest_date_from.datetime;
    parameters.ParamByName('own_classes').value           := iif(OwnClasses.ItemIndex = 0, 'Y', 'N');
    parameters.ParamByName('dest_period_must_be_empty').value:= iif( dest_period_must_be_empty.checked , 'Y', 'N');
    parameters.ParamByName('planner_id').value            := FMain.getUserOrRoleID;
    parameters.ParamByName('selected_lec_id').value       := iif(whichSheets.ItemIndex = 0,keyValue,'-1');
    parameters.ParamByName('selected_gro_id').value       := iif(whichSheets.ItemIndex = 1,keyValue,'-1');
    parameters.ParamByName('selected_res_id').value       := iif(whichSheets.ItemIndex = 2,keyValue,'-1');
    // does not work in BDE: Ora-6502 String buffer is to small; no return value is passed
    //ParamByName('error_message').DataType      := ftString;
    //ParamByName('error_message').Size          := 255;
    //ParamByName('error_message').AsString      := error_message;
    //ParamByName('error_message').ParamType     := ptOutput;
    execSQL;
  end;
  error_message := dmodule.SingleValue('select planner_utils.get_output_param_char1 from dual');
  if error_message = '' then
  begin
    cnt := dmodule.SingleValue('select planner_utils.get_output_param_num1, planner_utils.get_output_param_num2 from dual');
    info ('Czynnoœæ zosta³a wykonana. '+cr+'Skopiowano nastêpuj¹c¹ liczbê rekordów: ' + cnt+ cr + ' Nie skopiowano nastêpuj¹cej liczy rekordów z powodu konfliktów:'+ dmodule.QWork.Fields[1].AsString );
    gCanCloseQuery := true;
  end
  else
  begin
    info('Czynnoœæ nie powiod³a sie z powodu nastêpuj¹cego b³êdu:' + cr + cr + error_message);
  end;
 except
   on E:exception do Begin
     Dmodule.RollbackTrans;
     info('Czynnoœæ nie powiod³a sie z powodu nastêpuj¹cego b³êdu:' + cr + cr + E.Message);
   end;
 end;
end;


procedure TFCopyClasses.AnulujClick(Sender: TObject);
begin
 gCanCloseQuery := true;
end;

procedure TFCopyClasses.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CanClose := gCanCloseQuery;
  gCanCloseQuery := true;
end;

procedure TFCopyClasses.FormCreate(Sender: TObject);
begin
  source_date_from.DateTime := now();
  source_date_to.DateTime := now();
  dest_date_from.DateTime := now();
  dest_date_to.DateTime := now();
  keyValue    := '';
  keyValueDsp := '';
end;

procedure TFCopyClasses.whichSheetsClick(Sender: TObject);
begin
  inherited;
  BSelectSheet.Visible := whichSheets.ItemIndex <> 3;
  keyValue    := '';
  keyValueDsp := '';

  refreshButtonCaption;
end;

procedure TFCopyClasses.BSelectSheetClick(Sender: TObject);
var modalResult : tmodalresult;
begin
  keyValue    := '';
  keyValueDsp := '';
  case whichSheets.ItemIndex of
   0: modalResult := LECTURERSShowModalAsSelect(KeyValue,'','0=0','');
   1: modalResult := GROUPSShowModalAsSelect(KeyValue,'','0=0','');
   2: modalResult := ROOMSShowModalAsSelect(dmodule.pResCatId0,'',KeyValue,'0=0','');
  end;

  if modalResult <> mrOK Then begin info('Anulowano czynnoœæ wyboru arkusza do skopiowania'); exit; end;

  case whichSheets.ItemIndex of
   0: keyValueDsp := dmodule.SingleValue(dm.sql_LECDESC+keyValue);
   1: keyValueDsp := dmodule.SingleValue(dm.sql_GRODESC+keyValue);
   2: keyValueDsp := dmodule.SingleValue(dm.sql_ResCat0DESC+keyValue);
  end;

  refreshButtonCaption;
end;

procedure TFCopyClasses.refreshButtonCaption;
begin
  if keyValue = '' then
    BSelectSheet.Caption := 'Kliknij tu, aby wybraæ arkusz do skopiowania'
  else
  begin
    case whichSheets.ItemIndex of
     0: BSelectSheet.Caption := FProgramSettings.translateMessages ( '%L.: ') + keyValueDsp;
     1: BSelectSheet.Caption := FProgramSettings.translateMessages ( '%G.: ') + keyValueDsp;
     2: BSelectSheet.Caption :=  'Zasób: ' + keyValueDsp;
    end;
  end;
end;

procedure TFCopyClasses.BSelectPeriodFromClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := fmain.conPeriod.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
    With DModule do begin
        Dmodule.SingleValue('SELECT TO_CHAR(DATE_FROM,''YYYY''),TO_CHAR(DATE_FROM,''MM''),TO_CHAR(DATE_FROM,''DD''),TO_CHAR(DATE_TO,''YYYY''),TO_CHAR(DATE_TO,''MM''),TO_CHAR(DATE_TO,''DD'') FROM PERIODS WHERE ID='+KeyValue);
        source_date_from.Date := EncodeDate(QWork.Fields[0].AsInteger,QWork.Fields[1].AsInteger,QWork.Fields[2].AsInteger);
        source_date_to.Date := EncodeDate(QWork.Fields[3].AsInteger,QWork.Fields[4].AsInteger,QWork.Fields[5].AsInteger);
    End;
  End;
end;

procedure TFCopyClasses.BSelectPeriodToClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := fmain.conPeriod.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
    With DModule do begin
        Dmodule.SingleValue('SELECT TO_CHAR(DATE_FROM,''YYYY''),TO_CHAR(DATE_FROM,''MM''),TO_CHAR(DATE_FROM,''DD''),TO_CHAR(DATE_TO,''YYYY''),TO_CHAR(DATE_TO,''MM''),TO_CHAR(DATE_TO,''DD'') FROM PERIODS WHERE ID='+KeyValue);
        dest_date_from.Date := EncodeDate(QWork.Fields[0].AsInteger,QWork.Fields[1].AsInteger,QWork.Fields[2].AsInteger);
        dest_date_fromChange(nil);
    End;
  End;
end;

end.
