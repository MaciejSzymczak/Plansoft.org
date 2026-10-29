unit UFWeeklySchoolPlan;

// Podgl¹d | Tygodniowy rozk³ad zajêæ (Plan lekcji): plan jednego tygodnia dla wyk³adowcy, grupy albo sali.
// Kolumny = widoczne dni tygodnia okresu (PERIODS.SHOW_MON..SHOW_SUN), wiersze = siatka godzin,
// kolejne godziny z tymi samymi zajêciami s¹ zawsze scalane (tylko w pionie - dni nigdy nie s¹ scalane).
// Zawartoœæ i kolory komórek - jak w wydruku semestralnym (Plik | Drukuj), bez legendy.

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls;

// polecenie z menu Podgl¹d: wybór tygodnia, utworzenie i otwarcie planu
procedure showWeeklySchoolPlan;

// czêœæ nazwy pliku planu tygodniowego zale¿na od tygodnia, np. _2026-03-02_2026-03-08
function  weeklyPlanSuffix(dateFrom, dateTo : TDateTime) : string;
// nazwa pliku planu tygodniowego bez rozszerzenia: nazwa jak w rozk³adzie semestralnym (timetableFileName,
// skracana hashem) + daty tygodnia, np. Pan_Szymanski_Adam_2026-03-02_2026-03-08. Rozk³ad semestralny i plany
// kolejnych tygodni le¿¹ w tym samym folderze i mog¹ siê wzajemnie linkowaæ.
function  weeklyPlanFileName(resType, resId : string; dateFrom, dateTo : TDateTime) : string;

// tworzy plan tygodnia weekId (okres z PERIODS.SUB_PERIOD_PARENT) w pliku fileName (.htm).
// resType: LEC / GRO / ROM / SUB; resCat1: zasób z drugiej kategorii (zak³adka obok sal)
// genForm: TFWWWGenerator do ponownego u¿ycia (zapytanie o zajêcia); nil - tworzony na czas wywo³ania
function  createWeeklySchoolPlan(weekId, resType, resId : string; resCat1 : boolean; fileName : string;
                                 const genForm : TForm = nil) : boolean;

type
  // "PrzejdŸ do planu tygodnia" w grafiku semestralnym (Plik | Drukuj): kolumna siatki semestru (convertGrid) = tydzieñ.
  // columnButton tworzy plan tygodnia kolumny (raz na tydzieñ) w folderze grafiku i zwraca przycisk-link do niego.
  // Okres bez tygodni: tygodnie s¹ tworzone (jak "Utwórz tygodnie").
  TWeekPlanButtons = class
  private
    resType, resId, folder : string;
    genForm : TForm;
    weeks   : array of record
                id        : string;
                num       : integer;
                dateFrom,
                dateTo    : TDateTime;
                button    : string;   // '' = plan jeszcze nie utworzony
              end;
  public
    constructor Create(periodId, aResType, aResId, semesterFileName : string; const aGenForm : TForm = nil);
    function    columnButton(col : integer) : string;
  end;

// style przycisku w grafiku semestralnym (do <style>)
const weekPlanButtonCss =
  'a.weekPlanBtn { display: inline-block; min-width: 15px; padding: 1px 4px; border-radius: 8px;'+
  ' background: #1e3a5f; color: #fff !important; font: 600 9px/1.5 "Segoe UI", Arial, sans-serif;'+
  ' text-decoration: none; white-space: nowrap; box-shadow: 0 1px 2px rgba(15, 23, 42, .25); }'+#13#10+
  'a.weekPlanBtn:hover { background: #c2410c; }'+#13#10+
  '@media print { a.weekPlanBtn { background: none; box-shadow: none; color: #1e3a5f !important; border: 1px solid #1e3a5f; } }';

implementation

uses DM, UFMain, UFSettings, UFLegend, UFWWWGenerator, UUtilities, UUtilityParent, UCommon, UWeekSync;

type
  // podwójne klikniêcie na liœcie tygodni = OK
  TWeekListHandler = class
    procedure listDblClick(Sender : TObject);
  end;

procedure TWeekListHandler.listDblClick(Sender : TObject);
begin
  if TListBox(Sender).ItemIndex >= 0 then TForm(TListBox(Sender).Owner).ModalResult := mrOK;
end;

function oracleDate(s : string) : TDateTime; // 'yyyy-mm-dd'
begin
  result := EncodeDate(StrToInt(Copy(s,1,4)), StrToInt(Copy(s,6,2)), StrToInt(Copy(s,9,2)));
end;

function weeklyPlanSuffix(dateFrom, dateTo : TDateTime) : string;
begin
  result := '_' + FormatDateTime('yyyy-mm-dd', dateFrom) + '_' + FormatDateTime('yyyy-mm-dd', dateTo);
end;

function weeklyPlanFileName(resType, resId : string; dateFrom, dateTo : TDateTime) : string;
begin
  result := timetableFileName(resType, resId);
  if isBlank(result) then result := 'plan';
  result := result + weeklyPlanSuffix(dateFrom, dateTo);
end;

//------------------------------------------------------------------------------------------------
// mini formularz: tygodnie okresu parentId; zwraca ID wybranego tygodnia albo ''
function selectWeek(parentId, currentWeekId : string) : string;
var f       : TForm;
    lbl     : TLabel;
    lb      : TListBox;
    bOk, bCancel : TButton;
    handler : TWeekListHandler;
    ids     : TStringList;
    vis, id, caption : string;
    n, idxCurrent, idxToday, idxVisible : integer;
    dFrom, dTo : TDateTime;
begin
  result  := '';
  ids     := TStringList.Create;
  handler := TWeekListHandler.Create;
  f       := TForm.CreateNew(Application);
  try
    f.Caption      := 'Tygodniowy rozk³ad zajêæ (Plan lekcji)';
    f.BorderStyle  := bsDialog;
    f.Position     := poScreenCenter;
    f.Font.Name    := 'Tahoma';
    f.Font.Size    := 9;
    f.ClientWidth  := 440;
    f.ClientHeight := 420;

    lbl := TLabel.Create(f);
    lbl.Parent  := f;
    lbl.Left    := 14;
    lbl.Top     := 12;
    lbl.Caption := 'Wybierz tydzieñ, dla którego chcesz utworzyæ plan zajêæ:';

    lb := TListBox.Create(f);
    lb.Parent     := f;
    lb.Left       := 14;
    lb.Top        := 34;
    lb.Width      := 412;
    lb.Height     := 332;
    lb.ItemHeight := 18;
    lb.OnDblClick := handler.listDblClick;

    bOk := TButton.Create(f);
    bOk.Parent      := f;
    bOk.Caption     := 'Utwórz plan';
    bOk.Default     := true;
    bOk.ModalResult := mrOK;
    bOk.SetBounds(240, 380, 92, 27);

    bCancel := TButton.Create(f);
    bCancel.Parent      := f;
    bCancel.Caption     := 'Anuluj';
    bCancel.Cancel      := true;
    bCancel.ModalResult := mrCancel;
    bCancel.SetBounds(338, 380, 88, 27);

    idxCurrent := -1;
    idxToday   := -1;
    idxVisible := -1;
    vis := fmain.weekVisibilityPattern(parentId);
    DModule.openSQL('select id, sub_period_num, to_char(date_from,''yyyy-mm-dd''), to_char(date_to,''yyyy-mm-dd'')'+
                    '  from periods where sub_period_parent = '+parentId+' order by sub_period_num');
    while not DModule.QWork.Eof do begin
      id    := DModule.QWork.Fields[0].AsString;
      n     := DModule.QWork.Fields[1].AsInteger;
      dFrom := oracleDate(DModule.QWork.Fields[2].AsString);
      dTo   := oracleDate(DModule.QWork.Fields[3].AsString);
      caption := Format('Tydzieñ %d:   %s – %s', [n, FormatDateTime('dd.mm', dFrom), FormatDateTime('dd.mm.yyyy', dTo)]);
      if not isWeekVisible(vis, n) then caption := caption + '   (niewidoczny)'
      else if idxVisible = -1 then idxVisible := ids.Count;
      if id = currentWeekId then idxCurrent := ids.Count;
      if (Date >= dFrom) and (Date <= dTo) then idxToday := ids.Count;
      ids.Add(id);
      lb.Items.Add(caption);
      DModule.QWork.Next;
    end;
    if lb.Items.Count = 0 then exit;

    // bie¿¹cy tydzieñ (uk³ad tygodnia), tydzieñ z dzisiejsz¹ dat¹, pierwszy widoczny
    if idxCurrent >= 0 then lb.ItemIndex := idxCurrent else
    if idxToday   >= 0 then lb.ItemIndex := idxToday   else
    if idxVisible >= 0 then lb.ItemIndex := idxVisible else lb.ItemIndex := 0;
    f.ActiveControl := lb;

    if (f.ShowModal = mrOK) and (lb.ItemIndex >= 0) then result := ids[lb.ItemIndex];
  finally
    f.Free;
    handler.Free;
    ids.Free;
  end;
end;

//------------------------------------------------------------------------------------------------
// kolor zajêæ wg "Kolorowanie" z Plik | Drukuj (jak DrawRect w UFWWWGenerator)
function lessonColour(const c : TClass_; coloringIndex : shortString) : integer;

  function average(ids : string; kind : char) : integer;
  var t, n : integer;
      sum  : Int64;
  begin
    n := WordCount(ids, [';']);
    if n = 0 then begin result := clRed {brak - jak w wydruku semestralnym}; exit; end;
    sum := 0;
    for t := 1 to n do
      case kind of
        'L': sum := sum + DModule.LecturerGetColour(ExtractWord(t, ids, [';']));
        'G': sum := sum + DModule.GroupGetColour(ExtractWord(t, ids, [';']));
        else sum := sum + DModule.RoomGetColour(ExtractWord(t, ids, [';']));
      end;
    result := sum div n;
  end;

  function descColour(desc : string) : integer;
  begin
    if isBlank(desc) then result := clSilver else result := clRed;
  end;

begin
  if c.FOR_KIND = 'R'               then result := clSilver else
  if coloringIndex = 'L'            then result := average(c.CALC_LEC_IDS, 'L') else
  if coloringIndex = 'G'            then result := average(c.CALC_GRO_IDS, 'G') else
  if coloringIndex = 'S'            then result := c.SUB_COLOUR else
  if coloringIndex = 'F'            then result := c.FOR_COLOUR else
  if coloringIndex = 'OWNER'        then result := c.OWNER_COLOUR else
  if coloringIndex = 'CREATED_BY'   then result := c.CREATOR_COLOUR else
  if coloringIndex = 'CLASS'        then result := c.CLASS_COLOUR else
  if coloringIndex = 'NONE'         then result := clWhite else
  if coloringIndex = 'DESC1'        then result := descColour(c.desc1) else
  if coloringIndex = 'DESC2'        then result := descColour(c.desc2) else
  if coloringIndex = 'DESC3'        then result := descColour(c.desc3) else
  if coloringIndex = 'DESC4'        then result := descColour(c.desc4) else
  if coloringIndex = 'ALL_RES'      then result := average(c.CALC_ROM_IDS, 'R')
  else result := average(ucommon.getResourcesByType(coloringIndex, c.CALC_RESCAT_IDS, c.CALC_ROM_IDS), 'R');
end;

// czytelny tekst na tle colour: ciemny na jasnym, bia³y na ciemnym
function textColourFor(colour : integer) : string;
var rgb : integer;
begin
  rgb := ColorToRGB(colour);
  if (GetRValue(rgb)*299 + GetGValue(rgb)*587 + GetBValue(rgb)*114) div 1000 < 140
    then result := '#ffffff'
    else result := '#1f2937';
end;

function capitalize(s : string) : string;
begin
  result := AnsiUpperCase(Copy(s, 1, 1)) + Copy(s, 2, Length(s));
end;

const planCss =
  '@page { size: A4 landscape; margin: 9mm; }'+#13#10+
  '* { box-sizing: border-box; }'+#13#10+
  'html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }'+#13#10+
  'body { margin: 0; background: #e9edf3; color: #1f2937;'+
        ' font-family: "Segoe UI", "Helvetica Neue", Calibri, Arial, sans-serif; }'+#13#10+
  '.sheet { max-width: 1400px; margin: 28px auto; background: #fff; border-radius: 18px;'+
          ' box-shadow: 0 12px 36px rgba(15, 23, 42, .10); padding: 30px 34px 22px; }'+#13#10+
  '.head { display: flex; justify-content: space-between; align-items: flex-end; gap: 24px;'+
         ' padding-bottom: 16px; margin-bottom: 14px; border-bottom: 3px solid #1e3a5f; }'+#13#10+
  '.title { font-size: 25px; font-weight: 800; letter-spacing: .05em; color: #1e3a5f; text-transform: uppercase; }'+#13#10+
  '.who { margin-top: 6px; font-size: 19px; color: #475569; }'+#13#10+
  '.who b { color: #111827; font-weight: 700; }'+#13#10+
  '.meta { text-align: right; font-size: 12px; color: #64748b; line-height: 1.6; white-space: nowrap; }'+#13#10+
  '.badge { display: inline-block; background: #1e3a5f; color: #fff; border-radius: 999px;'+
          ' padding: 3px 12px; font-weight: 700; font-size: 12px; letter-spacing: .04em; }'+#13#10+
  'table.plan { width: 100%; height: 1px; table-layout: fixed; border-collapse: separate; border-spacing: 6px; }'+#13#10+
  'col.hours { width: 96px; }'+#13#10+
  'thead th { background: #1e3a5f; color: #fff; border-radius: 10px; padding: 9px 6px; font-weight: 600; }'+#13#10+
  'thead th.today { background: #c2410c; }'+#13#10+
  'thead th.corner { background: transparent; color: #94a3b8; font-size: 11px; font-weight: 600;'+
                   ' text-transform: uppercase; letter-spacing: .08em; }'+#13#10+
  'thead .dayname { display: block; font-size: 15px; }'+#13#10+
  'thead .date { display: block; margin-top: 2px; font-size: 12px; font-weight: 400; opacity: .8; }'+#13#10+
  'tbody tr { height: 54px; }'+#13#10+
  'th.hour { background: #f1f5f9; border-radius: 10px; padding: 5px 4px; text-align: center; }'+#13#10+
  'th.hour .no { display: block; font-size: 18px; font-weight: 800; color: #1e3a5f; line-height: 1.1; }'+#13#10+
  'th.hour .time { display: block; margin-top: 2px; font-size: 11px; font-weight: 400; color: #64748b; white-space: nowrap; }'+#13#10+
  'td { height: 100%; padding: 0; border-radius: 10px; text-align: center; vertical-align: middle; }'+#13#10+
  'td.empty { background: #f8fafc; border: 1px dashed #dbe2ea; }'+#13#10+
  'td.lesson, .lessons > div { padding: 7px 6px; line-height: 1.25; overflow-wrap: anywhere;'+
                              ' box-shadow: inset 4px 0 0 rgba(0, 0, 0, .16), 0 1px 3px rgba(15, 23, 42, .14); }'+#13#10+
  '.lessons { display: flex; gap: 4px; height: 100%; }'+#13#10+
  '.lessons > div { flex: 1; min-width: 0; border-radius: 10px; display: flex; align-items: center; justify-content: center; }'+#13#10+
  'td.lesson a, .lessons a { text-decoration: none; }'+#13#10+
  'td.lesson a:hover, .lessons a:hover { text-decoration: underline; }'+#13#10+
  'td.holiday { color: #b91c1c; font-weight: 600; font-size: 13px; letter-spacing: .03em;'+
              ' background: repeating-linear-gradient(135deg, #fef2f2 0 10px, #fde4e4 10px 20px); }'+#13#10+
  'td.outside { background: repeating-linear-gradient(135deg, #f8fafc 0 10px, #eef2f6 10px 20px); }'+#13#10+
  '.note { text-align: center; color: #64748b; font-size: 14px; padding: 10px 0 4px; }'+#13#10+
  '.foot { display: flex; justify-content: space-between; margin-top: 12px; font-size: 11px; color: #94a3b8; }'+#13#10+
  '.foot a { color: inherit; }'+#13#10+
  '@media print {'+#13#10+
  '  body { background: #fff; }'+#13#10+
  '  .sheet { margin: 0; max-width: none; padding: 0; border-radius: 0; box-shadow: none; }'+#13#10+
  '  tbody tr { height: 42px; }'+#13#10+
  '  table.plan { page-break-inside: avoid; }'+#13#10+
  '}';

//------------------------------------------------------------------------------------------------
function createWeeklySchoolPlan(weekId, resType, resId : string; resCat1 : boolean; fileName : string;
                                const genForm : TForm = nil) : boolean;
type TPlanCell = record
       key   : string;   // '' = pusta komórka; kolejne godziny o tym samym kluczu s¹ scalane
       attrs : string;   // atrybuty <td> (bez rowspan)
       body  : string;
     end;
var prefix : string;
    descCodes, sizes : array[0..4] of shortString;
    bolds, links     : array[0..4] of boolean;
    coloringIndex    : shortString;
    hideEmptyRows    : boolean;

    weekFrom, weekTo, monday, d : TDateTime;
    weekNum, hoursPerDay : integer;
    parentId, periodName, resLabel, resName, suffix, showDays : string;

    dayCount : integer;
    dayDate  : array of TDateTime;
    cells    : array of array of TPlanCell; // [dzieñ][godzina 1..hoursPerDay]
    rows     : array of integer;           // widoczne godziny
    skip     : array of integer;           // ile kolejnych wierszy dnia zajmuje ju¿ scalona komórka

    gen          : TFWWWGenerator;
    ownGen       : boolean;
    chart        : tcurrentChartClasses;
    subjectCache : TClassBySubjectCache;  // przedmiot: zajêcia jak w wydruku przedmiotu (UFWWWGeneratorSUB)
    subjectClasses : TClassArray;
    reservations : TReservationsCache;
    classList    : TclassList;
    html         : TStringList;

    i, t, h, r, k, uniqueCnt : integer;
    colour : integer;
    one, all, txt, reserved, lbl, tm, s : string;
    hasClasses : boolean;
    ts : TTimeStamp;

  procedure add(line : string);
  begin
    html.Add(line);
  end;

  function control(name : string) : TComponent;
  begin
    result := FSettings.FindComponent(prefix + name);
    if result = nil then raise Exception.Create('Brak ustawienia wydruku: ' + prefix + name);
  end;

begin
  result := false;

  // ustawienia zawartoœci komórek z Plik | Drukuj - zak³adka wyk³adowcy / grupy / zasobu
  if resType = 'LEC' then prefix := 'L' else
  if resType = 'GRO' then prefix := 'G' else
  if resType = 'SUB' then prefix := 'S' else prefix := 'R';
  for t := 0 to 4 do begin
    descCodes[t] := getCode(TComboBox(control('D'+IntToStr(t+1))));
    sizes[t]     := TEdit(control('S'+IntToStr(t+1))).Text;
    bolds[t]     := TCheckBox(control('B'+IntToStr(t+1))).Checked;
    links[t]     := TCheckBox(control('Link'+IntToStr(t+1))).Checked;
  end;
  coloringIndex := getCode(TComboBox(control('ViewType')));
  hideEmptyRows := TCheckBox(control('HideEmptyRows')).Checked;

  // tydzieñ
  DModule.SingleValue('select to_char(date_from,''yyyy-mm-dd''), to_char(date_to,''yyyy-mm-dd''), hours_per_day,'+
                      '       nvl(sub_period_num,0), sub_period_parent,'+
                      '       show_mon||show_tue||show_wed||show_thu||show_fri||show_sat||show_sun'+
                      '  from periods where id = '+weekId);
  weekFrom    := oracleDate(DModule.QWork.Fields[0].AsString);
  weekTo      := oracleDate(DModule.QWork.Fields[1].AsString);
  hoursPerDay := DModule.QWork.Fields[2].AsInteger;
  weekNum     := DModule.QWork.Fields[3].AsInteger;
  parentId    := DModule.QWork.Fields[4].AsString;
  showDays    := DModule.QWork.Fields[5].AsString;
  periodName  := DModule.SingleValue(sql_PERDESC + iif(parentId <> '', parentId, weekId));

  // kolumny: widoczne dni tygodnia (poniedzia³ek..niedziela), DayOfWeek: 1 = niedziela
  monday := weekFrom - ((DayOfWeek(weekFrom) + 5) mod 7);
  dayCount := 0;
  for t := 0 to 6 do
    if Copy(showDays, t+1, 1) = '+' then begin
      inc(dayCount);
      SetLength(dayDate, dayCount);
      dayDate[dayCount-1] := monday + t;
    end;
  if (dayCount = 0) or (hoursPerDay = 0) then begin
    SError('W ustawieniach okresu nie ma widocznych dni tygodnia albo godzin zajêæ');
    exit;
  end;

  if resType = 'LEC' then begin resLabel := 'Wyk³adowca'; resName := DModule.SingleValue(sql_LECDESC + resId); end else
  if resType = 'GRO' then begin resLabel := 'Grupa';      resName := DModule.SingleValue(sql_GRODESC + resId); end else
  if resType = 'SUB' then begin resLabel := 'Przedmiot';  resName := DModule.SingleValue(sql_SUBDESC + resId); end else
  if resCat1        then begin resLabel := 'Zasób';      resName := DModule.SingleValue(sql_ResCat1DESC + resId); end
                     else begin resLabel := 'Sala';       resName := DModule.SingleValue(sql_ResCat0DESC + resId); end;
  // linki: plany tygodniowe pozosta³ych wyk³adowców / grup / sal z tego samego tygodnia
  suffix := weeklyPlanSuffix(weekFrom, weekTo);

  ownGen       := (genForm = nil) and (resType <> 'SUB');
  if ownGen then gen := TFWWWGenerator.Create(Application)
            else gen := TFWWWGenerator(genForm);
  chart        := nil;
  subjectCache := nil;
  subjectClasses := nil;
  reservations := TReservationsCache.Create;
  html         := TStringList.Create;
  try
    if resType = 'SUB' then begin
      subjectCache := TClassBySubjectCache.Create;
      subjectCache.init;
    end else begin
      // zajêcia razem z obiektami nadrzêdnymi i podrzêdnymi oraz wykluczeniami - jak w wydruku semestralnym
      chart := tcurrentChartClasses.Create;
      chart.init(gen.IcsSQLHolder.Lines.Text, weekId, resId, resType, gen);
    end;
    reservations.ReservationsCacheLoadPeriod(weekId);

    SetLength(cells, dayCount, hoursPerDay + 1);
    hasClasses := false;
    for i := 0 to dayCount-1 do begin
      d := dayDate[i];
      for h := 1 to hoursPerDay do begin
        cells[i][h].key   := '';
        cells[i][h].attrs := 'class="empty"';
        cells[i][h].body  := '';
        if (d < weekFrom) or (d > weekTo) then begin
          cells[i][h].key   := 'OUT';
          cells[i][h].attrs := 'class="outside"';
          continue;
        end;
        ts := DateTimeToTimeStamp(d);
        if subjectCache <> nil then begin
          subjectClasses := subjectCache.GetClasses(ts, h, StrToInt(weekId), resId);
          classList.cnt  := Length(subjectClasses);
          SetLength(classList.classes, classList.cnt);
          for k := 0 to classList.cnt-1 do classList.classes[k] := subjectClasses[k];
        end else
          classList := chart.get(ts, h);
        if classList.cnt > 0 then begin
          hasClasses := true;
          all := '';
          uniqueCnt := 0;
          colour := clWhite;
          txt := '';
          for k := 0 to classList.cnt-1 do begin
            if classList.classes[k].FOR_KIND = 'R'
              then s := XMLescapeChars(classList.classes[k].FOR_abbreviation)
              else s := classCellText(classList.classes[k], descCodes, sizes, bolds, links, suffix);
            colour := lessonColour(classList.classes[k], coloringIndex);
            one := '<div style="background:'+DelphiColourToHTML(ColorToRGB(colour))+';color:'+textColourFor(colour)+'"><span>'+s+'</span></div>';
            if Pos(one, all) = 0 then begin
              all := all + one;
              inc(uniqueCnt);
              txt := s;
            end;
          end;
          cells[i][h].key := 'C' + all;
          if uniqueCnt = 1 then begin
            cells[i][h].attrs := 'class="lesson" style="background:'+DelphiColourToHTML(ColorToRGB(colour))+';color:'+textColourFor(colour)+'"';
            cells[i][h].body  := txt;
          end else begin
            cells[i][h].attrs := 'class="multi"';
            cells[i][h].body  := '<div class="lessons">'+all+'</div>';
          end;
        end else begin
          reserved := reservations.IsReserved(ts, h);  // CLASSES_ALLOWED:TYPE
          if reserved <> '' then begin
            lbl := Trim(Copy(reserved, Pos(':', reserved) + 1, Length(reserved)));
            if (lbl = '') or (UpperCase(lbl) = 'HOLIDAY') then lbl := 'Dzieñ wolny';
            cells[i][h].key   := 'R' + lbl;
            cells[i][h].attrs := 'class="holiday"';
            cells[i][h].body  := XMLescapeChars(lbl);
          end;
        end;
      end;
    end;

    // wiersze: ca³a siatka, albo (Ukryj puste wiersze) tylko godziny z zajêciami
    SetLength(rows, 0);
    for h := 1 to hoursPerDay do begin
      s := '';
      if hideEmptyRows and hasClasses then
        for i := 0 to dayCount-1 do
          if Copy(cells[i][h].key, 1, 1) = 'C' then s := '+';
      if (not hideEmptyRows) or (not hasClasses) or (s = '+') then begin
        SetLength(rows, Length(rows) + 1);
        rows[High(rows)] := h;
      end;
    end;

    add('<!DOCTYPE html>');
    add('<html lang="pl">');
    add('<head>');
    add('<meta charset="utf-8">');
    add('<meta name="viewport" content="width=device-width, initial-scale=1">');
    add('<title>Plan zajêæ - '+XMLescapeChars(resName)+' - '+FormatDateTime('dd.mm.yyyy', weekFrom)+' - '+FormatDateTime('dd.mm.yyyy', weekTo)+'</title>');
    add('<style>');
    add(planCss);
    add('</style>');
    add('</head>');
    add('<body>');
    add('<div class="sheet">');
    add('<div class="head">');
    add('  <div>');
    add('    <div class="title">Plan zajêæ w dniach '+FormatDateTime('dd.mm.yyyy', weekFrom)+' – '+FormatDateTime('dd.mm.yyyy', weekTo)+'</div>');
    add('    <div class="who">'+resLabel+': <b>'+XMLescapeChars(resName)+'</b></div>');
    add('  </div>');
    s := '  <div class="meta">';
    if weekNum > 0 then s := s + '<span class="badge">Tydzieñ '+IntToStr(weekNum)+'</span><br/>';
    add(s + XMLescapeChars(periodName) + '</div>');
    add('</div>');

    add('<table class="plan">');
    add('<colgroup><col class="hours">');
    for i := 0 to dayCount-1 do add('<col>');
    add('</colgroup>');
    add('<thead><tr><th class="corner">Godzina</th>');
    for i := 0 to dayCount-1 do
      add('<th'+iif(Trunc(dayDate[i]) = Date, ' class="today"', '')+'><span class="dayname">'+capitalize(LongDayNames[DayOfWeek(dayDate[i])])+'</span>'+
          '<span class="date">'+FormatDateTime('dd.mm', dayDate[i])+'</span></th>');
    add('</tr></thead>');

    add('<tbody>');
    SetLength(skip, dayCount);
    for i := 0 to dayCount-1 do skip[i] := 0;
    for r := 0 to High(rows) do begin
      h := rows[r];
      lbl := Trim(gridDefinition.getLabel(h));
      tm  := Trim(gridDefinition.hour_from[h]);
      if Trim(gridDefinition.hour_to[h]) <> '' then tm := tm + '–' + Trim(gridDefinition.hour_to[h]);
      if (lbl = '') or (lbl = tm) or (Pos(':', lbl) > 0) then lbl := IntToStr(h); // etykieta = godziny: poka¿ numer
      add('<tr><th class="hour"><span class="no">'+XMLescapeChars(lbl)+'</span><span class="time">'+XMLescapeChars(tm)+'</span></th>');
      for i := 0 to dayCount-1 do begin
        if skip[i] > 0 then begin dec(skip[i]); continue; end;
        // scalanie w pionie: kolejne godziny siatki (bez przerw w ukrytych wierszach) z t¹ sam¹ zawartoœci¹
        k := 1;
        if cells[i][h].key <> '' then
          while (r + k <= High(rows)) and (rows[r+k] = rows[r+k-1] + 1)
                and (cells[i][rows[r+k]].key = cells[i][h].key) do inc(k);
        skip[i] := k - 1;
        add('  <td'+iif(k > 1, ' rowspan="'+IntToStr(k)+'"', '')+' '+cells[i][h].attrs+'>'+cells[i][h].body+'</td>');
      end;
      add('</tr>');
    end;
    add('</tbody>');
    add('</table>');
    if not hasClasses then add('<div class="note">W tym tygodniu nie ma zaplanowanych zajêæ.</div>');

    add('<div class="foot"><span>Data aktualizacji: '+DateTimeToStr(Now())+'</span>'+
        '<span>Dokument utworzony w programie <a href="http://www.plansoft.org">Plansoft.org</a></span></div>');
    add('</div>');
    add('</body>');
    add('</html>');

    html.Text := UTF8Encode(html.Text);
    html.SaveToFile(fileName);
    result := true;
  finally
    html.Free;
    reservations.Free;
    chart.Free;
    subjectCache.Free;
    if ownGen then gen.Free;
  end;
end;

//------------------------------------------------------------------------------------------------
constructor TWeekPlanButtons.Create(periodId, aResType, aResId, semesterFileName : string; const aGenForm : TForm = nil);
var n : integer;
begin
  inherited Create;
  resType := aResType;
  resId   := aResId;
  genForm := aGenForm;
  // folder grafiku: œcie¿ka bywa sklejana z "/" (publikacja)
  folder  := Copy(semesterFileName, 1, LastDelimiter('\/:', semesterFileName));

  if DModule.SingleValue('select count(1) from periods where sub_period_parent = '+periodId) = '0' then
    fmain.createWeeks(periodId);

  DModule.openSQL('select id, sub_period_num, to_char(date_from,''yyyy-mm-dd''), to_char(date_to,''yyyy-mm-dd'')'+
                  '  from periods where sub_period_parent = '+periodId+' order by sub_period_num');
  n := 0;
  while not DModule.QWork.Eof do begin
    SetLength(weeks, n+1);
    weeks[n].id       := DModule.QWork.Fields[0].AsString;
    weeks[n].num      := DModule.QWork.Fields[1].AsInteger;
    weeks[n].dateFrom := oracleDate(DModule.QWork.Fields[2].AsString);
    weeks[n].dateTo   := oracleDate(DModule.QWork.Fields[3].AsString);
    weeks[n].button   := '';
    inc(n);
    DModule.QWork.Next;
  end;
end;

function TWeekPlanButtons.columnButton(col : integer) : string;
var i, w : integer;
    ts : TTimeStamp;
    d : TDateTime;
    fileName : string;
begin
  result := '&nbsp';
  // pierwszy dzieñ kolumny (ColRowDate: Col liczone od 0, w siatce od kolumny 2)
  d := 0;
  for i := 1 to convertGrid.convertSingleObject.Len do
      if convertGrid.convertSingleObject.ColRowDate[i].Col = col - 2 then begin
        ts.Date := convertGrid.convertSingleObject.ColRowDate[i].Date;
        ts.Time := 0;
        d := TimeStampToDateTime(ts);
        break;
      end;
  if d = 0 then exit;

  for w := 0 to High(weeks) do
    if (d >= weeks[w].dateFrom) and (d <= weeks[w].dateTo) then begin
      if weeks[w].button = '' then begin
        fileName := weeklyPlanFileName(resType, resId, weeks[w].dateFrom, weeks[w].dateTo) + '.htm';
        try
          if createWeeklySchoolPlan(weeks[w].id, resType, resId, false, folder + fileName, genForm) then
            weeks[w].button :=
              '<a class="weekPlanBtn" href="'+XMLescapeChars(fileName)+'" title="Plan zajêæ w dniach '+
              FormatDateTime('dd.mm', weeks[w].dateFrom)+' – '+FormatDateTime('dd.mm.yyyy', weeks[w].dateTo)+'">'+
              IntToStr(weeks[w].num)+'</a>'
          else weeks[w].button := '&nbsp';
        except
          // b³¹d planu tygodnia nie mo¿e przerwaæ grafiku semestralnego
          on E : Exception do begin
            fmain.wlog('TWeekPlanButtons: '+fileName+': '+E.Message);
            weeks[w].button := '&nbsp';
          end;
        end;
      end;
      result := weeks[w].button;
      exit;
    end;
end;

//------------------------------------------------------------------------------------------------
procedure showWeeklySchoolPlan;
var resType, resId, parentId, weekId, currentWeekId, fileName : string;
    resCat1 : boolean;
    weekFrom, weekTo : TDateTime;
begin
  if isBlank(fmain.conPeriod.Text) then exit;

  resCat1 := false;
  case fmain.TabViewType.TabIndex of
    0: begin resType := 'LEC'; resId := fmain.conlecturer.Text; end;
    1: begin resType := 'GRO'; resId := fmain.congroup.Text;    end;
    2: begin resType := 'ROM'; resId := fmain.conResCat0.Text;  end;
    3: begin resType := 'ROM'; resId := fmain.conResCat1.Text; resCat1 := true; end;
    5: begin resType := 'SUB'; resId := fmain.consubject.Text;  end;
    else begin
      SError('Tygodniowy rozk³ad zajêæ mo¿na utworzyæ dla wyk³adowcy, grupy, sali albo przedmiotu');
      exit;
    end;
  end;
  resId := Trim(ExtractWord(1, resId, [';'])); // kilka wybranych obiektów: plan pierwszego
  if isBlank(resId) then begin
    SError('Wybierz wyk³adowcê, grupê albo salê, dla której chcesz utworzyæ plan zajêæ');
    exit;
  end;

  // jak Podgl¹d | Uruchom: zapisz zmiany i wczytaj ustawienia wydruku
  FLegend.SaveTimeTableNotes;
  dmodule.CommitTrans;
  FSettings.FormShow(nil);

  // okres tygodniowy: wybór spoœród tygodni jego semestru; semestr: jego tygodnie (brak - tworzone w tle)
  currentWeekId := '';
  parentId := fmain.conPeriod.Text;
  if FSettings.WeeklyView.Checked then begin
    currentWeekId := fmain.conPeriod.Text;
    parentId      := fmain.weekParentPeriodId;
  end;

  if parentId = '' then
    weekId := currentWeekId // tydzieñ bez semestru
  else begin
    if DModule.SingleValue('select count(1) from periods where sub_period_parent = '+parentId) = '0' then begin
      Screen.Cursor := crHourGlass;
      try
        fmain.createWeeks(parentId);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    if DModule.SingleValue('select count(1) from periods where sub_period_parent = '+parentId) = '0' then begin
      SError('Nie mo¿na utworzyæ tygodni dla tego okresu');
      exit;
    end;
    weekId := selectWeek(parentId, currentWeekId);
  end;
  if weekId = '' then exit;

  resetLinkFileNames; // nazwy plików: aktualne nazwy wyk³adowców / grup / sal
  DModule.SingleValue('select to_char(date_from,''yyyy-mm-dd''), to_char(date_to,''yyyy-mm-dd'') from periods where id = '+weekId);
  weekFrom := oracleDate(DModule.QWork.Fields[0].AsString);
  weekTo   := oracleDate(DModule.QWork.Fields[1].AsString);
  fileName := uutilityParent.ApplicationDocumentsPath + weeklyPlanFileName(resType, resId, weekFrom, weekTo) + '.htm';
  if not CanOverwriteFile(fileName) then exit;

  Screen.Cursor := crHourGlass;
  try
    if not createWeeklySchoolPlan(weekId, resType, resId, resCat1, fileName) then exit;
  finally
    Screen.Cursor := crDefault;
  end;
  UUtilityParent.ExecuteFile(fileName, '', '', SW_SHOWMAXIMIZED);
end;

end.
