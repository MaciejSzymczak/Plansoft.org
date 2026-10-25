unit UWeekSync;

// Synchronizacja tygodni (przycisk "Synchronizacja tygodni" w uk³adzie tygodnia).
// Zmiany zajêæ w bie¿¹cym tygodniu s¹ powtarzane w pozosta³ych WIDOCZNYCH tygodniach tego samego okresu:
//   tygodnie okresu   = PERIODS.SUB_PERIOD_PARENT (przycisk "Utwórz tygodnie"),
//   widoczne tygodnie = "Widocznoœæ tygodni" okresu (PERIODS.ATTRIBS_13, tydzieñ nr SUB_PERIOD_NUM).
// Termin w innym tygodniu = ten sam dzieñ tygodnia i ta sama godzina, o ile mieœci siê w zakresie dat tego tygodnia.
// Dni przechowywane s¹ jako TTimeStamp.Date.

interface

uses SysUtils, Classes;

type
  TDayList = array of Integer;

  TWeekSync = class
  private
    FWeekId    : string;      // tydzieñ, dla którego wczytano dane ('' = nie wczytano)
    FWeekFrom  : Integer;     // zakres dat bie¿¹cego tygodnia
    FWeekTo    : Integer;
    FOtherFrom : TDayList;    // pozosta³e widoczne tygodnie okresu: zakresy dat
    FOtherTo   : TDayList;
    FBlocked   : TStringList; // 'dzieñ:godzina' - dzieñ wolny pozosta³ych tygodni, w którym nie wolno planowaæ
    procedure ensureLoaded(weekId : string);
    procedure load(weekId : string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure invalidate;
    function  hasOtherWeeks(weekId : string) : Boolean;
    // ten sam termin w pozosta³ych widocznych tygodniach;
    // skipBlocked: bez terminów, w których dzieñ wolny tygodnia nie pozwala planowaæ zajêæ
    function  otherWeekDays(weekId : string; day, hour : Integer; skipBlocked : Boolean) : TDayList;
    // warunek SQL: column w bie¿¹cym tygodniu lub w jednym z pozosta³ych widocznych tygodni
    function  allWeeksClause(weekId, column : string) : string;
    // dzieñ innego tygodnia -> ten sam dzieñ tygodnia w bie¿¹cym tygodniu
    function  toCurrentWeek(weekId : string; day : Integer) : Integer;
  end;

// "Widocznoœæ tygodni" (ATTRIBS_13) rozwiniêta tak jak w siatce (OmitWeeks w UUtilities.pas): wzorzec powtarzany,
// '-' = tydzieñ ukryty
function expandWeekVisibility(pattern : string) : string;
function isWeekVisible(const expandedPattern : string; weekNum : Integer) : Boolean;

function dayToTimeStamp(day : Integer) : TTimeStamp;
function mondayOf(day : Integer) : Integer;
procedure addDay(var days : TDayList; day : Integer);

implementation

uses DM, UUtilityParent;

function expandWeekVisibility(pattern : string) : string;
begin
  result := pattern;
  if result = '' then result := '+';
  while length(result) < 120 do result := result + result;
end;

function isWeekVisible(const expandedPattern : string; weekNum : Integer) : Boolean;
begin
  result := (weekNum < 1) or (weekNum > length(expandedPattern)) or (expandedPattern[weekNum] <> '-');
end;

function dayToTimeStamp(day : Integer) : TTimeStamp;
begin
  result.Date := day;
  result.Time := 0;
end;

function mondayOf(day : Integer) : Integer;
begin
  // DayOfWeek: niedziela = 1, poniedzia³ek = 2, ...
  result := day - ((DayOfWeek(TimeStampToDateTime(dayToTimeStamp(day))) + 5) mod 7);
end;

procedure addDay(var days : TDayList; day : Integer);
begin
  SetLength(days, Length(days) + 1);
  days[High(days)] := day;
end;

function dayOf(dateTime : TDateTime) : Integer;
begin
  result := DateTimeToTimeStamp(dateTime).Date;
end;

{ TWeekSync }

constructor TWeekSync.Create;
begin
  inherited Create;
  FBlocked := TStringList.Create;
  FBlocked.Sorted     := true;
  FBlocked.Duplicates := dupIgnore;
end;

destructor TWeekSync.Destroy;
begin
  FBlocked.Free;
  inherited Destroy;
end;

procedure TWeekSync.invalidate;
begin
  FWeekId    := '';
  FWeekFrom  := 0;
  FWeekTo    := 0;
  FOtherFrom := nil;
  FOtherTo   := nil;
  FBlocked.Clear;
end;

procedure TWeekSync.ensureLoaded(weekId : string);
begin
  if (FWeekId = '') or (FWeekId <> weekId) then load(weekId);
end;

procedure TWeekSync.load(weekId : string);
var parentId, visibility, otherIds : string;
begin
  invalidate;
  if isBlank(weekId) then exit;
  FWeekId := weekId;

  DModule.SingleValue('select sub_period_parent, date_from, date_to from periods where id = '+weekId);
  parentId  := DModule.QWork.Fields[0].AsString;
  FWeekFrom := dayOf(DModule.QWork.Fields[1].AsDateTime);
  FWeekTo   := dayOf(DModule.QWork.Fields[2].AsDateTime);
  if parentId = '' then exit; // okres nie jest tygodniem utworzonym przez "Utwórz tygodnie"

  visibility := expandWeekVisibility(DModule.SingleValue('select attribs_13 from periods where id = '+parentId));
  otherIds   := '';
  DModule.openSQL('select id, sub_period_num, date_from, date_to from periods'+
                  ' where sub_period_parent = '+parentId+' and id <> '+weekId+' order by sub_period_num');
  while not DModule.QWork.Eof do begin
    if isWeekVisible(visibility, DModule.QWork.Fields[1].AsInteger) then begin
      addDay(FOtherFrom, dayOf(DModule.QWork.Fields[2].AsDateTime));
      addDay(FOtherTo,   dayOf(DModule.QWork.Fields[3].AsDateTime));
      otherIds := merge(otherIds, DModule.QWork.Fields[0].AsString, ',');
    end;
    DModule.QWork.Next;
  end;
  if otherIds = '' then exit;

  // ta sama regu³a co w bie¿¹cym tygodniu (ReservationsCache): w dniu wolnym planowaæ wolno tylko,
  // gdy CLASSES_ALLOWED zaczyna siê od '+'
  DModule.openSQL('select day, hour from holiday_days where per_id in ('+otherIds+')'+
                  ' and nvl(substr(classes_allowed, 1, 1), ''-'') <> ''+''');
  while not DModule.QWork.Eof do begin
    FBlocked.Add(IntToStr(dayOf(DModule.QWork.Fields[0].AsDateTime))+':'+DModule.QWork.Fields[1].AsString);
    DModule.QWork.Next;
  end;
end;

function TWeekSync.hasOtherWeeks(weekId : string) : Boolean;
begin
  ensureLoaded(weekId);
  result := Length(FOtherFrom) > 0;
end;

function TWeekSync.otherWeekDays(weekId : string; day, hour : Integer; skipBlocked : Boolean) : TDayList;
var i, otherDay : Integer;
begin
  result := nil;
  ensureLoaded(weekId);
  for i := 0 to High(FOtherFrom) do begin
    otherDay := day + mondayOf(FOtherFrom[i]) - mondayOf(FWeekFrom);
    if (otherDay < FOtherFrom[i]) or (otherDay > FOtherTo[i]) then continue; // tydzieñ niepe³ny (pocz¹tek/koniec okresu)
    if skipBlocked and (FBlocked.IndexOf(IntToStr(otherDay)+':'+IntToStr(hour)) >= 0) then continue;
    addDay(result, otherDay);
  end;
end;

function TWeekSync.allWeeksClause(weekId, column : string) : string;
var i : Integer;
  function between(dayFrom, dayTo : Integer) : string;
  begin
    result := column+' BETWEEN '+TSDateToOracle(dayToTimeStamp(dayFrom))+' AND '+TSDateToOracle(dayToTimeStamp(dayTo));
  end;
begin
  ensureLoaded(weekId);
  if FWeekId = '' then begin result := '0=1'; exit; end;
  result := between(FWeekFrom, FWeekTo);
  for i := 0 to High(FOtherFrom) do
    result := result + ' OR ' + between(FOtherFrom[i], FOtherTo[i]);
  result := '(' + result + ')';
end;

function TWeekSync.toCurrentWeek(weekId : string; day : Integer) : Integer;
begin
  ensureLoaded(weekId);
  result := day - (mondayOf(day) - mondayOf(FWeekFrom));
end;

end.
