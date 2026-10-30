unit UFExportTimetable;

// Dane | Zarz¹dzanie danymi | Zapisz rozk³ad zajêæ w Excel
// Plik w formacie importu "U³o¿ony rozk³ad zajêæ" (UFMassImport.ImportTimetable): jeden wiersz = jedna godzina zajêæ.
// Zapisywane s¹ zajêcia, których u¿ytkownik jest w³aœcicielem (tak¿e jako prze³o¿ony - "Mój zespó³"), i w których jest
// co najmniej jeden zaznaczony wyk³adowca, grupa albo zasób. Listy zawieraj¹ tylko obiekty, do których u¿ytkownik
// (albo wybrana autoryzacja) ma uprawnienia.
// "Ca³a baza danych" (tylko administrator): bez sprawdzania uprawnieñ i w³aœcicieli.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, CheckLst, ComObj;

type
  TFExportTimetable = class(TFormConfig)
    TopPanel: TPanel;
    LPeriod: TLabel;
    currentPeriod: TEdit;
    currentPeriod_VALUE: TEdit;
    BitBtnPER: TBitBtn;
    WholeDatabase: TCheckBox;
    BottomPanel: TPanel;
    BExport: TBitBtn;
    BClose: TBitBtn;
    pleft: TPanel;
    plefttop: TPanel;
    Lecturers: TCheckBox;
    lselector: TCheckBox;
    LList: TCheckListBox;
    Splitter1: TSplitter;
    pright: TPanel;
    prighttop: TPanel;
    Resources: TCheckBox;
    rselector: TCheckBox;
    RList: TCheckListBox;
    Splitter2: TSplitter;
    pmiddle: TPanel;
    pmiddletop: TPanel;
    Groups: TCheckBox;
    gselector: TCheckBox;
    GList: TCheckListBox;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtnPERClick(Sender: TObject);
    procedure currentPeriodChange(Sender: TObject);
    procedure WholeDatabaseClick(Sender: TObject);
    procedure LecturersClick(Sender: TObject);
    procedure selectorClick(Sender: TObject);
    procedure BExportClick(Sender: TObject);
  private
    formPrepared : boolean;
  end;

var
  FExportTimetable: TFExportTimetable;

implementation

uses DM, UFMain, UUtilities, UCommon, UUtilityParent, AutoCreate, UFProgramSettings, UProgress;

{$R *.DFM}

procedure TFExportTimetable.FormCreate(Sender: TObject);
begin
  inherited;
  formPrepared := false;
end;

procedure TFExportTimetable.FormShow(Sender: TObject);
begin
  inherited;
  with fprogramSettings do begin
    LPeriod.Caption   := profileObjectNamePeriod.Text;
    Lecturers.Caption := profileObjectNameLs.Text;
    Groups.Caption    := profileObjectNameGs.Text;
  end;
  // tylko administrator; zapisane ustawienia okna nie mog¹ w³¹czyæ tej opcji
  WholeDatabase.Checked := false;
  WholeDatabase.Enabled := isAdmin;
  LecturersClick(nil);
  formPrepared := true;
  currentPeriodChange(nil);
end;

procedure TFExportTimetable.BitBtnPERClick(Sender: TObject);
var KeyValue : ShortString;
begin
  KeyValue := currentPeriod.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then
    currentPeriod.Text := KeyValue;
end;

// listy jak w oknie Tworzenie witryny www: obiekty, które maj¹ zajêcia w okresie,
// bez "Ca³a baza danych" - tylko te, do których u¿ytkownik (autoryzacja) ma uprawnienia
procedure TFExportTimetable.currentPeriodChange(Sender: TObject);
var periodClause : string;

  // lista przerysowywana raz, po wczytaniu wszystkich pozycji (bez mrugania)
  procedure fill(L : TCheckListBox; sql : string);
  var i : integer;
  begin
    L.Items.BeginUpdate;
    try
      L.Items.Clear;
      DModule.OpenSQL(sql);
      while not DModule.QWork.Eof do begin
        L.Items.AddObject(DModule.QWork.Fields[0].AsString, pointer(DModule.QWork.Fields[1].AsInteger));
        DModule.QWork.Next;
      end;
      for i := 0 to L.Count - 1 do L.Checked[i] := true;
    finally
      L.Items.EndUpdate;
    end;
  end;

  function permission(alias, idColumn : string) : string;
  begin
    if WholeDatabase.Checked then result := ''
    else result := ' AND '+idColumn+' IN (SELECT '+alias+'_ID FROM '+alias+'_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
  end;

begin
  if not formPrepared then exit;
  if isBlank(currentPeriod.Text) then exit;
  DModule.RefreshLookupEdit(Self, currentPeriod.Name, 'NAME', 'PERIODS', '');

  periodClause := UCommon.getWhereClausefromPeriod('ID = ' + currentPeriod.Text, 'XXX.');
  Screen.Cursor := crHourGlass;
  try
    fill(LList, 'SELECT DISTINCT '+sql_LECNAME+' LEC_NAME, LEC.ID FROM LEC_CLA XXX, LECTURERS LEC'+
                ' WHERE LEC.ID > 0 AND XXX.LEC_ID = LEC.ID AND '+periodClause+permission('LEC', 'LEC.ID')+
                ' ORDER BY LEC_NAME');
    fill(GList, 'SELECT DISTINCT '+sql_GRONAME+' GRO_NAME, GROUPS.ID FROM GRO_CLA XXX, GROUPS'+
                ' WHERE GROUPS.ID > 0 AND XXX.GRO_ID = GROUPS.ID AND '+periodClause+permission('GRO', 'GROUPS.ID')+
                ' ORDER BY GRO_NAME');
    fill(RList, 'SELECT DISTINCT '+sql_ResCat0NAME+' ROM_NAME, ROM.ID FROM ROM_CLA XXX, ROOMS ROM'+
                ' WHERE ROM.ID > 0 AND XXX.ROM_ID = ROM.ID AND '+periodClause+permission('ROM', 'ROM.ID')+
                ' ORDER BY ROM_NAME');
  finally
    Screen.Cursor := crDefault;
  end;
  lselector.Checked := true;
  gselector.Checked := true;
  rselector.Checked := true;
end;

procedure TFExportTimetable.WholeDatabaseClick(Sender: TObject);
begin
  if WholeDatabase.Checked and not isAdmin then begin
    SError('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
    WholeDatabase.Checked := false;
    exit;
  end;
  currentPeriodChange(nil);
end;

procedure TFExportTimetable.LecturersClick(Sender: TObject);
begin
  LList.Enabled := Lecturers.Checked;  lselector.Enabled := Lecturers.Checked;
  GList.Enabled := Groups.Checked;     gselector.Enabled := Groups.Checked;
  RList.Enabled := Resources.Checked;  rselector.Enabled := Resources.Checked;
end;

procedure TFExportTimetable.selectorClick(Sender: TObject);
var L : TCheckListBox;
    t : integer;
begin
  if Sender = lselector then L := LList else
  if Sender = gselector then L := GList else L := RList;
  L.Items.BeginUpdate;
  try
    for t := 0 to L.Count - 1 do L.Checked[t] := (Sender as TCheckBox).Checked;
  finally
    L.Items.EndUpdate;
  end;
end;

procedure TFExportTimetable.BExportClick(Sender: TObject);
const header : array[1..14] of string = ('Data', 'Godzina', 'Wyk³adowca', 'Grupa', 'Sala', 'Przedmiot', 'Forma',
                                         'Info dla studentów', 'Info dla planistów', 'W³aœciciel', 'Opis 3', 'Opis 4', 'Wype³nienie', 'Kolor');
type TRow = record
       day    : TDateTime;
       hour   : integer;
       txt    : array[3..12] of string; // kolumny C..L
       fill   : integer;                // M; 100 (domyœlne) - pusta komórka
       colour : Variant;                // N; Null - pusta komórka
     end;
var selL, selG, selR   : TStringList;
    keys               : TStringList; // posortowane klucze 'L12', 'G3', 'R7', 'S5', 'F2'; Objects = indeks w names
    names, problems    : TStringList;
    rows               : array of TRow;
    data, xl, wb, ws   : OleVariant;
    c                  : integer;
    periodClause       : string;
    lastRow, dateFmt   : string;
    cnt, t, total, n   : integer;

  procedure progress(position : integer);
  begin
    FProgress.ProgressBar.Position := position;
    FProgress.Refresh;
  end;

  function selected(enabled : boolean; L : TCheckListBox) : TStringList;
  var i : integer;
  begin
    result := TStringList.Create;
    result.Sorted := true;
    if enabled then
      for i := 0 to L.Count - 1 do
        if L.Checked[i] then result.Add(IntToStr(integer(L.Items.Objects[i])));
  end;

  // czy któryœ z identyfikatorów "1;2;3" jest zaznaczony
  function anySelected(ids : string; sel : TStringList) : boolean;
  var i : integer;
  begin
    result := false;
    for i := 1 to WordCount(ids, [';']) do
      if sel.IndexOf(Trim(ExtractWord(i, ids, [';']))) >= 0 then begin result := true; exit; end;
  end;

  // nazwy do pliku: cla_interface_pkg.exportName - nazwa, któr¹ import dopasuje dok³adnie do tego samego obiektu
  // (bez tworzenia duplikatów); obiekt bez takiej nazwy jest zg³aszany przed zapisem
  procedure loadNames(kind : char; kindName, sql : string);
  begin
    DModule.OpenSQL(sql);
    while not DModule.QWork.Eof do begin
      keys.AddObject(kind + DModule.QWork.Fields[0].AsString, pointer(names.Count));
      if DModule.QWork.Fields[1].AsString <> '' then names.Add(DModule.QWork.Fields[1].AsString)
                                                 else names.Add(#1 + kindName + ' ' + DModule.QWork.Fields[2].AsString);
      DModule.QWork.Next;
    end;
  end;

  function nameOf(kind : char; id : string) : string;
  var k : integer;
  begin
    result := '';
    if id = '' then exit;
    k := keys.IndexOf(kind + id);
    if k >= 0 then result := names[integer(keys.Objects[k])]
              else result := #1 + kind + id;
    if Copy(result, 1, 1) = #1 then begin
      if problems.IndexOf(Copy(result, 2, MaxInt)) < 0 then problems.Add(Copy(result, 2, MaxInt));
      result := '';
    end;
  end;

  function namesOf(kind : char; ids : string) : string;
  var i : integer;
  begin
    result := '';
    for i := 1 to WordCount(ids, [';']) do
      result := result + iif(result = '', '', ', ') + nameOf(kind, Trim(ExtractWord(i, ids, [';'])));
  end;

  // identyfikatory obiektów przypisanych bezpoœrednio do zajêæ (is_child = 'N' - podrzêdne import tworzy sam)
  function idList(alias, claTable : string) : string;
  begin
    result := '(SELECT LISTAGG(XC.'+alias+'_ID, '';'') WITHIN GROUP (ORDER BY XC.ID) FROM '+claTable+' XC'+
              '  WHERE XC.CLA_ID = CLA.ID AND XC.IS_CHILD = ''N'') '+alias+'_IDS';
  end;

begin
  if isBlank(currentPeriod.Text) then begin
    SError('Wybierz: ' + LPeriod.Caption);
    exit;
  end;
  if not (Lecturers.Checked or Groups.Checked or Resources.Checked) then begin
    SError('Zaznacz co najmniej jedno z pól: ' + Lecturers.Caption + ', ' + Groups.Caption + ', ' + Resources.Caption);
    exit;
  end;
  SaveDialog.FileName := StringToValidFileName(currentPeriod_VALUE.Text);
  if not SaveDialog.Execute then exit;

  selL     := selected(Lecturers.Checked, LList);
  selG     := selected(Groups.Checked,    GList);
  selR     := selected(Resources.Checked, RList);
  keys     := TStringList.Create;
  names    := TStringList.Create;
  problems := TStringList.Create;
  cnt      := 0;
  Screen.Cursor := crHourGlass;
  FProgress.Show;
  progress(0);
  try
    periodClause := UCommon.getWhereClausefromPeriod('ID = ' + currentPeriod.Text, 'XXX.');
    loadNames('L', 'Wyk³adowca', 'SELECT ID, cla_interface_pkg.exportName(''L'', ID), '+sql_LECNAME+' FROM LECTURERS'+
                                 ' WHERE ID IN (SELECT LEC_ID FROM LEC_CLA XXX WHERE '+periodClause+')');
    progress(5);
    loadNames('G', 'Grupa',      'SELECT ID, cla_interface_pkg.exportName(''G'', ID), '+sql_GRONAME+' FROM GROUPS'+
                                 ' WHERE ID IN (SELECT GRO_ID FROM GRO_CLA XXX WHERE '+periodClause+')');
    progress(10);
    loadNames('R', 'Sala',       'SELECT ID, cla_interface_pkg.exportName(''R'', ID), '+sql_ResCat0NAME+' FROM ROOMS'+
                                 ' WHERE ID IN (SELECT ROM_ID FROM ROM_CLA XXX WHERE '+periodClause+')');
    progress(15);
    loadNames('S', 'Przedmiot',  'SELECT ID, cla_interface_pkg.exportName(''S'', ID), NAME FROM SUBJECTS'+
                                 ' WHERE ID IN (SELECT SUB_ID FROM CLASSES XXX WHERE '+periodClause+')');
    loadNames('F', 'Forma',      'SELECT ID, cla_interface_pkg.exportName(''F'', ID), NAME FROM FORMS'+
                                 ' WHERE ID IN (SELECT FOR_ID FROM CLASSES XXX WHERE '+periodClause+')');
    keys.Sorted := true;
    progress(25);

    // liczba zajêæ okresu - tylko do paska postêpu
    total := StrToIntDef(DModule.SingleValue('SELECT COUNT(*) FROM CLASSES CLA WHERE NVL(CLA.OWNER, ''-'') <> ''AUTO'''+
                                             ' AND '+replace(periodClause, 'XXX.', 'CLA.')), 0);
    n := 0;

    // zajêcia i rezerwacje okresu; bez zajêæ tworzonych automatycznie (w³aœciciel AUTO - podgrupy / nadgrupy)
    DModule.OpenSQL(
      'SELECT CLA.DAY, CLA.HOUR, CLA.OWNER, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, CLA.FILL, CLA.COLOUR, CLA.SUB_ID, CLA.FOR_ID, '+
      idList('LEC', 'LEC_CLA')+', '+idList('GRO', 'GRO_CLA')+', '+idList('ROM', 'ROM_CLA')+
      ' FROM CLASSES CLA'+
      ' WHERE NVL(CLA.OWNER, ''-'') <> ''AUTO'''+
      '   AND '+replace(periodClause, 'XXX.', 'CLA.')+
      ' ORDER BY CLA.DAY, CLA.HOUR, CLA.ID');

    // zajêcia u¿ytkownika (z zespo³em) z co najmniej jednym zaznaczonym obiektem
    with DModule.QWork do
      while not Eof do begin
        if (WholeDatabase.Checked or isOwner(FieldByName('OWNER').AsString))
           and (anySelected(FieldByName('LEC_IDS').AsString, selL) or
                anySelected(FieldByName('GRO_IDS').AsString, selG) or
                anySelected(FieldByName('ROM_IDS').AsString, selR)) then
        begin
          if cnt = Length(rows) then SetLength(rows, cnt + 1000);
          rows[cnt].day     := Trunc(FieldByName('DAY').AsDateTime);
          rows[cnt].hour    := FieldByName('HOUR').AsInteger;
          rows[cnt].txt[3]  := namesOf('L', FieldByName('LEC_IDS').AsString);
          rows[cnt].txt[4]  := namesOf('G', FieldByName('GRO_IDS').AsString);
          rows[cnt].txt[5]  := namesOf('R', FieldByName('ROM_IDS').AsString);
          rows[cnt].txt[6]  := nameOf('S', FieldByName('SUB_ID').AsString);   // pusty: rezerwacja
          rows[cnt].txt[7]  := nameOf('F', FieldByName('FOR_ID').AsString);
          rows[cnt].txt[8]  := FieldByName('DESC2').AsString;  // info dla studentów
          rows[cnt].txt[9]  := FieldByName('DESC1').AsString;  // info dla planistów
          rows[cnt].txt[10] := FieldByName('OWNER').AsString;  // kilku w³aœcicieli: "A;B"
          rows[cnt].txt[11] := FieldByName('DESC3').AsString;
          rows[cnt].txt[12] := FieldByName('DESC4').AsString;
          if FieldByName('FILL').IsNull then rows[cnt].fill := 100
                                        else rows[cnt].fill := FieldByName('FILL').AsInteger;
          rows[cnt].colour  := FieldByName('COLOUR').Value;
          inc(cnt);
        end;
        inc(n);
        if (n mod 200 = 0) and (total > 0) then progress(25 + 45 * n div total);
        Next;
      end;
    progress(70);

    if cnt = 0 then begin
      FProgress.Hide;
      SError('Brak zajêæ do zapisania. SprawdŸ wybrany okres i zaznaczone obiekty' +
             iif(WholeDatabase.Checked, '', ' (zapisywane s¹ tylko zajêcia, których jesteœ w³aœcicielem)'));
      exit;
    end;

    // ca³y arkusz jednym zapisem (zapis komórka po komórce jest bardzo wolny)
    data := VarArrayCreate([1, cnt + 1, 1, 14], varVariant);
    for t := 1 to 14 do data[1, t] := header[t];
    for t := 0 to cnt - 1 do begin
      data[t+2, 1] := VarFromDateTime(rows[t].day);
      data[t+2, 2] := rows[t].hour;
      for c := 3 to 12 do data[t+2, c] := rows[t].txt[c];
      if rows[t].fill <> 100 then data[t+2, 13] := rows[t].fill;
      if not VarIsNull(rows[t].colour) then data[t+2, 14] := rows[t].colour;
    end;

    // nazwa, której import nie dopasuje jednoznacznie, utworzy³aby duplikat albo zgubi³a zajêcia - nie zapisujemy
    if problems.Count > 0 then begin
      FProgress.Hide;
      SError('Nie zapisano pliku. Tych obiektów nie da siê zapisaæ tak, aby import jednoznacznie je rozpozna³ '+
             '(nazwa i skrót pasuj¹ te¿ do innego obiektu albo zawieraj¹ przecinek). Zmieñ nazwê lub skrót i spróbuj ponownie:' +
             cr + cr + problems.Text);
      exit;
    end;

    lastRow := IntToStr(cnt + 1);
    xl := CreateOleObject('Excel.Application');
    try
      xl.DisplayAlerts := false;
      // wywo³ania przez IDispatch Excel interpretuje w ustawieniach regionalnych u¿ytkownika (np. polski rok = "rrrr"),
      // dlatego format daty jest sk³adany z kodów roku, miesi¹ca i dnia odczytanych z Excela
      dateFmt := xl.International[19] + xl.International[19] + xl.International[19] + xl.International[19] + '-' +  // xlYearCode
                 xl.International[20] + xl.International[20] + '-' +                                                   // xlMonthCode
                 xl.International[21] + xl.International[21];                                                          // xlDayCode
      progress(75);
      wb := xl.Workbooks.Add;
      ws := wb.Worksheets[1];
      ws.Name := 'Rozk³ad zajêæ';
      ws.Range['C1', 'L' + lastRow].NumberFormat := '@'; // tekst: nazwy takie jak "03" nie zmieni¹ siê w liczby
      ws.Range['A1', 'N' + lastRow].Value := data;
      progress(85);
      ws.Range['A2', 'A' + lastRow].NumberFormat := dateFmt;
      ws.Range['A1', 'N1'].Font.Bold := true;
      ws.Range['A1', 'N' + lastRow].Columns.AutoFit;
      if ws.Range['F1'].ColumnWidth > 70 then ws.Range['F1'].ColumnWidth := 70;
      if FileExists(SaveDialog.FileName) then DeleteFile(SaveDialog.FileName);
      progress(90);
      wb.SaveAs(SaveDialog.FileName, 51); // xlOpenXMLWorkbook
      progress(100);
      wb.Close(false);
    finally
      ws := Unassigned;
      wb := Unassigned;
      xl.Quit;
      xl := Unassigned;
    end;
  finally
    selL.Free;
    selG.Free;
    selR.Free;
    keys.Free;
    names.Free;
    problems.Free;
    FProgress.Hide;
    Screen.Cursor := crDefault;
  end;

  if Question('Zapisano godzin zajêæ: ' + IntToStr(cnt) + '.' + cr + cr + 'Czy chcesz otworzyæ plik?') = ID_YES then
    ExecuteFile(SaveDialog.FileName, '', '', SW_SHOWMAXIMIZED);
end;

end.
