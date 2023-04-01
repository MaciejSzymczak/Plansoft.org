unit UFConsolidation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFConsolidation = class(TFormConfig)
    PageControl1: TPageControl;
    TabSheet: TTabSheet;
    BNext: TBitBtn;
    Memo2: TMemo;
    TabSheetPage2: TTabSheet;
    consolidationKind: TRadioGroup;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    RECORD1: TEdit;
    RECORD_VALUE1: TEdit;
    SelectRECORD1: TBitBtn;
    RECORD2: TEdit;
    RECORD_VALUE2: TEdit;
    SelectRECORD2: TBitBtn;
    BConsolidate: TBitBtn;
    administratorMerging: TCheckBox;
    BCancel: TBitBtn;
    procedure SelectRECORD1Click(Sender: TObject);
    procedure SelectRECORD2Click(Sender: TObject);
    procedure RECORD1Change(Sender: TObject);
    procedure RECORD2Change(Sender: TObject);
    procedure RECORD_VALUE1DblClick(Sender: TObject);
    procedure RECORD_VALUE2DblClick(Sender: TObject);
    procedure BConsolidateClick(Sender: TObject);
    procedure consolidationKindClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RECORD_VALUE1KeyPress(Sender: TObject; var Key: Char);
    procedure RECORD_VALUE2KeyPress(Sender: TObject; var Key: Char);
    procedure administratorMergingClick(Sender: TObject);
    procedure BNextClick(Sender: TObject);
    procedure Memo2Click(Sender: TObject);
    procedure RECORD_VALUE1Click(Sender: TObject);
    procedure RECORD_VALUE2Click(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    Function GENERICShowModalAsSelect(VAR keyValue : ShortString) : TModalResult;
  end;

var
  FConsolidation: TFConsolidation;

implementation

{$R *.dfm}

USES autocreate, UUtilityParent, uCommon, UFMAIN, DM;

Function TFConsolidation.GENERICShowModalAsSelect(VAR keyValue : ShortString) : TModalResult;
begin
 result := mrCancel;
  case consolidationKind.ItemIndex of
   0 : result := LECTURERSShowModalAsSelect(KeyValue,'','0=0','');
   1 : result := GROUPSShowModalAsSelect(KeyValue,'','0=0','');
   2 : result := ROOMSShowModalAsSelect(dmodule.pResCatId0,'',KeyValue,'0=0','');
   3 : result := SUBJECTSShowModalAsSelect(KeyValue,'');
   4 : result := FORMSShowModalAsSelect(KeyValue,'');
  end;
end;


procedure TFConsolidation.SelectRECORD1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := '';
  If GENERICShowModalAsSelect(KeyValue) = mrOK Then Begin
   If ExistsValue(RECORD1.Text, [';'], KeyValue)
    Then Info('Nie mo¿na wybraæ ponownie tego samego rekordu')
    Else begin
     //ConLecturer.Text := Merge(KeyValue, RECORD1.Text, ';');
     RECORD1.Text := KeyValue;
    end;
  End;
end;

procedure TFConsolidation.SelectRECORD2Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := '';
  If GENERICShowModalAsSelect(KeyValue) = mrOK Then Begin
   If ExistsValue(RECORD2.Text, [';'], KeyValue)
    Then Info('Nie mo¿na wybraæ ponownie tego samego rekordu')
    Else begin
     //ConLecturer.Text := Merge(KeyValue, RECORD1.Text, ';');
     RECORD2.Text := KeyValue;
    end;
  End;
end;

procedure TFConsolidation.RECORD1Change(Sender: TObject);
begin
  inherited;
  case consolidationKind.ItemIndex of
   0 : RECORD_VALUE1.text := FChange(RECORD1.text, dm.sql_LECDESC);
   1 : RECORD_VALUE1.text := FChange(RECORD1.text, dm.sql_GRODESC);
   2 : RECORD_VALUE1.text := FChange(RECORD1.text, dm.sql_ResCat0DESC);
   3 : RECORD_VALUE1.text := FChange(RECORD1.text, dm.sql_SUBDESC);
   4 : RECORD_VALUE1.text := FChange(RECORD1.text, dm.sql_FORDESC);
  end;
end;

procedure TFConsolidation.RECORD2Change(Sender: TObject);
begin
  inherited;
  case consolidationKind.ItemIndex of
   0 : RECORD_VALUE2.text := FChange(RECORD2.text, dm.sql_LECDESC);
   1 : RECORD_VALUE2.text := FChange(RECORD2.text, dm.sql_GRODESC);
   2 : RECORD_VALUE2.text := FChange(RECORD2.text, dm.sql_ResCat0DESC);
   3 : RECORD_VALUE2.text := FChange(RECORD2.text, dm.sql_SUBDESC);
   4 : RECORD_VALUE2.text := FChange(RECORD2.text, dm.sql_FORDESC);
  end;
end;

procedure TFConsolidation.RECORD_VALUE1DblClick(Sender: TObject);
begin
  inherited;
  SelectRECORD1Click(nil);
end;

procedure TFConsolidation.RECORD_VALUE2DblClick(Sender: TObject);
begin
  inherited;
  SelectRECORD2Click(nil);
end;

procedure TFConsolidation.BConsolidateClick(Sender: TObject);
var dummy : shortString;
const names : array[0..4] of shortString = ('LEC','GRO','RES','SUB','FOR');
begin
 if isBlank ( RECORD1.Text ) then begin info ('Wybierz rekord do zachowania'); exit; end;
 if isBlank ( RECORD2.Text ) then begin info ('Wybierz rekord do usuniêcia'); exit; end;
 if RECORD2.Text = RECORD1.Text then begin info ('Wybierz dwa ró¿ne rekordy do scalenia'); exit; end;

 try
  with dmodule.QWork do begin
    SQL.Clear;
    SQL.Add('begin planner_utils.merge_'+names[consolidationKind.ItemIndex]+' (:save_id, :delete_id, :administrator_merging ); end;');
    parameters.ParamByName('save_id').value   := record1.text;
    parameters.ParamByName('delete_id').value := record2.text;
    parameters.ParamByName('administrator_merging').value := iif( administratorMerging.Checked, 'Y','N');
    execSQL;
  end;
  dummy := dmodule.SingleValue('select 0, planner_utils.get_output_param_num1, planner_utils.get_output_param_num2, planner_utils.get_output_param_num3, planner_utils.get_output_param_num4, planner_utils.get_output_param_num5 from dual');
  if dmodule.QWork.Fields[2].AsInteger <> 0 then
  begin
    if question('W wyniku scalania liczba rekordów zmniejszy siê. Ich liczba zmniejszy siê ze wzglêdu na to, ¿e zostan¹ usunietê rekordy, które w wyniku scalenia spowodowa³yby konflikty. Czy kontynuowaæ ?') = id_yes then
      begin
        dmodule.CommitTrans;
        info ('Zasób usuniêto. Zaktualizowano nastêpuj¹c¹ liczbê rekordów:'+ intToStr( dmodule.QWork.Fields[4].AsInteger + dmodule.QWork.Fields[2].AsInteger) );
      end
    else
      Dmodule.RollbackTrans;
  end
  else
  begin
    dmodule.CommitTrans;
    info ('Zasób usuniêto. Zaktualizowano nastêpuj¹c¹ liczbê zajêæ:'+ intToStr( dmodule.QWork.Fields[4].AsInteger + dmodule.QWork.Fields[2].AsInteger) );
  end;
 except
   on E:exception do Begin
     Dmodule.RollbackTrans;
     info('Czynnoœæ nie powiod³a sie z powodu nastêpuj¹cego b³êdu:' + cr + cr + E.Message);
   end;
 end;
end;




procedure TFConsolidation.consolidationKindClick(Sender: TObject);
begin
  inherited;
  TabSheetPage2.TabVisible := true;
  PageControl1.ActivePageIndex := 0;

  case consolidationKind.ItemIndex of
    0: TabSheetPage2.Caption := 'Scalanie wyk³adowców';
    1: TabSheetPage2.Caption := 'Scalanie grup';
    2: TabSheetPage2.Caption := 'Scalanie zasobów';
    3: TabSheetPage2.Caption := 'Scalanie przedmiotów';
    4: TabSheetPage2.Caption := 'Scalanie form zajêæ / rezerwacji';
  End;

  record1.Text := '';
  record2.Text := '';

  PageControl1.ActivePageIndex := 2;

end;

procedure TFConsolidation.FormActivate(Sender: TObject);
begin
  if consolidationKind.ItemIndex = -1 then begin
    TabSheetPage2.TabVisible := false;
    PageControl1.ActivePageIndex := 0;
  end;
end;

procedure TFConsolidation.RECORD_VALUE1KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if key <> char(27) then
  SelectRECORD1Click(nil);
end;

procedure TFConsolidation.RECORD_VALUE2KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if key <> char(27) then
  SelectRECORD2Click(nil);
end;

procedure TFConsolidation.administratorMergingClick(Sender: TObject);
begin
  inherited;
  if administratorMerging.Checked then
    If not isAdmin Then Begin
      Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
      administratorMerging.Checked := false;
    End;
end;

procedure TFConsolidation.BNextClick(Sender: TObject);
begin
  inherited;
  PageControl1.ActivePageIndex := 1;

end;

procedure TFConsolidation.Memo2Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
end;

procedure TFConsolidation.RECORD_VALUE1Click(Sender: TObject);
begin
  SelectRECORD1Click(nil);

end;

procedure TFConsolidation.RECORD_VALUE2Click(Sender: TObject);
begin
SelectRECORD2Click (nil);
end;

procedure TFConsolidation.BCancelClick(Sender: TObject);
begin
  Close;
end;

end.
