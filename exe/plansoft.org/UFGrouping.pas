unit UFGrouping;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Db, DBTables, Grids, DBGrids, UUtilityParent,
  ComCtrls, Mask, ToolEdit,
  StrHlder, OleServer, ExcelXP, ADODB, Menus, UFModuleFilter, ImgList;

Type  TKindOfExport = Integer;
Const NotePadExport = 0;
      ExcelExport   = 1;
      WordExport    = 2;
      wwwExport     = 3;
Const LEC_UTILIZATION = 1;
      STUDENTHOURS   = 2;

type
  TFGrouping = class(TFormConfig)
    topPanel: TPanel;
    DataSource: TDataSource;
    groupSelect: TGroupBox;
    ChDay: TCheckBox;
    ChHOUR: TCheckBox;
    CHL: TCheckBox;
    ChG: TCheckBox;
    ChR: TCheckBox;
    ChS: TCheckBox;
    ChF: TCheckBox;
    ChFILL: TCheckBox;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    wherePanel: TGroupBox;
    LL: TLabel;
    LR: TLabel;
    LF: TLabel;
    conResCat0: TEdit;
    CONL: TEdit;
    CONL_VALUE: TEdit;
    conResCat0_value: TEdit;
    CONF_VALUE: TEdit;
    CONPERIOD: TEdit;
    CONPERIOD_VALUE: TEdit;
    Lperiod: TLabel;
    LS: TLabel;
    CONS: TEdit;
    CONS_VALUE: TEdit;
    LG: TLabel;
    CONG: TEdit;
    CONG_VALUE: TEdit;
    CHUNI: TCheckBox;
    CHGT: TCheckBox;
    Holder: TStrHolder;
    Query: TADOQuery;
    chgStudents: TCheckBox;
    groupOrderBy: TGroupBox;
    sortOrderField: TEdit;
    Label1: TLabel;
    savepopup: TPopupMenu;
    SaveApp: TMenuItem;
    SaveHtml: TMenuItem;
    SaveTxt: TMenuItem;
    SaveCsv: TMenuItem;
    ReportsPopup: TPopupMenu;
    BLEC_UTILIZATION: TMenuItem;
    BSTUDENTHOURS: TMenuItem;
    optionsPopup: TPopupMenu;
    chbShowAll: TMenuItem;
    EmergencyMode: TMenuItem;
    chLnewLine: TCheckBox;
    chGnewLine: TCheckBox;
    chRnewLine: TCheckBox;
    buttonsPanel: TPanel;
    bdelpopup: TSpeedButton;
    bOtherReports: TSpeedButton;
    bOptions: TSpeedButton;
    BRefresh: TBitBtn;
    BClose: TBitBtn;
    ChDayOfWeek: TCheckBox;
    BRefreshpopup: TSpeedButton;
    refreshpopup: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Automatycznyeksportdanych1: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    N2: TMenuItem;
    Raportobcieniewykadowcy1: TMenuItem;
    Raportstudentogodziny1: TMenuItem;
    egzaminiwykadwoddzielnejliniitak1: TMenuItem;
    egzaminiwykadwoddzielnejliniinie1: TMenuItem;
    egzaminiwykadwoddzielnejliniitak2: TMenuItem;
    egzaminiwykadwoddzielnejliniinie2: TMenuItem;
    bClearPeriod: TSpeedButton;
    bClearL: TSpeedButton;
    bClearG: TSpeedButton;
    bClearRes0: TSpeedButton;
    bClearS: TSpeedButton;
    bClearF: TSpeedButton;
    PERSettings: TStrHolder;
    LSettings: TStrHolder;
    GSettings: TStrHolder;
    RSettings: TStrHolder;
    SSettings: TStrHolder;
    FSettings: TStrHolder;
    PERPopup: TPopupMenu;
    Filtrprosty1: TMenuItem;
    Filtrzaawansowany1: TMenuItem;
    LPopup: TPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    GPopup: TPopupMenu;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    RPopup: TPopupMenu;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    SPopup: TPopupMenu;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    ImageList: TImageList;
    chgorg: TCheckBox;
    chsorg: TCheckBox;
    chrorg: TCheckBox;
    ChMonth: TCheckBox;
    chDesc1: TCheckBox;
    chDesc2: TCheckBox;
    chDesc3: TCheckBox;
    chDesc4: TCheckBox;
    ChSelectedDates: TCheckBox;
    egenericFilter: TEdit;
    Label2: TLabel;
    PodgldzapytaniaSQL1: TMenuItem;
    Grid: TDBGrid;
    sqlLecturers_aggr: TMemo;
    sqlGroups_aggr: TMemo;
    sqlRes_aggr: TMemo;
    fastQueryString: TMemo;
    SQLPreview: TMemo;
    sqlRes_no_aggr: TMemo;
    sqlGroups_no_aggr: TMemo;
    sqlLecturers_no_aggr: TMemo;
    N3: TMenuItem;
    Zapiszustawienia1: TMenuItem;
    Odczytajustawienia1: TMenuItem;
    Odwieteraz1: TMenuItem;
    bMoreLess: TBitBtn;
    ExcelApplication1: TExcelApplication;
    chlDesc1: TCheckBox;
    chlDesc2: TCheckBox;
    chlDesc3: TCheckBox;
    chlDesc4: TCheckBox;
    ChCreatedBy: TCheckBox;
    ChOwnerName: TCheckBox;
    ChCreationDate: TCheckBox;
    chgParent: TCheckBox;
    chlcount: TCheckBox;
    chgcount: TCheckBox;
    chrcount: TCheckBox;
    chlcountHelp: TSpeedButton;
    ChIntegration_Id: TCheckBox;
    SpeedButton1: TSpeedButton;
    procedure BRefreshClick(Sender: TObject);
    procedure CONLChange(Sender: TObject);
    procedure conResCat0Change(Sender: TObject);
    procedure CONGChange(Sender: TObject);
    procedure CONSChange(Sender: TObject);
    procedure CONPERIODChange(Sender: TObject);
    procedure xBitBtnPERClick(Sender: TObject);
    procedure calculateCountClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bdelpopupClick(Sender: TObject);
    procedure SaveAppClick(Sender: TObject);
    procedure SaveHtmlClick(Sender: TObject);
    procedure SaveTxtClick(Sender: TObject);
    procedure SaveCsvClick(Sender: TObject);
    procedure BLEC_UTILIZATIONClick(Sender: TObject);
    procedure BSTUDENTHOURSClick(Sender: TObject);
    procedure bOtherReportsClick(Sender: TObject);
    procedure bOptionsClick(Sender: TObject);
    procedure chbShowAllClick(Sender: TObject);
    procedure EmergencyModeClick(Sender: TObject);
    procedure BRefreshpopupClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure egzaminiwykadwoddzielnejliniitak1Click(Sender: TObject);
    procedure egzaminiwykadwoddzielnejliniinie1Click(Sender: TObject);
    procedure egzaminiwykadwoddzielnejliniitak2Click(Sender: TObject);
    procedure egzaminiwykadwoddzielnejliniinie2Click(Sender: TObject);
    procedure bClearPeriodClick(Sender: TObject);
    procedure bClearLClick(Sender: TObject);
    procedure bClearGClick(Sender: TObject);
    procedure bClearRes0Click(Sender: TObject);
    procedure bClearSClick(Sender: TObject);
    procedure bClearFClick(Sender: TObject);
    procedure Filtrprosty1Click(Sender: TObject);
    procedure Filtrzaawansowany1Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure CONPERIOD_VALUEChange(Sender: TObject);
    procedure CONL_VALUEChange(Sender: TObject);
    procedure CONG_VALUEChange(Sender: TObject);
    procedure conResCat0_valueChange(Sender: TObject);
    procedure CONS_VALUEChange(Sender: TObject);
    procedure CONF_VALUEChange(Sender: TObject);
    procedure ChSelectedDatesClick(Sender: TObject);
    procedure chLnewLineClick(Sender: TObject);
    procedure chGnewLineClick(Sender: TObject);
    procedure chRnewLineClick(Sender: TObject);
    procedure PodgldzapytaniaSQL1Click(Sender: TObject);
    procedure Zapiszustawienia1Click(Sender: TObject);
    procedure Odczytajustawienia1Click(Sender: TObject);
    procedure Odwieteraz1Click(Sender: TObject);
    procedure bMoreLessClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure chlcountHelpClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
     sortOrder : string[255];
     defaultText : string;
     Procedure UpdStatus(S : String);
     Function  GetFileName(KindOfExport : TKindOfExport) : tfilename;
     function  saveSettings(silentMode : boolean) :boolean;
     function  loadSettings :boolean;
     procedure createBat(batMethod : string);
  public
     ignoreIni : boolean;
     procedure LoadFromIni ( inifilename : tfilename );
     procedure generateReport(reportId : integer; separateLineMode : boolean; pshowLecNames : boolean; fileName : tfilename);
     procedure SaveAsHtml ( fileName : tfileName );
     procedure SaveAsTxt  ( fileName : tfilename);
     procedure SaveAsCsv  ( filename : tfilename);
  end;

var
  FGrouping: TFGrouping;

implementation

uses DM, AutoCreate, UUtilities, ufLookupWindow, UCommon,ComObj, ufMain,
  UFProgramSettings, UFIN_LINESGenerator, UFBrowseLECTURERS,
  uFBrowseGROUPS, uFBrowsePERIODS, UFBrowseSUBJECTS, uFBrowseFORMS,
  UFBrowseROOMS, ActiveX, TlHelp32, Variants, UFMessageBox;

{$R *.DFM}

procedure TFGrouping.BRefreshClick(Sender: TObject);
Var columnsSelect, columnsGroupBy      : String;
    S, _CONL, _CONG, _CONR, _CONS, _CONF, _CONPERIOD, genericFilter  : string;
    _CONL2, _CONG2, _CONR2 : string;
    _PERMISSIONSL, _PERMISSIONSG, _PERMISSIONSR, _PERMISSIONSS, _PERMISSIONSF : string;
    summary1, summary2, summary3, summary4, summary5 : string;
    t                : Integer;
    lx, gx, rx       : boolean;
    //
    columnsLec : string;
    groupByLec : string;
    sqlLecturers_aggr_str : string;
    sqlGroups_aggr_str : string;
    sqlRes_aggr_str : string;


begin

  columnsSelect := '';
  columnsGroupBy := '';
  summary1 := '';
  summary2 := '';
  summary3 := '';
  summary4 := '';
  summary5 := '';

  If ChDay.Checked        Then Begin columnsSelect := Merge(columnsSelect, 'DAY "Dzieñ"', ',');                            columnsGroupBy := Merge(columnsGroupBy, 'DAY', ',');            End;
  If ChMonth.Checked      Then Begin columnsSelect := Merge(columnsSelect, 'TO_CHAR(DAY,''YYYY-MM'') "Miesi¹c"', ',');     columnsGroupBy := Merge(columnsGroupBy, 'TO_CHAR(DAY,''YYYY-MM'')', ',');            End;
  If ChDayOfWeek.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'to_char(DAY,''dy'') "Dzieñ tyg."', ',');       columnsGroupBy := Merge(columnsGroupBy, 'to_char(DAY,''dy'')', ','); End;
  If ChHOUR.Checked       Then Begin columnsSelect := Merge(columnsSelect, 'GRIDS.CAPTION "Godzina"', ',');                columnsGroupBy := Merge(columnsGroupBy, 'GRIDS.CAPTION', ',');  End;
  If ChCreatedBy.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'CLASSES.created_by "Utworzy³"', ',');          columnsGroupBy := Merge(columnsGroupBy, 'CLASSES.created_by', ','); End;
  If ChOwnerName.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'CLASSES.owner "W³aœciciel"', ',');             columnsGroupBy := Merge(columnsGroupBy, 'CLASSES.owner', ','); End;
  If ChCreationDate.Checked        Then Begin columnsSelect := Merge(columnsSelect, 'classes.creation_date "Data utworzenia"', ','); columnsGroupBy := Merge(columnsGroupBy, 'classes.creation_date', ',');            End;

  If ChL.Checked Then Begin
      if chLnewLine.Checked then begin
          columnsSelect := Merge(columnsSelect, 'title "Tytu³"', ',');        columnsGroupBy := Merge(columnsGroupBy, 'title', ',');
          columnsSelect := Merge(columnsSelect, 'first_name "Imiê"', ',');    columnsGroupBy := Merge(columnsGroupBy, 'first_name', ',');
          columnsSelect := Merge(columnsSelect, 'last_name "Nazwisko"', ','); columnsGroupBy := Merge(columnsGroupBy, 'last_name', ',');
          if ChIntegration_Id.checked then columnsSelect := Merge(columnsSelect, 'lecturers.integration_id "LEC Integration Id"', ','); columnsGroupBy := Merge(columnsGroupBy, 'lecturers.integration_id', ',');
      end
      else begin
          //this is needed by report (report sets sortOrder)
          if sortOrder<>'' then begin
           columnsSelect := Merge(columnsSelect, 'CALC_LECTURERS "Wyk³adowcy-skróty"', ','); columnsGroupBy := Merge(columnsGroupBy, 'CALC_LECTURERS', ',');
          end;
          columnsSelect := Merge(columnsSelect, 'SUBSTR(lecturers.full_name,1,500) "%Ls."', ',');  columnsGroupBy := Merge(columnsGroupBy, 'SUBSTR(lecturers.full_name,1,500)', ',');
      end;
  End;

  If ChG.Checked    Then Begin
    columnsSelect := Merge(columnsSelect, 'SUBSTR(groups.group_name,1,500) "%Gs."', ',');  columnsGroupBy := Merge(columnsGroupBy, 'SUBSTR(groups.group_name,1,500)', ',');
    if ChIntegration_Id.checked and chGnewLine.Checked then begin
      columnsSelect := Merge(columnsSelect, 'groups.integration_id "GRO Integration Id"', ','); columnsGroupBy := Merge(columnsGroupBy, 'groups.integration_id', ',');
    end;
  End;

  If ChR.Checked    Then Begin
    columnsSelect := Merge(columnsSelect, 'SUBSTR(resources.res_name,1,500) "Zasoby"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'SUBSTR(resources.res_name,1,500)', ',');
    if (ChIntegration_Id.checked) and (chRnewLine.Checked) then begin
      columnsSelect := Merge(columnsSelect, 'resources.integration_id "RES Integration Id"', ','); columnsGroupBy := Merge(columnsGroupBy, 'resources.integration_id', ',');
    end;
  End;

  //columnsSelect := Merge(columnsSelect, 'CALC_LECTURERS "%Ls."', ',');  columnsGroupBy := Merge(columnsGroupBy, 'CALC_LECTURERS', ',');
  //columnsSelect := Merge(columnsSelect, 'CALC_GROUPS "%Gs."', ',');     columnsGroupBy := Merge(columnsGroupBy, 'CALC_GROUPS', ',');
  //columnsSelect := Merge(columnsSelect, 'CALC_ROOMS "Zasoby"', ',');    columnsGroupBy := Merge(columnsGroupBy, 'CALC_ROOMS', ',');

  If ChDesc1.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'CLASSES.DESC1 "'+chdesc1.Caption+'"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'CLASSES.DESC1', ',');            End;
  If ChDesc2.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'CLASSES.DESC2 "'+chdesc2.Caption+'"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'CLASSES.DESC2', ',');            End;
  If ChDesc3.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'CLASSES.DESC3 "'+chdesc3.Caption+'"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'CLASSES.DESC3', ',');            End;
  If ChDesc4.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'CLASSES.DESC4 "'+chdesc4.Caption+'"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'CLASSES.DESC4', ',');            End;

  If ChFILL.Checked Then Begin columnsSelect := Merge(columnsSelect, 'FILL "Wype³nienie"', ',');     columnsGroupBy := Merge(columnsGroupBy, 'FILL', ',');           End;
  If ChS.Checked    Then Begin
    columnsSelect := Merge(columnsSelect, 'SUB.NAME "%C1."', ',');        columnsGroupBy := Merge(columnsGroupBy, 'SUB.NAME', ',');
    if ChIntegration_Id.checked then begin
      columnsSelect := Merge(columnsSelect, 'SUB.integration_id "SUB Integration Id"', ','); columnsGroupBy := Merge(columnsGroupBy, 'SUB.integration_id', ',');
    end;
  End;

  //this is needed by report (report sets sortOrder)
  if sortOrder<>'' then begin
     If ChF.Checked    Then Begin columnsSelect := Merge(columnsSelect, 'FRM.NAME "%C2."', ',');        columnsGroupBy := Merge(columnsGroupBy, 'FRM.NAME', ',');       End;
     //if ChIntegration_Id.checked then begin
     //  columnsSelect := Merge(columnsSelect, 'FRM.integration_id "FRM Integration Id"', ','); columnsGroupBy := Merge(columnsGroupBy, 'FRM.integration_id', ',');
     //end;
     //columnsSelect := Merge(columnsSelect, 'CALC_LECTURERS "Wykladowcy do obciazenia", CALC_GROUPS "Grupy do obciazenia"', ',');
     //columnsGroupBy := Merge(columnsGroupBy, 'CALC_LECTURERS, CALC_GROUPS', ',');
  end;

  If CHUNI.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'lecturers.orguni "Jednostka wyk³adowcy"', ',');     columnsGroupBy := Merge(columnsGroupBy, 'lecturers.orguni', ',');       End;

  If chgParent.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'groups.parent_group "Grupy nadrzêdne"', ',');    columnsGroupBy := Merge(columnsGroupBy, 'groups.parent_group', ',');       End;

  If chgorg.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'groups.orguni "Jednostka grupy"', ',');    columnsGroupBy := Merge(columnsGroupBy, 'groups.orguni', ',');       End;
  If chsorg.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'sou.name "Jednostka przedmiotu"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'sou.name', ',');       End;
  If chrorg.Checked  Then Begin columnsSelect := Merge(columnsSelect, 'resources.orguni "Jednostka zasobu"', ',');  columnsGroupBy := Merge(columnsGroupBy, 'resources.orguni', ',');       End;

  If CHGT.Checked   Then Begin columnsSelect := Merge(columnsSelect, 'group_type_dsp "Typ"', ',');   columnsGroupBy := Merge(columnsGroupBy, 'group_type_dsp', ',');       End;

  lx := chl.Checked or chuni.Checked;
  gx := chg.Checked or chgt.checked or chgStudents.Checked or chgorg.Checked or chgParent.Checked;
  rx := chr.Checked or chrorg.checked;

  if (chLnewLine.Checked or chGnewLine.Checked or chRnewLine.Checked) then begin
     //
     columnsLec := '';
     groupByLec := '';
     if  chldesc1.Checked then begin columnsLec := Merge(columnsLec, 'ldesc1 "'+chldesc1.Caption+'"', ','); groupByLec := Merge(groupByLec, 'ldesc1', ','); end;
     if  chldesc2.Checked then begin columnsLec := Merge(columnsLec, 'ldesc2 "'+chldesc2.Caption+'"', ','); groupByLec := Merge(groupByLec, 'ldesc2', ',');end;
     if  chldesc3.Checked then begin columnsLec := Merge(columnsLec, 'ldesc3 "'+chldesc3.Caption+'"', ','); groupByLec := Merge(groupByLec, 'ldesc3', ',');end;
     if  chldesc4.Checked then begin columnsLec := Merge(columnsLec, 'ldesc4 "'+chldesc4.Caption+'"', ','); groupByLec := Merge(groupByLec, 'ldesc4', ',');end;
     if chlcount.Checked then begin
       columnsLec := Merge(columnsLec, 'lcount "Liczba wyk³adowców"', ',');
       groupByLec := Merge(groupByLec, 'lcount', ',');
     end;
     //
     columnsSelect := Merge(columnsSelect,
      merge(
      merge(
         iif(chLnewLine.Checked and lx,columnsLec,'')
       , iif(chGnewLine.Checked and gx and chgcount.Checked,'gcount "Liczba Grup"','')
       , ','
      )
       , iif(chRnewLine.Checked and rx and chrcount.Checked,'rcount "Liczba zasobów"','')
       , ',')
    ,',');

    columnsgroupBy := Merge(columnsgroupBy,
      merge(
      merge(
         iif(chLnewLine.Checked and lx,groupByLec,'')
       , iif(chGnewLine.Checked and gx and chgcount.Checked,'gcount','')
       , ','
      )
       , iif(chRnewLine.Checked and rx and chrcount.Checked,'rcount','')
       , ',')
    ,',');
  end;

  if EmergencyMode.Checked then begin
      if ChF.Checked then begin
        dmodule.openSQL(
          'select id, name'+cr+
          'from forms'+cr+
          'where '+format(sql_FOR_SEARCH, [ replacePolishChars( ansiuppercase(trim(CONF_VALUE.Text)) ) ])+
          ' order by sort_order_on_reports,name'
        );
        With dmodule.QWork do begin
          First;
          While not Eof do begin
            SUMMARY1 := merge(summary1,
            ',decode(frm.id,'+FieldByName('id').AsString+',1,0)* GRIDS.DURATION * (FILL/100) "'+FieldByName('name').AsString+'"'
            ,'');
            next;
          end;
        end;
      end;
      SUMMARY1 := merge(summary1, ', ROUND(GRIDS.DURATION * (FILL/100),1) "%CLASSes. (suma)"','')+CR;
    if chgStudents.Checked    then SUMMARY4 := ', groups.NOP  "Liczba studentów"'+CR;
  end
  else begin
      if ChF.Checked then begin
        dmodule.openSQL(
          'select id, name'+cr+
          'from forms'+cr+
          'where '+format(sql_FOR_SEARCH, [ replacePolishChars( ansiuppercase(trim(CONF_VALUE.Text)) ) ])+
          ' order by sort_order_on_reports'
        );
        With dmodule.QWork do begin
          First;
          While not Eof do begin
            SUMMARY1 := merge(summary1,
            ',sum(decode(frm.id,'+FieldByName('id').AsString+',1,0)* GRIDS.DURATION * (FILL/100)) "'+FieldByName('name').AsString+'"'
            ,'');
            next;
          end;
        end;
      end;
      SUMMARY1 := merge(summary1, ', ROUND(sum(GRIDS.DURATION * (FILL/100)),1) "%CLASSes. (suma)"','')+CR;
    //if S4.Checked then SUMMARY4 := ', SUM ( groups.NOP ) "Liczba studentów"'+CR;
    if chgStudents.Checked    then begin SUMMARY4 := ', ( groups.NOP ) "Liczba studentów"'+CR; columnsGroupBy := Merge(columnsGroupBy, 'groups.NOP', ','); end;
  end;

  columnsSelect  := NVL(columnsSelect,'''Wszystko''');
  columnsGroupBy := NVL(columnsGroupBy,'''Wszystko''');


  //   PERIODFilterType : char;
  //   LFilterType : char;
  //   RFilterType : char;
  //   SFilterType : char;
  //   FFilterType : char;

  _CONPERIOD := '0=0';
  If (CONPERIOD.Text <> '') or (PERSettings.Strings.Values['SQL.Category:DEFAULT'] <> '') Then
    _CONPERIOD := Ucommon.getWhereClausefromPeriod(NVL(PERSettings.Strings.Values['SQL.Category:DEFAULT'], 'ID='+CONPERIOD.Text));

  _CONL := GetCLASSESforL('CLASSES.ID', nvl(CONL.Text, LSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',LSettings.Strings.Values['FilterType']);
  _CONG := GetCLASSESforG('CLASSES.ID', nvl(CONG.Text, GSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',GSettings.Strings.Values['FilterType']);
  _CONR := GetCLASSESforR('CLASSES.ID', nvl(conResCat0.Text, RSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',RSettings.Strings.Values['FilterType']);
  _CONL2 := GetCLASSESforL('CLA_ID', nvl(CONL.Text, LSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',LSettings.Strings.Values['FilterType']);
  _CONG2 := GetCLASSESforG('CLA_ID', nvl(CONG.Text, GSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',GSettings.Strings.Values['FilterType']);
  _CONR2 := GetCLASSESforR('CLA_ID', nvl(conResCat0.Text, RSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',RSettings.Strings.Values['FilterType']);

  _CONS := '0=0';
  If                                        CONS.Text <> '' then _CONS := 'SUB_ID='+CONS.Text;
  If SSettings.Strings.Values['SQL.Category:DEFAULT'] <> '' then _CONS := 'SUB_ID IN( SELECT ID FROM SUBJECTS WHERE '+SSettings.Strings.Values['SQL.Category:DEFAULT'] + ')';

  _CONF := '0=0';
  //If                                       CONF.Text <> '' Then _CONF := 'FOR_ID='+CONF.Text;
  //If FSettings.Strings.Values['SQL.Category:DEFAULT']<> '' Then _CONF := 'FOR_ID IN (SELECT ID FROM FORMS WHERE '+FSettings.Strings.Values['SQL.Category:DEFAULT']+')';
  If CONF_VALUE.Text <> '' Then _CONF := 'FOR_ID IN (SELECT ID FROM FORMS WHERE '+format(sql_FOR_SEARCH, [ replacePolishChars( ansiuppercase(trim(CONF_VALUE.Text)) ) ])+')';

  if chbShowAll.Checked then begin
    _permissionsl := '0=0';
    _permissionsg := '0=0';
    _permissionsr := '0=0';
    _permissionss := '0=0';
    _permissionsf := '0=0';
  end
  else begin
    _permissionsl := 'classes.id in ((select cla_id from lec_cla where lec_id in (select id from lecturers where '+getWhereClause('LECTURERS')+' )) union all select id from classes where calc_lec_ids is null)';
    _permissionsg := 'classes.id in ((select cla_id from gro_cla where gro_id in (select id from groups    where '+getWhereClause('GROUPS')+' )) union all select id from classes where calc_gro_ids is null)';
    _permissionsr := 'classes.id in ((select cla_id from rom_cla where rom_id in (select id from rooms     where '+getWhereClause('ROOMS')+' )) union all select id from classes where calc_rom_ids is null)';
    _permissionss := '(classes.sub_id in (select id from subjects  where '+getWhereClause('SUBJECTS')+') or classes.sub_id is null)';
    _permissionsf := '(classes.for_id in (select id from forms     where '+getWhereClause('FORMS')+') or classes.for_id is null )';
  end;

  if egenericFilter.Text='' then
    genericFilter := '0=0'
  else begin
    genericFilter := fastQueryString.Lines.Text;
    genericFilter := stringreplace(genericFilter, 'var1', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var2', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var3', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var4', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var5', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var6', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var7', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var8', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
    genericFilter := stringreplace(genericFilter, 'var9', replacePolishChars( ansiuppercase(egenericFilter.Text) ), []);
  end;

  sqlLecturers_aggr_str := stringreplace(sqlLecturers_aggr.Lines.Text, '%conl',_CONL2, []);
  sqlLecturers_aggr_str := stringreplace(sqlLecturers_aggr_str, '%cong',_CONG2, []);
  sqlLecturers_aggr_str := stringreplace(sqlLecturers_aggr_str, '%conr',_CONR2, []);

  sqlGroups_aggr_str := stringreplace(sqlGroups_aggr.Lines.Text, '%conl',_CONL2, []);
  sqlGroups_aggr_str := stringreplace(sqlGroups_aggr_str, '%cong',_CONG2, []);
  sqlGroups_aggr_str := stringreplace(sqlGroups_aggr_str, '%conr',_CONR2, []);

  sqlRes_aggr_str := stringreplace(sqlRes_aggr.Lines.Text, '%conl',_CONL2, []);
  sqlRes_aggr_str := stringreplace(sqlRes_aggr_str, '%cong',_CONG2, []);
  sqlRes_aggr_str := stringreplace(sqlRes_aggr_str, '%conr',_CONR2, []);

  if trim(sortOrderField.Text)='' then sortOrderField.Text := '1';

  S :=
   'SELECT '+columnsSelect+
   summary1+summary2+summary3+summary4+summary5+
   'FROM CLASSES'+cr+
       ',GRIDS'+cr+
       ',SUBJECTS SUB'+cr+
       ',org_units sou'+cr+
       ',FORMS FRM'+cr+
       iif(lx,',('+ iif(chLnewLine.Checked, sqlLecturers_no_aggr.Lines.Text, sqlLecturers_aggr_str) +') lecturers '+cr,'')+
       iif(gx,',('+ iif(chGnewLine.Checked, sqlGroups_no_aggr.Lines.Text, sqlGroups_aggr_str) +') groups '+cr,'')+
       iif(rx,',('+ iif(chRnewLine.Checked, sqlRes_no_aggr.Lines.Text, sqlRes_aggr_str) +') resources '+cr,'')+
   'WHERE '+
            iif(lx,'lecturers.id(+) = classes.id','0=0')+ cr+
   ' and '+ iif(gx,'groups.id(+) = classes.id','0=0') +cr+
   ' and '+ iif(rx ,'resources.id(+) = classes.id','0=0') +cr+
   ' and FOR_ID = FRM.ID'+cr+
   ' and SUB.ID (+)= SUB_ID'+cr+
   ' and CLASSES.HOUR = GRIDS.NO'+cr+
   ' and SUB.ORGUNI_ID = sou.ID(+)'+cr+
   ' and '+_CONL+CR+
   ' and '+_CONG+CR+
   ' and '+_CONR+CR+
   ' and '+_CONS+CR+
   ' and '+_CONF+CR+
   ' and '+_CONPERIOD +CR+
   ' and '+_PERMISSIONSL+CR+
   ' and '+_PERMISSIONSG+CR+
   ' and '+_PERMISSIONSR+CR+
   ' and '+_PERMISSIONSS+CR+
   ' and '+_PERMISSIONSF+CR+
   ' and '+genericFilter+cr+
   ' and '+iif(ChSelectedDates.Checked,'( CLASSES.DAY,CLASSES.HOUR ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''SESSIONID'') ) ','0=0 ')+CR+
   iif(EmergencyMode.Checked, '--no GROUP BY clause in emergency mode', 'GROUP BY '+columnsGroupBy) + cr+
   nvl(sortOrder, 'order by '
         +  replace(
            replace(
            replace(
               trim(sortOrderField.Text)
            ,'- ',',')
            ,';',',')
            ,'.',',')
       );

  S := fprogramSettings.translateMessages(S);

  sortOrder := '';
  UpdStatus('Oczekiwanie na odpowiedŸ serwera');
  SQLPreview.Lines.clear;
  SQLPreview.Lines.Add(S);

 If (PageControl.ActivePage = TabSheet1) Then
  Begin
   //2011.10.08 to aviod problem "object was open"
   dmodule.resetConnection ( Query );
   Query.SQL.Clear;
   Query.SQL.Add(S);
   Try
   dm.logSQLStart ('SQL', S);
   Query.Open;
   if Grid.Columns[0].Width > 200 then Grid.Columns[0].Width := 200;
   dm.logSQLStop;
   Except
    on E:exception do begin
     if pos('ORA-00933', E.Message) <> 0 then info('B³êdna wartoœæ w polu "porz¹dkowanie danych wg"') else
     if pos('ORA-00904', E.Message) <> 0 then info('B³êdna wartoœæ w polu "porz¹dkowanie danych wg"') else
     if pos('ORA-01785', E.Message) <> 0 then info('B³êdna wartoœæ w polu "porz¹dkowanie danych wg"') else
       SError('Wyst¹pi³ b³¹d podczas wykonywania zapytania:' + E.Message);
      exit;
    end;
   End;
   For t := 0 To Grid.Columns.Count - 1 Do Begin
    With Grid.Columns[t] Do Begin
           If FieldName = 'Dzieñ'                                     Then Begin Title.Caption := 'Dzieñ';                                    Width :=  60; End
      Else If FieldName = 'Godz.'                                     Then Begin Title.Caption := 'Godz.';                                    Width :=  35; End
      Else If FieldName = fprogramSettings.profileObjectNameLs.Text   Then Begin Title.Caption := fprogramSettings.profileObjectNameLs.text;  Width := 200; End
      Else If FieldName = fprogramSettings.profileObjectNameGs.text   Then Begin Title.Caption := fprogramSettings.profileObjectNameGs.text;  Width := 200; End
      Else If FieldName = 'Zasoby'                                    Then Begin Title.Caption := 'Zasoby';                                   Width := 200; End
      Else If FieldName = 'Wype³nienie'                               Then Begin Title.Caption := 'Wype³nienie';                              Width :=  60; End
      Else If FieldName = fprogramSettings.profileObjectNameC1.text   Then Begin Title.Caption := fprogramSettings.profileObjectNameC1.text;  Width := 180; End
      Else If FieldName = fprogramSettings.profileObjectNameC2.text   Then Begin Title.Caption := fprogramSettings.profileObjectNameC2.Text;  Width :=  60; End
      //Else If FieldName = 'Liczba zajêæ' Then Begin Title.Caption := 'Liczba zajêæ'; Width :=  60; End;
    End;
    //FieldName
   End;
  End;

 for t := 1 to Grid.Columns.Count-1 do begin
  if grid.Columns[t].Width > 100 then grid.Columns[t].Width := 100;
  //info ( grid.Columns[0].Field.DataType );
 end;

 UpdStatus('');
end;

procedure TFGrouping.CONLChange(Sender: TObject);
begin
  inherited;
  If Trim(CONL.TEXT) <> '' Then CONL_VALUE.Text := DMOdule.SingleValue('SELECT FIRST_NAME||'' ''||LAST_NAME FROM LECTURERS WHERE ID='+CONL.TEXT)
                           Else CONL_VALUE.Text := '';
  Query.close;
end;

procedure TFGrouping.conResCat0Change(Sender: TObject);
begin
  inherited;
  If Trim(conResCat0.TEXT) <> '' Then conResCat0_value.Text := DMOdule.SingleValue('SELECT '+sql_ResCat0NAME+' FROM ROOMS WHERE ID='+conResCat0.TEXT)
                                 Else conResCat0_value.Text := '';
  Query.close;
end;

procedure TFGrouping.CONGChange(Sender: TObject);
begin
  inherited;
  If Trim(CONG.TEXT) <> '' Then CONG_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM GROUPS WHERE ID='+CONG.TEXT)
                           Else CONG_VALUE.Text := '';
  Query.close;
end;

procedure TFGrouping.CONSChange(Sender: TObject);
begin
  inherited;
  If Trim(CONS.TEXT) <> '' Then CONS_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM SUBJECTS WHERE ID='+CONS.TEXT)
                           Else CONS_VALUE.Text := '';
  Query.close;
end;

//procedure TFGrouping.CONFChange(Sender: TObject);
//begin
//  inherited;
//  If Trim(CONF.TEXT) <> '' Then CONF_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM FORMS WHERE ID='+CONF.TEXT)
//                           Else CONF_VALUE.Text := '';
//  Query.close;
//end;

procedure TFGrouping.CONPERIODChange(Sender: TObject);
begin
  If Not DModule.ADOConnection.Connected Then exit;  // = omit this event during onCreate form
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
  Query.close;
end;

procedure TFGrouping.xBitBtnPERClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 if btn.Name = 'CONPERIOD_VALUE' then PERPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'CONL_VALUE'      then LPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'CONG_VALUE'      then GPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'conResCat0_value'then RPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'CONS_VALUE'      then SPopup.Popup(Point.X,Point.Y);
 //if btn.Name = 'CONF_VALUE'      then FPopup.Popup(Point.X,Point.Y);
end;

procedure TFGrouping.calculateCountClick(Sender: TObject);
begin
  chLnewLine.visible := chl.Checked or chuni.Checked;
  chlDesc1.Visible := chLnewLine.Checked and  (fprogramsettings.getClassDescSingular(1)<>'');
  chlDesc2.Visible := chLnewLine.Checked and  (fprogramsettings.getClassDescSingular(2)<>'');
  chlDesc3.Visible := chLnewLine.Checked and  (fprogramsettings.getClassDescSingular(3)<>'');
  chlDesc4.Visible := chLnewLine.Checked and  (fprogramsettings.getClassDescSingular(4)<>'');
  chGnewLine.visible := chg.Checked or chgt.checked or chgStudents.Checked or chgorg.Checked or chgParent.Checked;
  chRnewLine.visible := chr.Checked or chrorg.checked;
  chlcount.Visible := chLnewLine.Checked;
  chlcountHelp.Visible := chLnewLine.Checked;
  chGcount.Visible := chGnewLine.Checked;
  chRcount.Visible := chRnewLine.Checked;
  Query.close;
end;

procedure TFGrouping.FormShow(Sender: TObject);
var lshowme : boolean;
begin
  if manySubjectsFlag then begin
    ChS.Visible := false;
    ChF.Visible := false;
    chsorg.Visible := false;

    ChS.Checked := false;
    ChF.Checked := false;
    chsorg.Checked := false;
  end;

  defaultText := status.Caption;

 with fprogramsettings do begin
  //self.Caption           := fprogramsettings.profileObjectNameGs.Text;
  LPeriod.Caption := profileObjectNamePeriod.Text;
  LL     .Caption := profileObjectNameL.Text;
  LG     .Caption := profileObjectNameG.Text;
  LS     .Caption := profileObjectNameC1.Text;
  LF     .Caption := profileObjectNameC2.Text;

  chDesc1.Caption := getClassDescPlural(1);
  chDesc2.Caption := getClassDescPlural(2);
  chDesc3.Caption := getClassDescPlural(3);
  chDesc4.Caption := getClassDescPlural(4);

  chlDesc1.Caption := getClassDescSingular(1);
  chlDesc2.Caption := getClassDescSingular(2);
  chlDesc3.Caption := getClassDescSingular(3);
  chlDesc4.Caption := getClassDescSingular(4);

  chDesc1.visible := getClassDescPlural(1)<>'';
  chDesc2.visible := getClassDescPlural(2)<>'';
  chDesc3.visible := getClassDescPlural(3)<>'';
  chDesc4.visible := getClassDescPlural(4)<>'';

  chlDesc1.visible := getClassDescSingular(1)<>'';
  chlDesc2.visible := getClassDescSingular(2)<>'';
  chlDesc3.visible := getClassDescSingular(3)<>'';
  chlDesc4.visible := getClassDescSingular(4)<>'';

  //@@@hardcoding
  lshowme := profileType.ItemIndex = 0;
  //group by
  CHL .Caption := profileObjectNameLs.Text;
  ChG .Caption := profileObjectNameGs.Text;
  ChS .Caption := profileObjectNameC1s.Text;
  ChF .Caption := profileObjectNameC2s.Text;
  CHGT.Caption := 'Typ (' + profileObjectNameG.Text + ')';
  chgStudents.Visible   := lshowme;
  EmergencyMode.Visible := lshowme;

  //additional reports
  BLEC_UTILIZATION.Visible := lshowme;
  BSTUDENTHOURS.Visible    := lshowme;
  end;

  topPanel.Height := 330;
  bMoreLessClick(nil);

  if not ignoreIni then
  if FileExists(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FGrouping.ini') then
      LoadFromIni (UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FGrouping.ini');
end;

Procedure TFGrouping.UpdStatus(S : String);
Begin
 if s = '' then S := defaultText;
 STATUS.Caption := S;
 STATUS.Refresh;
End;

Function TFGrouping.GetFileName(KindOfExport : TKindOfExport) : tfilename;
Var SDialog : TSaveDialog;
Begin
 SDialog  := TSaveDialog.Create(Application);
 SDialog.Options := [ofOverwritePrompt,ofHideReadOnly];
 Case KindOfExport Of
   NotePadExport:Begin
                  SDialog.DefaultExt := 'txt';
                  SDialog.Filter  := Holder.Strings[0];
                 End;
   ExcelExport  :Begin
                  SDialog.DefaultExt := 'xlsx';
                  SDialog.Filter  := Holder.Strings[1];
                 End;
   WordExport   :Begin
                  SDialog.DefaultExt := 'doc';
                  SDialog.Filter  := Holder.Strings[2];
                 End;
   wwwExport   :Begin
                  SDialog.DefaultExt := 'htm';
                  SDialog.Filter  := Holder.Strings[3];
                 End;
   End;

  if SDialog.Execute then result := sdialog.FileName else result := '';
  SDialog.Free;
End;

procedure TFGrouping.generateReport(reportId : integer;
                                    separateLineMode : boolean;
                                    pshowLecNames : boolean;
                                    filename : tfilename);
Var l                 : Integer;
    LiczbaWierszy     : Integer;
    ExcelApplication  : variant;
    colNo             : integer;
    forms2cols        : array [1..100] of string[50];
    lastMarker        : string;
    totalLine1        : extended;
    totalLine2        : extended;
    offset            : integer;

    function getColNo ( s : string ) : integer;
     var i : integer;
    begin
      i := 1;
      while (forms2cols [i] <> s) and (i<100) do inc(i);
      if i = 100 then i := -1;
      result := i;
    end;

begin
  ChDay.Checked       := false;
  ChCreationDate.checked := false;
  ChMonth.Checked     := false;
  ChIntegration_Id.Checked := false;
  ChDayOfWeek.Checked := false;
  ChCreatedBy.Checked   := false;
  ChOwnerName.Checked       := false;
  ChHOUR.Checked      := false;
  CHL.Checked         := true; //!
  ChG.Checked         := true; //!
  ChR.Checked         := false;
  ChFILL.Checked      := false;
  ChS.Checked         := true; //!
  ChF.Checked         := true; //!
  CHUNI.Checked       := false;
  chgorg.Checked      := false;
  chgParent.Checked   := false;
  chsorg.Checked      := false;
  chrorg.Checked      := false;
  CHGT.Checked        := false;
  ChDesc1.Checked     := false;
  ChDesc2.Checked     := false;
  ChDesc3.Checked     := false;
  ChDesc4.Checked     := false;
  ChlDesc1.Checked     := false;
  ChlDesc2.Checked     := false;
  ChlDesc3.Checked     := false;
  ChlDesc4.Checked     := false;
  ChSelectedDates.Checked := false;
  chLnewLine.Checked  := false;
  chGnewLine.Checked  := false;
  chRnewLine.Checked  := false;
  chlcount.Checked  := true;
  chgcount.Checked  := true;
  chrcount.Checked  := true;

  if reportId = STUDENTHOURS then begin
    chgStudents.Checked    := true;
  end;

  if EmergencyMode.Checked then begin
    info ('Nie mo¿na uruchamiaæ tego raportu w trybie diagnostycznym. Je¿eli chcesz uruchomiæ tryb diagnostyczny, to naciœnij przycisk Odœwie¿');
    exit;
  end;

  offset := iif(pshowLecNames, 1, 0);
  //sortOrder := 'ORDER BY CALC_LECTURERS, CALC_GROUPS, SUB.NAME, FRM.NAME';
  sortOrder := 'ORDER BY SUBSTR(lecturers.full_name,1,500),SUBSTR(groups.group_name,1,500), SUB.NAME, FRM.NAME';
  BRefreshClick( nil );

  if not Query.Active then begin
    exit;
  end;

 If true Then Begin
  UpdStatus('Otwieranie programu Excel');
  ExcelApplication := CreateOleObject('Excel.sheet');
  //ExcelApplication.Application.Visible:= true;
  UpdStatus('Tworzenie dokumentu');

  //Query.DisableControls;

  For L := 0 To 2+offset Do Begin
   ExcelApplication.Application.Cells[1,L+1].Value := Grid.Columns[l].Title.Caption;
  End;

  if reportId = STUDENTHOURS then ExcelApplication.Application.Cells[1,4+offset].Value := 'Liczba studentów';

  if reportId = STUDENTHOURS then colNo := 5+offset //zacznij od pi¹tej na raporcie studentogodzin czwarta kolumna to liczba studentów
                             else colNo := 4+offset;

  with dmodule do begin
    dmodule.OPENSQL('SELECT NAME FROM FORMS WHERE KIND = ''C'' AND SORT_ORDER_ON_REPORTS IS NOT NULL ORDER BY SORT_ORDER_ON_REPORTS,NAME');
    while not QWork.Eof do begin
     ExcelApplication.Application.Cells[1, colNo ].Value := qwork.Fields[0].AsString;
     forms2cols [colNo]  := qwork.Fields[0].AsString;
     QWork.Next;
     colNo := colNo + 1;
    end;
  end;

  ExcelApplication.Application.Cells[1, colNo ].Value := 'Razem';
  forms2cols [colno]  := 'Razem';

  LiczbaWierszy := 1;
  lastMarker    := '';
  Query.First;
  totalLine1 := 0;
  totalLine2 := 0;
  While Not Query.EOF Do Begin
    if lastMarker <> (Query.fields[0].AsString + Query.fields[1+offset].AsString + Query.fields[2+offset].AsString) then begin
      if totalLine1 <> 0 then begin
        colNo := getColNo ( 'Razem' );
        if colNo <> -1 then ExcelApplication.Application.Cells[LiczbaWierszy,colNo].Value := totalLine1;
      end;
      if totalLine2 <> 0 then begin
        if colNo <> -1 then colNo := getColNo ( 'Razem' );
        ExcelApplication.Application.Cells[LiczbaWierszy+1,colNo].Value := totalLine2;
      end;
      LiczbaWierszy := LiczbaWierszy + iif (separateLineMode, 2,1);
      totalLine1 := 0;
      totalLine2 := 0;
    end;

    ExcelApplication.Application.Cells[LiczbaWierszy,1].Value := Query.fields[0].AsString; //wykladowca
    if pshowLecNames then begin
      ExcelApplication.Application.Cells[LiczbaWierszy,2].Value := Query.fields[1].AsString; //wykladowca
    end;
    ExcelApplication.Application.Cells[LiczbaWierszy,2+offset].Value := Query.fields[1+offset].AsString; //grupa
    ExcelApplication.Application.Cells[LiczbaWierszy,3+offset].Value := Query.fields[2+offset].AsString; //przedmiot
    if reportId = STUDENTHOURS then
      ExcelApplication.Application.Cells[LiczbaWierszy,4+offset].Value := Query.fields[5+offset].AsString; //liczba studentow

    lastMarker := Query.fields[0].AsString + Query.fields[1+offset].AsString + Query.fields[2+offset].AsString;

    colNo := getColNo ( Query.fields[3+offset].AsString ); //forma
    if colNo <> -1 then begin
      if (not separateLineMode) or ((Query.fields[3+offset].AsString = 'Wyk³ad') or (Query.fields[3+offset].AsString = 'Egzamin')) then begin
        ExcelApplication.Application.Cells[LiczbaWierszy,colNo].Value   := Query.fields[4+offset].AsFloat; //wspolczynnik
        totalLine1 := totalLine1 + Query.fields[4+offset].AsFloat
      end else begin
        ExcelApplication.Application.Cells[LiczbaWierszy+1,colNo].Value := Query.fields[4+offset].AsFloat; //wspolczynnik
        totalLine2 := totalLine2 + Query.fields[4+offset].AsFloat;
      end;
    end;

   Query.Next;
  End;

  deleteFile(FileName);
  ExcelApplication.SaveAs(FileName);
  ExcelApplication.Application.Quit;
  //Query.EnableControls;
  UpdStatus('Uruchamianie programu Excel');
  if not fmain.silentMode then ExecuteFile('Excel.exe','"'+FileName+'"','',SW_SHOWMAXIMIZED);
  UpdStatus('');
 End;
end;

procedure TFGrouping.bdelpopupClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tspeedbutton).Height;
 Point   := (sender as tspeedbutton).ClientToScreen(Point);
 savepopup.Popup(Point.X,Point.Y);
end;

procedure TFGrouping.SaveAppClick(Sender: TObject);
var t : integer;
    pqty, pdesc : string;
begin
  if not query.Active then BRefreshClick(BRefresh);

  Application.CreateForm(TFFIN_LINESGenerator, FFIN_LINESGenerator);
  if FFIN_LINESGenerator.showModal = mrOK then
  begin
   Query.First;
   While not query.Eof do begin
     //
     pdesc := '';
     for t := 0 to query.Fields.Count - 1 do
     begin
      if Grid.Columns[t].FieldName = fprogramsettings.profileObjectNameClasses.Text+' (suma)' then
        pqty := query.Fields[t].AsString
      else
        pdesc := pdesc + Grid.Columns[t].FieldName + ':' +  query.Fields[t].AsString + '    ';
     end;
     pdesc := trim (pdesc);
     // ; is reserved char to separate tokens
     pdesc := searchAndreplace ( pdesc, ';', ',');

     if pqty <> '' then
       FFIN_LINESGenerator.insertLine (pdesc, pqty );
     query.Next;
   end;
   info ('Linie zosta³y dodane do dokumentu');
  end;
  FFIN_LINESGenerator.Free;
  FFIN_LINESGenerator := nil;
end;

procedure TFGrouping.SaveHtmlClick(Sender: TObject);
begin
  if not query.Active then BRefreshClick(BRefresh);
  SaveAsHtml ( applicationDocumentsPath + 'temp.htm' );
end;

procedure TFGrouping.SaveAsHtml (fileName : tfileName );
Var F : Textfile;
    S : String;

    Procedure OutputQuery(Query : TADOQuery; Length : Integer);
    Var t : Integer;
    Begin
      WriteLn(F, '<TABLE ID="mytable">');

      S := '';
      For t := 0 To Query.Fields.Count-1 Do  S := Merge(S, '<TH>'+Query.Fields[t].FieldName+'</TH>', '');
      Writeln(F, '<TR ALIGN=center VALIGN=middle>'+S+'</TR>');

      Query.First;
      While Not Query.EOF Do Begin
       S := '';
       For t := 0 To Query.Fields.Count-1 Do
        If Query.Fields[t].DataType = ftFloat Then S := Merge(S, '<TD>'+FormatFloat('###,###,###,##0.00',Query.Fields[t].AsFloat)+'</TD>', '')
        Else  S := Merge(S, '<TD>'+Query.Fields[t].AsString+'</TD>', '');
       Writeln(F, '<TR ALIGN=center VALIGN=middle>'+S+'</TR>');

       Query.Next;
      End;

      WriteLn(F, '</TABLE>');
    End;

begin
  FProgramSettings.generateJsFiles;

  AssignFile(F, fileName);
  ReWrite(f);
  Writeln(f, '<!DOCTYPE html>');
  Writeln(f, '<HTML>');
  Writeln(f, '<HEAD>');
  Writeln(f, '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">');
  Writeln(f, '<TITLE>'+Self.Caption+'</TITLE>');

  Writeln(f, '<style type="text/css" media="screen">');
  Writeln(f, '@import "filtergrid.css";');
  Writeln(f, 'h2{ margin-top: 50px; }');
  Writeln(f, '.mytable{');
  Writeln(f, '	width:100%; font-size:12px;');
  Writeln(f, '	border:1px solid #ccc;');
  Writeln(f, '}');
  Writeln(f, 'th{ background-color:#003366; color:#FFF; padding:2px; border:1px solid #ccc; }');
  Writeln(f, 'td{ padding:2px; border-bottom:1px solid #ccc; border-right:1px solid #ccc; }');
  Writeln(f, '</style>');
  Writeln(f, '<script language="javascript" type="text/javascript" src="actb.js"></script>');
  Writeln(f, '<script language="javascript" type="text/javascript" src="tablefilter.js"></script>');

  Writeln(f, '</HEAD>');
  Writeln(f, '<BODY>');

  WriteLn(F,'<H2>'+Self.Caption+'</H2>');
  WriteLn(F,'<BR>');
  If Query.Active Then OutputQuery(Query,20);
  WriteLn(F,'<BR>');

  Writeln(f, '<script language="javascript" type="text/javascript">');
  Writeln(f, '//<![CDATA[');

  Writeln(f, '	var table2_Props = 	{');
  Writeln(f, '		sort_select: true,');
  Writeln(f, '		loader: true,');
  Writeln(f, '		col_0: "select",');
  Writeln(f, '		on_change: true,');
  Writeln(f, '		display_all_text: " [ Wszystkie ] ",');
  Writeln(f, '		rows_counter: true,');
  Writeln(f, '		btn_reset: true,');
  Writeln(f, '		rows_counter_text: "Liczba wierszy: ",');
  Writeln(f, '		alternate_rows: true,');
  Writeln(f, '		btn_reset_text: "Czyœæ filtr",');
  //Writeln(f, '		col_width: ["220px",null,"280px"]');
  Writeln(f, '		};');

  Writeln(f, '	setFilterGrid( "mytable",table2_Props );');
  Writeln(f, '//]]>');
  Writeln(f, '</script>');

  Writeln(f, '</BODY></HTML>');
  Closefile(f);
  if not fmain.silentMode then ExecuteFile( fileName,'','',SW_SHOWMAXIMIZED);
end;

procedure TFGrouping.SaveTxtClick(Sender: TObject);
begin
  if not query.Active then BRefreshClick(BRefresh);
  SaveAsTxt(applicationDocumentsPath + 'temp.txt');
end;

procedure TFGrouping.SaveAsTxt(fileName : tfilename);
Var F : Textfile;
    S : String;

    Procedure OutputQuery(Query : TADOQuery; Length : Integer);
    Var t : Integer;
    Begin
      S := '';
      For t := 0 To Query.Fields.Count-1 Do  S := Merge(S, Copy(Query.Fields[t].FieldName+'                                            ',1,Length), '|');
      Writeln(F, S);

      S := '';
      For t := 0 To Query.Fields.Count-1 Do  S := Merge(S, Copy('--------------------------------------------',1,Length), '|');
      Writeln(F, S);

      Query.First;
      While Not Query.EOF Do Begin
       S := '';
       For t := 0 To Query.Fields.Count-1 Do
        If Query.Fields[t].DataType = ftFloat Then S := Merge(S, Copy(FormatFloat('###,###,###,##0.00',Query.Fields[t].AsFloat)+'                                            ',1,Length), '|')
        Else  S := Merge(S, Copy(Query.Fields[t].AsString+'                                            ',1,Length), '|');
       Writeln(F, S);

       Query.Next;
      End;
    End;

begin
  inherited;
  AssignFile(F, filename);
  ReWrite(f);

  If Query.Active Then OutputQuery(Query,20);
  WriteLn(F);

  Closefile(f);
  if not fmain.silentMode then ExecuteFileAndWait('Notepad.exe "'+fileName+'"');
end;

procedure TFGrouping.SaveCsvClick(Sender: TObject);
begin
  if not query.Active then BRefreshClick(BRefresh);
  //SaveAsCsv is obsolete and replaced by ExportToExcel
  //@@@!!! todo: merge  ExportToExcel (the same code is this module and in BrowseParent)
  //SaveAsCsv( applicationDocumentsPath + 'temp.csv' );
  Dmodule.ExportToExcel(grid);
end;


procedure TFGrouping.SaveAsCsv( filename : tfilename);
var F : Textfile;
    S : String;

    Procedure OutputQuery(Query : TADOQuery);
    var t : Integer;
    Begin
      S := '';
      For t := 0 To Query.Fields.Count-1 Do  S := Merge(S, Query.Fields[t].FieldName, ';');
      Writeln(F, S);

      Query.First;
      While Not Query.EOF Do Begin
       S := '';
       For t := 0 To Query.Fields.Count-1 Do
        If Query.Fields[t].DataType = ftFloat Then S := Merge(S, FormatFloat('###,###,###,##0.00',Query.Fields[t].AsFloat), ';')
        Else  S := Merge(S, nvl(Query.Fields[t].AsString, '-'), ';');
       Writeln(F, S);

       Query.Next;
      End;
    End;

begin
  AssignFile(F, fileName );
  ReWrite(f);

  If Query.Active Then OutputQuery(Query);

  Closefile(f);
  if not fmain.silentMode then ExecuteFile( fileName,'','',SW_SHOWMAXIMIZED);
end;


procedure TFGrouping.BLEC_UTILIZATIONClick(Sender: TObject);
var separateLineMode : boolean;
    filename : tfilename;
begin
  filename := getFileName(ExcelExport);
  if filename <> '' then begin
    separateLineMode  := question('Czy pokazywaæ egzamin i wyk³ad w oddzielnej linii ?') = ID_YES;
    generateReport (LEC_UTILIZATION, separateLineMode, true, filename );
  end;
end;

procedure TFGrouping.BSTUDENTHOURSClick(Sender: TObject);
var separateLineMode : boolean;
    filename : tfilename;
begin
  filename := getFileName(ExcelExport);
  if filename <> '' then begin
    separateLineMode  := question('Czy pokazywaæ egzamin i wyk³ad w oddzielnej linii ?') = ID_YES;
    generateReport (STUDENTHOURS, separateLineMode, true, filename );
  end;
end;

procedure TFGrouping.bOtherReportsClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tspeedbutton).Height;
 Point   := (sender as tspeedbutton).ClientToScreen(Point);
 ReportsPopup.Popup(Point.X,Point.Y);
end;

procedure TFGrouping.bOptionsClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tspeedbutton).Height;
 Point   := (sender as tspeedbutton).ClientToScreen(Point);
 optionspopup.Popup(Point.X,Point.Y);
end;

procedure TFGrouping.chbShowAllClick(Sender: TObject);
begin
  inherited;
 (sender as tmenuItem).Checked := not (sender as tmenuItem).Checked;
 bOptionsClick(bOptions);
end;

procedure TFGrouping.EmergencyModeClick(Sender: TObject);
begin
 (sender as tmenuItem).Checked := not (sender as tmenuItem).Checked;
 bOptionsClick(bOptions);
end;

procedure TFGrouping.BRefreshpopupClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tspeedbutton).Height;
 Point   := (sender as tspeedbutton).ClientToScreen(Point);
 refreshpopup.Popup(Point.X,Point.Y);
end;

procedure TFGrouping.MenuItem1Click(Sender: TObject);
begin
  BRefreshClick(BRefresh);
end;

function TFGrouping.saveSettings (silentMode : boolean) :boolean;
begin
  result := false;
  if not silentMode then
     if not saveDialog.Execute then exit;

  uutilityparent.saveToIni(
            saveDialog.FileName , 'grouping',
            [ CONPERIOD, CONL, CONG, conResCat0, CONS, CONF_VALUE
            , ChDay, ChCreationDate, ChHOUR, ChFILL, ChDayOfWeek, ChCreatedBy, ChOwnerName, ChMonth, ChIntegration_Id, CHL, CHUNI, chgorg, chgParent, chsorg, chrorg, chLnewLine, ChG, CHGT, chGnewLine, ChR, chgStudents, chRnewLine, ChS, ChF
            , sortOrderField, chbShowAll, EmergencyMode
            , PERSettings, LSettings, GSettings, RSettings, SSettings, FSettings
            , ChDesc1, ChDesc2, ChDesc3, ChDesc4
            , ChlDesc1, ChlDesc2, ChlDesc3, ChlDesc4
            , ChSelectedDates
            , chlcount, chgcount, chrcount
            ]);
  result := true;
end;

procedure TFGrouping.LoadFromIni ( inifilename : tfilename );
begin

  CONPERIOD.Text := '';
  CONL.Text := '';
  CONG.Text := '';
  conResCat0.Text := '';
  CONS.Text := '';
  CONF_VALUE.Text := '';

  CONPERIOD_VALUE.Text := '';
  CONL_VALUE.Text := '';
  CONG_VALUE.Text := '';
  conResCat0_value.Text := '';
  CONS_VALUE.Text := '';
  CONF_VALUE.Text := '';

  uutilityparent.LoadFromIni(
            inifilename , 'grouping',
            [ CONPERIOD, CONL, CONG, conResCat0, CONS, CONF_VALUE
            , ChDay, ChCreationDate, ChHOUR, ChFILL, ChDayOfWeek, ChCreatedBy, ChOwnerName, ChMonth, ChIntegration_Id, CHL, CHUNI,  chgorg, chgParent, chsorg, chrorg, chLnewLine, ChG, CHGT, chGnewLine, ChR, chgStudents, chRnewLine, ChS, ChF
            , sortOrderField, chbShowAll, EmergencyMode
            , LSettings, GSettings, RSettings, SSettings, FSettings
            , ChDesc1, ChDesc2, ChDesc3, ChDesc4
            , ChlDesc1, ChlDesc2, ChlDesc3, ChlDesc4
            , ChSelectedDates
            , chlcount, chgcount, chrcount
            ], true);

  if PERSettings.Strings.Values['FilterType'] = 'a' then CONPERIOD_VALUE.Text := PERSettings.Strings.Values['Notes.Category:DEFAULT'];
  if LSettings.Strings.Values['FilterType'] = 'a'   then CONL_VALUE.Text := LSettings.Strings.Values['Notes.Category:DEFAULT'];
  if GSettings.Strings.Values['FilterType'] = 'a'   then CONG_VALUE.Text := GSettings.Strings.Values['Notes.Category:DEFAULT'];
  if RSettings.Strings.Values['FilterType'] = 'a'   then conResCat0_value.Text := RSettings.Strings.Values['Notes.Category:DEFAULT'];
  if SSettings.Strings.Values['FilterType'] = 'a'   then CONS_VALUE.Text := SSettings.Strings.Values['Notes.Category:DEFAULT'];
  //if FSettings.Strings.Values['FilterType'] = 'a'   then CONF_VALUE.Text := FSettings.Strings.Values['Notes.Category:DEFAULT'];

end;

function TFGrouping.loadSettings :boolean;
begin
  result := false;
  if not openDialog.Execute then exit;
  self.LoadFromIni( openDialog.FileName );
  result := true;
end;

procedure TFGrouping.createBat(batMethod : string);
var  f : textFile;
     s : string;
     fileExt : shortString;
begin
  fileext := batMethod;
  if batMethod='LEC_UTILIZATION_SEPARATE_LINE' then fileext := 'xls';
  if batMethod='LEC_UTILIZATION'               then fileext := 'xls';
  if batMethod='STUDENTHOURS_SEPARATE_LINE'    then fileext := 'xls';
  if batMethod='STUDENTHOURS'                  then fileext := 'xls';

  if not saveSettings(false) then exit;
  uutilityparent.saveToIni(saveDialog.FileName , 'initype'  ,'initype'      ,'grouping');
  uutilityparent.saveToIni(saveDialog.FileName , 'grouping', 'exportMethod', batMethod);
  uutilityparent.saveToIni(saveDialog.FileName , 'grouping', 'filename', applicationDocumentsPath + 'temp.' + fileext );

  AssignFile(f, extractFileDir(saveDialog.FileName)+'/publikacja.bat' );
  reWrite(f);

  writeLn(f, '"'+ApplicationDir + '\' + 'planowanie.exe" '+userName+' '+uutilityparent.EncryptShortString(1, 'PASSWORD:'+password, 'SoftwareFactory')+' '+DBname+' "inifile='+ saveDialog.FileName +'"');
  closeFile(f);

  s :=
  'Pliki zosta³y pomyœlnie zapisane.'+cr+
  'Teraz lub póŸniej mo¿esz rozpocz¹æ eksport uruchamiaj¹c plik publikacja.bat.'+cr+
  'Spowoduje to automatyczne odœwie¿enie danych, bez potrzeby uruchamiania programu.'+cr+
  'Mo¿esz te¿ zaharmonogramowaæ automatyczne tworzenie za pomoc¹ funkcji Panel sterowania->Zaplanowane zadania';

  info(s);
end;


procedure TFGrouping.MenuItem3Click(Sender: TObject);
begin
  createBat('txt');
end;

procedure TFGrouping.MenuItem2Click(Sender: TObject);
begin
  createBat('html');
end;

procedure TFGrouping.MenuItem4Click(Sender: TObject);
begin
  createBat('csv');
end;

procedure TFGrouping.egzaminiwykadwoddzielnejliniitak1Click(
  Sender: TObject);
begin
  createBat('LEC_UTILIZATION_SEPARATE_LINE');
end;

procedure TFGrouping.egzaminiwykadwoddzielnejliniinie1Click(
  Sender: TObject);
begin
  createBat('LEC_UTILIZATION');
end;

procedure TFGrouping.egzaminiwykadwoddzielnejliniitak2Click(
  Sender: TObject);
begin
  createBat('STUDENTHOURS_SEPARATE_LINE');
end;

procedure TFGrouping.egzaminiwykadwoddzielnejliniinie2Click(
  Sender: TObject);
begin
  createBat('STUDENTHOURS');
end;

procedure TFGrouping.bClearPeriodClick(Sender: TObject);
begin
  CONPERIOD_VALUE.Text := '';
  PerSettings.Strings.Clear;
  CONPERIOD.Text := '';
end;

procedure TFGrouping.bClearLClick(Sender: TObject);
begin
  CONL_VALUE.Text := '';
  LSettings.Strings.Clear;
  CONL.Text := '';
end;

procedure TFGrouping.bClearGClick(Sender: TObject);
begin
  CONG_VALUE.Text := '';
  GSettings.Strings.Clear;
  CONG.Text := '';
end;

procedure TFGrouping.bClearRes0Click(Sender: TObject);
begin
  conResCat0_value.Text := '';
  RSettings.Strings.Clear;
  conResCat0.Text := '';
end;

procedure TFGrouping.bClearSClick(Sender: TObject);
begin
  CONS_VALUE.Text := '';
  SSettings.Strings.Clear;
  CONS.Text := '';
end;

procedure TFGrouping.bClearFClick(Sender: TObject);
begin
  CONF_VALUE.Text := '';
  //FSettings.Strings.Clear;
  //CONF.Text := '';
end;

procedure TFGrouping.Filtrprosty1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONPERIOD.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
      PerSettings.Strings.Clear;
      CONPERIOD.Text := KeyValue;
      PERSettings.Strings.Values['FilterType'] := 'e';
  End;
end;

procedure TFGrouping.MenuItem5Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONL.Text;
  If LECTURERSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
      LSettings.Strings.Clear;
      CONL.Text := KeyValue;
      LSettings.Strings.Values['FilterType'] := 'e';
  End;
end;

procedure TFGrouping.MenuItem7Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONG.Text;
  If groupSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
      GSettings.Strings.Clear;
      CONG.Text := KeyValue;
      GSettings.Strings.Values['FilterType'] := 'e';
  End;
end;

procedure TFGrouping.MenuItem9Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := conResCat0.Text;
  If ROOMSShowModalAsSelect(dmodule.pResCatId0,'',KeyValue,'0=0','') = mrOK Then Begin
      RSettings.Strings.Clear;
      conResCat0.Text := KeyValue;
      RSettings.Strings.Values['FilterType'] := 'e';
  End;
end;

procedure TFGrouping.MenuItem11Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONS.Text;
  If SUBJECTSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
      SSettings.Strings.Clear;
      CONS.Text := KeyValue;
      SSettings.Strings.Values['FilterType'] := 'e';
  End;
end;

//procedure TFGrouping.MenuItem13Click(Sender: TObject);
//Var KeyValue : ShortString;
//begin
//  KeyValue := CONF.Text;
//  If FORMSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
//      FSettings.Strings.Clear;
//      CONF.Text := KeyValue;
//      FSettings.Strings.Values['FilterType'] := 'e';
//  End;
//end;

procedure TFGrouping.Filtrzaawansowany1Click(Sender: TObject);
begin
  autocreate.PERIODSCreate;

  If UFModuleFilter.ShowModal( PerSettings.Strings, fBrowsePERIODS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONPERIOD.Text := '';
      CONPERIOD_VALUE.Text := PERSettings.Strings.Values['Notes.Category:DEFAULT'];
      PERSettings.Strings.Values['FilterType'] := 'a';
  End;
end;

procedure TFGrouping.MenuItem6Click(Sender: TObject);
begin
  autocreate.LECTURERSCreate;
  If UFModuleFilter.ShowModal( LSettings.Strings, fBrowseLECTURERS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONL.Text := '';
      CONL_VALUE.Text := LSettings.Strings.Values['Notes.Category:DEFAULT'];
      LSettings.Strings.Values['FilterType'] := 'a';
  End;
end;

procedure TFGrouping.MenuItem8Click(Sender: TObject);
begin
  autocreate.GROUPSCreate;
  If UFModuleFilter.ShowModal( GSettings.Strings, fBrowseGROUPS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONG.Text := '';
      CONG_VALUE.Text := GSettings.Strings.Values['Notes.Category:DEFAULT'];
      GSettings.Strings.Values['FilterType'] := 'a';
      info('Je¿eli w danym zajêciu uczestnicz¹ grupy ze studiów stacjonarnych oraz niestacjonarnych i zostanie ustawiony filtr ="Stacjonarne", to na zestawieniu pojawi¹ siê OBIE grupy', showOnceaday);
  End;
end;


procedure TFGrouping.MenuItem10Click(Sender: TObject);
begin
  autocreate.ROOMSInit(dmodule.pResCatId0,'','0=0','');
  If UFModuleFilter.ShowModal( RSettings.Strings, fBrowseROOMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      conResCat0.Text := '';
      conResCat0_value.Text := RSettings.Strings.Values['Notes.Category:DEFAULT'];
      RSettings.Strings.Values['FilterType'] := 'a';
  End;
end;

procedure TFGrouping.MenuItem12Click(Sender: TObject);
begin
  autocreate.SUBJECTSCreate;
  If UFModuleFilter.ShowModal( SSettings.Strings, fBrowseSUBJECTS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONS.Text := '';
      CONS_VALUE.Text := SSettings.Strings.Values['Notes.Category:DEFAULT'];
      SSettings.Strings.Values['FilterType'] := 'a';
  End;
end;

//procedure TFGrouping.MenuItem14Click(Sender: TObject);
//begin
//  autocreate.FORMSCreate;
//  If UFModuleFilter.ShowModal( FSettings.Strings, fBrowseFORMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
//      CONF.Text := '';
//      CONF_VALUE.Text := FSettings.Strings.Values['Notes.Category:DEFAULT'];
//      FSettings.Strings.Values['FilterType'] := 'a';
//  End;
//end;

procedure TFGrouping.CONPERIOD_VALUEChange(Sender: TObject);
begin
  bClearPeriod.Visible := (sender as tedit).Text <> '';
end;

procedure TFGrouping.CONL_VALUEChange(Sender: TObject);
begin
  bClearL.Visible := (sender as tedit).Text <> '';
end;

procedure TFGrouping.CONG_VALUEChange(Sender: TObject);
begin
  bClearG.Visible := (sender as tedit).Text <> '';
end;

procedure TFGrouping.conResCat0_valueChange(Sender: TObject);
begin
  bClearRes0.Visible := (sender as tedit).Text <> '';
end;

procedure TFGrouping.CONS_VALUEChange(Sender: TObject);
begin
  bClearS.Visible := (sender as tedit).Text <> '';
end;

procedure TFGrouping.CONF_VALUEChange(Sender: TObject);
begin
  bClearF.Visible := (sender as tedit).Text <> '';
end;

procedure TFGrouping.ChSelectedDatesClick(Sender: TObject);
begin
  Query.close;
end;

procedure TFGrouping.chLnewLineClick(Sender: TObject);
begin
  calculateCountClick(nil);
end;

procedure TFGrouping.chGnewLineClick(Sender: TObject);
begin
  calculateCountClick(nil);
end;

procedure TFGrouping.chRnewLineClick(Sender: TObject);
begin
  calculateCountClick(nil);
end;

procedure TFGrouping.PodgldzapytaniaSQL1Click(Sender: TObject);
begin
 CopyToClipboard(SQLPreview.Lines.Text);
 info('Zapytanie SQL zosta³o skopiowane do schowka. Przeka¿ je administratorowi w celu analizy');
end;

procedure TFGrouping.Zapiszustawienia1Click(Sender: TObject);
begin
  saveSettings(false);
end;

procedure TFGrouping.Odczytajustawienia1Click(Sender: TObject);
begin
  loadSettings;
end;

procedure TFGrouping.Odwieteraz1Click(Sender: TObject);
begin
  BRefreshClick(BRefresh);
end;

procedure TFGrouping.bMoreLessClick(Sender: TObject);
begin
 if topPanel.Height=160 then begin
  groupOrderBy.Visible := true;
  groupSelect.Visible := true;
  bOtherReports.Visible := true;
  bOptions.Visible := true;
  topPanel.Height := 405;
  bMoreLess.Caption := 'Mniej';
 end else begin
  groupSelect.Visible := false;
  groupOrderBy.Visible := false;
  bOtherReports.Visible := false;
  bOptions.Visible := false;
  topPanel.Height := 160;
  bMoreLess.Caption := 'Wiêcej';
 end;
end;

procedure TFGrouping.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  saveDialog.FileName := UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FGrouping.ini';
  if not ignoreIni then saveSettings (true);
end;

procedure TFGrouping.FormCreate(Sender: TObject);
begin
  ignoreIni:=false;
end;

procedure TFGrouping.chlcountHelpClick(Sender: TObject);
begin
  Info('Dotyczy zajêæ prowadzonych przez wiêcej ni¿ jednego wyk³adowcê: Podziel liczbê zajêæ przez liczbê wyk³adowców, a otrzymasz liczbê zajêæ w przeliczeniu na ka¿dego wyk³adowcê.'+cr+
  ' Program nie wykonuje dzielenia automatycznie z dwóch powodów:'+cr+
  ' 1) Ze wzglêdu na mo¿liwe zaokr¹glenia np. 1/3 '+cr+
   '2) Czasami po prostu nie chcemy, by dzieliæ liczbê zajêæ przez liczbê wyk³adowców');

end;

procedure TFGrouping.SpeedButton1Click(Sender: TObject);
begin
  FMessageBox.Message.Text :=
'Dodaje do raportu kolumne INTEGRATION ID wyk³adowcy, grupy, sali, przedmiotu'+cr+cr+
  ' Aby zobaczyæ integration id WYK£ADOWCY, zaznacz pole wyboru "Wyk³adowcy" ***ORAZ "Ka¿dy w oddzielnej linii"'+cr+
  ' Aby zobaczyæ integration id GRUPY, zaznacz pole wyboru "Grupy" ***ORAZ "Ka¿dy w oddzielnej linii"'+cr+
  ' Aby zobaczyæ integration id SALI/ZASOBU, zaznacz pole wyboru "Zasoby" ***ORAZ "Kazdy w oddzielnej linii"'+cr+
  ' Aby zobaczyc integration id PRZEDMIOTU, zaznacz pole wyboru "Przedmioty"';
  FMessageBox.showModal;

end;


end.
