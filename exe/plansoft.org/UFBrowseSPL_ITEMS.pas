unit UFBrowseSPL_ITEMS;

// Study plan 2 (Plan2) - tables SPL_ITEMS and SPL_ITEM_CLA, package SPL_PKG (cd/serverInstall/updates/2026.11.21.sql).
// Used instead of UFBrowseTT_COMBINATIONS when "Plan studiów 2" is switched on (FProgramSettings.Plan2Enabled).
// Resource tags used by the filter and edit controls: 1 lecturer, 2 group, 3 room, 4 subject, 5 form, 6 period.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, OleServer, ExcelXP, DB, ADODB, ImgList,
  ExtCtrls, StrHlder, Menus, ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls,
  ComCtrls, Grids, DBGrids, Buttons;

type
  TFBrowseSPL_ITEMS = class(TFBrowseParent)
    BRecalc: TBitBtn;
    LFltLec: TLabel;
    FltLec: TEdit;
    FltLecValue: TEdit;
    BFltLecClear: TBitBtn;
    LFltGro: TLabel;
    FltGro: TEdit;
    FltGroValue: TEdit;
    BFltGroClear: TBitBtn;
    LFltRom: TLabel;
    FltRom: TEdit;
    FltRomValue: TEdit;
    BFltRomClear: TBitBtn;
    LFltSub: TLabel;
    FltSub: TEdit;
    FltSubValue: TEdit;
    BFltSubClear: TBitBtn;
    LFltFor: TLabel;
    FltFor: TEdit;
    FltForValue: TEdit;
    BFltForClear: TBitBtn;
    LFltPer: TLabel;
    FltPer: TEdit;
    FltPerValue: TEdit;
    BFltPerClear: TBitBtn;
    CompareMode: TRadioGroup;
    DetSplitter: TSplitter;
    DetPanel: TPanel;
    LDetails: TPanel;
    GridClasses: TDBGrid;
    EditPanel: TPanel;
    LPER: TLabel;
    PER_ID: TDBEdit;
    PER_VALUE: TEdit;
    LGRO: TLabel;
    GRO_ID: TDBEdit;
    GRO_VALUE: TEdit;
    LSUB: TLabel;
    SUB_ID: TDBEdit;
    SUB_VALUE: TEdit;
    LFOR: TLabel;
    FOR_ID: TDBEdit;
    FOR_VALUE: TEdit;
    LLEC: TLabel;
    LEC_ID: TDBEdit;
    LEC_VALUE: TEdit;
    BLECClear: TBitBtn;
    BCreatePlan: TBitBtn;
    BDeleteShown: TBitBtn;
    LPLANNED_HOURS: TLabel;
    PLANNED_HOURS: TDBEdit;
    LSCHEDULED_HOURS: TLabel;
    SCHEDULED_HOURS: TDBEdit;
    LDESC1: TLabel;
    DESC1: TDBEdit;
    LSORT_ORDER: TLabel;
    SORT_ORDER: TDBEdit;
    LINTEGRATION_ID: TLabel;
    INTEGRATION_ID: TDBEdit;
    QClasses: TADOQuery;
    DSClasses: TDataSource;
    TimerDetails: TTimer;
    procedure FormShow(Sender: TObject);
    procedure BRecalcClick(Sender: TObject);
    procedure BFltSelClick(Sender: TObject);
    procedure BFltClearClick(Sender: TObject);
    procedure FltChange(Sender: TObject);
    procedure CompareModeClick(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure TimerDetailsTimer(Sender: TObject);
    procedure EditIdChange(Sender: TObject);
    procedure BEditSelClick(Sender: TObject);
    procedure BLecClearClick(Sender: TObject);
    procedure BCreatePlanClick(Sender: TObject);
    procedure BDeleteShownClick(Sender: TObject);
  private
    DetailsCounter : integer;
    function  fltEdit(aTag : integer) : TEdit;
    function  fltValue(aTag : integer) : TEdit;
    function  selectResource(aTag : integer; var aId : ShortString) : boolean;
    function  resourceName(aTag : integer; aId : string) : string;
    procedure refreshDetails;
    procedure embedClearButtons;
  public
    procedure GetTableName;             override;
    procedure CustomConditions;         override;
    function  CheckRecord : Boolean;    override;
    procedure DefaultValues;            override;
    procedure AfterPost;                override;
    function  getSearchFilter : string; override;
    function  getFindCaption : string;  override;
  end;

var
  FBrowseSPL_ITEMS: TFBrowseSPL_ITEMS;

procedure SPL_ITEMSShowModalAsBrowser;
//selection of study plan items (ids "1,2,3"), filters preset: period (a period of items overlapping aPerId), lecturer, group
function  SPL_ITEMSShowModalAsMultiSelect(var IDs : String; aPerId, aLecId, aGroId : string) : TModalResult;
//items (ids "1,2,3", in this order) to an Excel file in the format of "Pobierz dane z programu Excel | Plan studiów"
procedure SPL_ITEMSExportToExcel(IDs : string);
//"Rozplanuj": terms for the hours still to be planned (spl_pkg.propose), the accepted ones are added as classes.
//aViewLecId / aViewRomId - lecturer / room of the main window (default lecturer of an item without lecturer).
//Result: number of added classes.
function  SPL_ITEMSSchedule(aItemId, aViewLecId, aViewRomId : string) : integer;

implementation

{$R *.dfm}

uses DM, UUtilityParent, UCommon, AutoCreate, UFProgramSettings, UFMain, ComObj, UUtilities, DateUtils;

type
  // "Utworz plan na podstawie zajec": okres i grupa - skad i dokad, kopiowanie wykladowcow (form created in code)
  TSplCreateDlg = class(TForm)
  public
    Values  : array[0..3] of TEdit;   // 0 period from, 1 group from, 2 period to, 3 group to
    Ids     : array[0..3] of string;
    WithLec : TCheckBox;
    constructor CreateDlg(AOwner : TComponent);
    procedure setValue(n : integer; id : string);
    procedure ValueClick(Sender : TObject);
    procedure OkClick(Sender : TObject);
  end;

const
  SPL_RES_TAG : array[0..3] of integer = (6, 2, 6, 2);   // period / group (TFBrowseSPL_ITEMS.selectResource)

  SPL_CAPTIONS : array[0..3] of string = ('Okres (sk¹d)', 'Grupa (sk¹d)', 'Okres (dok¹d)', 'Grupa (dok¹d)');

constructor TSplCreateDlg.CreateDlg(AOwner : TComponent);
var n : integer;
    l : TLabel;
    b : TButton;
begin
  inherited CreateNew(AOwner);
  Caption     := 'Utwórz plan na podstawie zajêæ';
  BorderStyle := bsDialog;
  Position    := poScreenCenter;
  ClientWidth := 480;
  ClientHeight:= 230;
  Font.Name   := 'Tahoma';
  for n := 0 to 3 do begin
    l := TLabel.Create(self);
    l.Parent  := self;
    l.Left    := 12;
    l.Top     := 16 + n * 30;
    l.Caption := SPL_CAPTIONS[n];
    Values[n] := TEdit.Create(self);
    with Values[n] do begin
      Parent   := self;
      Left     := 130;
      Top      := 12 + n * 30;
      Width    := 336;
      ReadOnly := true;
      Cursor   := crHandPoint;
      Tag      := n;
      Hint     := 'Kliknij, aby wybraæ z listy';
      ShowHint := true;
      OnClick  := ValueClick;
    end;
    Ids[n] := '';
  end;
  WithLec := TCheckBox.Create(self);
  with WithLec do begin
    Parent  := self;
    Left    := 130;
    Top     := 136;
    Width   := 336;
    Caption := 'Kopiuj do planu równie¿ wyk³adowców';
  end;
  l := TLabel.Create(self);
  l.Parent  := self;
  l.Left    := 12;
  l.Top     := 162;
  l.Caption := 'Dotychczasowy plan grupy (dok¹d) w okresie (dok¹d) zostanie zast¹piony.';
  b := TButton.Create(self);
  with b do begin Parent := self; Left := 290; Top := 192; Width := 85; Caption := 'Utwórz'; Default := true; OnClick := OkClick; end;
  b := TButton.Create(self);
  with b do begin Parent := self; Left := 381; Top := 192; Width := 85; Caption := 'Anuluj'; Cancel := true; ModalResult := mrCancel; end;
end;

// the target follows the source until it is changed (default: period to = period from, group to = group from)
procedure TSplCreateDlg.setValue(n : integer; id : string);
var old : string;
begin
  old    := Ids[n];
  Ids[n] := id;
  Values[n].Text := FBrowseSPL_ITEMS.resourceName(SPL_RES_TAG[n], id);
  if (n < 2) and ((Ids[n + 2] = '') or (Ids[n + 2] = old)) then setValue(n + 2, id);
end;

procedure TSplCreateDlg.ValueClick(Sender : TObject);
var n : integer;
    KeyValue : ShortString;
begin
  n := (Sender as TComponent).Tag;
  KeyValue := Ids[n];
  if FBrowseSPL_ITEMS.selectResource(SPL_RES_TAG[n], KeyValue) then setValue(n, KeyValue);
end;

procedure TSplCreateDlg.OkClick(Sender : TObject);
var n : integer;
begin
  for n := 0 to 3 do
    if Ids[n] = '' then begin
      SError('Uzupe³nij pole: ' + SPL_CAPTIONS[n]);
      exit;
    end;
  ModalResult := mrOK;
end;

const
  // "Dowolna fraza" - searched in all descriptions of the item and its resources
  sql_SPL_SEARCH = '(xxmsz_tools.erasePolishChars(upper(''#''||lec.last_name||''#''||lec.first_name||''#''||lec.title'+
                   '||''#''||gro.abbreviation||''#''||gro.name||''#''||sub.abbreviation||''#''||sub.name'+
                   '||''#''||xfor.abbreviation||''#''||xfor.name||''#''||per.name||''#''||i.desc1||''#'')) like ''%%%s%%'')';

procedure SPL_ITEMSShowModalAsBrowser;
begin
  if not Assigned(FBrowseSPL_ITEMS) then FBrowseSPL_ITEMS := TFBrowseSPL_ITEMS.Create(Application);
  FBrowseSPL_ITEMS.ShowModalAsBrowser('');
end;

function SPL_ITEMSShowModalAsMultiSelect(var IDs : String; aPerId, aLecId, aGroId : string) : TModalResult;
var perId : string;
begin
  if not Assigned(FBrowseSPL_ITEMS) then FBrowseSPL_ITEMS := TFBrowseSPL_ITEMS.Create(Application);
  perId := '';
  //the main window may show a weekly sub-period - the items belong to the period which contains it
  if Trim(aPerId) <> '' then
    perId := DModule.SingleValue(
      'select nvl(max(decode(per.id, cur.id, per.id)), max(per.id)) from spl_items i, periods per, periods cur'+
      ' where cur.id = '+aPerId+' and per.id = i.per_id and per.date_from <= cur.date_to and per.date_to >= cur.date_from');
  with FBrowseSPL_ITEMS do begin
    FltPer.Text := perId;
    FltLec.Text := Trim(aLecId);
    FltGro.Text := Trim(aGroId);
    FltRom.Text := '';
    FltSub.Text := '';
    FltFor.Text := '';
  end;
  IDs := '';
  result := FBrowseSPL_ITEMS.ShowModalAsMultiSelect(IDs);
end;

{ TFBrowseSPL_ITEMS }

procedure TFBrowseSPL_ITEMS.GetTableName;
begin
  Self.TableName := 'SPL_ITEMS';
end;

function TFBrowseSPL_ITEMS.fltEdit(aTag: integer): TEdit;
begin
  case aTag of
    1: result := FltLec;
    2: result := FltGro;
    3: result := FltRom;
    4: result := FltSub;
    5: result := FltFor;
  else result := FltPer;
  end;
end;

function TFBrowseSPL_ITEMS.fltValue(aTag: integer): TEdit;
begin
  case aTag of
    1: result := FltLecValue;
    2: result := FltGroValue;
    3: result := FltRomValue;
    4: result := FltSubValue;
    5: result := FltForValue;
  else result := FltPerValue;
  end;
end;

function TFBrowseSPL_ITEMS.selectResource(aTag: integer; var aId: ShortString): boolean;
begin
  case aTag of
    1: result := LECTURERSShowModalAsSelect(aId, '', '0=0', '') = mrOK;
    2: result := GROUPSShowModalAsSelect(aId, '', '0=0', '') = mrOK;
    3: result := ROOMSShowModalAsSelect(dmodule.pResCatId0, '', aId, '0=0', '') = mrOK;
    4: result := SUBJECTSShowModalAsSelect(aId, '') = mrOK;
    5: result := FORMSShowModalAsSelect(aId, '') = mrOK;
  else result := PERIODSShowModalAsSelect(aId) = mrOK;
  end;
end;

function TFBrowseSPL_ITEMS.resourceName(aTag: integer; aId: string): string;
begin
  result := '';
  aId := Trim(aId);
  if aId = '' then exit;
  case aTag of
    1: result := DModule.SingleValue('select last_name||'' ''||first_name||'' ''||title from lecturers where id = '+aId);
    2: result := DModule.SingleValue('select abbreviation||'' (''||name||'')'' from groups where id = '+aId);
    3: result := DModule.SingleValue('select name||'' ''||substr(attribs_01,1,55) from rooms where id = '+aId);
    4: result := DModule.SingleValue('select name||'' (''||abbreviation||'')'' from subjects where id = '+aId);
    5: result := DModule.SingleValue('select name||'' (''||abbreviation||'')'' from forms where id = '+aId);
  else result := DModule.SingleValue('select name from periods where id = '+aId);
  end;
end;

procedure TFBrowseSPL_ITEMS.FormShow(Sender: TObject);
begin
  inherited;
  with FProgramSettings do begin
    LFltLec.Caption := profileObjectNameL.Text;
    LFltGro.Caption := profileObjectNameG.Text;
    LFltRom.Caption := dmodule.pResCatName0;
    LFltSub.Caption := profileObjectNameC1.Text;
    LFltFor.Caption := profileObjectNameC2.Text;
    LFltPer.Caption := profileObjectNamePeriod.Text;
    LPER.Caption    := profileObjectNamePeriod.Text;
    LGRO.Caption    := profileObjectNameG.Text;
    LSUB.Caption    := profileObjectNameC1.Text;
    LFOR.Caption    := profileObjectNameC2.Text;
    LLEC.Caption    := profileObjectNameL.Text + ' (opcjonalnie)';
  end;
  embedClearButtons;
end;

// clear buttons inside the fields, at the right edge - like FDetails.embedButtons; visible only when the field
// is filled. The field gets a right margin (EM_SETMARGINS), so the text does not go under the button.
procedure TFBrowseSPL_ITEMS.embedClearButtons;
  const W = 20;
  procedure embed(ed : TEdit; btn : TControl);
  begin
    if btn.Parent <> ed then begin
      btn.Parent  := ed;
      btn.Anchors := [akTop, akRight];
    end;
    btn.Visible := ed.Text <> '';
    btn.SetBounds(ed.ClientWidth - W, 0, W, ed.ClientHeight);
    if ed.HandleAllocated then
      SendMessage(ed.Handle, EM_SETMARGINS, EC_RIGHTMARGIN, MakeLong(0, iif(btn.Visible, W + 2, 0)));
  end;
begin
  if csLoading in ComponentState then exit;
  embed(FltLecValue, BFltLecClear);
  embed(FltGroValue, BFltGroClear);
  embed(FltRomValue, BFltRomClear);
  embed(FltSubValue, BFltSubClear);
  embed(FltForValue, BFltForClear);
  embed(FltPerValue, BFltPerClear);
  embed(LEC_VALUE,   BLECClear);
end;

// ------------------------------------------------------------------------------------------- filters

procedure TFBrowseSPL_ITEMS.BFltSelClick(Sender: TObject);
var KeyValue : ShortString;
    aTag     : integer;
begin
  aTag := (Sender as TComponent).Tag;
  KeyValue := fltEdit(aTag).Text;
  if selectResource(aTag, KeyValue) then fltEdit(aTag).Text := KeyValue;
end;

procedure TFBrowseSPL_ITEMS.BFltClearClick(Sender: TObject);
begin
  fltEdit((Sender as TComponent).Tag).Text := '';
end;

procedure TFBrowseSPL_ITEMS.FltChange(Sender: TObject);
var aTag : integer;
begin
  aTag := (Sender as TComponent).Tag;
  fltValue(aTag).Text := resourceName(aTag, fltEdit(aTag).Text);
  embedClearButtons;
  if Visible then BRefreshClick(nil);
end;

procedure TFBrowseSPL_ITEMS.CompareModeClick(Sender: TObject);
begin
  if Visible then BRefreshClick(nil);
end;

procedure TFBrowseSPL_ITEMS.CustomConditions;
var filter : string;
begin
  inherited;
  filter := '0=0';
  if FltLec.Text <> '' then
    // the lecturer of the item, or (item without lecturer) the lecturer of a linked class
    filter := filter + ' and (i.lec_id = '+FltLec.Text+
                       ' or (i.lec_id is null and exists (select 1 from spl_item_cla c, lec_cla lc where c.item_id = i.id and lc.cla_id = c.cla_id and lc.lec_id = '+FltLec.Text+')))';
  if FltGro.Text <> '' then filter := filter + ' and i.gro_id = '+FltGro.Text;
  if FltRom.Text <> '' then
    // a room of a linked class
    filter := filter + ' and exists (select 1 from spl_item_cla c, rom_cla rc where c.item_id = i.id and rc.cla_id = c.cla_id and rc.rom_id = '+FltRom.Text+')';
  if FltSub.Text <> '' then filter := filter + ' and i.sub_id = '+FltSub.Text;
  if FltFor.Text <> '' then filter := filter + ' and i.for_id = '+FltFor.Text;
  if FltPer.Text <> '' then filter := filter + ' and i.per_id = '+FltPer.Text;
  if CompareMode.ItemIndex = 1 then filter := filter + ' and i.planned_hours > i.scheduled_hours';
  DM.macros.setMacro(Query, 'CUSTOMCONDITIONALS', filter);

  DM.macros.setMacro(Query, 'CONPERMISSIONS',
     '     (lec.id is null or ' + getWhereClause('lecturers','lec') + ')'+
     ' and ' + getWhereClause('groups',  'gro')  +
     ' and ' + getWhereClause('subjects','sub')  +
     ' and ' + getWhereClause('forms',   'xfor') +
     ' and ' + getWhereClause('periods', 'per')
     );
end;

function TFBrowseSPL_ITEMS.getFindCaption: string;
begin
  result := 'Dowolna fraza';
end;

function TFBrowseSPL_ITEMS.getSearchFilter: string;
begin
  result := buildFilter(sql_SPL_SEARCH, ESearch.Text);
end;

// ------------------------------------------------------------------------------------------- recalculation

// Columns A..G as read by UFMassImport (Plan studiów): lecturer, group, subject, form, period, number of classes,
// Integration Id. Objects are written so that the import recognizes them unambiguously: Integration Id of the object,
// otherwise its name (abbreviation) when no other object has it, otherwise its id.
procedure SPL_ITEMSExportToExcel(IDs : string);
const cols = 7;
      header : array[1..cols] of string = ('Wyk³adowca', 'Grupa', 'Przedmiot', 'Forma', 'Okres', 'Liczba zajêæ', 'Integration Id');
var dlg : TSaveDialog;
    all, chunk : TStringList;
    rows : TStringList;   // id=values separated by #9
    t, c, n : integer;
    data, xl, wb, ws : Variant;
    lastRow, v : string;
  // n-th field of a line separated by #9 (empty fields count - unlike ExtractWord)
  function field(n : integer; line : string) : string;
  var k, p : integer;
  begin
    for k := 1 to n - 1 do begin
      p := Pos(#9, line);
      if p = 0 then begin line := ''; break; end;
      Delete(line, 1, p);
    end;
    p := Pos(#9, line);
    if p > 0 then result := Copy(line, 1, p - 1) else result := line;
  end;
  // object -> value recognized by the import (tt_interface matching rules: integration_id, id, abbreviation, name)
  function objExpr(alias, table, nameExpr : string; withAbbreviation : boolean) : string;
  begin
    result :=
      'case when '+alias+'.id is null then null'+
      ' when '+alias+'.integration_id is not null then '+alias+'.integration_id'+
      iif(withAbbreviation,
      ' when '+alias+'.abbreviation is not null and (select count(*) from '+table+' x where trim(upper(x.abbreviation)) = trim(upper('+alias+'.abbreviation))) = 1'+
      '      and (select count(*) from '+table+' x where to_char(x.id) = trim('+alias+'.abbreviation) or trim(upper(x.integration_id)) = trim(upper('+alias+'.abbreviation))) = 0'+
      ' then '+alias+'.abbreviation', '')+
      ' when (select count(*) from '+table+' x where trim(upper('+StringReplace(nameExpr, alias+'.', 'x.', [rfReplaceAll])+')) = trim(upper('+nameExpr+'))) = 1'+
      '      and (select count(*) from '+table+' x where to_char(x.id) = trim('+nameExpr+') or trim(upper(x.integration_id)) = trim(upper('+nameExpr+'))) = 0'+
      iif(withAbbreviation, '      and (select count(*) from '+table+' x where trim(upper(x.abbreviation)) = trim(upper('+nameExpr+'))) = 0', '')+
      ' then trim('+nameExpr+')'+
      ' else to_char('+alias+'.id) end';
  end;
begin
  if IDs = '' then begin SError('Brak pozycji do zapisania'); exit; end;
  dlg := TSaveDialog.Create(nil);
  all := TStringList.Create;
  chunk := TStringList.Create;
  rows := TStringList.Create;
  try
    dlg.Filter     := 'Excel (*.xlsx)|*.xlsx';
    dlg.DefaultExt := 'xlsx';
    dlg.FileName   := 'Plan_studiow.xlsx';
    dlg.Options    := dlg.Options + [ofOverwritePrompt];
    if not dlg.Execute then exit;

    Screen.Cursor := crHourGlass;
    all.CommaText := IDs;
    // at most 500 ids in one query (ORA-01795: at most 1000 expressions in a list)
    t := 0;
    while t < all.Count do begin
      chunk.Clear;
      while (t < all.Count) and (chunk.Count < 500) do begin chunk.Add(all[t]); inc(t); end;
      dmodule.openSQL(
        'select i.id'+
        ', '+objExpr('lec', 'lecturers', 'lec.title||'' ''||lec.first_name||'' ''||lec.last_name', true)+' c1'+
        ', '+objExpr('gro', 'groups',   'gro.name', true)+' c2'+
        ', '+objExpr('sub', 'subjects', 'sub.name', true)+' c3'+
        ', '+objExpr('xfor','forms',    'xfor.name', true)+' c4'+
        ', '+objExpr('per', 'periods',  'per.name', false)+' c5'+
        ', i.planned_hours c6, i.integration_id c7'+
        '  from spl_items i, lecturers lec, groups gro, subjects sub, forms xfor, periods per'+
        ' where lec.id (+) = i.lec_id and gro.id = i.gro_id and sub.id = i.sub_id and xfor.id = i.for_id and per.id = i.per_id'+
        '   and i.id in ('+chunk.CommaText+')');
      with dmodule.QWork do begin
        First;
        while not Eof do begin
          v := '';
          for c := 1 to cols do v := v + FieldByName('c'+intToStr(c)).AsString + iif(c < cols, #9, '');
          rows.Values[FieldByName('id').AsString] := v;
          Next;
        end;
      end;
    end;

    // the order of the list; the whole sheet written at once (cell by cell is very slow)
    data := VarArrayCreate([1, all.Count + 1, 1, cols], varVariant);
    for c := 1 to cols do data[1, c] := header[c];
    n := 1;
    for t := 0 to all.Count - 1 do begin
      v := rows.Values[all[t]];
      if v = '' then continue;
      inc(n);
      for c := 1 to cols do
        if c = 6 then data[n, c] := StrToFloatDef(field(c, v), 0)
                 else data[n, c] := field(c, v);
    end;
    lastRow := intToStr(all.Count + 1);

    xl := CreateOleObject('Excel.Application');
    try
      xl.DisplayAlerts := false;
      wb := xl.Workbooks.Add;
      ws := wb.Worksheets[1];
      ws.Name := 'Plan studiów';
      ws.Range['A1', 'E' + lastRow].NumberFormat := '@';   // text: names such as "03" stay text
      ws.Range['G1', 'G' + lastRow].NumberFormat := '@';
      ws.Range['A1', 'G' + lastRow].Value := data;
      ws.Range['A1', 'G1'].Font.Bold := true;
      ws.Range['A1', 'G' + lastRow].Columns.AutoFit;
      if FileExists(dlg.FileName) then DeleteFile(dlg.FileName);
      wb.SaveAs(dlg.FileName, 51); // xlOpenXMLWorkbook
      wb.Close(false);
    finally
      ws := Unassigned;
      wb := Unassigned;
      xl.Quit;
      xl := Unassigned;
    end;
    Screen.Cursor := crDefault;
    Info('Zapisano pozycji planu studiów: ' + intToStr(n - 1) + cr + dlg.FileName + cr + cr +
         'Plik mo¿na wczytaæ: Plik | Pobierz dane z programu Excel | Plan studiów (albo przycisk Import).');
  finally
    Screen.Cursor := crDefault;
    dlg.Free;
    all.Free;
    chunk.Free;
    rows.Free;
  end;
end;

// ------------------------------------------------------------------------------------------------ "Rozplanuj"
type
  TSplScheduleDlg = class(TForm)
  public
    ItemId, GroId, SubId, ForId, LecId, RomId : string;
    ItemHasLec : boolean;
    LInfo, LStatus : TLabel;
    LecEdit, RomEdit : TEdit;
    Mode : TRadioGroup;
    WeekDay, HFrom, HTo, Block : TComboBox;
    List : TListView;
    BAdd : TButton;
    Added : integer;
    constructor CreateDlg(AOwner : TComponent);
    procedure LecClick(Sender : TObject);
    procedure RomClick(Sender : TObject);
    procedure RomClearClick(Sender : TObject);
    procedure ProposeClick(Sender : TObject);
    procedure AddClick(Sender : TObject);
    function  selectLecturer : boolean;
  end;

constructor TSplScheduleDlg.CreateDlg(AOwner : TComponent);
  function lbl(x, y : integer; txt : string) : TLabel;
  begin
    result := TLabel.Create(self);
    result.Parent := self; result.Left := x; result.Top := y; result.Caption := txt;
  end;
  function combo(x, y, w : integer) : TComboBox;
  begin
    result := TComboBox.Create(self);
    result.Parent := self; result.Style := csDropDownList; result.SetBounds(x, y, w, 21); result.DropDownCount := 16;
  end;
var b : TButton;
    t : integer;
const days : array[0..7] of string = ('Dowolny dzieñ', 'Poniedzia³ek', 'Wtorek', 'Œroda', 'Czwartek', 'Pi¹tek', 'Sobota', 'Niedziela');
begin
  inherited CreateNew(AOwner);
  Caption      := 'Rozplanuj';
  BorderStyle  := bsSizeable;
  Position     := poScreenCenter;
  ClientWidth  := 640;
  ClientHeight := 600;
  Font.Name    := 'Tahoma';
  Constraints.MinWidth  := 560;
  Constraints.MinHeight := 420;

  LInfo := lbl(12, 10, '');
  LInfo.Font.Style := [fsBold];
  LInfo.AutoSize := false; LInfo.Width := 616; LInfo.Height := 32; LInfo.WordWrap := true;
  LInfo.Anchors := [akLeft, akTop, akRight];

  lbl(12, 50, 'Wyk³adowca');
  LecEdit := TEdit.Create(self);
  with LecEdit do begin Parent := self; SetBounds(150, 46, 330, 21); ReadOnly := true; Cursor := crHandPoint; Hint := 'Kliknij, aby wybraæ z listy'; ShowHint := true; OnClick := LecClick; end;
  lbl(12, 78, 'Sala (opcjonalnie)');
  RomEdit := TEdit.Create(self);
  with RomEdit do begin Parent := self; SetBounds(150, 74, 330, 21); ReadOnly := true; Cursor := crHandPoint; Hint := 'Kliknij, aby wybraæ z listy'; ShowHint := true; OnClick := RomClick; end;
  b := TButton.Create(self);
  with b do begin Parent := self; SetBounds(484, 74, 60, 21); Caption := 'Bez sali'; OnClick := RomClearClick; end;

  Mode := TRadioGroup.Create(self);
  with Mode do begin
    Parent := self; SetBounds(12, 102, 616, 58); Caption := 'Sposób';
    Items.Add('Pierwsze wolne terminy (jak najwczeœniej)');
    Items.Add('Równomiernie: ten sam dzieñ i godzina co tydzieñ (gdy za ma³o - tak¿e kolejne dni tygodnia)');
    ItemIndex := 1;
    Anchors := [akLeft, akTop, akRight];
  end;

  lbl(12, 172, 'Dzieñ tygodnia');
  WeekDay := combo(150, 168, 130);
  for t := 0 to 7 do WeekDay.Items.Add(days[t]);
  WeekDay.ItemIndex := 0;
  lbl(300, 172, 'Bloków pod rz¹d');
  Block := combo(410, 168, 60);
  for t := 1 to 4 do Block.Items.Add(intToStr(t));
  Block.ItemIndex := 0;
  lbl(12, 200, 'Godziny od');
  HFrom := combo(150, 196, 130);
  lbl(300, 200, 'do');
  HTo := combo(410, 196, 130);

  b := TButton.Create(self);
  with b do begin Parent := self; SetBounds(12, 228, 160, 25); Caption := 'Zaproponuj terminy'; Default := true; OnClick := ProposeClick; end;

  LStatus := lbl(184, 233, '');
  LStatus.AutoSize := false; LStatus.Width := 444; LStatus.Anchors := [akLeft, akTop, akRight];

  List := TListView.Create(self);
  with List do begin
    Parent := self; SetBounds(12, 262, 616, 290);
    Anchors := [akLeft, akTop, akRight, akBottom];
    ViewStyle := vsReport; RowSelect := true; ReadOnly := true; Checkboxes := true; HideSelection := false;
    with Columns.Add do begin Caption := 'Data';      Width := 90;  end;
    with Columns.Add do begin Caption := 'Dzieñ';     Width := 95;  end;
    with Columns.Add do begin Caption := 'Godzina';   Width := 170; end;
    with Columns.Add do begin Caption := 'Godzin';    Width := 60;  Alignment := taRightJustify; end;
    with Columns.Add do begin Caption := 'Spotkanie'; Width := 70;  Alignment := taRightJustify; end;
  end;

  BAdd := TButton.Create(self);
  with BAdd do begin Parent := self; SetBounds(352, 564, 180, 25); Caption := 'Dodaj zaznaczone zajêcia'; Enabled := false; OnClick := AddClick; Anchors := [akRight, akBottom]; end;
  b := TButton.Create(self);
  with b do begin Parent := self; SetBounds(540, 564, 88, 25); Caption := 'Zamknij'; Cancel := true; ModalResult := mrCancel; Anchors := [akRight, akBottom]; end;
end;

function TSplScheduleDlg.selectLecturer : boolean;
var KeyValue : ShortString;
begin
  KeyValue := LecId;
  result := LECTURERSShowModalAsSelect(KeyValue, '', '0=0', '') = mrOK;
  if result then begin
    LecId := KeyValue;
    LecEdit.Text := FBrowseSPL_ITEMS.resourceName(1, LecId);
  end;
end;

procedure TSplScheduleDlg.LecClick(Sender : TObject);
begin
  if ItemHasLec then exit;   // the lecturer of the item
  if selectLecturer then begin List.Items.Clear; BAdd.Enabled := false; end;
end;

procedure TSplScheduleDlg.RomClick(Sender : TObject);
var KeyValue : ShortString;
begin
  KeyValue := RomId;
  if ROOMSShowModalAsSelect(dmodule.pResCatId0, '', KeyValue, '0=0', '') = mrOK then begin
    RomId := KeyValue;
    RomEdit.Text := FBrowseSPL_ITEMS.resourceName(3, RomId);
    List.Items.Clear; BAdd.Enabled := false;
  end;
end;

procedure TSplScheduleDlg.RomClearClick(Sender : TObject);
begin
  RomId := '';
  RomEdit.Text := '';
  List.Items.Clear; BAdd.Enabled := false;
end;

//spl_pkg.propose: 'OK|PART|DONE|ERR;<hours to plan>;<not covered>' + '|yyyy-mm-dd;hour;hours;meeting' ...
procedure TSplScheduleDlg.ProposeClick(Sender : TObject);
const days : array[1..7] of string = ('poniedzia³ek', 'wtorek', 'œroda', 'czwartek', 'pi¹tek', 'sobota', 'niedziela');
var res, head, e, status : string;
    t, n : integer;
    d : TDateTime;
    item : TListItem;
  function hourNo(c : TComboBox) : string;
  begin
    if c.ItemIndex < 0 then result := 'null' else result := intToStr(integer(c.Items.Objects[c.ItemIndex]));
  end;
  function hourLabel(no : integer) : string;
  var k : integer;
  begin
    result := intToStr(no);
    for k := 0 to HFrom.Items.Count - 1 do
      if integer(HFrom.Items.Objects[k]) = no then begin result := HFrom.Items[k]; exit; end;
  end;
begin
  // item without lecturer: first the lecturer (default - the one of the main window), then the terms
  if (not ItemHasLec) and (LecId = '') then
    if not selectLecturer then exit;
  List.Items.Clear;
  BAdd.Enabled := false;
  Screen.Cursor := crHourGlass;
  try
    res := dmodule.SingleValue('select spl_pkg.propose('+ItemId+', '''+iif(Mode.ItemIndex = 1, 'EVEN', 'FIRST')+''', '+
             intToStr(WeekDay.ItemIndex)+', '+hourNo(HFrom)+', '+hourNo(HTo)+', '+intToStr(Block.ItemIndex + 1)+', '+
             iif(LecId = '', 'null', LecId)+', '+iif(RomId = '', 'null', RomId)+') r from dual');
  finally
    Screen.Cursor := crDefault;
  end;
  n := WordCount(res, ['|']);
  head := ExtractWord(1, res, ['|']);
  status := ExtractWord(1, head, [';']);
  if status = 'ERR' then begin LStatus.Caption := Copy(head, 5, 500); exit; end;
  if status = 'DONE' then begin LStatus.Caption := 'Pozycja jest ju¿ w pe³ni zaplanowana.'; exit; end;
  List.Items.BeginUpdate;
  try
    for t := 2 to n do begin
      e := ExtractWord(t, res, ['|']);
      d := EncodeDate(StrToInt(Copy(e, 1, 4)), StrToInt(Copy(e, 6, 2)), StrToInt(Copy(e, 9, 2)));
      item := List.Items.Add;
      item.Caption := Copy(e, 1, 10);
      item.SubItems.Add(days[DayOfTheWeek(d)]);
      item.SubItems.Add(hourLabel(StrToInt(ExtractWord(2, e, [';']))));
      item.SubItems.Add(StringReplace(ExtractWord(3, e, [';']), '.', DecimalSeparator, []));
      item.SubItems.Add(ExtractWord(4, e, [';']));
      item.Data := Pointer(StrToInt(ExtractWord(2, e, [';'])));   // row of the grid
      item.Checked := true;
    end;
  finally
    List.Items.EndUpdate;
  end;
  if status = 'OK' then
    LStatus.Caption := 'Terminy bez konfliktów na ' + ExtractWord(2, head, [';']) + ' godz. Odznacz niepotrzebne i dodaj.'
  else
    LStatus.Caption := 'Brakuje ' + ExtractWord(3, head, [';']) + ' z ' + ExtractWord(2, head, [';']) +
                       ' godz. - nie ma wiêcej wolnych terminów (zmieñ dzieñ, godziny, salê albo sposób).';
  BAdd.Enabled := List.Items.Count > 0;
end;

//the checked terms as classes - the same insert as in the main window (planner_utils_insert_classes: canInsertClass,
//insert_classes); the transaction as in FMain.insertClasses (the changes are saved / undone with Zapisz / Cofnij)
procedure TSplScheduleDlg.AddClick(Sender : TObject);
var t, ok, cnt : integer;
    cl : TClass_;
    e : string;
begin
  cnt := 0;
  for t := 0 to List.Items.Count - 1 do if List.Items[t].Checked then inc(cnt);
  if cnt = 0 then begin SError('Zaznacz terminy'); exit; end;
  dmodule.CommitTrans;
  ok := 0;
  Screen.Cursor := crHourGlass;
  try
    for t := 0 to List.Items.Count - 1 do begin
      if not List.Items[t].Checked then continue;
      e := List.Items[t].Caption;
      cl.id           := 0;
      cl.day          := DateTimeToTimeStamp(EncodeDate(StrToInt(Copy(e, 1, 4)), StrToInt(Copy(e, 6, 2)), StrToInt(Copy(e, 9, 2))));
      cl.hour         := integer(List.Items[t].Data);
      cl.fill         := 100;
      cl.sub_id       := StrToInt(SubId);
      cl.for_id       := StrToInt(ForId);
      cl.class_colour := 0;
      cl.owner        := dm.UserName;
      cl.calc_lec_ids := LecId;
      cl.calc_gro_ids := GroId;
      cl.calc_rom_ids := RomId;
      cl.desc1 := ''; cl.desc2 := ''; cl.desc3 := ''; cl.desc4 := '';
      if planner_utils_insert_classes(cl, '', -1, false) then inc(ok);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
  Added := Added + ok;
  Info('Dodano zajêæ: ' + intToStr(ok) + ' z ' + intToStr(cnt) + '.');
  if ok > 0 then ModalResult := mrOK;
end;

function SPL_ITEMSSchedule(aItemId, aViewLecId, aViewRomId : string) : integer;
var dlg : TSplScheduleDlg;
    per, labels, hidden, lbl : string;
    no, k : integer;
begin
  result := 0;
  if not Assigned(FBrowseSPL_ITEMS) then FBrowseSPL_ITEMS := TFBrowseSPL_ITEMS.Create(Application);
  dlg := TSplScheduleDlg.CreateDlg(nil);
  try
    dmodule.SingleValue('select i.id, i.gro_id, i.sub_id, i.for_id, i.lec_id, i.per_id, i.planned_hours'+
                        ', spl_pkg.scheduled_hours_now(i.id) sch, sub.name||'', ''||xfor.name||'' - ''||gro.abbreviation sub_dsp'+
                        '  from spl_items i, subjects sub, forms xfor, groups gro'+
                        ' where i.id = '+aItemId+' and sub.id = i.sub_id and xfor.id = i.for_id and gro.id = i.gro_id');
    with dmodule.QWork do begin
      if IsEmpty then begin SError('Nie znaleziono pozycji planu'); exit; end;
      dlg.ItemId := aItemId;
      dlg.GroId  := FieldByName('gro_id').AsString;
      dlg.SubId  := FieldByName('sub_id').AsString;
      dlg.ForId  := FieldByName('for_id').AsString;
      dlg.LecId  := FieldByName('lec_id').AsString;
      per        := FieldByName('per_id').AsString;
      dlg.LInfo.Caption := FieldByName('sub_dsp').AsString + '.   Do zaplanowania: ' +
        FormatFloat('0.##', FieldByName('planned_hours').AsFloat - FieldByName('sch').AsFloat) + ' z ' +
        FormatFloat('0.##', FieldByName('planned_hours').AsFloat) + ' godz.';
    end;
    dlg.ItemHasLec := dlg.LecId <> '';
    if not dlg.ItemHasLec then dlg.LecId := aViewLecId;   // item without lecturer: the lecturer of the main window
    if dlg.LecId <> '' then dlg.LecEdit.Text := FBrowseSPL_ITEMS.resourceName(1, dlg.LecId);
    if dlg.ItemHasLec then begin dlg.LecEdit.Color := clBtnFace; dlg.LecEdit.Cursor := crDefault; dlg.LecEdit.Hint := 'Wyk³adowca pozycji planu'; end
                      else dlg.LecEdit.Hint := 'Pozycja bez wyk³adowcy - wybierz wyk³adowcê (kliknij)';
    dlg.RomId := aViewRomId;
    if dlg.RomId <> '' then dlg.RomEdit.Text := FBrowseSPL_ITEMS.resourceName(3, dlg.RomId);

    // rows of the grid of the period: own labels (ATTRIBS_14), hidden rows (ATTRIBS_15) left out
    dmodule.SingleValue('select hours_per_day, attribs_14, attribs_15 from periods where id = '+per);
    labels := dmodule.QWork.FieldByName('attribs_14').AsString;
    hidden := dmodule.QWork.FieldByName('attribs_15').AsString;
    dmodule.openSQL('select no, caption, hour_from from grids where no between 1 and '+
                    intToStr(dmodule.QWork.FieldByName('hours_per_day').AsInteger)+' order by no');
    with dmodule.QWork do begin
      First;
      while not Eof do begin
        no := FieldByName('no').AsInteger;
        if (hidden = '') or (Copy(hidden, ((no - 1) mod Length(hidden)) + 1, 1) <> '-') then begin
          lbl := Trim(ExtractWord(no, labels, [',']));
          if lbl = '' then lbl := Trim(FieldByName('caption').AsString);
          lbl := intToStr(no) + '.  ' + lbl + iif(Trim(FieldByName('hour_from').AsString) <> '', '  (' + Trim(FieldByName('hour_from').AsString) + ')', '');
          dlg.HFrom.Items.AddObject(lbl, TObject(no));
          dlg.HTo.Items.AddObject(lbl, TObject(no));
        end;
        Next;
      end;
    end;
    dlg.HFrom.ItemIndex := 0;
    dlg.HTo.ItemIndex   := dlg.HTo.Items.Count - 1;
    k := dlg.ShowModal;
    if k = mrOK then result := dlg.Added else result := dlg.Added;
  finally
    dlg.Free;
  end;
end;

// "Utworz plan na podstawie zajec" (spl_pkg.create_from_classes)
procedure TFBrowseSPL_ITEMS.BCreatePlanClick(Sender: TObject);
var dlg : TSplCreateDlg;
    existing, created : string;
begin
  dlg := TSplCreateDlg.CreateDlg(nil);
  try
    // defaults: the period of the main window, the group of the filter (or of the main window)
    dlg.setValue(0, FMain.conPeriod.Text);
    if FltGro.Text <> '' then dlg.setValue(1, FltGro.Text)
    else if FMain.TabViewType.TabIndex = 1 then dlg.setValue(1, ExtractWord(1, FMain.ConGroup.Text, [';']));
    if dlg.ShowModal <> mrOK then exit;

    existing := dmodule.SingleValue('select count(*) from spl_items where per_id = '+dlg.Ids[2]+' and gro_id = '+dlg.Ids[3]);
    if StrToIntDef(existing, 0) > 0 then
      if question('Plan grupy ' + dlg.Values[3].Text + ' w okresie ' + dlg.Values[2].Text + ' ma pozycji: ' + existing + '.' + cr +
                  'Plan zostanie zast¹piony planem utworzonym na podstawie zajêæ. Kontynuowaæ?') <> id_yes then exit;

    dmodule.SQL('begin spl_pkg.create_from_classes(:pPerFrom, :pGroFrom, :pPerTo, :pGroTo, :pWithLec); commit; end;',
                'pPerFrom='+dlg.Ids[0]+';pGroFrom='+dlg.Ids[1]+';pPerTo='+dlg.Ids[2]+';pGroTo='+dlg.Ids[3]+
                ';pWithLec='+iif(dlg.WithLec.Checked, 'Y', 'N'));
    created := dmodule.SingleValue('select count(*) from spl_items where per_id = '+dlg.Ids[2]+' and gro_id = '+dlg.Ids[3]);

    // show the new plan
    FltLec.Text := ''; FltRom.Text := ''; FltSub.Text := ''; FltFor.Text := '';
    FltPer.Text := dlg.Ids[2];
    FltGro.Text := dlg.Ids[3];
    BRefreshClick(nil);
    Info('Utworzono pozycji planu studiów: ' + created);
  finally
    dlg.Free;
  end;
end;

// "Skasuj wyswietlane rekordy": all records of the list (filters, search), e.g. the plan of one group
procedure TFBrowseSPL_ITEMS.BDeleteShownClick(Sender: TObject);
var ids : string;
    cnt, n : integer;
  procedure flush;
  begin
    if ids <> '' then dmodule.SQL('begin delete from spl_items where id in ('+ids+'); commit; end;');
    ids := '';
    n   := 0;
  end;
begin
  if not Query.Active or Query.IsEmpty then begin SError('Brak wyœwietlanych rekordów'); exit; end;
  cnt := Query.RecordCount;
  if question('Skasowaæ wszystkie wyœwietlane pozycje planu studiów (' + intToStr(cnt) + ')?' + cr +
              'Kasowane s¹ rekordy widoczne na liœcie - zgodne z filtrami i wyszukiwaniem.') <> id_yes then exit;
  ids := ''; n := 0;
  Query.DisableControls;
  try
    Query.First;
    while not Query.Eof do begin
      ids := Merge(ids, Query.FieldByName('ID').AsString, ',');
      inc(n);
      if n >= 500 then flush;   // ORA-01795: at most 1000 expressions in a list
      Query.Next;
    end;
    flush;
  finally
    Query.EnableControls;
  end;
  BRefreshClick(nil);
  Info('Skasowano pozycji planu studiów: ' + intToStr(cnt));
end;

procedure TFBrowseSPL_ITEMS.BRecalcClick(Sender: TObject);
begin
  // the period from the filter, or all periods
  dmodule.SQL('begin spl_pkg.recalc(:pPerId, null); commit; end;', 'pPerId='+FltPer.Text);
  BRefreshClick(nil);
end;

// ------------------------------------------------------------------------------------------- linked classes

procedure TFBrowseSPL_ITEMS.QueryAfterScroll(DataSet: TDataSet);
begin
  DetailsCounter := 2;
end;

procedure TFBrowseSPL_ITEMS.TimerDetailsTimer(Sender: TObject);
begin
  if DetailsCounter > 0 then DetailsCounter := DetailsCounter - 1;
  if DetailsCounter = 1 then refreshDetails;
end;

procedure TFBrowseSPL_ITEMS.refreshDetails;
begin
  QClasses.Close;
  if (not Query.Active) or Query.IsEmpty or (Query.FindField('ID') = nil) then
    QClasses.Parameters.ParamByName('item_id').Value := '-1'
  else
    QClasses.Parameters.ParamByName('item_id').Value := NVL(Query.FieldByName('ID').AsString, '-1');
  QClasses.Open;
end;

// ------------------------------------------------------------------------------------------- edit

procedure TFBrowseSPL_ITEMS.DefaultValues;
begin
  inherited;
  Query['ID']              := DModule.SingleValue('select spl_seq.nextval from dual');
  Query['PLANNED_HOURS']   := 0;
  Query['SCHEDULED_HOURS'] := 0;
  // new item gets the resources of the current filter
  if FltPer.Text <> '' then Query['PER_ID'] := FltPer.Text;
  if FltGro.Text <> '' then Query['GRO_ID'] := FltGro.Text;
  if FltSub.Text <> '' then Query['SUB_ID'] := FltSub.Text;
  if FltFor.Text <> '' then Query['FOR_ID'] := FltFor.Text;
  if FltLec.Text <> '' then Query['LEC_ID'] := FltLec.Text;
end;

function TFBrowseSPL_ITEMS.CheckRecord: Boolean;
begin
  with UUtilityParent.CheckValid do begin
    Init(Self);
    if Trim(PER_ID.Text) = '' then addError('Wybierz: ' + LPER.Caption);
    if Trim(GRO_ID.Text) = '' then addError('Wybierz: ' + LGRO.Caption);
    if Trim(SUB_ID.Text) = '' then addError('Wybierz: ' + LSUB.Caption);
    if Trim(FOR_ID.Text) = '' then addError('Wybierz: ' + LFOR.Caption);
    if Trim(PLANNED_HOURS.Text) = '' then addError('Podaj planowan¹ liczbê godzin');
    result := ShowMessage;
  end;
end;

procedure TFBrowseSPL_ITEMS.AfterPost;
begin
  inherited;
  // link the classes of the saved item at once
  if Query.FindField('ID') <> nil then
    if Query.FieldByName('ID').AsString <> '' then
      dmodule.SQL('begin spl_pkg.recalc(null, :pItemId); end;', 'pItemId='+Query.FieldByName('ID').AsString);
end;

procedure TFBrowseSPL_ITEMS.EditIdChange(Sender: TObject);
var aTag : integer;
    v    : string;
begin
  aTag := (Sender as TComponent).Tag;
  v    := resourceName(aTag, (Sender as TDBEdit).Text);
  case aTag of
    1: LEC_VALUE.Text := v;
    2: GRO_VALUE.Text := v;
    4: SUB_VALUE.Text := v;
    5: FOR_VALUE.Text := v;
    6: PER_VALUE.Text := v;
  end;
  if aTag = 1 then embedClearButtons;
end;

procedure TFBrowseSPL_ITEMS.BEditSelClick(Sender: TObject);
var KeyValue  : ShortString;
    aTag      : integer;
    fieldName : string;
begin
  aTag := (Sender as TComponent).Tag;
  case aTag of
    1: fieldName := 'LEC_ID';
    2: fieldName := 'GRO_ID';
    4: fieldName := 'SUB_ID';
    5: fieldName := 'FOR_ID';
  else fieldName := 'PER_ID';
  end;
  KeyValue := Query.FieldByName(fieldName).AsString;
  if selectResource(aTag, KeyValue) then begin
    if not (Query.State in [dsEdit, dsInsert]) then Query.Edit;
    Query.FieldByName(fieldName).AsString := KeyValue;
  end;
end;

procedure TFBrowseSPL_ITEMS.BLecClearClick(Sender: TObject);
begin
  if not (Query.State in [dsEdit, dsInsert]) then Query.Edit;
  Query.FieldByName('LEC_ID').Clear;
end;

end.
