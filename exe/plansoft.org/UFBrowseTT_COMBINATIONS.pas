unit UFBrowseTT_COMBINATIONS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, UFGenericFilter, OleServer, ExcelXP;

type
  TFBrowseTT_COMBINATIONS = class(TFBrowseParent)
    DetPanel: TPanel;
    Splitter1: TSplitter;
    DetPanel1: TPanel;
    Gridtt_resource_lists: TDBGrid;
    DStt_resource_lists: TDataSource;
    Panel2: TPanel;
    AVAIL_TYPE: TDBCheckBox;
    ENABLED: TDBCheckBox;
    AVAIL_ORIG: TDBEdit;
    LabelAVAIL_CURR: TLabel;
    AVAIL_CURR: TDBEdit;
    LabelSORT_ORDER: TLabel;
    SORT_ORDER: TDBEdit;
    Panel3: TPanel;
    llec: TLabel;
    lgro: TLabel;
    lResCat0: TLabel;
    lResCat1: TLabel;
    lsub: TLabel;
    lfor: TLabel;
    lper: TLabel;
    lpla: TLabel;
    conlec: TEdit;
    congro: TEdit;
    conResCat0: TEdit;
    conResCat1: TEdit;
    consub: TEdit;
    confor: TEdit;
    conper: TEdit;
    conpla: TEdit;
    conlec_value: TEdit;
    congro_value: TEdit;
    conResCat0_value: TEdit;
    conResCat1_value: TEdit;
    consub_value: TEdit;
    confor_value: TEdit;
    conper_value: TEdit;
    conpla_value: TEdit;
    selectLec: TBitBtn;
    selectGro: TBitBtn;
    selectResCat0: TBitBtn;
    selectResCat1: TBitBtn;
    selectSub: TBitBtn;
    selectFor: TBitBtn;
    selectPer: TBitBtn;
    selectPla: TBitBtn;
    clearLec: TBitBtn;
    clearGro: TBitBtn;
    clearResCat0: TBitBtn;
    clearResCat1: TBitBtn;
    clearSub: TBitBtn;
    clearFor: TBitBtn;
    clearPer: TBitBtn;
    clearPla: TBitBtn;
    lecAll: TCheckBox;
    groAll: TCheckBox;
    resCat0All: TCheckBox;
    resCat1All: TCheckBox;
    subAll: TCheckBox;
    forAll: TCheckBox;
    perAll: TCheckBox;
    plaAll: TCheckBox;
    group_AVAIL_TYPE: TRadioGroup;
    group_AVAIL_CURR: TRadioGroup;
    chbRecalculate_AVAIL_CURR: TCheckBox;
    lCombType: TLabel;
    conttt: TEdit;
    conttt_value: TEdit;
    bSelttt: TBitBtn;
    bClearttt: TBitBtn;
    Panel4: TPanel;
    GenericFilter: TFGenericFilter;
    RESCAT_COMB_ID: TDBEdit;
    LRESCAT_COMB_ID: TLabel;
    RESCAT_COMB_ID_VALUE: TEdit;
    RESCAT_COMB_IDSel: TBitBtn;
    RESCAT_COMB_IDClear: TBitBtn;
    chbShowL: TCheckBox;
    chbShowS: TCheckBox;
    chbShowG: TCheckBox;
    chbShowF: TCheckBox;
    chbShowRESCAT0: TCheckBox;
    chbShowPer: TCheckBox;
    chbShowResCat1: TCheckBox;
    chbShowPla: TCheckBox;
    BRecalculateAll: TBitBtn;
    chbShowttt: TCheckBox;
    BRecalculateAllQuick: TBitBtn;
    QClasses: TADOQuery;
    TimerDetails: TTimer;
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure QClassesBeforeOpen(DataSet: TDataSet);
    procedure Qtt_inclusionsBeforeOpen(DataSet: TDataSet);
    procedure selectLecClick(Sender: TObject);
    procedure selectGroClick(Sender: TObject);
    procedure selectResCat0Click(Sender: TObject);
    procedure selectResCat1Click(Sender: TObject);
    procedure selectSubClick(Sender: TObject);
    procedure selectForClick(Sender: TObject);
    procedure selectPerClick(Sender: TObject);
    procedure selectPlaClick(Sender: TObject);
    procedure clearLecClick(Sender: TObject);
    procedure clearGroClick(Sender: TObject);
    procedure clearResCat0Click(Sender: TObject);
    procedure clearResCat1Click(Sender: TObject);
    procedure clearSubClick(Sender: TObject);
    procedure clearForClick(Sender: TObject);
    procedure clearPerClick(Sender: TObject);
    procedure clearPlaClick(Sender: TObject);
    procedure conlecChange(Sender: TObject);
    procedure congroChange(Sender: TObject);
    procedure conResCat0Change(Sender: TObject);
    procedure conResCat1Change(Sender: TObject);
    procedure consubChange(Sender: TObject);
    procedure conforChange(Sender: TObject);
    procedure conperChange(Sender: TObject);
    procedure conplaChange(Sender: TObject);
    procedure lecAllClick(Sender: TObject);
    procedure conlec_valueExit(Sender: TObject);
    procedure congro_valueExit(Sender: TObject);
    procedure conResCat0_valueExit(Sender: TObject);
    procedure conResCat1_valueExit(Sender: TObject);
    procedure conpla_valueExit(Sender: TObject);
    procedure conper_valueExit(Sender: TObject);
    procedure confor_valueExit(Sender: TObject);
    procedure consub_valueExit(Sender: TObject);
    procedure AVAIL_TYPEClick(Sender: TObject);
    procedure group_AVAIL_TYPEClick(Sender: TObject);
    procedure group_AVAIL_CURRClick(Sender: TObject);
    procedure AVAIL_ORIGExit(Sender: TObject);
    procedure AVAIL_ORIGEnter(Sender: TObject);
    procedure contttChange(Sender: TObject);
    procedure bSeltttClick(Sender: TObject);
    procedure bCleartttClick(Sender: TObject);
    procedure conttt_valueDblClick(Sender: TObject);
    procedure RESCAT_COMB_IDChange(Sender: TObject);
    procedure RESCAT_COMB_IDSelClick(Sender: TObject);
    procedure RESCAT_COMB_IDClearClick(Sender: TObject);
    procedure RESCAT_COMB_ID_VALUEDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FGenericFilterbClearLClick(Sender: TObject);
    procedure FGenericFilterbClearSClick(Sender: TObject);
    procedure FGenericFilterbClearRes0Click(Sender: TObject);
    procedure FGenericFilterbClearPeriodClick(Sender: TObject);
    procedure FGenericFilterconPerChange(Sender: TObject);
    procedure FGenericFilterconPlaChange(Sender: TObject);
    procedure chbShowLClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BRecalculateAllClick(Sender: TObject);
    procedure FGenericFilterMenuItem5Click(Sender: TObject);
    procedure FGenericFilterMenuItem6Click(Sender: TObject);
    procedure GenericFilterbClearLClick(Sender: TObject);
    procedure GenericFilterbClearGClick(Sender: TObject);
    procedure GenericFilterbClearSClick(Sender: TObject);
    procedure GenericFilterbClearFClick(Sender: TObject);
    procedure GenericFilterbClearPeriodClick(Sender: TObject);
    procedure GenericFiltermigeClick(Sender: TObject);
    procedure GenericFiltermigaClick(Sender: TObject);
    procedure GenericFiltermiseClick(Sender: TObject);
    procedure GenericFiltermisaClick(Sender: TObject);
    procedure GenericFiltermifeClick(Sender: TObject);
    procedure GenericFiltermifaClick(Sender: TObject);
    procedure GenericFiltermipeClick(Sender: TObject);
    procedure GenericFiltermipaClick(Sender: TObject);
    procedure GenericFiltermir0eClick(Sender: TObject);
    procedure GenericFiltermir0aClick(Sender: TObject);
    procedure GenericFiltermir1eClick(Sender: TObject);
    procedure GenericFiltermir1aClick(Sender: TObject);
    procedure GenericFilterbClearRes0Click(Sender: TObject);
    procedure GenericFilterbClearRes1Click(Sender: TObject);
    procedure BRecalculateAllQuickClick(Sender: TObject);
    procedure TimerDetailsTimer(Sender: TObject);
  private
    Counter  : Integer;
    procedure refreshDetails;
    procedure ValidField (f, f_value : tedit; tableName, fieldName : shortString);
    function getResIds : string;
    function getRescatIts : string;
    procedure Recalculate_AVAIL_CURR;
    procedure lecvisible     ( pVisible : boolean );
    procedure grovisible     ( pVisible : boolean );
    procedure rescat0visible ( pVisible : boolean );
    procedure rescat1visible ( pVisible : boolean );
    procedure subvisible     ( pVisible : boolean );
    procedure forvisible     ( pVisible : boolean );
    procedure pervisible     ( pVisible : boolean );
    procedure plavisible     ( pVisible : boolean );
  public
    disableControls : boolean;
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues;         override;
    Procedure CustomConditions;    override;
    procedure hideDisplayFields(Sender: TObject);
    Procedure BeforeEdit;            override;
    Procedure AfterPost;             override;
    procedure setColsVisible;
    Procedure SetAccessForButtons;   override;
    Procedure GetTableName;  override;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;
    Function  canInsert    : Boolean;        override;
    Function  canDelete    : Boolean;        override;
  end;

var
  FBrowseTT_COMBINATIONS: TFBrowseTT_COMBINATIONS;

implementation

uses DM, uutilityParent, autocreate, ucommon, ufmain, UFProgramSettings;

{$R *.dfm}

{ TFBrowseTT_COMBINATIONS }

Procedure TFBrowseTT_COMBINATIONS.GetTableName;
Begin
  Self.TableName := 'TT_COMBINATIONS';
End;


function TFBrowseTT_COMBINATIONS.CheckRecord: Boolean;
var resIds      : String;
    q           : tadoquery;
    checkResult : shortString;
    p_current_comb_id : string;
begin
  With UUtilityParent.CheckValid Do Begin
    Init(Self);
    //RestrictEmpty([FOR_ID, ORGUNI_ID, FORMULA_TYPE, FORMULA, DATE_FROM ]);
    resIds := getresIds;

    if (AVAIL_TYPE.Checked) and (AVAIL_ORIG.Text = '') then addError('Podaj wartoœæ limitu');

    if (conlec_value.Visible)     and (conlec.Text = '')     then addError('WprowadŸ wartoœæ w polu ' + llec.caption     );
    if (congro_value.Visible)     and (congro.Text = '')     then addError('WprowadŸ wartoœæ w polu ' + lgro.caption     );
    if (conrescat0_value.Visible) and (conrescat0.Text = '') then addError('WprowadŸ wartoœæ w polu ' + lrescat0.caption );
    if (conrescat1_value.Visible) and (conrescat1.Text = '') then addError('WprowadŸ wartoœæ w polu ' + lrescat1.caption );
    if (consub_value.Visible)     and (consub.Text = '')     then addError('WprowadŸ wartoœæ w polu ' + lsub.caption     );
    if (confor_value.Visible)     and (confor.Text = '')     then addError('WprowadŸ wartoœæ w polu ' + lfor.caption     );
    if (conper_value.Visible)     and (conper.Text = '')     then addError('WprowadŸ wartoœæ w polu ' + lper.caption     );
    if (conpla_value.Visible)     and (conpla.Text = '')     then addError('WprowadŸ wartoœæ w polu ' + lpla.caption     );

    if CanClose_ = false then begin
      Result := ShowMessage;
      exit;
    end;

    if (resIds = '' ) and (getRescatIts = '') then addError('Brak danych do zapisania');
    if (resIds <> '') and (getRescatIts = '') then
    begin
      if wordCount( resIds,[','])>=16 then
        info('Ze wzglêdu na du¿¹ liczbê wybranych zasobów (>=16), operacja sprawdzenia, czy istniej¹ podobne kombinacje zajê³a by zbyt wiele czasu i zostanie pominiêta. Kombinacja zostanie dodana')
      else
      begin
        q := nil;
        dmodule.createQuery(q);
        p_current_comb_id := Query['Id'];
        dmodule.sql(q, 'begin tt_planner.verify(:p_pla_id, :resIds, :p_auto_fix, :p_current_comb_id, :p_no_subsets ); end;'
                   // p_no_subsets must be N. Example: comb type is: LEC,SUB. Combination is: LEC1, SUB1, SUB2, SUB3.
                   // With p_no_subsets=Y we would be unable to add combination.
                   ,'p_pla_id='+fmain.getUserOrRoleId+';resIds='+resIds+';p_auto_fix=N;p_current_comb_id='+p_current_comb_id+';p_no_subsets=N'
                   );
        checkResult := dmodule.SingleValue('select count(1) from tt_check_results');
        if checkResult <> '0' then
        begin
          checkResult := dmodule.SingleValue('select count(1) from tt_check_results where found_tt is null');
          if checkResult <> '0' then
          //no error, there are combinations to be satisfacted, so add combination
          else addError('Nie mo¿na zapisaæ rekordu. '+cr+'Mo¿liwe przyczyny: '+cr+'    1/ Nie wype³niono wszystkich pól'+cr+'    2/ Kombinacja, lub kombinacja ogólniejsza ju¿ istnieje');
        end;
      end;
    end;
    //todo: if getRescatIts <> '' then verify

    Result := ShowMessage;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.DefaultValues;
begin
  inherited;
  Query['ID'] := DModule.SingleValue('SELECT TT_SEQ.NEXTVAL FROM DUAL');
  if group_AVAIL_TYPE.ItemIndex = 0 then Query['AVAIL_TYPE'] := 'N';
  if group_AVAIL_TYPE.ItemIndex = 1 then Query['AVAIL_TYPE'] := 'L';
  if group_AVAIL_TYPE.ItemIndex = 2 then Query['AVAIL_TYPE'] := 'N';
  if conttt.Text <>'' THEN Query['RESCAT_COMB_ID'] := conttt.Text;
  conlec.Text    := GenericFilter.conl.Text;
  congro.Text    := GenericFilter.cong.Text;
  conrescat0.Text:= GenericFilter.conrescat0.Text;
  conrescat1.Text:= GenericFilter.conrescat1.Text;
  consub.Text    := GenericFilter.cons.Text;
  confor.Text    := GenericFilter.conf.Text;
  conper.Text    := GenericFilter.conperiod.Text;
  conpla.Text    := GenericFilter.conpla.Text;
  Query['ENABLED']    := 'Y';
  //
  lecAll.Checked := false;
  groAll.Checked := false;
  resCat0All.Checked := false;
  resCat1All.Checked := false;
  subAll.Checked := false;
  forAll.Checked := false;
  perAll.Checked := false;
  plaAll.Checked := false;
end;

procedure TFBrowseTT_COMBINATIONS.QueryAfterScroll(DataSet: TDataSet);
begin
  Counter := 2;
end;

procedure TFBrowseTT_COMBINATIONS.QClassesBeforeOpen(
  DataSet: TDataSet);
begin
  //If not Query.Active Then exit;
  //(DataSet as tadoquery).Parameters.ParamByName('tt_comb_id').Value := Query['Id'];
end;

procedure TFBrowseTT_COMBINATIONS.Qtt_inclusionsBeforeOpen(
  DataSet: TDataSet);
begin
  //If not Query.Active Then exit;
  // (DataSet as tadoquery).Parameters.ParamByName('tt_comb_id').Value := Query['Id'];
end;

procedure TFBrowseTT_COMBINATIONS.setColsVisible;
    Function ColNo(FieldName : ShortString) : Integer;
    Var L : Integer;
    Begin
     For L:=0 To Grid.Columns.Count - 1 Do Begin
      If Grid.Columns[L].FieldName = FieldName Then Begin Result := L; Exit; End;
     End;
     Result := -1;
    End;
  begin
    With fprogramSettings do begin
     Grid.Columns[ ColNo('RES_DESC_L') ].visible := iif(chbShowL.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_G') ].visible := iif(chbShowG.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_RESCAT0') ].visible := iif(chbShowRESCAT0.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_RESCAT1') ].visible := iif(chbShowRESCAT1.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_S') ].visible := iif(chbShowS.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_F') ].visible := iif(chbShowF.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_PER') ].visible := iif(chbShowPer.Checked, true, false);
     Grid.Columns[ ColNo('RES_DESC_PLA') ].visible := iif(chbShowPla.Checked, true, false);
     Grid.Columns[ ColNo('TYPE_DSP') ].visible := iif(chbShowttt.Checked, true, false);
    end;
  end;

procedure TFBrowseTT_COMBINATIONS.CustomConditions;
var filter     : string;
    resIds     : string;
begin
  inherited;
  with GenericFilter do
  resIds     := concatElements ( [iif(true,genericfilter.conl.Text,'')
                                , iif(true,genericfilter.cong.Text,'')
                                , iif(true,genericfilter.conresCat0.Text,'')
                                , iif(true,genericfilter.conresCat1.Text,'')
                                , iif(true,genericfilter.cons.Text,'')
                                , iif(true,genericfilter.conf.Text,'')
                                , iif(true,genericfilter.conperiod.Text,'')
                                , iif(true,genericfilter.conpla.Text,'')
                                ]
                                , ',');

  if resIds='' then
    filter := '0=0'
  else
    filter :=
      dmodule.SingleValue('select tt_planner.get_filter (:p_res_ids) from dual'
                         ,'p_res_ids='+resIds
                          );

  if group_AVAIL_TYPE.ItemIndex = 0 then filter := filter + ' AND AVAIL_TYPE=''L''';
  if group_AVAIL_TYPE.ItemIndex = 1 then filter := filter + ' AND AVAIL_TYPE=''N''';
  if group_AVAIL_CURR.ItemIndex = 0 then filter := filter + ' AND AVAIL_CURR>0';
  if group_AVAIL_CURR.ItemIndex = 1 then filter := filter + ' AND AVAIL_CURR<0';
  if group_AVAIL_CURR.ItemIndex = 2 then filter := filter + ' AND AVAIL_CURR=0';

  if conttt.Text <> ''              then filter := filter + ' AND RESCAT_COMB_ID='+conttt.Text;

  if filter='' then filter := '0=0';
  DM.macros.setMacro(query, 'CUSTOMCONDITIONALS', filter );

   DM.macros.setMacro( Query, 'CONPERMISSIONS',
     '     (lec.id is null or ' + getWhereClause('lecturers','lec')   +')'+
     ' and (gro.id is null or ' + getWhereClause('groups','gro')      +')'+
     ' and (rom.id is null or ' + getWhereClause('rooms','rom')       +')'+
     ' and (sub.id is null or ' + getWhereClause('subjects','sub')    +')'+
     ' and (xfor.id is null or ' + getWhereClause('forms','xfor')       +')'+
     ' and (per.id is null or ' + getWhereClause('periods','per')     +')'
     );

  //DM.macros.setMacro(query, 'g_lecturer', intToStr(dm.g_lecturer));
  //DM.macros.setMacro(query, 'g_group'   , intToStr(dm.g_group));
  //DM.macros.setMacro(query, 'prescatid0', dmodule.presCatId0);
  //DM.macros.setMacro(query, 'prescatid1', dmodule.presCatId1);
  //DM.macros.setMacro(query, 'g_subject' , intToStr(dm.g_subject));
  //DM.macros.setMacro(query, 'g_form'    , intToStr(dm.g_form));
  //DM.macros.setMacro(query, 'g_period'  , intToStr(dm.g_period));
  //DM.macros.setMacro(query, 'g_planner' , intToStr(dm.g_planner));

end;


procedure TFBrowseTT_COMBINATIONS.selectLecClick(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(ConLec.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego wyk³adowcy')
      Else begin
       ConLec.Text := Merge(KeyValue, ConLec.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectGroClick(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If GROUPSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conGro.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tej samej grupy')
      Else begin
        conGro.Text := Merge(KeyValue, conGro.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectResCat0Click(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId0,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conResCat0.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else begin
        conResCat0.Text := Merge(KeyValue, conResCat0.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectResCat1Click(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId1,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conResCat1.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else begin
        conResCat1.Text := Merge(KeyValue, conResCat1.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectSubClick(Sender: TObject);
Var KeyValues : shortString;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  //@@@should be SUBJECTSShowModalAsMultiSelect
  If SUBJECTSShowModalAsSelect(KeyValues,'') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conSub.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego przedmiotu')
      Else begin
        conSub.Text := Merge(KeyValue, conSub.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectForClick(Sender: TObject);
Var KeyValues : shortString;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  //@@@should be FormSShowModalAsMultiSelect
  If FormsShowModalAsSelect(KeyValues,'') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conFor.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tej samej formy')
      Else begin
        conFor.Text := Merge(KeyValue, conFor.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectPerClick(Sender: TObject);
Var KeyValues : shortString;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  //@@@should be FormSShowModalAsMultiSelect
  If PeriodsShowModalAsSelect(KeyValues) = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conPer.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego semestru')
      Else begin
        conPer.Text := Merge(KeyValue, conPer.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.selectPlaClick(Sender: TObject);
Var KeyValues : shortString;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  //@@@should be FormSShowModalAsMultiSelect
  If plannersShowModalAsSelect(KeyValues) = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conPla.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego planisty')
      Else begin
        conPla.Text := Merge(KeyValue, conPla.Text, ';');
      end;
   end;
  End;
end;

procedure TFBrowseTT_COMBINATIONS.clearLecClick(Sender: TObject);
begin
  conlec.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearGroClick(Sender: TObject);
begin
  congro.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearResCat0Click(Sender: TObject);
begin
  conResCat0.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearResCat1Click(Sender: TObject);
begin
  conResCat1.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearSubClick(Sender: TObject);
begin
  conSub.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearForClick(Sender: TObject);
begin
  conFor.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearPerClick(Sender: TObject);
begin
  conPer.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.clearPlaClick(Sender: TObject);
begin
  conPla.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.conlecChange(Sender: TObject);
begin
  if not disableControls then conLec_value.Text := FChange(ConLec.text, sql_LECDESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.congroChange(Sender: TObject);
begin
  if not disableControls then conGro_value.Text := FChange(ConGro.text, sql_GRODESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.conResCat0Change(Sender: TObject);
begin
  if not disableControls then conResCat0_value.Text := FChange(conResCat0.text, sql_ResCat0DESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.conResCat1Change(Sender: TObject);
begin
  if not disableControls then conResCat1_value.Text :=  FChange(conResCat1.text, sql_ResCat1DESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.consubChange(Sender: TObject);
begin
  if not disableControls then conSub_value.Text := FChange(conSub.text, sql_SUBDESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.conforChange(Sender: TObject);
begin
  if not disableControls then conFor_value.Text := FChange(conFor.text,  sql_FORDESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.conperChange(Sender: TObject);
begin
  if not disableControls then conPer_value.Text := FChange(conPer.text, sql_PERDESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.conplaChange(Sender: TObject);
begin
  if not disableControls then conPla_value.Text := FChange(conPla.text, sql_PLADESC, ';');
end;

procedure TFBrowseTT_COMBINATIONS.hideDisplayFields(Sender: TObject);
begin
  if disableControls then exit;

  if llec.Visible then begin
  conlec_value.Visible := not lecAll.Checked;
  selectLec.Visible    := not lecAll.Checked;
  clearLec.Visible     := not lecAll.Checked;
  end;

  if lgro.Visible then begin
  congro_value.Visible := not groAll.Checked;
  selectgro.Visible    := not groAll.Checked;
  cleargro.Visible     := not groAll.Checked;
  end;

  if lrescat0.Visible then begin
  conrescat0_value.Visible := not rescat0All.Checked;
  selectrescat0.Visible    := not rescat0All.Checked;
  clearrescat0.Visible     := not rescat0All.Checked;
  end;

  if lrescat1.Visible then begin
  conrescat1_value.Visible := not rescat1All.Checked;
  selectrescat1.Visible    := not rescat1All.Checked;
  clearrescat1.Visible     := not rescat1All.Checked;
  end;

  if lsub.Visible then begin
  consub_value.Visible := not subAll.Checked;
  selectsub.Visible    := not subAll.Checked;
  clearsub.Visible     := not subAll.Checked;
  end;

  if lfor.Visible then begin
  confor_value.Visible := not forAll.Checked;
  selectfor.Visible    := not forAll.Checked;
  clearfor.Visible     := not forAll.Checked;
  end;

  if lper.Visible then begin
  conper_value.Visible := not perAll.Checked;
  selectper.Visible    := not perAll.Checked;
  clearper.Visible     := not perAll.Checked;
  end;

  if lpla.Visible then begin
  conpla_value.Visible := not plaAll.Checked;
  selectpla.Visible    := not plaAll.Checked;
  clearpla.Visible     := not plaAll.Checked;
  end;
end;

procedure TFBrowseTT_COMBINATIONS.lecAllClick(Sender: TObject);
begin
  hideDisplayFields( nil );
end;

procedure TFBrowseTT_COMBINATIONS.BeforeEdit;
var   rescat_id : integer;
      res_id    : shortString;
begin
 // CurrOperation mo¿e przyjmowaæ wartoœci {AINSERT, ACOPY, AEDIT}
 if CurrOperation <> AINSERT then begin
   disableControls := true;
   forAll.Checked     := false;
   subAll.Checked     := false;
   lecAll.Checked     := false;
   groAll.Checked     := false;
   plaAll.Checked     := false;
   perAll.Checked     := false;
   resCat0All.Checked := false;
   resCat1All.Checked := false;
   conlec.Text        := '';
   congro.Text        := '';
   conrescat0.Text    := '';
   conrescat1.Text    := '';
   consub.Text        := '';
   confor.Text        := '';
   conper.Text        := '';
   conpla.Text        := '';
   //
   with dmodule do begin
     opensql(
      'select * from tt_inclusions where inclusion_type=''ALL'' and tt_comb_id = '+ id +cr+
      'order by 1');
     qwork.First;
     while not qwork.Eof do begin
       rescat_id := qwork.fieldbyname('rescat_id').AsInteger;
       case rescat_id of
         g_form      : forAll.Checked := true;
         g_subject   : subAll.Checked := true;
         g_lecturer  : lecAll.Checked := true;
         g_group     : groAll.Checked := true;
         g_planner   : plaAll.Checked := true;
         g_period    : perAll.Checked := true;
         //g_date_hour : forAll.Checked := true @@@currently not used
         else
           if rescat_id = strToInt(dmodule.pResCatId0) then resCat0All.Checked := true else
           if rescat_id = strToInt(dmodule.pResCatId1) then resCat1All.Checked := true;
       end;
       qwork.Next;
     end;
   end;
   //
   with dmodule do begin
     opensql(
      'select id, res_id, tt_planner.get_rescat_id(res_id) rescat_id from tt_resource_lists where tt_comb_id = '+ id +cr+
      'order by 1');
     qwork.First;
     while not qwork.Eof do begin
       rescat_id := qwork.fieldbyname('rescat_id').AsInteger;
       res_id    := qwork.fieldbyname('res_id').AsString;

       case rescat_id of
         g_form      : confor.Text := merge(confor.Text, res_id, ';');
         g_subject   : consub.Text := merge(consub.Text, res_id, ';');
         g_lecturer  : conlec.Text := merge(conlec.Text, res_id, ';');
         g_group     : congro.Text := merge(congro.Text, res_id, ';');
         g_planner   : conpla.Text := merge(conpla.Text, res_id, ';');
         g_period    : conper.Text := merge(conper.Text, res_id, ';');
         //g_date_hour : forAll.Checked := true @@@currently not used
         else
           if rescat_id = strToInt(dmodule.pResCatId0) then conrescat0.Text := merge(conrescat0.Text, res_id, ';') else
           if rescat_id = strToInt(dmodule.pResCatId1) then conrescat1.Text := merge(conrescat1.Text, res_id, ';');
       end;
       qwork.Next;
     end;
   disableControls := false;
   hideDisplayFields(nil);
   conLec_value.Text := FChange(ConLec.text, sql_LECDESC, ';');
   conGro_value.Text := FChange(ConGro.text, sql_GRODESC, ';');
   conResCat0_value.Text := FChange(conResCat0.text, sql_ResCat0DESC, ';');
   conResCat1_value.Text := FChange(conResCat1.text, sql_ResCat1DESC, ';');
   conSub_value.Text := FChange(conSub.text, sql_SUBDESC, ';');
   conFor_value.Text :=  FChange(conFor.text, sql_FORDESC, ';');
   conPer_value.Text :=  FChange(conPer.text, sql_PERDESC, ';');
   conPla_value.Text :=  FChange(conPla.text, sql_PLADESC, ';');
   end;
 end else
 begin
   if RESCAT_COMB_ID.text = '' then begin
     lecvisible     ( false );
     grovisible     ( false );
     rescat0visible ( false );
     rescat1visible ( false );
     subvisible     ( false );
     forvisible     ( false );
     pervisible     ( false );
     plavisible     ( false );
   end;
 end;
 AVAIL_TYPEClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.AfterPost;
var vId              : shortString;
    resIds           : String;
    resCatIds        : String;
    q                : tadoquery;
    p_avail_type     : shortString;
    p_avail_orig     : shortString;
    p_avail_curr     : shortString;
    p_enabled        : shortString;
    p_sort_order     : shortString;
    p_rescat_comb_id : shortString;
begin
  if not (llec.Visible)     then conlec.Text     := '';
  if not (lgro.Visible)     then congro.Text     := '';
  if not (lrescat0.Visible) then conrescat0.Text := '';
  if not (lrescat1.Visible) then conrescat1.Text := '';
  if not (lsub.Visible)     then consub.Text     := '';
  if not (lfor.Visible)     then confor.Text     := '';
  if not (lper.Visible)     then conper.Text     := '';
  if not (lpla.Visible)     then conpla.Text     := '';

  vId          := Query['ID'];
  p_avail_type := Query['avail_type'];
  p_avail_orig := replace( Query.FieldByName('avail_orig').AsString, ',', '.');
  p_avail_curr := replace( Query.FieldByName('avail_curr').AsString, ',', '.');
  p_enabled    := Query['enabled'];
  p_sort_order := Query.FieldByName('sort_order').AsString;
  p_rescat_comb_id:= Query.FieldByName('rescat_comb_id').AsString;

  resIds := getresIds;
  resCatIds := getRescatIts;

  q := nil;
  dmodule.createQuery(q);
  dmodule.sql(q, 'begin tt_planner.put_combination(:p_rescat_comb_id, :resIds, :resAllCatIds, :vCombId, :p_avail_type, :p_avail_orig, :p_avail_curr, :p_enabled, :p_sort_order); end;'
             ,'p_rescat_comb_id='+p_rescat_comb_id+';resIds='+resIds+';resAllCatIds='+resCatIds+';vCombId='+vId+';p_avail_type='+p_avail_type+';p_avail_orig='+p_avail_orig+';p_avail_curr='+p_avail_curr+';p_enabled='+p_enabled+';p_sort_order='+p_sort_order
             );

  Recalculate_AVAIL_CURR;
end;

procedure TFBrowseTT_COMBINATIONS.ValidField(f, f_value: tedit; tableName,
  fieldName: shortString);
var values, ids : String;
begin
 values := f_value.Text;
 ValidValues(tableName,values,fieldName,ids,';');
 f_value.Text := values;
 f.Text := ids;
end;

procedure TFBrowseTT_COMBINATIONS.conlec_valueExit(Sender: TObject);
begin
  ValidField (conLec, conLec_value, 'LECTURERS', sql_LECNAME);
end;

procedure TFBrowseTT_COMBINATIONS.congro_valueExit(Sender: TObject);
begin
  ValidField (conGro, conGro_value, 'GROUPS', sql_GRONAME);
end;

procedure TFBrowseTT_COMBINATIONS.conResCat0_valueExit(Sender: TObject);
begin
  ValidField (conResCat0, conResCat0_value, 'ROOMS', sql_RESCAT0NAME);
end;

procedure TFBrowseTT_COMBINATIONS.conResCat1_valueExit(Sender: TObject);
begin
  ValidField (conResCat1, conResCat1_value, 'ROOMS', sql_RESCAT1NAME);
end;

procedure TFBrowseTT_COMBINATIONS.conpla_valueExit(Sender: TObject);
begin
  ValidField (conPla, conPla_value, 'PLANNERS', sql_PLANAME);
end;

procedure TFBrowseTT_COMBINATIONS.conper_valueExit(Sender: TObject);
begin
  ValidField (conPer, conPer_value, 'PERIODS', sql_PERNAME);
end;

procedure TFBrowseTT_COMBINATIONS.confor_valueExit(Sender: TObject);
begin
  ValidField (conFor, conFor_value, 'FORMS', sql_FORNAME);
end;

procedure TFBrowseTT_COMBINATIONS.consub_valueExit(Sender: TObject);
begin
  ValidField (conSub, conSub_value, 'SUBJECTS', sql_SUBNAME);
end;

function TFBrowseTT_COMBINATIONS.getResIds: string;
begin
  result    := '';
  result := merge( result , iif(lecAll.Checked,     '', conlec.Text)    , ',');
  result := merge( result , iif(groAll.Checked,     '', congro.Text    ), ',');
  result := merge( result , iif(rescat0All.Checked, '', conrescat0.Text), ',');
  result := merge( result , iif(rescat1All.Checked, '', conrescat1.Text), ',');
  result := merge( result , iif(subAll.Checked,     '', consub.Text    ), ',');
  result := merge( result , iif(forAll.Checked,     '', confor.Text    ), ',');
  result := merge( result , iif(perAll.Checked,     '', conper.Text    ), ',');
  result := merge( result , iif(plaAll.Checked,     '', conpla.Text    ), ',');
  result := replace(result,';',',');
end;

function TFBrowseTT_COMBINATIONS.getRescatIts: string;
begin
  result := '';
  result := merge(result, iif(lecAll.Checked,     intTostr(g_lecturer), ''), ',');
  result := merge(result, iif(groAll.Checked,     intTostr(g_group),    ''), ',');
  result := merge(result, iif(rescat0All.Checked, dmodule.pResCatId0,   ''), ',');
  result := merge(result, iif(rescat1All.Checked, dmodule.pResCatId1,   ''), ',');
  result := merge(result, iif(subAll.Checked,     intTostr(g_subject),  ''), ',');
  result := merge(result, iif(forAll.Checked,     intTostr(g_form),     ''), ',');
  result := merge(result, iif(perAll.Checked,     intTostr(g_period),   ''), ',');
  result := merge(result, iif(plaAll.Checked,     intTostr(g_planner),  ''), ',');
  result := replace(result,';',',');
end;

procedure TFBrowseTT_COMBINATIONS.AVAIL_TYPEClick(Sender: TObject);
begin
  AVAIL_ORIG.Visible              := AVAIL_TYPE.Checked;
  LabelAVAIL_CURR.Visible         := AVAIL_TYPE.Checked;
  AVAIL_CURR.Visible              := AVAIL_TYPE.Checked;
  chbRecalculate_AVAIL_CURR.Visible := AVAIL_TYPE.Checked;
end;

procedure TFBrowseTT_COMBINATIONS.group_AVAIL_TYPEClick(Sender: TObject);
begin
  inherited;
  group_AVAIL_CURR.Visible := group_AVAIL_TYPE.ItemIndex in [0,2];
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.group_AVAIL_CURRClick(Sender: TObject);
begin
  inherited;
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.AVAIL_ORIGExit(Sender: TObject);
begin
  inherited;
  Query['AVAIL_CURR'] := AVAIL_ORIG.Text;
end;

procedure TFBrowseTT_COMBINATIONS.Recalculate_AVAIL_CURR;
var p_tt_comb_id : shortString;
begin
 if not chbRecalculate_AVAIL_CURR.Checked then exit;
 p_tt_comb_id := Query['Id'];
 // this function is more general and works fine, but it slower:
 //dmodule.sql('begin tt_planner.recalc_book_combination (:p_tt_comb_id ); end;'
 //           ,'p_tt_comb_id='+p_tt_comb_id
 //           );
 dmodule.sql('begin tt_planner.recalc_combination122 (''N'', null, :p_tt_comb_id ); end;'
            ,'p_tt_comb_id='+p_tt_comb_id
            );

 //Query.FieldByName('avail_curr').AsString := dmodule.SingleValue('select avail_curr from tt_combinations where id = ' + p_tt_comb_id );
 info ('Wartoœæ "Do zaplanowania" zosta³a przeliczona');
end;

procedure TFBrowseTT_COMBINATIONS.AVAIL_ORIGEnter(Sender: TObject);
begin
  chbRecalculate_AVAIL_CURR.Checked := true;
end;

procedure TFBrowseTT_COMBINATIONS.contttChange(Sender: TObject);
begin
  conttt_value.Text := fchange(Conttt.text, sql_TTRESCATDESC);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.bSeltttClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONttt.Text;
  If TT_RESCAT_COMBINATIONSShowModalAsSelect(KeyValue) = mrOK Then Begin
   CONttt.Text := KeyValue;
  End;
end;


procedure TFBrowseTT_COMBINATIONS.bCleartttClick(Sender: TObject);
begin
  conttt.Text := '';
end;

procedure TFBrowseTT_COMBINATIONS.conttt_valueDblClick(Sender: TObject);
begin
  bSeltttClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.RESCAT_COMB_IDChange(Sender: TObject);
begin
  //if not ( MainPage.ActivePage = update ) then exit;
  with dmodule do begin
    RefreshLookupEdit(Self, TControl(Sender).Name,'tt_planner.get_resource_cat_names(ID)','TT_RESCAT_COMBINATIONS','');
    //if disableControls then exit;
    lecvisible     ( false );
    grovisible     ( false );
    rescat0visible ( false );
    rescat1visible ( false );
    subvisible     ( false );
    forvisible     ( false );
    pervisible     ( false );
    plavisible     ( false );
    //
    if RESCAT_COMB_ID.Text = '' then exit;
    openSQL('select rescat_id from tt_rescat_combinations_dtl where rescat_comb_id = :rescat_comb_id', 'rescat_comb_id='+ RESCAT_COMB_ID.Text );
    while not qwork.Eof do begin
      case qwork.FieldByName('rescat_id').AsInteger of
        g_form    : forvisible     ( true );
        g_subject : subvisible     ( true );
        g_lecturer: lecvisible     ( true );
        g_group   : grovisible     ( true );
        g_planner : plavisible     ( true );
        g_period  : pervisible     ( true );
        else begin
         if qwork.FieldByName('rescat_id').AsString = dm.dmodule.pResCatId0 then rescat0visible ( true );
         if qwork.FieldByName('rescat_id').AsString = dm.dmodule.pResCatId1 then rescat1visible ( true );
        end;
      end;
      qwork.Next;
    end;
  end;
end;

procedure TFBrowseTT_COMBINATIONS.RESCAT_COMB_IDSelClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := RESCAT_COMB_ID.Text;
  If TT_RESCAT_COMBINATIONSShowModalAsSelect(ID) = mrOK Then Query['RESCAT_COMB_ID'] := ID;
end;

procedure TFBrowseTT_COMBINATIONS.RESCAT_COMB_IDClearClick(Sender: TObject);
begin
 Query.FieldByName('RESCAT_COMB_ID').AsString := '';
end;

procedure TFBrowseTT_COMBINATIONS.RESCAT_COMB_ID_VALUEDblClick(
  Sender: TObject);
begin
 RESCAT_COMB_IDSelClick (nil);
end;

procedure TFBrowseTT_COMBINATIONS.lecvisible ( pVisible : boolean );
begin
  llec.Visible         := pVisible;
  conlec_value.visible := pVisible;
  selectLec.visible    := pVisible;
  clearLec.visible     := pVisible;
  lecAll.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.grovisible ( pVisible : boolean );
begin
  lgro.Visible := pVisible;
  congro_value.visible := pVisible;
  selectgro.visible    := pVisible;
  cleargro.visible     := pVisible;
  groAll.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.rescat0visible ( pVisible : boolean );
begin
  lResCat0.Visible := pVisible;
  conResCat0_value.visible := pVisible;
  selectResCat0.visible    := pVisible;
  clearResCat0.visible     := pVisible;
  ResCat0All.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.rescat1visible ( pVisible : boolean );
begin
  lResCat1.Visible := pVisible;
  conResCat1_value.visible := pVisible;
  selectResCat1.visible    := pVisible;
  clearResCat1.visible     := pVisible;
  ResCat1All.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.subvisible ( pVisible : boolean );
begin
  lsub.Visible := pVisible;
  consub_value.visible := pVisible;
  selectsub.visible    := pVisible;
  clearsub.visible     := pVisible;
  subAll.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.forvisible ( pVisible : boolean );
begin
  lfor.Visible := pVisible;
  confor_value.visible := pVisible;
  selectfor.visible    := pVisible;
  clearfor.visible     := pVisible;
  forAll.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.pervisible ( pVisible : boolean );
begin
  lper.Visible := pVisible;
  conper_value.visible := pVisible;
  selectper.visible    := pVisible;
  clearper.visible     := pVisible;
  perAll.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.plavisible ( pVisible : boolean );
begin
  lpla.Visible := pVisible;
  conpla_value.visible := pVisible;
  selectpla.visible    := pVisible;
  clearpla.visible     := pVisible;
  plaAll.visible       := pVisible;
end;

procedure TFBrowseTT_COMBINATIONS.FormCreate(Sender: TObject);
    procedure refreshLabelNames;
      Function ColNo(FieldName : ShortString) : Integer;
      Var L : Integer;
      Begin
       For L:=0 To Grid.Columns.Count - 1 Do Begin
        If Grid.Columns[L].FieldName = FieldName Then Begin Result := L; Exit; End;
       End;
       Result := -1;
      End;
    begin
      lResCat0.Caption := dmodule.pResCatName0;
      lResCat1.Caption := dmodule.pResCatName1;

      With fprogramSettings do begin
      Grid.Columns[ ColNo('RES_DESC_L') ].Title.Caption       := profileObjectNameL.text;
      Grid.Columns[ ColNo('RES_DESC_G') ].Title.Caption       := profileObjectNameG.text;
      Grid.Columns[ ColNo('RES_DESC_RESCAT0') ].Title.Caption := dmodule.pResCatName0;
      Grid.Columns[ ColNo('RES_DESC_RESCAT1') ].Title.Caption := dmodule.pResCatName1;
      Grid.Columns[ ColNo('RES_DESC_S') ].Title.Caption       := profileObjectNameC1.text;
      Grid.Columns[ ColNo('RES_DESC_F') ].Title.Caption       := profileObjectNameC2.text;
      Grid.Columns[ ColNo('RES_DESC_PER') ].Title.Caption     := profileObjectNamePeriod.text;
      Grid.Columns[ ColNo('RES_DESC_PLA') ].Title.Caption     := profileObjectNamePlanner.text;
      end;
    end;
begin
  GenericFilter.refreshLabelNames;
  refreshLabelNames;
  with fprogramSettings do begin
    HolderSortOrder.CommaText := translateMessages ( HolderSortOrder.CommaText );
  end;
  inherited;
  SetNotUpdatable([RESCAT_COMB_ID, RESCAT_COMB_ID_VALUE, RESCAT_COMB_IDSel, RESCAT_COMB_IDClear], [LRESCAT_COMB_ID]);
  Counter := 3;
end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterbClearLClick(
  Sender: TObject);
begin
  GenericFilter.bClearLClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterbClearSClick(
  Sender: TObject);
begin
  inherited;
  GenericFilter.bClearSClick(Sender);
end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterbClearRes0Click(
  Sender: TObject);
begin
  inherited;
  GenericFilter.bClearRes0Click(Sender);
end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterbClearPeriodClick(
  Sender: TObject);
begin
  inherited;
  GenericFilter.bClearPeriodClick(Sender);

end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterconPerChange(
  Sender: TObject);
begin
  inherited;
  GenericFilter.conPeriodChange(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterconPlaChange(
  Sender: TObject);
begin
  inherited;
  GenericFilter.conPlaChange(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.chbShowLClick(Sender: TObject);
begin
  setColsVisible;
end;

procedure TFBrowseTT_COMBINATIONS.SetAccessForButtons;
begin
  inherited;
  setColsVisible;
end;

procedure TFBrowseTT_COMBINATIONS.BRefreshClick(Sender: TObject);
begin
  inherited;
  GenericFilter.refresh;
end;

procedure TFBrowseTT_COMBINATIONS.BRecalculateAllClick(Sender: TObject);
var p_tt_comb_id, lRevert : shortString;
    counter       : integer;
begin
  lRevert := BRecalculateAll.Caption;
  counter := 0;
  query.First;
  while not query.Eof do begin
    p_tt_comb_id := Query['Id'];
    // this function is more general and works fine, but it slower:
    //dmodule.sql('begin tt_planner.recalc_book_combination (:p_tt_comb_id ); end;'
    //           ,'p_tt_comb_id='+p_tt_comb_id
    //
    dmodule.sql('begin tt_planner.recalc_combination122 (''N'', null, :p_tt_comb_id ); end;'
            ,'p_tt_comb_id='+p_tt_comb_id
            );


    query.Next;
    counter := counter + 1;
    BRecalculateAll.Caption := 'Przeliczonych:' + intToStr(counter);
    BRecalculateAll.Refresh;
  end;
  BRecalculateAll.Caption := lRevert;
  Fmain.Zapisz1Click(nil);

  BRefreshClick(nil);
end;


procedure TFBrowseTT_COMBINATIONS.FGenericFilterMenuItem5Click(
  Sender: TObject);
begin
  GenericFilter.mileClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.FGenericFilterMenuItem6Click(
  Sender: TObject);
begin
  GenericFilter.milaClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearLClick(
  Sender: TObject);
begin
  GenericFilter.bClearLClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearGClick(
  Sender: TObject);
begin
  GenericFilter.bClearGClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearSClick(
  Sender: TObject);
begin
  GenericFilter.bClearSClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearFClick(
  Sender: TObject);
begin
  GenericFilter.bClearFClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearPeriodClick(
  Sender: TObject);
begin
  GenericFilter.bClearPeriodClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermigeClick(Sender: TObject);
begin
  GenericFilter.migeClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermigaClick(Sender: TObject);
begin
  GenericFilter.migaClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermiseClick(Sender: TObject);
begin
  GenericFilter.miseClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermisaClick(Sender: TObject);
begin
  GenericFilter.misaClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermifeClick(Sender: TObject);
begin
  GenericFilter.mifeClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermifaClick(Sender: TObject);
begin
  GenericFilter.mifaClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermipeClick(Sender: TObject);
begin
  GenericFilter.mipeClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermipaClick(Sender: TObject);
begin
  GenericFilter.mipaClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermir0eClick(Sender: TObject);
begin
  GenericFilter.mir0eClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermir0aClick(Sender: TObject);
begin
  GenericFilter.mir0aClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermir1eClick(Sender: TObject);
begin
  GenericFilter.mir1eClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFiltermir1aClick(Sender: TObject);
begin
  GenericFilter.mir1aClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearRes0Click(
  Sender: TObject);
begin
  GenericFilter.bClearRes0Click(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseTT_COMBINATIONS.GenericFilterbClearRes1Click(
  Sender: TObject);
begin
  GenericFilter.bClearRes1Click(Sender);
  BRefreshClick(nil);
end;

function TFBrowseTT_COMBINATIONS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;


function TFBrowseTT_COMBINATIONS.getSearchFilter: string;
begin
 result := '('+
         buildFilter(FMain.sql_COM_SEARCH.Text, ESearch.Text)+
        ' OR sub.Id in (SELECT SUBJECTS.ID FROM SUBJECTS, ORG_UNITS  where ORGUNI_ID=ORG_UNITS.ID and SUBJECTS.id>0 and ' + buildFilter(sql_SUB_SEARCH, ESearch.Text) + ')'+
        ')';
end;

procedure TFBrowseTT_COMBINATIONS.BRecalculateAllQuickClick(Sender: TObject);
begin
    dmodule.sql('begin tt_planner.recalc_combination122 (:pCleanYpMode ); commit; end;'
            ,'pCleanYpMode=N'
    );
  BRefreshClick(nil);
end;


{
select tt_planner.get_res_desc ( res_id, tt_planner.get_rescat_id (res_id) ) description
  from tt_resource_lists
  where tt_comb_id = :tt_comb_id
order by 1


select decode(INCLUSION_TYPE,'LIST','Lista: ','ALL','WSZYSCY: ', INCLUSION_TYPE) ||' '|| tt_planner.get_rescat_desc (rescat_id) description
  from tt_inclusions
  where tt_comb_id = :tt_comb_id and INCLUSION_TYPE <> 'LIST'
order by 1
}



procedure TFBrowseTT_COMBINATIONS.refreshDetails;
begin
  QClasses.Close;
  If Query.IsEmpty Then Begin
    QClasses.Parameters.paramByName('tt_comb_id').value   := '-1';
  End Else Begin
    ID := NVL(Query.FieldByName('ID').AsString,'-1');
    QClasses.Parameters.paramByName('tt_comb_id').value             := ID;
  End;
  QClasses.Open;

  Counter := 1;
end;

procedure TFBrowseTT_COMBINATIONS.TimerDetailsTimer(Sender: TObject);
begin
  If Counter > 0 Then Counter := Counter - 1;
  If Counter = 1 Then refreshDetails;
end;

function TFBrowseTT_COMBINATIONS.canDelete: Boolean;
begin
 result := isIntegrated=false;
end;

function TFBrowseTT_COMBINATIONS.canInsert: Boolean;
begin
 result := isIntegrated=false;
end;

end.
