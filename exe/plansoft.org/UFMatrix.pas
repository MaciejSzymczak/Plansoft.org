unit UFMatrix;

interface
   //@@@
   //licznik zajec ( zliczaj unikatowe classes.id)
   //ka�da rzecz w oddzielnym pliku
       //info o plansoft org pod kazda tabela
   //kilka rzeczy w jednej linii


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Db, DBTables, Grids, DBGrids, UUtilityParent,
  ComCtrls, Mask, ToolEdit,
  StrHlder, OleServer, ExcelXP, ADODB, Menus, UFModuleFilter, jpeg, inifiles;

Type  TKindOfExport = Integer;
Const NotePadExport = 0;
      ExcelExport   = 1;
      WordExport    = 2;
      wwwExport     = 3;
Const LEC_UTILIZATION = 1;
      STUDENTHOURS   = 2;

type
  TFMatrix = class(TFormConfig)
    Panel1: TPanel;
    DataSource: TDataSource;
    GroupBox2: TGroupBox;
    LL: TLabel;
    LR: TLabel;
    LF: TLabel;
    CONF: TEdit;
    CONR: TEdit;
    CONL: TEdit;
    CONL_VALUE: TEdit;
    CONR_VALUE: TEdit;
    CONF_VALUE: TEdit;
    LS: TLabel;
    CONS: TEdit;
    CONS_VALUE: TEdit;
    LG: TLabel;
    CONG: TEdit;
    CONG_VALUE: TEdit;
    Holder: TStrHolder;
    Query: TADOQuery;
    optionsPopup: TPopupMenu;
    chbShowAll: TMenuItem;
    Clean2: TSpeedButton;
    Clean3: TSpeedButton;
    Clean4: TSpeedButton;
    Clean5: TSpeedButton;
    Clean6: TSpeedButton;
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
    FPopup: TPopupMenu;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    PERFilterType: TEdit;
    LFilterType: TEdit;
    GFilterType: TEdit;
    RFilterType: TEdit;
    SFilterType: TEdit;
    FFilterType: TEdit;
    mainQuery: TADOQuery;
    buttonsPanel: TPanel;
    ButtonOptions: TSpeedButton;
    lookupQuery: TADOQuery;
    BWord: TBitBtn;
    BOK: TBitBtn;
    Zapisz1: TMenuItem;
    Otwrz1: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    getFlexSQL: TMemo;
    ColumnsOriginal: TMemo;
    wordExcel: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Przegldarka1: TMenuItem;
    N1: TMenuItem;
    noHideFlag: TMenuItem;
    Panel2: TPanel;
    row: TComboBox;
    row2: TComboBox;
    row3: TComboBox;
    row4: TComboBox;
    row5: TComboBox;
    row6: TComboBox;
    Colors: TMemo;
    Panel5: TPanel;
    Label2: TLabel;
    color: TComboBox;
    ChbcntMode: TCheckBox;
    cell1: TComboBox;
    cell2: TComboBox;
    cell3: TComboBox;
    cell4: TComboBox;
    cell5: TComboBox;
    cell6: TComboBox;
    Panel6: TPanel;
    Panel3: TPanel;
    title: TComboBox;
    subtitle: TComboBox;
    Columns: TMemo;
    Panel4: TPanel;
    Column: TComboBox;
    subcolumn: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label1: TLabel;
    source_date_from: TDateTimePicker;
    Label10: TLabel;
    source_date_to: TDateTimePicker;
    BitBtn1: TBitBtn;
    SelectDates: TPopupMenu;
    MenuItem3: TMenuItem;
    Cdesc3: TMenuItem;
    Cdesc4: TMenuItem;
    Wczoraj1: TMenuItem;
    Przedwczoraj1: TMenuItem;
    Wybierzsemestr1: TMenuItem;
    N2: TMenuItem;
    rowSpanFlag: TMenuItem;
    colSpanFlag: TMenuItem;
    N3: TMenuItem;
    supressNAValuesFlag: TMenuItem;
    PeriodSelectionDsp: TLabel;
    BGenerateBatch: TMenuItem;
    N4: TMenuItem;
    SaveDialog1: TSaveDialog;
    perId: TEdit;
    PerLabel: TLabel;
    perId_Value: TEdit;
    PerClean: TSpeedButton;
    procedure CONLChange(Sender: TObject);
    procedure CONRChange(Sender: TObject);
    procedure CONGChange(Sender: TObject);
    procedure CONSChange(Sender: TObject);
    procedure CONFChange(Sender: TObject);
    procedure CONPERIODChange(Sender: TObject);
    procedure xBitBtnPERClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonOptionsClick(Sender: TObject);
    procedure chbShowAllClick(Sender: TObject);
    procedure Clean2Click(Sender: TObject);
    procedure Clean3Click(Sender: TObject);
    procedure Clean4Click(Sender: TObject);
    procedure Clean5Click(Sender: TObject);
    procedure Clean6Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure CONL_VALUEChange(Sender: TObject);
    procedure CONG_VALUEChange(Sender: TObject);
    procedure CONR_VALUEChange(Sender: TObject);
    procedure CONS_VALUEChange(Sender: TObject);
    procedure CONF_VALUEChange(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure Zapisz1Click(Sender: TObject);
    procedure Otwrz1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure BWordClick(Sender: TObject);
    procedure Przegldarka1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BUstawieniaFormularzaClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Wczoraj1Click(Sender: TObject);
    procedure Przedwczoraj1Click(Sender: TObject);
    procedure Cdesc3Click(Sender: TObject);
    procedure Cdesc4Click(Sender: TObject);
    procedure Wybierzsemestr1Click(Sender: TObject);
    procedure source_date_fromChange(Sender: TObject);
    procedure source_date_toChange(Sender: TObject);
    procedure BGenerateBatchClick(Sender: TObject);
    procedure PerCleanClick(Sender: TObject);
    procedure perId_ValueClick(Sender: TObject);
    procedure perId_ValueChange(Sender: TObject);
  private
     defaultText : string;
     sqlFlexColumns : string;
     defSettingsFileName : string;
     ignoreSave : boolean;
     procedure UpdStatus(S : String);
     function  saveSettings :boolean;
     function  loadSettings :boolean;
  public
     periodClause : string;
     defaultSchema : shortstring;
     outFileName : string;
     procedure loadFromIni ( inifilename : tfilename );
     procedure saveToIni ( inifilename : tfilename );
     procedure generate (prog : string);
     procedure loadPeriod (perId_ : shortString);
  end;

var
  FMatrix: TFMatrix;

implementation

uses DM, AutoCreate, UUtilities, ufLookupWindow, UCommon,ComObj, ufMain,
  UFProgramSettings, UFIN_LINESGenerator, UFBrowseLECTURERS,
  uFBrowseGROUPS, uFBrowsePERIODS, UFBrowseSUBJECTS, uFBrowseFORMS,
  UFBrowseROOMS, UWeeklyTable;

{$R *.DFM}

procedure TFMatrix.FormCreate(Sender: TObject);
begin
  periodClause := '';
  PeriodSelectionDsp.Caption := '';
  ignoreSave := false;
  defSettingsFileName := UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.' + Self.Name + '.defSettings.ini';
  outFileName := uutilityParent.ApplicationDocumentsPath + 'temp.htm';
end;


procedure TFMatrix.CONLChange(Sender: TObject);
begin
  inherited;
  If Trim(CONL.TEXT) <> '' Then CONL_VALUE.Text := DMOdule.SingleValue('SELECT FIRST_NAME||'' ''||LAST_NAME FROM LECTURERS WHERE ID='+CONL.TEXT)
                           Else CONL_VALUE.Text := '';
  Query.close;
end;

procedure TFMatrix.CONRChange(Sender: TObject);
begin
  inherited;
  If Trim(CONR.TEXT) <> '' Then CONR_VALUE.Text := DMOdule.SingleValue('SELECT '+sql_ResCat0NAME+' FROM ROOMS WHERE ID='+CONR.TEXT)
                           Else CONR_VALUE.Text := '';
  Query.close;
end;

procedure TFMatrix.CONGChange(Sender: TObject);
begin
  inherited;
  If Trim(CONG.TEXT) <> '' Then CONG_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM GROUPS WHERE ID='+CONG.TEXT)
                           Else CONG_VALUE.Text := '';
  Query.close;
end;

procedure TFMatrix.CONSChange(Sender: TObject);
begin
  inherited;
  If Trim(CONS.TEXT) <> '' Then CONS_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM SUBJECTS WHERE ID='+CONS.TEXT)
                           Else CONS_VALUE.Text := '';
  Query.close;
end;

procedure TFMatrix.CONFChange(Sender: TObject);
begin
  inherited;
  If Trim(CONF.TEXT) <> '' Then CONF_VALUE.Text := DMOdule.SingleValue('SELECT NAME||''(''||abbreviation||'')'' FROM FORMS WHERE ID='+CONF.TEXT)
                           Else CONF_VALUE.Text := '';
  Query.close;
end;

procedure TFMatrix.CONPERIODChange(Sender: TObject);
begin
  If Not DModule.ADOConnection.Connected Then exit;  // = ignore this event during onCreate form
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
  Query.close;
end;

procedure TFMatrix.xBitBtnPERClick(Sender: TObject);
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
 if btn.Name = 'CONR_VALUE'      then RPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'CONS_VALUE'      then SPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'CONF_VALUE'      then FPopup.Popup(Point.X,Point.Y);
end;

procedure TFMatrix.FormShow(Sender: TObject);
var t : integer;
    v : array[1..50] of shortString;

    function getFlexColumns : string;
        var q : tadoQuery;
            t : integer;
    begin
        if ColumnsOriginal.Lines.Text='' then ColumnsOriginal.Lines.Text := Columns.lines.Text;

        sqlFlexColumns := 'null to_begin_with';
        Columns.lines.Text :=  ColumnsOriginal.Lines.Text;

        q := tadoquery.Create(self);
        dmodule.openSQL(q, getFlexSQL.lines.text);
        q.First;
        while not q.Eof do begin
           Columns.lines.Add(q.FieldByName('caption').AsString+'='+q.FieldByName('alias_name').AsString);
           sqlFlexColumns := merge(sqlFlexColumns, q.FieldByName('db_col_name').AsString,',');
           q.Next;
        end;
        q.free;
        for t := 1 to 4 do begin
            if FProgramSettings.getClassDescPlural(t) <> '' then begin
                Columns.lines.Add( 'Zaj�cie: '+FProgramSettings.getClassDescPlural(t)+'=CLASSES_DESC'+intToStr(t));
                sqlFlexColumns := merge(sqlFlexColumns, 'CLASSES.DESC'+intToStr(t)+' '+'CLASSES_DESC'+intToStr(t),',');
            end;
        end;
        for t := 1 to 4 do begin
            if FProgramSettings.getClassDescSingular(t) <> '' then begin
                Columns.lines.Add( 'Wyk�adowca: '+FProgramSettings.getClassDescSingular(t)+'=LEC_CLA_DESC'+intToStr(t));
                sqlFlexColumns := merge(sqlFlexColumns, 'LEC_CLA.DESC'+intToStr(t)+' '+'LEC_CLA_DESC'+intToStr(t),',');
            end;
        end;
    end;
    //----
procedure SortTStrings(Strings:TStrings);
var
   tmp: TStringList;
begin
   if Strings is TStringList then
   begin
      TStringList(Strings).Sort;
   end
   else
   begin
      tmp := TStringList.Create;
      try
         // make a copy
         tmp.Assign(Strings);
         // sort the copy
         tmp.Sort;
         //
         Strings.Assign(tmp);
      finally
         tmp.Free;
      end;
   end;
end;


begin
    getFlexColumns;

    color.Items.Clear;
    column.Items.Clear;
    subcolumn.Items.Clear;
    row.items.Clear;
    row2.items.Clear;
    row3.items.Clear;
    row4.items.Clear;
    row5.items.Clear;
    row6.items.Clear;
    cell1.Items.Clear;
    cell2.Items.Clear;
    cell3.Items.Clear;
    cell4.Items.Clear;
    cell5.Items.Clear;
    cell6.Items.Clear;
    title.Items.Clear;
    subtitle.items.Clear;
    for t := 0 to columns.Lines.Count-1 do begin
        column.items.add( columns.lines.names[t] );
        subcolumn.items.add( columns.lines.names[t] );
        row.items.add( columns.lines.names[t] );
        row2.items.add( columns.lines.names[t] );
        row3.items.add( columns.lines.names[t] );
        row4.items.add( columns.lines.names[t] );
        row5.items.add( columns.lines.names[t] );
        row6.items.add( columns.lines.names[t] );
        cell1.items.add( columns.lines.names[t] );
        cell2.items.add( columns.lines.names[t] );
        cell3.items.add( columns.lines.names[t] );
        cell4.items.add( columns.lines.names[t] );
        cell5.items.add( columns.lines.names[t] );
        cell6.items.add( columns.lines.names[t] );
        title.items.add( columns.lines.names[t] );
        subtitle.items.add( columns.lines.names[t] );
    end;

    SortTStrings( column.Items );
    SortTStrings( subcolumn.items );
    SortTStrings( row.items );
    SortTStrings( row2.items );
    SortTStrings( row3.items );
    SortTStrings( row4.items );
    SortTStrings( row5.items );
    SortTStrings( row6.items );
    SortTStrings( cell1.items );
    SortTStrings( cell2.items );
    SortTStrings( cell3.items );
    SortTStrings( cell4.items );
    SortTStrings( cell5.items );
    SortTStrings( cell6.items );
    SortTStrings( title.items );
    SortTStrings( subtitle.items );

    for t := 0 to colors.Lines.Count-1 do begin
        color.items.add( colors.lines.names[t] );
    end;

    if defaultSchema = 'S' then begin
        // title
        v[ 1] := 'Przedmiot';
        v[ 2] := 'Tydzie� od-do';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := '<Nie dotyczy>';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Forma zaj��';
        v[ 7] := 'Grupa';
        v[ 8] := 'Zas�b';
        v[ 9] := 'Wyk�adowca';
        v[10] := '<Nie dotyczy>';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Grupa';
    end;
    if defaultSchema = 'Sall' then begin
        // title
        v[ 1] := 'Tydzie� od-do';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := 'Przedmiot';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Forma zaj��';
        v[ 7] := 'Grupa';
        v[ 8] := 'Zas�b';
        v[ 9] := 'Wyk�adowca';
        v[10] := '<Nie Dotyczy>';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'L' then begin
        // title
        v[ 1] := 'Wyk�adowca';
        v[ 2] := 'Tydzie� od-do';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;
    if defaultSchema = 'Lall' then begin
        // title
        v[ 1] := 'Tydzie� od-do';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := 'Wyk�adowca';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'G' then begin
        // title
        v[ 1] := 'Grupa';
        v[ 2] := 'Tydzie� od-do';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;
    if defaultSchema = 'Gall' then begin
        // title
        v[ 1] := 'Tydzie� od-do';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := 'Grupa';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'R' then begin
        // title
        v[ 1] := 'Zas�b';
        v[ 2] := 'Tydzie� od-do';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;
    if defaultSchema = 'Rall' then begin
        // title
        v[ 1] := 'Tydzie� od-do';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := 'Zas�b';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;


    if defaultSchema = 'F' then begin
        // title
        v[ 1] := 'Forma zaj��';
        v[ 2] := 'Tydzie� od-do';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;
    if defaultSchema = 'Fall' then begin
        // title
        v[ 1] := 'Tydzie� od-do';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := 'Forma zaj��';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'SvsG' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Przedmiot';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Grupa';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'SvsL' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Przedmiot';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Wyk�adowca';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'SvsR' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Przedmiot';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Zas�b';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'LvsG' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Wyk�adowca';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Grupa';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'LvsR' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Wyk�adowca';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Zas�b';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Grupa';
        v[ 9] := 'Zas�b';
        v[10] := 'Wyk�adowca';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Przedmiot';
    end;

    if defaultSchema = 'R_Availibility' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie�';
        v[ 4] := 'Godzina';
        // row
        v[ 5] := 'Zas�b';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Forma zaj��';
        v[ 7] := '<Nie Dotyczy>';
        v[ 8] := '<Nie Dotyczy>';
        v[ 9] := '<Nie Dotyczy>';
        v[10] := '<Nie Dotyczy>';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Forma';
    end;

     if defaultSchema = 'G_Availibility' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie�';
        v[ 4] := 'Godzina';
        // row
        v[ 5] := 'Grupa';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Forma zaj��';
        v[ 7] := '<Nie Dotyczy>';
        v[ 8] := '<Nie Dotyczy>';
        v[ 9] := '<Nie Dotyczy>';
        v[10] := '<Nie Dotyczy>';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Forma';
    end;

    if defaultSchema = 'L_Availibility' then begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie�';
        v[ 4] := 'Godzina';
        // row
        v[ 5] := 'Wyk�adowca';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := 'Forma zaj��';
        v[ 7] := '<Nie Dotyczy>';
        v[ 8] := '<Nie Dotyczy>';
        v[ 9] := '<Nie Dotyczy>';
        v[10] := '<Nie Dotyczy>';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Forma';
    end;

    if defaultSchema = 'WEEKLY' then begin
        // title
        v[ 1] := 'Tydzie� nr wg ISO';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Dzie� tygodnia';
        v[ 4] := 'Grupa';
        // row
        v[ 5] := 'Godzina';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[50] := 'Przedmiot';
        v[ 6] := 'Przedmiot';
        v[ 7] := 'Forma zaj��';
        v[ 8] := 'Wyk�adowcy';
        v[ 9] := 'Grupy';
        v[10] := 'Zasoby';
        v[11] := 'Zaj�cie: Info dla student�w';
        //
    end;

    if defaultSchema = 'CUSTOM' then begin
        if fileExists(defSettingsFileName) then begin
            self.LoadFromIni( defSettingsFileName );
            v[ 1] := 'RELOADED';
        end else begin
        // title
        v[ 1] := '<Nie Dotyczy>';
        v[ 2] := '<Nie Dotyczy>';
        // columns
        v[ 3] := 'Wyk�adowca';
        v[ 4] := '<Nie Dotyczy>';
        // row
        v[ 5] := 'Zas�b';
        v[12] := '<Nie Dotyczy>';
        // cell
        v[ 6] := '<Nie Dotyczy>';
        v[ 7] := '<Nie Dotyczy>';
        v[ 8] := '<Nie Dotyczy>';
        v[ 9] := '<Nie Dotyczy>';
        v[10] := '<Nie Dotyczy>';
        v[11] := '<Nie Dotyczy>';
        v[50] := 'Forma zaj��';
        end;
    end;



    if v[ 1] <> 'RELOADED' then begin
    title.ItemIndex := column.items.IndexOf(v[1]);
    subtitle.ItemIndex := column.items.IndexOf(v[2]);
    column.ItemIndex := column.items.IndexOf(v[3]);
    subcolumn.ItemIndex := column.items.IndexOf(v[4]);
    row.ItemIndex := column.items.IndexOf(v[5]);
    row2.ItemIndex := column.items.IndexOf(v[12]);
    row3.ItemIndex := column.items.IndexOf('<Nie Dotyczy>');
    row4.ItemIndex := column.items.IndexOf('<Nie Dotyczy>');
    row5.ItemIndex := column.items.IndexOf('<Nie Dotyczy>');
    row6.ItemIndex := column.items.IndexOf('<Nie Dotyczy>');
    cell1.ItemIndex := column.items.IndexOf(v[6]);
    cell2.ItemIndex := column.items.IndexOf(v[7]);
    cell3.ItemIndex := column.items.IndexOf(v[8]);
    cell4.ItemIndex := column.items.IndexOf(v[9]);
    cell5.ItemIndex := column.items.IndexOf(v[10]);
    cell6.ItemIndex := column.items.IndexOf(v[11]);
    color.ItemIndex := color.items.IndexOf(v[50]);
    end;

    with fprogramsettings do begin
        //self.Caption           := fprogramsettings.profileObjectNameGs.Text;
        LL     .Caption := profileObjectNameL.Text;
        LG     .Caption := profileObjectNameG.Text;
        LS     .Caption := profileObjectNameC1.Text;
        LF     .Caption := profileObjectNameC2.Text;
    end;


end;

Procedure TFMatrix.UpdStatus(S : String);
Begin
 if s = '' then S := defaultText;
 STATUS.Caption := S;
 STATUS.Refresh;
End;


procedure TFMatrix.ButtonOptionsClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tspeedbutton).Height;
 Point   := (sender as tspeedbutton).ClientToScreen(Point);
 optionspopup.Popup(Point.X,Point.Y);
end;

procedure TFMatrix.chbShowAllClick(Sender: TObject);
begin
 (sender as tmenuItem).Checked := not (sender as tmenuItem).Checked;
 ButtonOptionsClick(ButtonOptions);
end;

procedure TFMatrix.Clean2Click(Sender: TObject);
begin
  CONL_VALUE.Text := '';
  LSettings.Strings.Clear;
  CONL.Text := '';
end;

procedure TFMatrix.Clean3Click(Sender: TObject);
begin
  CONG_VALUE.Text := '';
  GSettings.Strings.Clear;
  CONG.Text := '';
end;

procedure TFMatrix.Clean4Click(Sender: TObject);
begin
  CONR_VALUE.Text := '';
  RSettings.Strings.Clear;
  CONR.Text := '';
end;

procedure TFMatrix.Clean5Click(Sender: TObject);
begin
  CONS_VALUE.Text := '';
  SSettings.Strings.Clear;
  CONS.Text := '';
end;

procedure TFMatrix.Clean6Click(Sender: TObject);
begin
  CONF_VALUE.Text := '';
  FSettings.Strings.Clear;
  CONF.Text := '';
end;

procedure TFMatrix.MenuItem5Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONL.Text;
  If LECTURERSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
      LSettings.Strings.Clear;
      CONL.Text := KeyValue;
  End;
  LFilterType.text := 'e';
end;

procedure TFMatrix.MenuItem7Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONG.Text;
  If groupSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
      GSettings.Strings.Clear;
      CONG.Text := KeyValue;
  End;
  GFilterType.text := 'e';
end;

procedure TFMatrix.MenuItem9Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONR.Text;
  If ROOMSShowModalAsSelect(dmodule.pResCatId0,'',KeyValue,'0=0','') = mrOK Then Begin
      RSettings.Strings.Clear;
      CONR.Text := KeyValue;
  End;
  RFilterType.text := 'e';
end;

procedure TFMatrix.MenuItem11Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONS.Text;
  If SUBJECTSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
      SSettings.Strings.Clear;
      CONS.Text := KeyValue;
  End;
  SFilterType.text := 'e';
end;

procedure TFMatrix.MenuItem13Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CONF.Text;
  If FORMSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
      FSettings.Strings.Clear;
      CONF.Text := KeyValue;
  End;
  FFilterType.text := 'e';
end;

procedure TFMatrix.MenuItem6Click(Sender: TObject);
begin
  autocreate.LECTURERSCreate;
  If UFModuleFilter.ShowModal( LSettings.Strings, fBrowseLECTURERS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONL.Text := '';
      CONL_VALUE.Text := LSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  LFilterType.text := 'a';
end;

procedure TFMatrix.MenuItem8Click(Sender: TObject);
begin
  autocreate.GROUPSCreate;
  If UFModuleFilter.ShowModal( GSettings.Strings, fBrowseGROUPS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONG.Text := '';
      CONG_VALUE.Text := GSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  GFilterType.text := 'a';
  info('Je�eli w danym zaj�ciu uczestnicz� grupy ze studi�w stacjonarnych oraz niestacjonarnych i zostanie ustawiony filtr ="Stacjonarne", to na zestawieniu pojawi� si� OBIE grupy', showOnceaday);
end;


procedure TFMatrix.MenuItem10Click(Sender: TObject);
begin
  autocreate.ROOMSInit(dmodule.pResCatId0,'','0=0','');
  If UFModuleFilter.ShowModal( RSettings.Strings, fBrowseROOMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONR.Text := '';
      CONR_VALUE.Text := RSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  RFilterType.text := 'a';
end;

procedure TFMatrix.MenuItem12Click(Sender: TObject);
begin
  autocreate.SUBJECTSCreate;
  If UFModuleFilter.ShowModal( SSettings.Strings, fBrowseSUBJECTS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
    CONS.Text := '';
    CONS_VALUE.Text := SSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  SFilterType.text := 'a';
end;

procedure TFMatrix.MenuItem14Click(Sender: TObject);
begin
  autocreate.FORMSCreate;
  If UFModuleFilter.ShowModal( FSettings.Strings, fBrowseFORMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
      CONF.Text := '';
      CONF_VALUE.Text := FSettings.Strings.Values['Notes.Category:DEFAULT'];
  End;
  FFilterType.text := 'a';
end;

procedure TFMatrix.CONL_VALUEChange(Sender: TObject);
begin
  Clean2.Visible := (sender as tedit).Text <> '';
end;

procedure TFMatrix.CONG_VALUEChange(Sender: TObject);
begin
  Clean3.Visible := (sender as tedit).Text <> '';
end;

procedure TFMatrix.CONR_VALUEChange(Sender: TObject);
begin
  Clean4.Visible := (sender as tedit).Text <> '';
end;

procedure TFMatrix.CONS_VALUEChange(Sender: TObject);
begin
  Clean5.Visible := (sender as tedit).Text <> '';
end;

procedure TFMatrix.CONF_VALUEChange(Sender: TObject);
begin
  Clean6.Visible := (sender as tedit).Text <> '';
end;

//-------------------------------------------
procedure TFMatrix.generate (prog : string);
var
    columnValues, subColumnValues, rowValues : array of string;
    weeklyTables : tweeklyTables;
    weeklyTable  : tweeklyTable;
    f            : textFile;
    matrix_id    : shortstring;

    colColor    : shortstring;
    colColumn    : shortstring;
    colColumnValue    : shortstring;
    colSubcolumn : shortstring;
    colSubColumnValue : shortString;
    colRow       : shortstring;
    colRow2       : shortstring;
    colRow3       : shortstring;
    colRow4       : shortstring;
    colRow5       : shortstring;
    colRow6       : shortstring;
    colRowValue  : shortstring;
    colTitle     : shortstring;
    colSubTitle  : shortstring;
    colCell1     : shortstring;
    colCell2     : shortstring;
    colCell3     : shortstring;
    colCell4     : shortstring;
    colCell5     : shortstring;
    colCell6     : shortstring;
    coltitle_dsp    : shortstring;
    colSubtitle_dsp : shortstring;

    recordsProcessed : integer;

    bgcolor : shortstring;

    _conl, _cong, _conr, _cons, _conf, _conperiod  : string;
    _permissionsl, _permissionsg, _permissionsr, _permissionss, _permissionsf : string;
    datefrom, dateto : string;

    function setSQL (columnName, columnName2, columnName3, columnName4, columnName5, columnName6 : string) : string;
    begin
        lookupQuery.Close;
        with dm.macros do begin
            setMacro(lookupQuery, 'sqlFlexColumns', sqlFlexColumns);
            setMacro(lookupQuery,'CONL',_CONL);
            setMacro(lookupQuery,'CONG',_CONG);
            setMacro(lookupQuery,'CONR',_CONR);
            setMacro(lookupQuery,'CONS',_CONS);
            setMacro(lookupQuery,'CONF',_CONF);
            setMacro(lookupQuery,'CONPERIOD',_CONPERIOD);
            setMacro(lookupQuery,'PERMISSIONSL',_PERMISSIONSL);
            setMacro(lookupQuery,'PERMISSIONSG',_PERMISSIONSG);
            setMacro(lookupQuery,'PERMISSIONSR',_PERMISSIONSR);
            setMacro(lookupQuery,'PERMISSIONSS',_PERMISSIONSS);
            setMacro(lookupQuery,'PERMISSIONSF',_PERMISSIONSF);
            //
            if columnName='WEEK_FROM_TO' then begin
                setMacro(lookupQuery,'COLUMNS','unique WEEK_FROM_TO,'+columnName2+','+columnName3+','+columnName4+','+columnName5+','+columnName6+', WEEK_ISO');
                setMacro(lookupQuery,'CUSTOM_CONDITION','WEEK_FROM_TO is not null');
                setMacro(lookupQuery,'ORDER_BY','WEEK_ISO,2,3,4,5,6');
            end;
            if columnName='GROUP_DAYOF_WEEK_PARENT_GROUP' then begin
                setMacro(lookupQuery,'COLUMNS','unique GROUP_DAYOF_WEEK_PARENT_GROUP,'+columnName2+','+columnName3+','+columnName4+','+columnName5+','+columnName6+', group_1_sort');
                setMacro(lookupQuery,'CUSTOM_CONDITION','GROUP_DAYOF_WEEK_PARENT_GROUP is not null');
                setMacro(lookupQuery,'ORDER_BY','group_1_sort,2,3,4,5,6');
            end;
            if columnName='DAY_IN_SAY_PL' then begin
                setMacro(lookupQuery,'COLUMNS','unique DAY_IN_SAY_PL,'+columnName2+','+columnName3+','+columnName4+','+columnName5+','+columnName6+', day_of_week');
                setMacro(lookupQuery,'CUSTOM_CONDITION','DAY_IN_SAY_PL is not null');
                setMacro(lookupQuery,'ORDER_BY','day_of_week,2,3,4,5,6');
            end;
            if columnName='HOUR_DSP' then begin
                setMacro(lookupQuery,'COLUMNS','unique HOUR_DSP,'+columnName2+','+columnName3+','+columnName4+','+columnName5+','+columnName6+', GRIDS_NO');
                setMacro(lookupQuery,'CUSTOM_CONDITION','GRIDS_NO is not null');
                setMacro(lookupQuery,'ORDER_BY','GRIDS_NO,2,3,4,5,6');
            end;
            //default order by
            if (columnName<>'DAY_IN_SAY_PL')
              and (columnName<>'HOUR_DSP')
              and (columnName<>'GROUP_DAYOF_WEEK_PARENT_GROUP')
              and (columnName<>'WEEK_FROM_TO')
            then begin
                setMacro(lookupQuery,'COLUMNS','unique '+columnName+','+columnName2+','+columnName3+','+columnName4+','+columnName5+','+columnName6);
                //setMacro(lookupQuery,'CUSTOM_CONDITION',columnName+' is not null');
                setMacro(lookupQuery,'CUSTOM_CONDITION','0=0');
                setMacro(lookupQuery,'ORDER_BY','1,2,3,4,5,6');
            end;
        end;

    end;

begin
    try
    assignFile(f,outFileName);
    rewrite(f);
    closeFile(f);
    except
     info('Ups, program Word lub Excel nie pozwala na modyfikacj� pliku, zamknij program Word/Excel.'+cr+'Problem rozwi��e r�wnie� zapisanie raportu pod inn� nazw� w programie Word/Excel ("Zapisz jako")');
     exit;
    end;


    colColor     := Colors.lines.Values[Color.Items[Color.itemIndex]];
    colColumn    := Columns.lines.Values[Column.Items[Column.itemIndex]];
    colSubcolumn := Columns.lines.Values[Subcolumn.Items[Subcolumn.itemIndex]];
    colRow       := Columns.lines.Values[Row.Items[row.itemIndex]];
    colRow2      := Columns.lines.Values[Row.Items[row2.itemIndex]];
    colRow3      := Columns.lines.Values[Row.Items[row3.itemIndex]];
    colRow4      := Columns.lines.Values[Row.Items[row4.itemIndex]];
    colRow5      := Columns.lines.Values[Row.Items[row5.itemIndex]];
    colRow6      := Columns.lines.Values[Row.Items[row6.itemIndex]];
    colTitle     := Columns.lines.Values[Title.Items[title.itemIndex]];
    colSubTitle  := Columns.lines.Values[Subtitle.Items[subtitle.itemIndex]];
    colCell1     := Columns.lines.Values[Cell1.Items[cell1.itemIndex]];
    colCell2     := Columns.lines.Values[Cell2.Items[cell2.itemIndex]];
    colCell3     := Columns.lines.Values[Cell3.Items[cell3.itemIndex]];
    colCell4     := Columns.lines.Values[Cell4.Items[cell4.itemIndex]];
    colCell5     := Columns.lines.Values[Cell5.Items[cell5.itemIndex]];
    colCell6     := Columns.lines.Values[Cell6.Items[cell6.itemIndex]];

    if colRow = 'DUMMY_ROW' then begin
      info('W wierszach nie mo�na pokazywa� warto�ci <Nie dotyczy>');
      exit;
    end;

    if colColumn = 'DUMMY_ROW' then begin
      info('W kolumnach nie mo�na pokazywa� warto�ci <Nie dotyczy>');
      exit;
    end;

    coltitle_dsp    := title.Items[title.itemIndex];
    colSubtitle_dsp := Subtitle.Items[Subtitle.itemIndex];

    // ----------------- set where clause -------------------------

    UpdStatus('Budowanie warunk�w zapyta�');
    dateFrom := DateToOracle(source_date_from.Datetime);
    dateTo   := DateToOracle(source_date_to.Datetime);
    if (not isBlank(periodClause)) then
      _CONPERIOD := periodClause
    else
      _CONPERIOD := 'CLASSES.DAY BETWEEN '+DateFrom+' AND '+DateTo;

    _CONL := GetCLASSESforL('CLASSES.ID', nvl(CONL.Text, LSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',LFilterType.text);
    _CONG := GetCLASSESforG('CLASSES.ID', nvl(CONG.Text, GSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',GFilterType.text);
    _CONR := GetCLASSESforR('CLASSES.ID', nvl(CONR.Text, RSettings.Strings.Values['SQL.Category:DEFAULT']) ,'',RFilterType.text);

    _CONS := '0=0';
    If                                        CONS.Text <> '' then _CONS := 'SUB_ID='+CONS.Text;
    If SSettings.Strings.Values['SQL.Category:DEFAULT'] <> '' then _CONS := 'SUB_ID IN( SELECT ID FROM SUBJECTS WHERE '+SSettings.Strings.Values['SQL.Category:DEFAULT'] + ')';

    _CONF := '0=0';
    If                                       CONF.Text <> '' Then _CONF := 'FOR_ID='+CONF.Text;
    If FSettings.Strings.Values['SQL.Category:DEFAULT']<> '' Then _CONF := 'FOR_ID IN (SELECT ID FROM FORMS WHERE '+FSettings.Strings.Values['SQL.Category:DEFAULT']+')';

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

    // ----------------- set where clause -------------------------

    weeklyTables := tweeklyTables.Create;

    with dmodule do begin

        //this code is replaced three times because I dont know how to pass "array of string" by parameter to procedure
        UpdStatus('Pobieranie danych (1/4 Nag��wki kolumn)');
        setSQL(colColumn,'DUMMY_NULL','DUMMY_NULL','DUMMY_NULL','DUMMY_NULL','DUMMY_NULL');
        resetConnection ( lookupQuery );
        lookupQuery.Open;
        while not lookupQuery.Eof do begin
            //if lookupQuery.fields[0].AsString <> '' then begin
                setLength(columnValues, length(columnValues)+1);
                colColumnValue := nvl(lookupQuery.fields[0].AsString,'*brak*');
                if upperCase(Prog)='EXCEL.EXE' then begin
                 colColumnValue := '="'+colColumnValue+'"';
                end;
                columnValues[length(columnValues)-1] := colColumnValue;
            //end;
            lookupQuery.next;
        end;

        UpdStatus('Pobieranie danych (2/4 Nag��wki podkolumn)');
        if colsubColumn <> 'DUMMY_NULL' then begin
            setSQL(colsubColumn,'DUMMY_NULL','DUMMY_NULL','DUMMY_NULL','DUMMY_NULL','DUMMY_NULL');
            resetConnection ( lookupQuery );
            lookupQuery.Open;
            while not lookupQuery.Eof do begin
                //if lookupQuery.fields[0].AsString <> '' then begin
                    setLength(subcolumnValues, length(subcolumnValues)+1);
                    colSubColumnValue := nvl( lookupQuery.fields[0].AsString, '*brak*');
                    if upperCase(Prog)='EXCEL.EXE' then begin
                     colSubColumnValue := '="'+colSubColumnValue+'"';
                    end;
                    subcolumnValues[length(subcolumnValues)-1] := colSubColumnValue;
                //end;
                lookupQuery.next;
            end;
        end;

        UpdStatus('Pobieranie danych (3/4 Nag��wki wierszy)');
        setSQL(colRow,colRow2,colRow3,colRow4,colRow5,colRow6);
        resetConnection ( lookupQuery );
        try
        lookupQuery.Open;

        except
          copyToClipboard(lookupQuery.SQL.Text);
          raise;
        end;
        while not lookupQuery.Eof do begin
            //if lookupQuery.fields[0].AsString <> '' then begin
                setLength(rowValues, length(rowValues)+1);
                colRowValue := nvl( merge(merge(merge(merge(merge(
                       lookupQuery.fields[0].AsString
                     , lookupQuery.fields[1].AsString, ':')
                     , lookupQuery.fields[2].AsString, ':')
                     , lookupQuery.fields[3].AsString, ':')
                     , lookupQuery.fields[4].AsString, ':')
                     , lookupQuery.fields[5].AsString, ':')
                               ,'*brak*');
                if upperCase(Prog)='EXCEL.EXE' then begin
                 colRowValue := '="'+colRowValue+'"';
                end;
                rowValues[length(rowValues)-1] := colRowValue;
            //end;
            lookupQuery.next;
        end;
    end;

    matrix_id := '';

    UpdStatus('Pobieranie danych (4/4 Cia�o tabeli)');
    mainQuery.Close;
    dm.Macros.setMacro(mainQuery,'ORDER_BY',
	    colTitle+','
		+colsubTitle+','
		+colColor+','
		+colCell1+','
		+colCell2+','
		+colCell3+','
		+colCell4+','
		+colCell5+','
		+colCell6+','
		+colColumn+','
		+colSubcolumn+','
		+colRow+','
		+colRow2+','
		+colRow3+','
		+colRow4+','
		+colRow5+','
		+colRow6
	);
    with dm.Macros do begin
      setMacro(mainQuery, 'sqlFlexColumns', sqlFlexColumns);
      setMacro(mainQuery,'CONL',_CONL);
      setMacro(mainQuery,'CONG',_CONG);
      setMacro(mainQuery,'CONR',_CONR);
      setMacro(mainQuery,'CONS',_CONS);
      setMacro(mainQuery,'CONF',_CONF);
      setMacro(mainQuery,'CONPERIOD',_CONPERIOD);
      setMacro(mainQuery,'PERMISSIONSL',_PERMISSIONSL);
      setMacro(mainQuery,'PERMISSIONSG',_PERMISSIONSG);
      setMacro(mainQuery,'PERMISSIONSR',_PERMISSIONSR);
      setMacro(mainQuery,'PERMISSIONSS',_PERMISSIONSS);
      setMacro(mainQuery,'PERMISSIONSF',_PERMISSIONSF);
    end;
    try
    mainQuery.Open;
    except
      copyToClipboard(mainQuery.SQL.Text);
      raise;
    end;

    UpdStatus('Budowanie raportu');
    with dmodule do begin
        mainQuery.First;

        if mainQuery.Eof then begin
          if question('Ups, nie znaleziono �adnych danych. Czy chcesz, aby umie�ci� w schowku informacje przydatne dla personelu wsparcia technicznego?')=id_yes then begin
            CopyToClipboard(mainQuery.sql.text);
            info('Zrobione. Skontaktuj si� z administratorem, kt�ry pomo�e w rozwi�zaniu problemu, gdy przeka�esz mu zawarto�� schowka');
          end;
        end;


        recordsProcessed := 0;
        while not mainQuery.Eof do begin

          if matrix_id <> mainQuery.FieldByName(colTitle).asstring+'+'+mainQuery.FieldByName(colsubtitle).asstring then begin
          matrix_id := mainQuery.FieldByName(coltitle).asstring+'+'+mainQuery.FieldByName(colSubtitle).asstring;
          weeklyTable :=
          weeklyTables.addWeeklyTable(
              ChbcntMode.Checked
              //titles
            , coltitle_dsp
            , mainQuery.FieldByName(coltitle).asstring
            , colsubtitle_dsp
            , mainQuery.FieldByName(colsubtitle).asstring
              //labels
            , columnValues
            , subColumnValues
            , rowValues
            , supressNAValuesFlag.checked);
          end;

            if mainQuery.FieldByName(colColor).asString <> '' then
                //bgcolor := 'BGCOLOR="'+DelphiColourToHTML(strToInt(nvl(mainQuery.FieldByName(colColor).asString,'0')))+'" border="1" style="border:solid white;"'
                  bgcolor := 'BGCOLOR="'+DelphiColourToHTML(strToInt(nvl(mainQuery.FieldByName(colColor).asString,'0')))+'" style="padding: 5px"'
            else
                bgcolor := '';

            colColumnValue    := nvl(mainQuery.FieldByName(colColumn).asstring   ,'*brak*');
            colSubColumnValue := nvl(mainQuery.FieldByName(colSubColumn).asstring,'*brak*');
            colRowValue       := nvl(
              merge(merge(merge(merge(merge(
              mainQuery.FieldByName(colRow).asstring
              ,mainQuery.FieldByName(colRow2).asstring,':')
              ,mainQuery.FieldByName(colRow3).asstring,':')
              ,mainQuery.FieldByName(colRow4).asstring,':')
              ,mainQuery.FieldByName(colRow5).asstring,':')
              ,mainQuery.FieldByName(colRow6).asstring,':')
              ,'*brak*');
            if upperCase(Prog)='EXCEL.EXE' then begin
             colColumnValue := '="'+colColumnValue+'"';
             colSubColumnValue := '="'+colSubColumnValue+'"';
             colRowValue := '="'+colRowValue+'"';
            end;

            weeklyTable.addCell(true, colColumnValue, colSubColumnValue, colRowValue, bgcolor,
                iif(colCell1='DUMMY_NULL','',mainQuery.FieldByName(colCell1).asstring+'<br/>')+
                iif(colCell2='DUMMY_NULL','',mainQuery.FieldByName(colCell2).asstring+'<br/>')+
                iif(colCell3='DUMMY_NULL','',mainQuery.FieldByName(colCell3).asstring+'<br/>')+
                iif(colCell4='DUMMY_NULL','',mainQuery.FieldByName(colCell4).asstring+'<br/>')+
                iif(colCell5='DUMMY_NULL','',mainQuery.FieldByName(colCell5).asstring+'<br/>')+
                iif(colCell6='DUMMY_NULL','',mainQuery.FieldByName(colCell6).asstring)
            ,colSubColumn <> 'DUMMY_NULL', mainQuery.FieldByName('Duration').asFloat  * mainQuery.FieldByName('Fill').asFloat/100 );

            mainQuery.Next;
            inc ( recordsProcessed);
            if recordsProcessed mod 10 = 0 then  UpdStatus('Przetworzono rekord�w : ' +inttoStr(recordsProcessed) );
        end;
    end;

    UpdStatus('Usuwanie duplikat�w');
    weeklyTables.merge(noHideFlag.Checked);
    assignFile(f,outFileName);
    rewrite(f);
    UpdStatus('Zapis danych do pliku');
    writeLn(f,  weeklyTables.getBody(noHideFlag.Checked, rowSpanFlag.checked, colSpanFlag.Checked) );
    closeFile(f);

    UpdStatus('Czyszczenie');
    weeklyTables.cleanUp;
    finalize( weeklyTables );

    UpdStatus('');

    if fmain.silentMode then exit;

    If isBlank(Prog) Then UUTilityParent.ExecuteFile( outFileName ,'','',SW_SHOWMAXIMIZED)
                     Else UUTilityParent.ExecuteFile(Prog, outFileName ,'',SW_SHOWMAXIMIZED);

end;

procedure TFMatrix.BOKClick(Sender: TObject);
begin
  close;
end;

procedure TFMatrix.LoadFromIni ( inifilename : tfilename );
begin
  uutilityparent.LoadFromIni(
            inifilename , 'pivot',
            [ source_date_from, source_date_to, CONL, CONG, CONR, CONS, CONF, CONL_value, CONG_value, CONR_value, CONS_value, CONF_value
            , PERFilterType, LFilterType, GFilterType, RFilterType, SFilterType, FFilterType
            , LSettings, GSettings, RSettings, SSettings, FSettings
            , Column, title, subtitle, subcolumn, color, row, row2, row3, row4, row5, row6, cell1, cell2, cell3, cell4, cell5, cell6
            , chbShowAll, noHideFlag, rowSpanFlag, colSpanFlag, supressNAValuesFlag
            , ChbcntMode, perId
            ]);
  loadPeriod( perId.Text );
end;

procedure TFMatrix.saveToIni ( inifilename : tfilename );
begin
  uutilityparent.saveToIni(
            inifilename , 'pivot',
            [ source_date_from, source_date_to, CONL, CONG, CONR, CONS, CONF, CONL_value, CONG_value, CONR_value, CONS_value, CONF_value
            , PERFilterType, LFilterType, GFilterType, RFilterType, SFilterType, FFilterType
            , PERSettings, LSettings, GSettings, RSettings, SSettings, FSettings
            , Column, title, subtitle, subcolumn, color, row, row2, row3, row4, row5, row6, cell1, cell2, cell3, cell4, cell5, cell6
            , chbShowAll, noHideFlag, rowSpanFlag, colSpanFlag, supressNAValuesFlag
            , ChbcntMode, perId
            ]);
end;

function  TFMatrix.loadSettings :boolean;
begin
    result := false;
    if not openDialog.Execute then exit;
    self.LoadFromIni( openDialog.FileName );
    result := true;
end;

function  TFMatrix.saveSettings :boolean;
begin
  result := false;
  if not saveDialog.Execute then exit;
  self.saveToIni(saveDialog.FileName);
  result := true;
end;

procedure TFMatrix.Zapisz1Click(Sender: TObject);
begin
    saveSettings;
end;

procedure TFMatrix.Otwrz1Click(Sender: TObject);
begin
    loadSettings;
end;

procedure TFMatrix.MenuItem1Click(Sender: TObject);
begin
    generate('excel.exe');
end;

procedure TFMatrix.MenuItem2Click(Sender: TObject);
begin
    generate('winword.exe');
end;

procedure TFMatrix.BWordClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tbitBtn).Height;
 Point   := (sender as tbitBtn).ClientToScreen(Point);
 wordExcel.Popup(Point.X,Point.Y);
end;

procedure TFMatrix.Przegldarka1Click(Sender: TObject);
begin
    generate('');
end;


procedure TFMatrix.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if not ignoreSave then
    self.SaveToIni( defSettingsFileName );
end;

procedure TFMatrix.BUstawieniaFormularzaClick(Sender: TObject);
begin
  inherited;
  deleteFile (defSettingsFileName);
  ignoreSave := true;
end;

procedure TFMatrix.BitBtn1Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 SelectDates.Popup(Point.X,Point.Y);
end;

procedure TFMatrix.MenuItem3Click(Sender: TObject);
begin
  source_date_from.Date := now;
  source_date_to.Date := now;
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.Wczoraj1Click(Sender: TObject);
begin
  source_date_from.Date := now-1;
  source_date_to.Date := now-1;
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.Przedwczoraj1Click(Sender: TObject);
begin
  source_date_from.Date := now-2;
  source_date_to.Date := now-2;
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.Cdesc3Click(Sender: TObject);
begin
  source_date_from.Date := now+1;
  source_date_to.Date := now+1;
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.Cdesc4Click(Sender: TObject);
begin
  source_date_from.Date := now+2;
  source_date_to.Date := now+2;
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;


procedure TFMatrix.loadPeriod (perId_ : shortString);
begin
    if (perId_='') then exit;
    With DModule do begin
        perId.Text := perId_;
        try
        Dmodule.SingleValue('SELECT TO_CHAR(DATE_FROM,''YYYY''), TO_CHAR(DATE_FROM,''MM''), TO_CHAR(DATE_FROM,''DD''), TO_CHAR(DATE_TO,''YYYY''), TO_CHAR(DATE_TO,''MM''), TO_CHAR(DATE_TO,''DD''), NAME FROM PERIODS WHERE ID='+ perId.Text);
        except {ignore error if any}  end;
        if QWork.IsEmpty then begin
         PerCleanClick(nil);
        end
        else begin
          perId_Value.text := QWork.Fields[6].AsString;
          source_date_from.Date := EncodeDate(QWork.Fields[0].AsInteger,QWork.Fields[1].AsInteger,QWork.Fields[2].AsInteger);
          source_date_to.Date := EncodeDate(QWork.Fields[3].AsInteger,QWork.Fields[4].AsInteger,QWork.Fields[5].AsInteger);
          periodClause  :=UCommon.getWhereClausefromPeriod('ID = ' + perId.Text ,'CLASSES.');
          PeriodSelectionDsp.Caption := Ucommon.PeriodSelectionDsp;
          perId_Value.Visible := true;
          PerClean.Visible := true;
          PerLabel.Visible := true;
        end;
    End;
end;

procedure TFMatrix.Wybierzsemestr1Click(Sender: TObject);
var perId_ : shortString;
begin
  inherited;
  perId_ := fmain.conPeriod.Text;
  If PERIODSShowModalAsSelect( perId_ ) = mrOK Then loadPeriod (perId_);
end;


procedure TFMatrix.source_date_fromChange(Sender: TObject);
begin
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.source_date_toChange(Sender: TObject);
begin
  PerCleanClick(nil);
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.BGenerateBatchClick(Sender: TObject);
var iniFile : TIniFile;
    s : string;
    f : textFile;
begin
  if (perId.Text='') then begin
    Info('Najpierw wybierz semestr naciskaj�c przycisk Wybierz | Wybierz semestr');
    exit;
  end;
  saveDialog.fileName := 'matrix.ini';
  if not saveDialog.Execute then exit;

  iniFile := TIniFile.Create( saveDialog.FileName );
  With iniFile do begin
    WriteString ('initype','initype','matrix');
    WriteString ('matrix','setup', extractFileDir(saveDialog.FileName)+'\setup.ini' );
    WriteString ('matrix','outFileName', uutilityParent.ApplicationDocumentsPath + 'temp.htm' );

  end;
  iniFile.Free;

  AssignFile(f, extractFileDir(saveDialog.FileName)+'\runMe.bat' );
  reWrite(f);

  writeLn(f, '"'+ApplicationDir + '\' + 'planowanie.exe" '+userName+' '+uutilityparent.EncryptShortString(1, 'PASSWORD:'+password, 'SoftwareFactory')+' '+DBname+' "inifile='+ saveDialog.FileName +'"');
  closeFile(f);

  self.saveToIni( extractFileDir(saveDialog.FileName)+'\setup.ini' );

  s :=
  'Pliki do automatycznej publikacji (CLI) s� gotowe!'+cr+
  'Uruchom plik runMe.bat'+cr+
  'Mo�esz zaharmonogramowa� automatyczne uruchomienie za pomoc� funkcji Panel sterowania->Zaplanowane zadania';

  info(s);
end;

procedure TFMatrix.PerCleanClick(Sender: TObject);
begin
  inherited;
  perId.Text := '';
  perId_Value.Text := '';
  perId.Visible := false;
  perId_Value.Visible := false;
  PerClean.Visible := false;
  PerLabel.Visible := false;
  periodClause := '';
  PeriodSelectionDsp.Caption := '';
end;

procedure TFMatrix.perId_ValueClick(Sender: TObject);
begin
 Wybierzsemestr1Click(nil);
end;

procedure TFMatrix.perId_ValueChange(Sender: TObject);
begin
  inherited;
  PerClean.Visible := (sender as tedit).Text <> '';
end;

end.
