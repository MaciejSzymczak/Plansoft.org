unit UFMoveClasses;

// Edycja | Kopiuj rozk³ad zajêæ | Metoda III - przesuñ rozk³ad
// Przesuwa zajêcia z okresu "Od dnia" .. "Do dnia" o tyle dni, ile dzieli "Od dnia" od "Nowa data pocz¹tkowa".
// Przesuwane s¹ zajêcia, w których jest co najmniej jeden zaznaczony wyk³adowca, grupa albo sala (pozosta³e obiekty
// zajêæ nie musz¹ byæ zaznaczone). Listy zawieraj¹ tylko obiekty z zajêciami w okresie, do których u¿ytkownik
// (albo wybrana autoryzacja) ma uprawnienia (XXX_PLA); pole "Dowolna fraza" filtruje listê jak w oknach Wyk³adowcy, Grupy, Sale.
// Uprawnienia jak przy przenoszeniu zajêæ rêcznie: prawo wstawiania i usuwania zajêæ, w³aœciciel zajêæ (tak¿e prze³o¿ony -
// "Mój zespó³"), uprawnienia do wszystkich wyk³adowców, grup, sal i przedmiotu zajêæ (cla_interface_pkg.moveClasses).
// Zajêcia, których nie da siê przesun¹æ (uprawnienia, konflikt w nowym terminie), s¹ pokazywane w raporcie.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, CheckLst, ComCtrls, ADODB, UFilteredCheckList;

type
  TFMoveClasses = class(TFormConfig)
    TopPanel: TPanel;
    LDateFrom: TLabel;
    DateFrom: TDateTimePicker;
    LDateTo: TLabel;
    DateTo: TDateTimePicker;
    LNewDateFrom: TLabel;
    NewDateFrom: TDateTimePicker;
    LShift: TLabel;
    BottomPanel: TPanel;
    BMove: TBitBtn;
    BClose: TBitBtn;
    pleft: TPanel;
    plefttop: TPanel;
    LLecturers: TLabel;
    lselector: TCheckBox;
    lfind: TLabel;
    lSearch: TEdit;
    LList: TCheckListBox;
    Splitter1: TSplitter;
    pright: TPanel;
    prighttop: TPanel;
    LResources: TLabel;
    rselector: TCheckBox;
    rfind: TLabel;
    rSearch: TEdit;
    RList: TCheckListBox;
    Splitter2: TSplitter;
    pmiddle: TPanel;
    pmiddletop: TPanel;
    LGroups: TLabel;
    gselector: TCheckBox;
    gfind: TLabel;
    gSearch: TEdit;
    GList: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure datesChange(Sender: TObject);
    procedure NewDateFromChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BMoveClick(Sender: TObject);
  private
    formPrepared : boolean;
    lItems, gItems, rItems : TFilteredCheckList;
    function shiftDays : integer;
  end;

var
  FMoveClasses: TFMoveClasses;

implementation

uses DM, UFMain, UUtilities, UCommon, UUtilityParent, UFProgramSettings, UProgress;

{$R *.DFM}

procedure TFMoveClasses.FormCreate(Sender: TObject);
begin
  inherited;
  formPrepared := false;
  lItems := TFilteredCheckList.Create(LList, lSearch, lselector, sql_LEC_SEARCH,
              'SELECT LECTURERS.ID FROM LECTURERS, ORG_UNITS WHERE LECTURERS.ORGUNI_ID = ORG_UNITS.ID(+)', 'LEC.ID');
  gItems := TFilteredCheckList.Create(GList, gSearch, gselector, sql_GRO_SEARCH,
              'SELECT GROUPS.ID FROM GROUPS, ORG_UNITS WHERE GROUPS.ORGUNI_ID = ORG_UNITS.ID(+)', 'GROUPS.ID');
  rItems := TFilteredCheckList.Create(RList, rSearch, rselector, sql_ROM_SEARCH,
              'SELECT ROOMS.ID FROM ROOMS, ORG_UNITS WHERE ROOMS.ORGUNI_ID = ORG_UNITS.ID(+)', 'ROM.ID');
end;

procedure TFMoveClasses.FormDestroy(Sender: TObject);
begin
  lItems.Free;
  gItems.Free;
  rItems.Free;
  inherited;
end;

procedure TFMoveClasses.FormShow(Sender: TObject);
begin
  inherited;
  with fprogramSettings do begin
    LLecturers.Caption := profileObjectNameLs.Text;
    LGroups.Caption    := profileObjectNameGs.Text;
  end;
  LResources.Caption := 'Sale';
  DateFrom.Date    := Date;
  DateTo.Date      := Date + 6;
  NewDateFrom.Date := Date + 7;
  formPrepared := true;
  datesChange(nil);
end;

function TFMoveClasses.shiftDays : integer;
begin
  result := Trunc(NewDateFrom.Date) - Trunc(DateFrom.Date);
end;

// listy: obiekty, które maj¹ zajêcia w okresie i do których u¿ytkownik (autoryzacja) ma uprawnienia;
// zaznaczenia obiektów, które nadal s¹ na liœcie, zostaj¹ zachowane
procedure TFMoveClasses.datesChange(Sender: TObject);
var dayClause : string;

  function permission(alias, idColumn : string) : string;
  begin
    result := ' AND '+idColumn+' IN (SELECT '+alias+'_ID FROM '+alias+'_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
  end;

begin
  if not formPrepared then exit;
  NewDateFromChange(nil);
  if Trunc(DateTo.Date) < Trunc(DateFrom.Date) then begin
    lItems.Clear;
    gItems.Clear;
    rItems.Clear;
    exit;
  end;
  dayClause := 'XXX.DAY BETWEEN '+DateToOracle(DateFrom.Date)+' AND '+DateToOracle(DateTo.Date)+' AND XXX.IS_CHILD = ''N''';
  Screen.Cursor := crHourGlass;
  try
    lItems.Load('SELECT DISTINCT '+sql_LECNAME+' LEC_NAME, LEC.ID FROM LEC_CLA XXX, LECTURERS LEC'+
                ' WHERE LEC.ID > 0 AND XXX.LEC_ID = LEC.ID AND '+dayClause+permission('LEC', 'LEC.ID'), ' ORDER BY LEC_NAME', false);
    gItems.Load('SELECT DISTINCT '+sql_GRONAME+' GRO_NAME, GROUPS.ID FROM GRO_CLA XXX, GROUPS'+
                ' WHERE GROUPS.ID > 0 AND XXX.GRO_ID = GROUPS.ID AND '+dayClause+permission('GRO', 'GROUPS.ID'), ' ORDER BY GRO_NAME', false);
    rItems.Load('SELECT DISTINCT '+sql_ResCat0NAME+' ROM_NAME, ROM.ID FROM ROM_CLA XXX, ROOMS ROM'+
                ' WHERE ROM.ID > 0 AND XXX.ROM_ID = ROM.ID AND '+dayClause+permission('ROM', 'ROM.ID'), ' ORDER BY ROM_NAME', false);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFMoveClasses.NewDateFromChange(Sender: TObject);
const dayNames : array[1..7] of string = ('niedziela', 'poniedzia³ek', 'wtorek', 'œroda', 'czwartek', 'pi¹tek', 'sobota');
var d : integer;
begin
  d := shiftDays;
  if d = 0 then LShift.Caption := 'Przesuniêcie: 0 dni - zmieñ now¹ datê pocz¹tkow¹'
  else begin
    LShift.Caption := 'Przesuniêcie: ' + iif(d > 0, 'o ' + IntToStr(d) + ' dni póŸniej', 'o ' + IntToStr(-d) + ' dni wczeœniej') +
                      ' (nowy okres: ' + FormatDateTime('yyyy-mm-dd', DateFrom.Date + d) + ' - ' + FormatDateTime('yyyy-mm-dd', DateTo.Date + d) + ')';
    if DayOfWeek(DateFrom.Date) <> DayOfWeek(NewDateFrom.Date) then
      LShift.Caption := LShift.Caption + '. Uwaga: zmieni siê dzieñ tygodnia (' + dayNames[DayOfWeek(DateFrom.Date)] + ' -> ' + dayNames[DayOfWeek(NewDateFrom.Date)] + ')';
  end;
end;

procedure TFMoveClasses.BMoveClick(Sender: TObject);
var selL, selG, selR : TStringList;
    ins              : TADOQuery;
    reportFile       : string;
    days, cnt, moved, total, notMoved : integer;
    committed        : boolean;

  // czy któryœ z identyfikatorów "1;2;3" jest zaznaczony
  function anySelected(ids : string; sel : TStringList) : boolean;
  var i : integer;
  begin
    result := false;
    for i := 1 to WordCount(ids, [';']) do
      if sel.IndexOf(Trim(ExtractWord(i, ids, [';']))) >= 0 then begin result := true; exit; end;
  end;

  function idList(alias, claTable : string) : string;
  begin
    result := '(SELECT LISTAGG(XC.'+alias+'_ID, '';'') WITHIN GROUP (ORDER BY XC.ID) FROM '+claTable+' XC'+
              '  WHERE XC.CLA_ID = CLA.ID AND XC.IS_CHILD = ''N'') '+alias+'_IDS';
  end;

begin
  days := shiftDays;
  if Trunc(DateTo.Date) < Trunc(DateFrom.Date) then begin
    SError('Data koñcowa nie mo¿e byæ wczeœniejsza ni¿ data pocz¹tkowa');
    exit;
  end;
  if days = 0 then begin
    SError('Nowa data pocz¹tkowa jest taka sama jak data pocz¹tkowa - zajêcia nie zosta³yby przesuniête');
    exit;
  end;
  if not (UutilityParent.CanInsert and UutilityParent.CanDelete) then begin
    SError('Nie mo¿esz przesuwaæ zajêæ - potrzebne s¹ uprawnienia do wstawiania i usuwania zajêæ');
    exit;
  end;

  reportFile := uutilityParent.ApplicationDocumentsPath + 'Rozklad_Przesuniecie.html';
  if not CanOverwriteFile(reportFile) then exit;

  // zaznaczone obiekty, tak¿e ukryte przez filtr "Dowolna fraza"
  selL := lItems.Selected;
  selG := gItems.Selected;
  selR := rItems.Selected;
  ins  := nil;
  committed := false;
  moved := 0;
  try
    if selL.Count + selG.Count + selR.Count = 0 then begin
      SError('Zaznacz co najmniej jednego wyk³adowcê, grupê albo salê');
      exit;
    end;

    dmodule.CommitTrans; // = BeginTrans
    Screen.Cursor := crHourGlass;
    FProgress.Show;
    try
      dmodule.SQL('delete from cla_interface where created_by = user');
      ins := TADOQuery.Create(self);
      ins.Connection := DModule.ADOConnection;
      ins.SQL.Text := 'insert into cla_interface (line_no, cla_id, status, message) values (:line_no, :cla_id, :status, :message)';

      // zajêcia i rezerwacje okresu z co najmniej jednym zaznaczonym obiektem;
      // bez zajêæ tworzonych automatycznie (w³aœciciel AUTO - przesuwaj¹ siê z zajêciami, z których powsta³y)
      DModule.OpenSQL(
        'SELECT CLA.ID, CLA.OWNER, '+idList('LEC', 'LEC_CLA')+', '+idList('GRO', 'GRO_CLA')+', '+idList('ROM', 'ROM_CLA')+
        ' FROM CLASSES CLA'+
        ' WHERE NVL(CLA.OWNER, ''-'') <> ''AUTO'''+
        '   AND CLA.DAY BETWEEN '+DateToOracle(DateFrom.Date)+' AND '+DateToOracle(DateTo.Date)+
        ' ORDER BY CLA.DAY, CLA.HOUR, CLA.ID');
      cnt := 0;
      with DModule.QWork do
        while not Eof do begin
          if anySelected(FieldByName('LEC_IDS').AsString, selL) or
             anySelected(FieldByName('GRO_IDS').AsString, selG) or
             anySelected(FieldByName('ROM_IDS').AsString, selR) then
          begin
            inc(cnt);
            ins.Parameters.ParamByName('line_no').Value := cnt;
            ins.Parameters.ParamByName('cla_id').Value  := FieldByName('ID').AsInteger;
            // tak jak przy rêcznej zmianie (UUtilities.DeleteClass): tylko zajêcia w³asne i zespo³u
            if (FieldByName('OWNER').AsString <> '') and (not isOwner(FieldByName('OWNER').AsString)) then begin
              ins.Parameters.ParamByName('status').Value  := 'ERR';
              ins.Parameters.ParamByName('message').Value := 'Nie mo¿esz zmieniaæ zajêæ u¿ytkownika ' + FieldByName('OWNER').AsString;
            end else begin
              ins.Parameters.ParamByName('status').Value  := Null;
              ins.Parameters.ParamByName('message').Value := Null;
            end;
            ins.ExecSQL;
          end;
          Next;
        end;
      total := cnt;
      FProgress.ProgressBar.Position := 20;
      FProgress.Refresh;

      if total = 0 then begin
        dmodule.RollbackTrans;
        FProgress.Hide;
        Screen.Cursor := crDefault;
        SError('W wybranym okresie nie ma zajêæ zaznaczonych wyk³adowców, grup ani sal');
        exit;
      end;

      FProgress.Hide;
      Screen.Cursor := crDefault;
      if Question('Przesun¹æ zajêcia (' + IntToStr(total) + ') ' + iif(days > 0, 'o ' + IntToStr(days) + ' dni póŸniej', 'o ' + IntToStr(-days) + ' dni wczeœniej') + '?') <> ID_YES then begin
        dmodule.RollbackTrans;
        exit;
      end;
      Screen.Cursor := crHourGlass;
      FProgress.Show;
      FProgress.ProgressBar.Position := 30;
      FProgress.Refresh;

      with TADOQuery.Create(self) do try
        Connection     := DModule.ADOConnection;
        CommandTimeout := 3600;
        ParamCheck     := false;
        SQL.Text       := 'begin cla_interface_pkg.moveClasses(' + IntToStr(days) + ', ' + FMain.getUserOrRoleID + '); end;';
        ExecSQL;
      finally
        Free;
      end;

      FProgress.ProgressBar.Position := 90;
      FProgress.Refresh;
      moved    := StrToIntDef(DModule.SingleValue('select count(*) from cla_interface where created_by = user and status = ''OK'''), 0);
      notMoved := total - moved;
      DModule.OpenSQL('select cla_interface_pkg.getMoveReport(' + IntToStr(days) + ') from dual');
      with TStringList.Create do try
        Text := UTF8Encode(DModule.QWork.Fields[0].AsString);
        SaveToFile(reportFile);
      finally
        Free;
      end;
      DModule.QWork.Close;
      FProgress.Hide;
      Screen.Cursor := crDefault;
      ExecuteFile(reportFile, '', '', SW_SHOWMAXIMIZED);

      if moved = 0 then dmodule.RollbackTrans
      else if Question('Przesuniêto zajêæ: ' + IntToStr(moved) + iif(notMoved > 0, ', nie przesuniêto: ' + IntToStr(notMoved), '') + '. Szczegó³y s¹ w raporcie.' + cr + cr +
                       'Czy zapisaæ zmiany? Jeœli wybierzesz "Nie", ¿adne zajêcia nie zostan¹ przesuniête.') = ID_YES then begin
        dmodule.CommitTrans;
        committed := true;
      end
      else dmodule.RollbackTrans;
    except
      dmodule.RollbackTrans;
      raise;
    end;
  finally
    ins.Free;
    FProgress.Hide;
    Screen.Cursor := crDefault;
  end;

  if committed then begin
    fmain.deepRefreshImmediate('MoveClasses');
    Info('Zajêcia zosta³y przesuniête (' + IntToStr(moved) + ').');
    datesChange(nil);
  end
  else if moved = 0 then
    Info('Nie przesuniêto ¿adnych zajêæ. Szczegó³y s¹ w raporcie.')
  else
    Info('Zmiany zosta³y wycofane - ¿adne zajêcia nie zosta³y przesuniête.');
end;

end.
