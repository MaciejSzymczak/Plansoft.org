unit UFGenericFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, StrHlder, Menus;

type
  TFGenericFilter = class(TFrame)
    conl: TEdit;
    conl_value: TEdit;
    cong: TEdit;
    cong_value: TEdit;
    conResCat0: TEdit;
    conrescat0_value: TEdit;
    conResCat1: TEdit;
    conrescat1_value: TEdit;
    cons: TEdit;
    cons_value: TEdit;
    conf: TEdit;
    conf_value: TEdit;
    conPeriod: TEdit;
    conperiod_value: TEdit;
    conPla: TEdit;
    conPla_value: TEdit;
    ShowL: TEdit;
    ShowG: TEdit;
    ShowResCat0: TEdit;
    ShowRESCAT1: TEdit;
    ShowS: TEdit;
    ShowForm: TEdit;
    ShowPeriod: TEdit;
    ShowPlanner: TEdit;
    PERFilterType: TEdit;
    LFilterType: TEdit;
    GFilterType: TEdit;
    R0FilterType: TEdit;
    SFilterType: TEdit;
    FFilterType: TEdit;
    PERPopup: TPopupMenu;
    mipe: TMenuItem;
    mipa: TMenuItem;
    LPopup: TPopupMenu;
    mile: TMenuItem;
    mila: TMenuItem;
    GPopup: TPopupMenu;
    mige: TMenuItem;
    miga: TMenuItem;
    R0Popup: TPopupMenu;
    mir0e: TMenuItem;
    mir0a: TMenuItem;
    SPopup: TPopupMenu;
    mise: TMenuItem;
    misa: TMenuItem;
    FPopup: TPopupMenu;
    mife: TMenuItem;
    mifa: TMenuItem;
    PERSettings: TStrHolder;
    LSettings: TStrHolder;
    GSettings: TStrHolder;
    R0Settings: TStrHolder;
    SSettings: TStrHolder;
    FSettings: TStrHolder;
    Holder: TStrHolder;
    bClearS: TSpeedButton;
    bClearF: TSpeedButton;
    bClearL: TSpeedButton;
    bClearG: TSpeedButton;
    bClearPeriod: TSpeedButton;
    R1Popup: TPopupMenu;
    mir1e: TMenuItem;
    mir1a: TMenuItem;
    R1Settings: TStrHolder;
    R1FilterType: TEdit;
    bClearRes0: TSpeedButton;
    bClearRes1: TSpeedButton;
    bClearPlanner: TSpeedButton;
    procedure bClearGClick(Sender: TObject);
    procedure aaaaClick(Sender: TObject);
    procedure yyyyyyyyyyClick(Sender: TObject);
    procedure bClearSClick(Sender: TObject);
    procedure bClearFClick(Sender: TObject);
    procedure conlChange(Sender: TObject);
    procedure congChange(Sender: TObject);
    procedure conResCat0Change(Sender: TObject);
    procedure conResCat1Change(Sender: TObject);
    procedure consChange(Sender: TObject);
    procedure confChange(Sender: TObject);
    procedure bSelPlannerClick(Sender: TObject);
    procedure bClearPeriodClick(Sender: TObject);
    procedure xxxClick(Sender: TObject);
    procedure conPeriodChange(Sender: TObject);
    procedure conPlaChange(Sender: TObject);
    procedure conl_valueChange(Sender: TObject);
    procedure conl_valueClick(Sender: TObject);
    procedure bClearLClick(Sender: TObject);
    procedure mileClick(Sender: TObject);
    procedure milaClick(Sender: TObject);
    procedure cons_valueChange(Sender: TObject);
    procedure cong_valueChange(Sender: TObject);
    procedure conf_valueChange(Sender: TObject);
    procedure conperiod_valueChange(Sender: TObject);
    procedure migeClick(Sender: TObject);
    procedure migaClick(Sender: TObject);
    procedure miseClick(Sender: TObject);
    procedure misaClick(Sender: TObject);
    procedure mifeClick(Sender: TObject);
    procedure mifaClick(Sender: TObject);
    procedure mipeClick(Sender: TObject);
    procedure mipaClick(Sender: TObject);
    procedure conrescat0_valueChange(Sender: TObject);
    procedure conrescat1_valueChange(Sender: TObject);
    procedure mir0eClick(Sender: TObject);
    procedure mir1eClick(Sender: TObject);
    procedure mir0aClick(Sender: TObject);
    procedure mir1aClick(Sender: TObject);
    procedure bClearRes0Click(Sender: TObject);
    procedure bClearRes1Click(Sender: TObject);
    procedure conPla_valueClick(Sender: TObject);
    procedure bClearPlannerClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure refreshLabelNames;
    function sqlL( ptablePostfix : string ) : string;
    function sqlG( ptablePostfix : string ) : string;
    function sqlR0( ptablePostfix : string ) : string;
    function sqlR1( ptablePostfix : string ) : string;
    function sqlS( ptablePostfix : string ) : string;
    function sqlF( ptablePostfix : string ) : string;
    function sqlP( ptablePostfix : string ) : string;
  end;

implementation

{$R *.dfm}

Uses autocreate, DM, ucommon, UFProgramSettings, UUtilities, UUtilityParent, UFModuleFilter,
  UFBrowseLECTURERS, uFBrowseGROUPS, UFBrowseSUBJECTS, uFBrowseFORMS,
  uFBrowsePERIODS, UFBrowseROOMS;

function TFGenericFilter.sqlL ( ptablePostfix : string ) : string;
begin
 result := GetCLASSESforL( nvl(CONL.Text, LSettings.Strings.Values['SQL.Category:DEFAULT']) ,ptablePostfix,LFilterType.text);
end;

function TFGenericFilter.sqlG ( ptablePostfix : string ) : string;
begin
 result := GetCLASSESforG( nvl(CONG.Text, GSettings.Strings.Values['SQL.Category:DEFAULT']) ,ptablePostfix,GFilterType.text);
end;

function TFGenericFilter.sqlR0 ( ptablePostfix : string ) : string;
begin
 result := GetCLASSESforR( nvl(conResCat0.Text, R0Settings.Strings.Values['SQL.Category:DEFAULT']) ,ptablePostfix,R0FilterType.text);
end;

function TFGenericFilter.sqlR1 ( ptablePostfix : string ) : string;
begin
 result := GetCLASSESforR( nvl(conResCat1.Text, R1Settings.Strings.Values['SQL.Category:DEFAULT']) ,ptablePostfix,R1FilterType.text);
end;


function TFGenericFilter.sqlS ( ptablePostfix : string ) : string;
begin
  result := '0=0';
  If                                        CONS.Text <> '' then result := 'SUB_ID='+CONS.Text;
  If SSettings.Strings.Values['SQL.Category:DEFAULT'] <> '' then result := 'SUB_ID IN( SELECT ID FROM SUBJECTS WHERE '+SSettings.Strings.Values['SQL.Category:DEFAULT'] + ')';
end;

function TFGenericFilter.sqlF ( ptablePostfix : string ) : string;
begin
  result := '0=0';
  If                                       CONF.Text <> '' Then result := 'FOR_ID='+CONF.Text;
  If FSettings.Strings.Values['SQL.Category:DEFAULT']<> '' Then result := 'FOR_ID IN (SELECT ID FROM FORMS WHERE '+FSettings.Strings.Values['SQL.Category:DEFAULT']+')';
end;

function TFGenericFilter.sqlP ( ptablePostfix : string ) : string;
Var     DateFrom, DateTo : string;
begin
  result := '0=0';
  If (CONPERIOD.Text <> '') or (PERSettings.Strings.Values['SQL.Category:DEFAULT'] <> '') Then
  Begin
      With DModule Do Begin
          Dmodule.SingleValue('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM FROM PERIODS WHERE '+ NVL(PERSettings.Strings.Values['SQL.Category:DEFAULT'], 'ID='+CONPERIOD.Text) );
          DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
          DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
      End;
      result := 'CLASSES.DAY BETWEEN '+DateFrom+' AND '+DateTo;
  End;
end;

procedure TFGenericFilter.bSelPlannerClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONPLA.Text;
  If PlannersShowModalAsSelect(KeyValue) = mrOK Then Begin
   CONPLA.Text := KeyValue;
  End;
  //to aviod problem "label vanished"
  self.Refresh;
end;

procedure TFGenericFilter.bClearGClick(Sender: TObject);
begin
  CONG_VALUE.Text := '';
  GSettings.Strings.Clear;
  CONG.Text := '';
end;

procedure TFGenericFilter.aaaaClick(Sender: TObject);
begin
  conResCat0_value.Text := '';
  R0Settings.Strings.Clear;
  conResCat0.Text := '';
end;

procedure TFGenericFilter.yyyyyyyyyyClick(Sender: TObject);
begin
  conResCat1_value.Text := '';
  R1Settings.Strings.Clear;
  conResCat1.Text := '';
end;

procedure TFGenericFilter.bClearSClick(Sender: TObject);
begin
  CONS_VALUE.Text := '';
  SSettings.Strings.Clear;
  CONS.Text := '';
end;

procedure TFGenericFilter.bClearFClick(Sender: TObject);
begin
  CONF_VALUE.Text := '';
  FSettings.Strings.Clear;
  CONF.Text := '';
end;

procedure TFGenericFilter.bClearPeriodClick(Sender: TObject);
begin
  CONPERIOD_VALUE.Text := '';
  PerSettings.Strings.Clear;
  CONPERIOD.Text := '';
end;

procedure TFGenericFilter.xxxClick(Sender: TObject);
begin
  conpla.Text := '';
end;

procedure TFGenericFilter.conlChange(Sender: TObject);
begin
  If Trim(CONL.TEXT) <> '' Then CONL_VALUE.Text := DModule.SingleValue('SELECT FIRST_NAME||'' ''||LAST_NAME FROM LECTURERS WHERE ID='+CONL.TEXT)
                           Else CONL_VALUE.Text := '';
end;

procedure TFGenericFilter.congChange(Sender: TObject);
begin
  //?FChange(ConG, conG_value, sql_GRODESC);
  If Trim(CONG.TEXT) <> '' Then CONG_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM GROUPS WHERE ID='+CONG.TEXT)
                           Else CONG_VALUE.Text := '';
end;

procedure TFGenericFilter.conResCat0Change(Sender: TObject);
begin
  //?FChange(ConResCat0, conResCat0_value, sql_RESCAT0DESC);
  If Trim(conResCat0.TEXT) <> '' Then conResCat0_value.Text := DMOdule.SingleValue('SELECT '+sql_ResCat0NAME+' FROM ROOMS WHERE ID='+conResCat0.TEXT)
                                 Else conResCat0_value.Text := '';
end;

procedure TFGenericFilter.conResCat1Change(Sender: TObject);
begin
  //?FChange(ConResCat1, conResCat1_value, sql_RESCAT1DESC);
  If Trim(conResCat1.TEXT) <> '' Then conResCat1_value.Text := DMOdule.SingleValue('SELECT '+sql_ResCat1NAME+' FROM ROOMS WHERE ID='+conResCat1.TEXT)
                                 Else conResCat1_value.Text := '';
end;

procedure TFGenericFilter.consChange(Sender: TObject);
begin
  //?FChange(ConS, conS_value, sql_SUBDESC);
  If Trim(CONS.TEXT) <> '' Then CONS_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM SUBJECTS WHERE ID='+CONS.TEXT)
                           Else CONS_VALUE.Text := '';
end;

procedure TFGenericFilter.confChange(Sender: TObject);
begin
  //?FChange(ConF, conF_value, sql_FORDESC);
  If Trim(CONF.TEXT) <> '' Then CONF_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM FORMS WHERE ID='+CONF.TEXT)
                           Else CONF_VALUE.Text := '';
end;

procedure TFGenericFilter.conPeriodChange(Sender: TObject);
begin
  FChange(ConPeriod, conPeriod_value, sql_PERDESC);
  //DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
end;

procedure TFGenericFilter.conPlaChange(Sender: TObject);
begin
  FChange(ConPla, ConPla_value, sql_PLADESC);
  bClearPlanner.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.refreshLabelNames;
begin
 ShowResCat0.text := dmodule.pResCatName0;
 ShowResCat1.text := dmodule.pResCatName1;

 with fprogramSettings do begin
   ShowL.text      := profileObjectNameL.text;
   ShowG.text      := profileObjectNameG.text;
   ShowS.text      := profileObjectNameC1.text;
   ShowForm.text      := profileObjectNameC2.text;
   ShowPeriod.text := profileObjectNamePeriod.text;
   ShowPlanner.text:= profileObjectNamePlanner.text;
 end;
end;


procedure TFGenericFilter.conl_valueChange(Sender: TObject);
begin
  bClearl.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.conl_valueClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 if btn.Name = 'conperiod_value' then PERPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'conl_value'      then LPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'cong_value'      then GPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'conrescat0_value' then R0Popup.Popup(Point.X,Point.Y);
 if btn.Name = 'conrescat1_value' then R1Popup.Popup(Point.X,Point.Y);
 if btn.Name = 'cons_value'      then SPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'conf_value'      then FPopup.Popup(Point.X,Point.Y);
end;

procedure TFGenericFilter.bClearLClick(Sender: TObject);
begin
  CONL_VALUE.Text := '';
  LSettings.Strings.Clear;
  CONL.Text := '';
end;

procedure TFGenericFilter.mileClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONL.Text;
  If LECTURERSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
      LFilterType.text := 'e';
      LSettings.Strings.Clear;
      CONL.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.milaClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.LECTURERSCreate;
  If UFModuleFilter.ShowModal( LSettings.Strings, fBrowseLECTURERS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      LFilterType.text := 'a';
      CONL.Text := '';
      CONL_VALUE.Text := LSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
end;

procedure TFGenericFilter.cons_valueChange(Sender: TObject);
begin
  bClearS.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.cong_valueChange(Sender: TObject);
begin
  bClearG.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.conf_valueChange(Sender: TObject);
begin
  bClearF.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.conperiod_valueChange(Sender: TObject);
begin
  bClearPeriod.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.migeClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONG.Text;
  If groupSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
      GFilterType.text := 'e';
      GSettings.Strings.Clear;
      CONG.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.migaClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.GROUPSCreate;
  If UFModuleFilter.ShowModal( GSettings.Strings, fBrowseGROUPS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      GFilterType.text := 'a';
      CONG.Text := '';
      CONG_VALUE.Text := GSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  info('Je¿eli w danym zajêciu uczestnicz¹ grupy ze studiów stacjonarnych oraz niestacjonarnych i zostanie ustawiony filtr ="Stacjonarne", to na zestawieniu pojawi¹ siê OBIE grupy', showOnceaday);
end;

procedure TFGenericFilter.miseClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONS.Text;
  If SUBJECTSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
      SFilterType.text := 'e';
      SSettings.Strings.Clear;
      CONS.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.misaClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.SUBJECTSCreate;
  If UFModuleFilter.ShowModal( SSettings.Strings, fBrowseSUBJECTS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
    SFilterType.text := 'a';
    CONS.Text := '';
    CONS_VALUE.Text := SSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
end;

procedure TFGenericFilter.mifeClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONF.Text;
  If FORMSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
      FFilterType.text := 'e';
      FSettings.Strings.Clear;
      CONF.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.mifaClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.FORMSCreate;
  If UFModuleFilter.ShowModal( FSettings.Strings, fBrowseFORMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      FFilterType.text := 'a';
      CONF.Text := '';
      CONF_VALUE.Text := FSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
end;

procedure TFGenericFilter.mipeClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONPERIOD.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
      PERFilterType.text := 'e';
      PerSettings.Strings.Clear;
      CONPERIOD.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.mipaClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.PERIODSCreate;

  If UFModuleFilter.ShowModal( PerSettings.Strings, fBrowsePERIODS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      PERFilterType.text := 'a';
      CONPERIOD.Text := '';
      CONPERIOD_VALUE.Text := PERSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
end;

procedure TFGenericFilter.conrescat0_valueChange(Sender: TObject);
begin
  bClearRes0.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.conrescat1_valueChange(Sender: TObject);
begin
  bClearRes1.Visible := (sender as tedit).Text <> '';
end;

procedure TFGenericFilter.mir0eClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := conResCat0.Text;
  If ROOMSShowModalAsSelect(dmodule.pResCatId0,'',KeyValue,'0=0','') = mrOK Then Begin
      R0FilterType.text := 'e';
      R0Settings.Strings.Clear;
      conResCat0.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.mir1eClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := conResCat1.Text;
  If ROOMSShowModalAsSelect(dmodule.pResCatId1,'',KeyValue,'0=0','') = mrOK Then Begin
      R1FilterType.text := 'e';
      R1Settings.Strings.Clear;
      conResCat1.Text := KeyValue;
  End;
end;

procedure TFGenericFilter.mir0aClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.ROOMSInit(dmodule.pResCatId0,'','0=0','');
  If UFModuleFilter.ShowModal( R0Settings.Strings, fBrowseROOMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      conResCat0.Text := '';
      conResCat0_value.Text := R0Settings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  R0FilterType.text := 'a';
end;

procedure TFGenericFilter.mir1aClick(Sender: TObject);
begin
  if not elementEnabled('"Statystyki - filtr zaawansowany"','2013.07.05', false) then exit;
  autocreate.ROOMSInit(dmodule.pResCatId1,'','0=0','');
  If UFModuleFilter.ShowModal( R1Settings.Strings, fBrowseROOMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      conResCat1.Text := '';
      conResCat1_value.Text := R1Settings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  R1FilterType.text := 'a';
end;

procedure TFGenericFilter.bClearRes0Click(Sender: TObject);
begin
  conResCat0_value.Text := '';
  R0Settings.Strings.Clear;
  conResCat0.Text := '';
end;

procedure TFGenericFilter.bClearRes1Click(Sender: TObject);
begin
  conResCat1_value.Text := '';
  R1Settings.Strings.Clear;
  conResCat1.Text := '';
end;

procedure TFGenericFilter.conPla_valueClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONPLA.Text;
  If PlannersShowModalAsSelect(KeyValue) = mrOK Then Begin
   CONPLA.Text := KeyValue;
  End;
  //to aviod problem "label vanished"
  self.Refresh;
end;

procedure TFGenericFilter.bClearPlannerClick(Sender: TObject);
begin
  conPla_value.Text := '';
  conPla.Text := '';
end;

end.
