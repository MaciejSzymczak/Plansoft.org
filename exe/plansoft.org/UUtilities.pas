unit UUtilities;

{$R-}

interface

Uses SysUtils, DM, UUtilityParent, grids, Windows, rxStrUtils, stdctrls, UFWarning, UFMain;

Const convOutOfRange   = 0;
      ConvHeader       = 1;
      ConvClass        = 2;
      ConvDayOfWeek    = 3;
      ConvNumeryZajec  = 4;

      crossTableViewObjNames    = 5;
      crossTableViewDayOfWeek   = 6;

Type TConvertSingleObject = object
      Len                : Integer;
      Date,Day,_Row,_Col : Integer;
      TimeStamp          : TTimeStamp;
      DateTime           : TDateTime;
      MaxIloscGodzin     : Integer;
      ColRowDate : Array Of Record
               Col, Row, Date : Integer;
             End;
      public
      Procedure Init(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean);
      Function  DateToColRow(_Date, _Hour : Integer; var Col, Row : Integer) : Boolean;
      Function  ColRowToDate(var _Date : TTimeStamp; var _Hour : Integer;Col, Row : Integer) : Integer;
     End;

Type TConvertManyObjects = class
      Len              : Integer;
      Date,Day,_Col    : Integer;
      TimeStamp        : TTimeStamp;
      DateTime         : TDateTime;
      MaxIloscGodzin   : Integer;
      currentObjName   : string;
      ObjectIds : Array Of Record
                               id : Integer;
                               name  : string[100];
                              End;
      ColDate : Array Of Record
                       Col
                      ,Date : Integer;
                      End;
      public
      Procedure init(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean; ObjIds : Array of integer; ObjNames : Array of string);
      //Function  dateObjToColRow(_Date, _Hour, _objId : Integer; var Col, Row : Integer) : Boolean;
      Function  colRowToDate(var objId : integer; var _Date : TTimeStamp; var _Hour : Integer;Col, Row : Integer) : Integer;
     End;

Const ConvSingleObject     = 1;
      ConvManyObjects      = 2;

type TConvertGrid = class
       convertMode          : integer;
       convertSingleObject  : TConvertSingleObject;
       convertManyObjects   : TConvertManyObjects;
       procedure setupGrid (periodId : String; singleChartMode: boolean; resType : integer; searchText: String; var pcolCnt, prowCnt : integer);
       Function  ColRowToDate(var objId : integer; var _Date : TTimeStamp; var _Hour : Integer;Col, Row : Integer) : Integer;
       Function  DateToColRow(var objId : integer; _Date, _Hour : Integer; var Col, Row : Integer) : Boolean;

       private
         Procedure initNOsingleChartMode(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean; ObjIds : Array of integer; ObjNames : Array of string);
         Procedure initSingleChartMode(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean);
     end;

     TGridDefinition = class
      no        : Array[1..dm.maxHours] Of String[20];
      hour_from : Array[1..dm.maxHours] Of String[20];
      hour_to   : Array[1..dm.maxHours] Of String[20];
      Procedure internalCreate(gridCustomLabels : tgridCustomLabels);
      Function getLabel(i : Integer) : String;
      function hourNumberToHourFromTo( hour, fill : integer; var hh1, mm1, hh2, mm2 : integer) : boolean;
     End;


Type TSingleClass = Record
                      Day        : TTimeStamp;
                      Hour       : integer;
                      fill       : integer;
                      colour     : integer;
                      Lecturers  : TPointers;
                      Groups     : TPointers;
                      Rooms      : TPointers;
                      Sub_id     : integer;
                      For_id     : integer;
                      Created_by : String[30];
                      _Owner     : String[255];
                      desc1      : string[255];
                      desc2      : string[255];
                      desc3      : string[255];
                      desc4      : string[255];
                      conflictReason: string[255];
                    End;

Type TCheckConflicts = Class
           NewClassWithChilds : TSingleClass;
           NewClassToCreate : TSingleClass;
           ConflictsClasses : Array[1..40] Of TSingleClass;
           Count            : Integer;
           Completion       : Boolean;
           CanDelete        : Boolean;
           currentClassId   : Integer;

           private
             procedure internalCreate(
               Day : TTimeStamp;
               Hour, fill, colour : Integer;
               Lecturers : TPointers;
               Groups: TPointers;
               Rooms: TPointers;
               LecturersWithChilds : TPointers;
               GroupsWithChilds: TPointers;
               RoomsWithChilds: TPointers;
               Sub_id, For_id : Integer; Created_by, _Owner, desc1, desc2, desc3, desc4 : String);
             procedure add(Day : TTimeStamp; Hour : Integer; Lecturers : TPointers; Groups: TPointers; Rooms: TPointers; Sub_id , For_id : Integer; Created_by, _Owner, conflictReason : String);
             function  deleteConflictClasses : Boolean;
           public
             function  conflictsReport(
               Day : TTimeStamp;
               Hour : Integer;
               acurrentClassId : Integer;
               Lecturers : TPointers;
               Groups: TPointers;
               Rooms: TPointers;
               LecturersWithChilds : TPointers;
               GroupsWithChilds: TPointers;
               RoomsWithChilds: TPointers;
               Sub_id , For_id , Res, aNewClassFill, aColour : integer; aCreated_by, aOwner, adesc1, adesc2, adesc3, adesc4 : String ) : Boolean;
             procedure getDesc(SGNewClass, SGConflicts : TStringGrid; L : TLabel; var dataStamp : String);
             function  empty : Boolean;
             function  checkConflictsInsert ( ttCombIds        : string ) : Boolean;
         End;

Var
    CheckConflicts : TCheckConflicts;
    convertGrid           : tConvertGrid;
    gridDefinition       : tGridDefinition;



function getChildsAndParents (KeyValues : string; resultString : string; addKeyValue : boolean; ignoreExclusiveParent : boolean) : string;
function getExcludedResources (Ids : string; colName : string) : string;

Function GetCLASSESforL  (colname, condition : String; const postfix : String = ''; const mode : shortstring = 'e' ) : String;
Function GetCLASSESforG  (colname, condition : String; const postfix : String = ''; const mode : shortstring = 'e' ) : String;
Function GetCLASSESforR  (colname, condition : String; const postfix : String = ''; const mode : shortstring = 'e' ) : String;
Function GetCLASSESforPLA(ID : ShortString ) : String;

Function NumToDayOfWeek(L : Integer) : String;
Function GetDate(Date : integer) : String;
Function GetDay(Date : integer) : String;
Function GetLongMonthName(Date : integer) : String;

// API do wstawiania, usuwania zajecia, oraz sprawdzenia, czy mozna zajecie wstawic nie powodujac konfliktow
// Nie przejmuj sie tym, ze pomiedzy sprawdzeniem, czy mozna wstawic zajecie, a wstawieniem inny uzytkownik wstawi zajecie
// Wowczas wiezy integralnosci bazy danych nie pozwola na wstawienie zajecia
// pamietaj, ze po wykonaniu wstawienia lub usuniecia zajecia, aby zmiany byly widoczne nalezy
// wykonac polecenie grid.refresh, a dodatkowo, zeby odswiezyc legende wykonaj RefreshClassCounterInLegend
// funkcja canInsertClass jest uproszczona wersja procedury standardowej, uzywanej podczas planowania za pomoca myszy.
// dzieki uproszczeniom dziala ona znacznie szybciej, ale nie uwzglednia ona doplanowania (pojecie doplanowania wyjasniono w podreczniku uzytkowniku w rozdziale definicje)
// nie wyswietla ona rowniez szczegolowego komunikatu
 // cla_id to id biezacego zajecia ( chodzi o to, zeby nie sprawdzac konfliku z samym soba )
function canInsertClass (
             theClass : TClass_;
             cla_id : integer;
             var resultMessage : string;
             const fastCheck : boolean = false //omits some optional checks. Thus it is faster. Database will examine this checks when insertClass in involved
         ) : boolean;
function planner_utils_insert_classes ( myClass : TClass_; pttCombIds : string; const currentClassId : integer =-1 ) : boolean;
function deleteClass(Class_ : TClass_; const currentClassId : integer =-1) : Boolean;
Procedure DeleteOrphanedClasses;

procedure importPreviousGridSettings;

function isOwner(classOwners : String): boolean;
function isOwnerSupervisor(classOwners : String): boolean;

function LROR (S : String; WordDelim : Char) : String;

// quickInsertMode disables the clear cache and this speeds up the insertion.
// once enabled remember to finalize the operation by Fmain.DeepRefresh(nil);
var quickInsertMode : boolean;


implementation

Uses UFProgramSettings, StrUtils;

function LROR (S : String; WordDelim : Char) : String;
Var Buffer : Array of String;
    count, t : integer;
Begin
  result := S;

  count := WordCount(S,[WordDelim]);
  if count <=1 then exit;
  SetLength(Buffer,count);
  for t := 1 to count do
   Buffer[t-1] := ExtractWord(t,S,[WordDelim]);

  result := '';
  for t := 2 to count do
   result := merge(result,Buffer[t-1],';');
  result :=  merge(result,Buffer[1-1],';');
End;

function getExcludedResources (Ids : string; colName : string) : string;
var resultString : string;
begin
  try
    resultString :=  DModule.SingleValue('select planner_utils.get_excluded_res_ids(''' +Ids+ ''') result from dual');
    if (resultString='') then result := '' else result := colName+' in ('+ resultString +')';
  except
    on E:exception do
      //not installed feature
      result := '';
  End;
end;




function getChildsAndParents (KeyValues : string; resultString : string; addKeyValue : boolean; ignoreExclusiveParent : boolean) : string;
var t : integer;
    KeyValue : string;
    sql : string;
    exclParent : string;
begin
  exclParent := '';
  if ignoreExclusiveParent then exclParent := 'and exclusive_parent=''-''';

  sql :=
  //parents
  'select unique id from'+cr+
  '('+cr+
  'select parent_id id'+cr+
  '  from str_elems_v'+cr+
  '  where level=1 and STR_NAME_LOV=''STREAM'''+exclParent+cr+
  '  CONNECT BY PRIOR STR_NAME_LOV=''STREAM'' and prior parent_id = child_id'+cr+
  '  start with child_id=:id1'+cr+
  'union'+cr+
  //childs
  'select child_id id'+cr+
  '  from str_elems_v'+cr+
  '  where level=1 and STR_NAME_LOV=''STREAM'''+exclParent+cr+        //!!bookmark!!
  '  CONNECT BY PRIOR STR_NAME_LOV=''STREAM'' and prior child_id = parent_id'+cr+
  '  start with parent_id=:id2'+cr+
  ')';

   for t := 1 to wordCount(KeyValues, [';']) do begin
     KeyValue := extractWord(t,KeyValues, [';']);
     if (addKeyValue) and (not ExistsValue(resultString, [';'], KeyValue)) then resultString :=  Merge(KeyValue, resultString, ';');
     //add childs and parents as well
     dmodule.OpenSQL(sql,'id1='+KeyValue+';id2='+KeyValue);
     with dmodule.QWork do begin
       first;
       while not Eof do begin
         if not ExistsValue(resultString, [';'], FieldByName('Id').AsString) then
           resultString :=  Merge(resultString, FieldByName('Id').AsString, ';');
          next;
        end;
     end;
   end;

  //set keyValue as current value
  KeyValue := extractWord(1,KeyValues, [';']);
  if (ExistsValue(resultString, [';'], KeyValue)) and (KeyValue <>  extractWord(1,resultString, [';'])) then
   repeat
     resultString := LROR(resultString,';');
   until extractWord(1,resultString, [';']) = KeyValue;

  result := resultString;
end;

procedure importPreviousGridSettings;
var pnos, phours_from, phours_to : array of string;
    t : integer;
begin
  t := 0;
  SetLength(pnos,60);
  pnos[t] := GetSystemParam('LESSON_NO1'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO2'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO3'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO4'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO5'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO6'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO7'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO8'); inc(t);
  pnos[t] := GetSystemParam('LESSON_NO9'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N10'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N11'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N12'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N13'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N14'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N15'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N16'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N17'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N18'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N19'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N20'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N21'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N22'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N23'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N24'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N25'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N26'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N27'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N28'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N29'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N30'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N31'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N32'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N33'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N34'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N35'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N36'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N37'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N38'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N39'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N40'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N41'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N42'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N43'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N44'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N45'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N46'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N47'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N48'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N49'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N50'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N51'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N52'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N53'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N54'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N55'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N56'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N57'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N58'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N59'); inc(t);
  pnos[t] := GetSystemParam('LESSON_N60'); 

 SetLength(phours_from,60);
 phours_from[0] :=getSystemParam('LESSON_HFROM1');
 phours_from[1] :=getSystemParam('LESSON_HFROM2');
 phours_from[2] :=getSystemParam('LESSON_HFROM3');
 phours_from[3] :=getSystemParam('LESSON_HFROM4');
 phours_from[4] :=getSystemParam('LESSON_HFROM5');
 phours_from[5] :=getSystemParam('LESSON_HFROM6');
 phours_from[6] :=getSystemParam('LESSON_HFROM7');
 phours_from[7] :=getSystemParam('LESSON_HFROM8');
 phours_from[8] :=getSystemParam('LESSON_HFROM9');
 phours_from[9] :=getSystemParam('LESSON_HFROM10');
 phours_from[10] :=getSystemParam('LESSON_HFROM11');
 phours_from[11] :=getSystemParam('LESSON_HFROM12');
 phours_from[12] :=getSystemParam('LESSON_HFROM13');
 phours_from[13] :=getSystemParam('LESSON_HFROM14');
 phours_from[14] :=getSystemParam('LESSON_HFROM15');
 phours_from[15] :=getSystemParam('LESSON_HFROM16');
 phours_from[16] :=getSystemParam('LESSON_HFROM17');
 phours_from[17] :=getSystemParam('LESSON_HFROM18');
 phours_from[18] :=getSystemParam('LESSON_HFROM19');
 phours_from[19] :=getSystemParam('LESSON_HFROM20');
 phours_from[20] :=getSystemParam('LESSON_HFROM21');
 phours_from[21] :=getSystemParam('LESSON_HFROM22');
 phours_from[22] :=getSystemParam('LESSON_HFROM23');
 phours_from[23] :=getSystemParam('LESSON_HFROM24');
 phours_from[24] :=getSystemParam('LESSON_HFROM25');
 phours_from[25] :=getSystemParam('LESSON_HFROM26');
 phours_from[26] :=getSystemParam('LESSON_HFROM27');
 phours_from[27] :=getSystemParam('LESSON_HFROM28');
 phours_from[28] :=getSystemParam('LESSON_HFROM29');
 phours_from[29] :=getSystemParam('LESSON_HFROM30');
 phours_from[30] :=getSystemParam('LESSON_HFROM31');
 phours_from[31] :=getSystemParam('LESSON_HFROM32');
 phours_from[32] :=getSystemParam('LESSON_HFROM33');
 phours_from[33] :=getSystemParam('LESSON_HFROM34');
 phours_from[34] :=getSystemParam('LESSON_HFROM35');
 phours_from[35] :=getSystemParam('LESSON_HFROM36');
 phours_from[36] :=getSystemParam('LESSON_HFROM37');
 phours_from[37] :=getSystemParam('LESSON_HFROM38');
 phours_from[38] :=getSystemParam('LESSON_HFROM39');
 phours_from[39] :=getSystemParam('LESSON_HFROM40');
 phours_from[40] :=getSystemParam('LESSON_HFROM41');
 phours_from[41] :=getSystemParam('LESSON_HFROM42');
 phours_from[42] :=getSystemParam('LESSON_HFROM43');
 phours_from[43] :=getSystemParam('LESSON_HFROM44');
 phours_from[44] :=getSystemParam('LESSON_HFROM45');
 phours_from[45] :=getSystemParam('LESSON_HFROM46');
 phours_from[46] :=getSystemParam('LESSON_HFROM47');
 phours_from[47] :=getSystemParam('LESSON_HFROM48');
 phours_from[48] :=getSystemParam('LESSON_HFROM49');
 phours_from[49] :=getSystemParam('LESSON_HFROM50');
 phours_from[50] :=getSystemParam('LESSON_HFROM51');
 phours_from[51] :=getSystemParam('LESSON_HFROM52');
 phours_from[52] :=getSystemParam('LESSON_HFROM53');
 phours_from[53] :=getSystemParam('LESSON_HFROM54');
 phours_from[54] :=getSystemParam('LESSON_HFROM55');
 phours_from[55] :=getSystemParam('LESSON_HFROM56');
 phours_from[56] :=getSystemParam('LESSON_HFROM57');
 phours_from[57] :=getSystemParam('LESSON_HFROM58');
 phours_from[58] :=getSystemParam('LESSON_HFROM59');
 phours_from[59] :=getSystemParam('LESSON_HFROM60');

 SetLength(phours_to,60);
 phours_to[0] :=getSystemParam('LESSON_HTO1');
 phours_to[1] :=getSystemParam('LESSON_HTO2');
 phours_to[2] :=getSystemParam('LESSON_HTO3');
 phours_to[3] :=getSystemParam('LESSON_HTO4');
 phours_to[4] :=getSystemParam('LESSON_HTO5');
 phours_to[5] :=getSystemParam('LESSON_HTO6');
 phours_to[6] :=getSystemParam('LESSON_HTO7');
 phours_to[7] :=getSystemParam('LESSON_HTO8');
 phours_to[8] :=getSystemParam('LESSON_HTO9');
 phours_to[9] :=getSystemParam('LESSON_HTO10');
 phours_to[10] :=getSystemParam('LESSON_HTO11');
 phours_to[11] :=getSystemParam('LESSON_HTO12');
 phours_to[12] :=getSystemParam('LESSON_HTO13');
 phours_to[13] :=getSystemParam('LESSON_HTO14');
 phours_to[14] :=getSystemParam('LESSON_HTO15');
 phours_to[15] :=getSystemParam('LESSON_HTO16');
 phours_to[16] :=getSystemParam('LESSON_HTO17');
 phours_to[17] :=getSystemParam('LESSON_HTO18');
 phours_to[18] :=getSystemParam('LESSON_HTO19');
 phours_to[19] :=getSystemParam('LESSON_HTO20');
 phours_to[20] :=getSystemParam('LESSON_HTO21');
 phours_to[21] :=getSystemParam('LESSON_HTO22');
 phours_to[22] :=getSystemParam('LESSON_HTO23');
 phours_to[23] :=getSystemParam('LESSON_HTO24');
 phours_to[24] :=getSystemParam('LESSON_HTO25');
 phours_to[25] :=getSystemParam('LESSON_HTO26');
 phours_to[26] :=getSystemParam('LESSON_HTO27');
 phours_to[27] :=getSystemParam('LESSON_HTO28');
 phours_to[28] :=getSystemParam('LESSON_HTO29');
 phours_to[29] :=getSystemParam('LESSON_HTO30');
 phours_to[30] :=getSystemParam('LESSON_HTO31');
 phours_to[31] :=getSystemParam('LESSON_HTO32');
 phours_to[32] :=getSystemParam('LESSON_HTO33');
 phours_to[33] :=getSystemParam('LESSON_HTO34');
 phours_to[34] :=getSystemParam('LESSON_HTO35');
 phours_to[35] :=getSystemParam('LESSON_HTO36');
 phours_to[36] :=getSystemParam('LESSON_HTO37');
 phours_to[37] :=getSystemParam('LESSON_HTO38');
 phours_to[38] :=getSystemParam('LESSON_HTO39');
 phours_to[39] :=getSystemParam('LESSON_HTO40');
 phours_to[40] :=getSystemParam('LESSON_HTO41');
 phours_to[41] :=getSystemParam('LESSON_HTO42');
 phours_to[42] :=getSystemParam('LESSON_HTO43');
 phours_to[43] :=getSystemParam('LESSON_HTO44');
 phours_to[44] :=getSystemParam('LESSON_HTO45');
 phours_to[45] :=getSystemParam('LESSON_HTO46');
 phours_to[46] :=getSystemParam('LESSON_HTO47');
 phours_to[47] :=getSystemParam('LESSON_HTO48');
 phours_to[48] :=getSystemParam('LESSON_HTO49');
 phours_to[49] :=getSystemParam('LESSON_HTO50');
 phours_to[50] :=getSystemParam('LESSON_HTO51');
 phours_to[51] :=getSystemParam('LESSON_HTO52');
 phours_to[52] :=getSystemParam('LESSON_HTO53');
 phours_to[53] :=getSystemParam('LESSON_HTO54');
 phours_to[54] :=getSystemParam('LESSON_HTO55');
 phours_to[55] :=getSystemParam('LESSON_HTO56');
 phours_to[56] :=getSystemParam('LESSON_HTO57');
 phours_to[57] :=getSystemParam('LESSON_HTO58');
 phours_to[58] :=getSystemParam('LESSON_HTO59');
 phours_to[59] :=getSystemParam('LESSON_HTO60');
 dmodule.generateGrid ( pnos, phours_from, phours_to );
end;

Procedure TGridDefinition.internalCreate;
var t : integer;
Begin
 for t:= 1 to dm.maxHours do
   no[ t] := '';

 dmodule.openSQL('select no, caption, hour_from, hour_to from grids order by 1');
 with dmodule.QWork do begin
  while not eof do begin
    if (fields[0].AsInteger <= dm.maxHours) and (fields[0].AsInteger >= 1) then begin
      no       [ fields[0].AsInteger ] :=  nvl( gridCustomLabels[fields[0].AsInteger],  fields[1].AsString );
      hour_from[ fields[0].AsInteger ] :=  fields[2].AsString;
      hour_to  [ fields[0].AsInteger ] :=  fields[3].AsString;
    end;
    next;
  end;
 end;

End;

Function TGridDefinition.getLabel(i : Integer) : String;
Begin
 Result := no[i];
End;

function TGridDefinition.hourNumberToHourFromTo(hour, fill: integer; var hh1, mm1, hh2, mm2: integer) : boolean;
var interval : integer;
  //--
  procedure addMinutes(hh1,mm1,interval : integer; var hh2,mm2 : integer);
  begin
    hh2 := (mm1 + interval + hh1*60) div 60;
    mm2 := (mm1 + interval + hh1*60) - hh2*60;
    hh2 := hh2 mod 24;
  end;
  //--
begin
  try
    hh1 := strtoint( copy(hour_from[hour],1,2) );
    mm1 := strtoint( copy(hour_from[hour],4,2) );
    hh2 := strtoint( copy(hour_to[hour],1,2) );
    mm2 := strtoint( copy(hour_to[hour],4,2) );
    interval := round((hh2*60+mm2-hh1*60-mm1)*fill/100);
    addMinutes(hh1,mm1,interval,hh2,mm2);
    result := true;
  except
    result := false;
  end;
end;


Const Modulo = 2;

Procedure TConvertSingleObject.Init(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean);

  Procedure OmitDays(Var Date : Integer);
   Var Changed : Boolean;
       fuse    : Integer;
  Begin
    //If DayOfWeek(Date) = 1 Then Date := Date + 1;
    fuse := 0;

    Repeat
     inc(fuse);
     Changed := False;
     TimeStamp.Date := Date;
     TimeStamp.Time := 0;
     DateTime := TimeStampToDateTime(TimeStamp);
     day := DayOfWeek(DateTime);

     If day = 2 Then If Not SHOW_MON Then Begin Date := Date + 1; Changed := True; End;
     If day = 3 Then If Not SHOW_TUE Then Begin Date := Date + 1; Changed := True; End;
     If day = 4 Then If Not SHOW_WED Then Begin Date := Date + 1; Changed := True; End;
     If day = 5 Then If Not SHOW_THU Then Begin Date := Date + 1; Changed := True; End;
     If day = 6 Then If Not SHOW_FRI Then Begin Date := Date + 1; Changed := True; End;
     If day = 7 Then If Not SHOW_SAT Then Begin Date := Date + 1; Changed := True; End;
     If day = 1 Then If Not SHOW_SUN Then Begin Date := Date + 1; Changed := True; End;
     If fuse = 8 Then Begin SError('Semestr musi zawieraæ przynajmniej jeden dzieñ'); dmodule.CloseDBConnection (true); halt; End;
    Until Changed = False;
  End;

Var StartRows : Array[1..7] Of Integer;
    StartRow  : Integer;

Begin
 SetLength(ColRowDate, EndDate - StartDate + 2 );       // inicjuje dlugosc tabeli dynamicznej ...
 // +2 poniewaz: +1 - bo uzywam elementow poczawszy od pierwszego a nie zerowego
 //              +1 - bo dla enddate = start date powinienem uzyskac 1
 // gdy niektore dni tygodnia nie sa uzywane ( np. zajecia w soboty i niedziele ), do liczba elementow tabeli jest za duza, mniejsza z tym

 MaxIloscGodzin := aMaxIloscGodzin;
 Len := 0;

 Date := StartDate;
 OmitDays(Date);

 TimeStamp.Date := Date;
 TimeStamp.Time := 0;
 DateTime := TimeStampToDateTime(TimeStamp);
 day := DayOfWeek(DateTime);

 StartRow := 0;
 If SHOW_MON Then Begin StartRows[2] := StartRow; Inc(StartRow); End;
 If SHOW_TUE Then Begin StartRows[3] := StartRow; Inc(StartRow); End;
 If SHOW_WED Then Begin StartRows[4] := StartRow; Inc(StartRow); End;
 If SHOW_THU Then Begin StartRows[5] := StartRow; Inc(StartRow); End;
 If SHOW_FRI Then Begin StartRows[6] := StartRow; Inc(StartRow); End;
 If SHOW_SAT Then Begin StartRows[7] := StartRow; Inc(StartRow); End;
 If SHOW_SUN Then Begin StartRows[1] := StartRow; Inc(StartRow); End;
 _Row := StartRows[Day];

 {Case day Of
  2:_Row := 0; //Mon
  3:_Row := 1; //Tue
  4:_Row := 2; //Wed
  5:_Row := 3; //Thu
  6:_Row := 4; //Fri
  7:_Row := 5; //Sat
  1:_Row := 6; //Sun
 End;}
  _Col := 0;
 Repeat
  Len := Len + 1;

  //info(inttostr(len) + ' ' +  intToStr( Date ) + ' ' + intToStr( startDate ) + ' ' + intToStr( endDate ) + ' ' + intToStr( startDate - endDate ) + ' ' + intToStr(Date - EndDate));

  if Len > high(ColRowDate) then begin
    SError('1.Wyst¹pi³o zdarzenie "4 Liczba dni poza zakresem". Zg³oœ problem serwisowi. Len =' + intToStr(len) + ' high(data)=' + intToStr(high(ColRowDate)) );
    dmodule.CloseDBConnection (true);
    halt;
  end;

  ColRowDate[Len].Col  := _Col;
  ColRowDate[Len].Row  := _Row * (MaxIloscGodzin+1);
  ColRowDate[Len].Date := Date;

  Date := Date + 1;
  OmitDays(Date);

  _Row := _Row + 1;

  LiczbaKolumn := _Col+1+Modulo;

  If _Row=StartRow Then
   Begin
    _Row := 0;
    _Col := _Col +1;
   End;
 Until Date > EndDate;

  //DateToColRow(EndDate, MaxIloscGodzin,Col,Row);

  LiczbaWierszy := StartRow * (MaxIloscGodzin + 1 );
  {If SobotyiNiedziele Then LiczbaWierszy := 7 * (MaxIloscGodzin + 1 )
                      Else LiczbaWierszy := 5 * (MaxIloscGodzin + 1 );}
End;

Function  TConvertSingleObject.DateToColRow(_Date, _Hour : Integer; var Col, Row : Integer) : Boolean;
var i : integer;
begin
  result := false;
  len := high(convertGrid.convertSingleObject.ColRowDate);
  i := 1;
  While (i<=Len) And  (Not((ColRowDate[i].Date=_Date) )) Do begin
    i := i + 1;
  End;

  if (i<=Len) then begin
    Col := ColRowDate[i].Col+2;
    Row := ColRowDate[i].Row+1;
    result := true;
  end;

end;


{
2024.10.18 not tested, may be correct
Function  TConvertSingleObject.DateToColRow(_Date, _Hour : Integer; var Col, Row : Integer) : Boolean;
Var i : Integer;
Begin
 i := 1;
 While (i<=Len) And (Data[i].Date<>_Date) Do
  Begin
   i := i + 1;
  End;
 If i>Len Then DateToColRow := False
 Else
  If Data[i].Date=_Date Then
   Begin
    Col := Data[i].Col;
    Row := Data[i].Row + _Hour;
    DateToColRow := True;
   End;
   Col := Col + modulo;
End;
}

Function  TConvertSingleObject.ColRowToDate;
Var i : Integer;
    _D : Integer;
Begin
 Col := Col - Modulo;
 _Hour := Row mod (MaxIloscGodzin+1);
 Row := (Row Div (MaxIloscGodzin+1))*(MaxIloscGodzin+1);
 i := 1;
 While (i<=Len) And  (Not((ColRowDate[i].Col=Col) And (ColRowDate[i].Row=Row))) Do i := i + 1;
 If i>Len Then
  Begin
   Case Col+2 OF
    0:Begin
       Result := ConvDayOfWeek;
       i := 1;
       While (i<=Len) And  (Not((ColRowDate[i].Row=Row))) Do i := i + 1;
       If i > Len Then Begin
        _Date.Date := -1;
        _Date.Time := 0;
       End
       Else Begin
        _D := ColRowDate[i].Date;
        _Date.Date := _D;
        _Date.Time := 0;
       End;
      End;
    1:Result := ConvNumeryZajec;
    Else Result := convOutOfRange;
   End;
   Exit;
  End
 Else
  If (ColRowDate[i].Col=Col) And (ColRowDate[i].Row=Row) Then
   Begin
    _D := ColRowDate[i].Date;
    _Date.Date := _D;
    _Date.Time := 0;
   End;
 If _Hour = 0 Then Result := ConvHeader
              Else Result := ConvClass;
End;

Function NumToDayOfWeek(L : Integer) : String;
//funkcja zwraca krótk¹ nazwê dnia w zal. od 0..6 = Pon..Niedz
Begin
 L := L + 2;
 If L=8 Then L := 1;
 NumToDayOfWeek := ShortDayNames[L];
End;

function IntToRoman(Value: LongInt): String;
const
Arabics: Array[1..13] of Integer = (1,4,5,9,10,40,50,90,100,400,500,900,1000) ;
Romans: Array[1..13] of String = ('I','IV','V','IX','X','XL','L','XC','C','CD','D','CM','M') ;
var
   j: Integer;
begin
  for j := 13 downto 1 do
  while (Value >= Arabics[j]) do begin
   Value := Value - Arabics[j];
   Result := Result + Romans[j];
  end;
end;

Function GetDate(Date : integer) : String;
Var TimeStamp : TTimeStamp;
    Year, Month, Day : Word;
Begin
 TimeStamp.Time := 0;
 TimeStamp.Date := Date;
 try
 DecodeDate(TimeStampToDateTime(TimeStamp),Year, Month, Day);
 except
 end;
 //GetDate := rxStrUtils.AddChar('0',IntToStr(Day),2) + '.' + rxStrUtils.AddChar('0',IntToStr(Month),2);
 GetDate := rxStrUtils.AddChar('0',IntToStr(Day),2) + ' ' + intToRoman ( Month );
End;

Function getDay(Date : integer) : String;
Var TimeStamp : TTimeStamp;
    Year, Month, Day : Word;
Begin
 TimeStamp.Time := 0;
 TimeStamp.Date := Date;
 try
 DecodeDate(TimeStampToDateTime(TimeStamp),Year, Month, Day);
 except
 end;
 Result := rxStrUtils.AddChar('0',IntToStr(Day),2);
End;

Function GetLongMonthName(Date : integer) : String;
Var TimeStamp : TTimeStamp;
    Year, Month, Day : Word;
Begin
 TimeStamp.Time := 0;
 TimeStamp.Date := Date;
 try
 DecodeDate(TimeStampToDateTime(TimeStamp),Year, Month, Day);
 except
 end;
 Result := LongMonthNames[Month];
End;

Procedure SortDesc(Var Pointers : TPointers);

  Function Max(I : Integer) : Integer;
  Var CurrentMin : Integer;
      CurrentW   : Integer;
      T          : Integer;
  Begin
   CurrentMin := I;
   CurrentW   := -1;
   For T:=I To maxInClass Do
   Begin
    If  Pointers[t]>CurrentW Then
     Begin
      CurrentW   := Pointers[T];
      CurrentMin := T;
     End;
   End;
   Result := CurrentMin;
  End;

  Procedure Zamien(I, J : Integer);
  Var Item : Integer;
  Begin
   Item := Pointers[I];
   Pointers[I] := Pointers[J];
   Pointers[J] := Item;
  End;

Var Minimum : Integer;
    T       : Integer;
Begin
 For T:=1 To maxInClass Do
  Begin
   Minimum := Max(T);
   Zamien(T, Minimum);
  End;
End;

Procedure TCheckConflicts.InternalCreate(
    Day : TTimeStamp;
    Hour, fill, colour : Integer;
    Lecturers : TPointers;
    Groups: TPointers;
    Rooms: TPointers;
    LecturersWithChilds : TPointers;
    GroupsWithChilds: TPointers;
    RoomsWithChilds: TPointers;
    Sub_id, For_id : Integer;
    Created_by, _Owner, desc1, desc2, desc3, desc4 : String);
Begin
 NewClassToCreate.day     := Day;
 NewClassToCreate.hour    := Hour;
 NewClassToCreate.fill    := fill;
 NewClassToCreate.colour  := colour;
 NewClassToCreate.desc1   := desc1;
 NewClassToCreate.desc2   := desc2;
 NewClassToCreate.desc3   := desc3;
 NewClassToCreate.desc4   := desc4;
 NewClassToCreate.lecturers := Lecturers;
 NewClassToCreate.groups  := Groups;
 NewClassToCreate.rooms   := Rooms;
 NewClassToCreate.sub_id  := Sub_id;
 NewClassToCreate.for_id  := For_id;
 NewClassToCreate.created_by := Created_by;
 NewClassToCreate._Owner  := _Owner;

 NewClassWithChilds.day     := Day;
 NewClassWithChilds.hour    := Hour;
 NewClassWithChilds.fill    := fill;
 NewClassWithChilds.colour  := colour;
 NewClassWithChilds.desc1   := desc1;
 NewClassWithChilds.desc2   := desc2;
 NewClassWithChilds.desc3   := desc3;
 NewClassWithChilds.desc4   := desc4;
 NewClassWithChilds.lecturers := LecturersWithChilds;
 NewClassWithChilds.groups  := GroupsWithChilds;
 NewClassWithChilds.rooms   := RoomsWithChilds;
 NewClassWithChilds.sub_id  := Sub_id;
 NewClassWithChilds.for_id  := For_id;
 NewClassWithChilds.created_by := Created_by;
 NewClassWithChilds._Owner  := _Owner;

 CanDelete := True;
 Completion := False;
 Count := 0;
End;

Procedure TCheckConflicts.Add(Day : TTimeStamp; Hour : Integer; Lecturers : TPointers; Groups: TPointers; Rooms: TPointers; Sub_id, For_id : Integer; Created_by, _Owner,conflictReason : String );
{--------------------------------------------------}
Function P1IncludesP2(P1, P2 : TPointers) : Boolean;
 Var t1, t2 : Integer;
     R : Boolean;
     Found : Boolean;
 Begin
  R := True;
  t1 := 1;
  Repeat
    If P2[t1] <> 0 Then Begin

      Found := False;
      t2 := 1;
      Repeat
       If P1[t2]=P2[t1] Then
         Begin Found := True; Break; End;
      Inc(t2);
      Until t2 > maxInClass;

      R := R And Found;
      If Not R Then Break;
    End Else Break;
    Inc(t1);
  Until t1 > maxInClass;
  Result := R;
 End;
{--------------------------------------------------}
 Function ComparePointers(P1, P2 : TPointers) : Boolean;
 Var t : Integer;
     R : Boolean;
 Begin
  SortDesc(p1);
  SortDesc(p2);

  R := True;
  For t := 1 To maxInClass Do Begin
    R := R And ( (P1[t] = P2[t]) );
  End;
  Result := R;
 End;
{--------------------------------------------------}
Var t : Integer;
Begin
   If (not UUtilities.isOwner(_Owner)) Then CanDelete := False;

 // nie dopisuj do listy doplanowania (unless planner is not to be able to erase it)
 If (NewClassWithChilds.Day.Date = Day.Date) And (NewClassWithChilds.Hour = Hour)
     And P1IncludesP2(NewClassToCreate.Lecturers, Lecturers)
     And P1IncludesP2(NewClassToCreate.Groups, Groups)
     And P1IncludesP2(NewClassToCreate.Rooms, Rooms)
     And  (NewClassWithChilds.Sub_id = Sub_id)
     And (NewClassWithChilds.For_id = For_id) And (NewClassWithChilds.Created_by = Created_by) And (NewClassWithChilds._Owner = _Owner) Then Begin
       If UUtilities.isOwner(_Owner) Then Begin
         Completion := True;
         Exit;
       End;
     End;
     //!!! NewClass.res = 0 ?...

 // nie dopisuj do listy identycznych rekordow:
 For t:=1 To Count Do
  If (ConflictsClasses[t].Day.Date = Day.Date) And
     (ConflictsClasses[t].Hour = Hour) And
     (ComparePointers(ConflictsClasses[t].Lecturers,Lecturers)) And
     (ComparePointers(ConflictsClasses[t].Groups,Groups)) And
     (ComparePointers(ConflictsClasses[t].Rooms,Rooms)) And
     (ConflictsClasses[t].Sub_id       = Sub_id) And
     (ConflictsClasses[t].For_id      = For_id) And
     (ConflictsClasses[t].Created_By  = Created_By) And
     (ConflictsClasses[t]._Owner      = _Owner)
  Then begin
    if  pos(conflictReason, ConflictsClasses[t].conflictReason)=0 then
        ConflictsClasses[t].conflictReason :=  ConflictsClasses[t].conflictReason + conflictReason;
    Exit;
  end;

 Count := Count + 1;
 ConflictsClasses[Count].Day      := Day;
 ConflictsClasses[Count].Hour     := Hour;
 ConflictsClasses[Count].Lecturers:= Lecturers;
 ConflictsClasses[Count].Groups   := Groups;
 ConflictsClasses[Count].Rooms    := Rooms;
 ConflictsClasses[Count].Sub_id   := Sub_id;
 ConflictsClasses[Count].For_id   := For_id;
 ConflictsClasses[Count].Created_By:= Created_By;
 ConflictsClasses[Count]._Owner   := _Owner;
 ConflictsClasses[Count].conflictReason   := conflictReason;
End;

Function  TCheckConflicts.empty;
Begin
 If Count = 0 Then Result := True
              Else Result := False;
End;

Function TCheckConflicts.ConflictsReport(
  Day : TTimeStamp;
  Hour : Integer;
  acurrentClassId : Integer;
  Lecturers : TPointers;
  Groups: TPointers;
  Rooms: TPointers;
  LecturersWithChilds : TPointers;
  GroupsWithChilds: TPointers;
  RoomsWithChilds: TPointers;
  Sub_id, For_id, Res, aNewClassFill, aColour : integer; aCreated_by, aOwner, adesc1, adesc2, adesc3, adesc4 : String) : Boolean;
Var L      : Integer;
    Status : String;
    Class_ : TClass_;
    listOfval : string;

Var PLecturers : TPointers; PGroups: TPointers; PRooms: TPointers;

 Procedure AddSingleClass (conflictReason: String);
 Var  L     : Integer;
      Len   : Integer;
  Begin
   {DBGetLecturers(Class_.ID, Lecturers);
   DBGetGroups(Class_.ID, Groups);
   DBGetRooms(Class_.ID, Rooms);}

   For L := 1 To maxInClass Do Begin
     PLecturers[L] :=0;
     PGroups[L]    :=0;
     PRooms[L]     :=0;
   End;

   Len := WordCount(Class_.CALC_LEC_IDS, [';']);
   For L := 1 To Len Do PLecturers[L] := StrToInt(ExtractWord(L,Class_.CALC_LEC_IDS, [';']));

   Len := WordCount(Class_.CALC_GRO_IDS, [';']);
   For L := 1 To Len Do PGroups[L] := StrToInt(ExtractWord(L,Class_.CALC_GRO_IDS, [';']));

   Len := WordCount(Class_.CALC_ROM_IDS, [';']);
   For L := 1 To Len Do PRooms[L] := StrToInt(ExtractWord(L,Class_.CALC_ROM_IDS, [';']));

   {For L := 1 To Lecturers.Count Do PLecturers[L] := Lecturers.CommonAttrs[L-1].ID;
   For L := 1 To Groups.Count    Do PGroups[L]    := Groups.CommonAttrs[L-1].ID;
   For L := 1 To Rooms.Count     Do PRooms[L]     := Rooms.CommonAttrs[L-1].ID;}

   Add(Day, Hour,
       PLecturers,
       PGroups,
       PRooms,
       Class_.SUB_ID,
       Class_.FOR_ID, Class_.Created_by, Class_.Owner, conflictReason
       );
  End;
Begin
  internalCreate(Day,Hour, aNewClassFill, aColour,Lecturers,Groups,Rooms,LecturersWithChilds,GroupsWithChilds,RoomsWithChilds,Sub_id,For_id,aCreated_by, aOwner, adesc1, adesc2, adesc3, adesc4);
  currentClassId := acurrentClassId;

  listOfval := '';
  For L := 1 To maxInClass Do
    If GroupsWithChilds[L] <> 0 Then
    Begin
      listOfval := merge(listOfval,IntToStr(GroupsWithChilds[L]), ',');
    End Else Break;
  For L := 1 To maxInClass Do
    If LecturersWithChilds[L] <> 0 Then
    Begin
      listOfval := merge(listOfval,IntToStr(LecturersWithChilds[L]), ',');
    End Else Break;
  For L := 1 To maxInClass Do
    If RoomsWithChilds[L] <> 0 Then
    Begin
      listOfval := merge(listOfval,IntToStr(RoomsWithChilds[L]), ',');
    End Else Break;

  if listOfval <> '' then begin
     listOfval := '('+listOfval+')';
     dm.DBGetClassByLGR(TSDateToOracle(Day), TSDateToOracle(Day), Hour, listOfval, Status, Class_);
     if Status =  'ClassNotFound' then Begin End
     else begin
       While Not Dmodule.QWork2.EOF Do Begin

        DModule.SingleValue(
        'SELECT CLA.*,'+
            'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR, FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR,CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, '+
            'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
        'FROM CLASSES CLA, '+
        '     subjects SUB,'+
        '     FORMS FRM,'+
        '     PLANNERS OWNER, '+
        '     PLANNERS CREATOR '+
        'WHERE SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
        '      CLA.ID = :id'
        ,'id='+DModule.QWork2.FieldByName('CLA_ID').AsString);

        Class_ := dm.QWorkToClass;
        AddSingleClass( Dmodule.QWork2.FieldByName('CONFLICTTYPE').AsString );
         Dmodule.QWork2.Next;
       End;
     End;


  end;



  If Empty And (Not Completion) Then Result := True Else Result := False;
End;

Function TCheckConflicts.DeleteConflictClasses : Boolean;
Var L : Integer;
    Status : Integer;
    Class_ : TClass_;
Begin
 Result := True;
 If Not CanDelete Then Begin
  Info('Nie mo¿esz usun¹æ rekordów, poniewa¿ nie jesteœ ich w³aœcicielem');
  Result := False;
  Exit;
 End;
 Result := True;

 For L := 1 To maxInClass Do
    If NewClassWithChilds.Groups[L] <> 0 Then
    Begin
      dm.DBGetClassByGroup(TSDateToOracle(NewClassWithChilds.Day), TSDateToOracle(NewClassWithChilds.Day), NewClassWithChilds.Hour, IntToStr(NewClassWithChilds.Groups[L]),Status,Class_);
      Case Status Of
       ClassNotFound : Begin End;
       ClassFound    : If Result Then Result := Result And DeleteClass(Class_, currentClassId);
       ClassError    : If Result Then Result := Result And DeleteClass(Class_, currentClassId);
      End;
    End;

 //The same for lecturers, rooms and so on
 For L := 1 To maxInClass Do
    If NewClassWithChilds.Lecturers[L] <> 0 Then
    Begin
      dm.DBGetClassByLecturer(TSDateToOracle(NewClassWithChilds.Day), TSDateToOracle(NewClassWithChilds.Day), NewClassWithChilds.Hour, IntToStr(NewClassWithChilds.Lecturers[L]),Status,Class_);
      Case Status Of
       ClassNotFound : Begin End;
       ClassFound    : If Result Then Result := Result And DeleteClass(Class_, currentClassId);
       ClassError    : If Result Then Result := Result And DeleteClass(Class_, currentClassId);
      End;
    End;

 For L := 1 To maxInClass Do
    If NewClassWithChilds.Rooms[L] <> 0 Then
    Begin
      dm.DBGetClassByRoom(TSDateToOracle(NewClassWithChilds.Day), TSDateToOracle(NewClassWithChilds.Day), NewClassWithChilds.Hour, IntToStr(NewClassWithChilds.Rooms[L]),Status,Class_);
      Case Status Of
       ClassNotFound : Begin End;
       ClassFound    : If Result Then Result := Result And DeleteClass(Class_, currentClassId);
       ClassError    : If Result Then Result := Result And DeleteClass(Class_, currentClassId);
      End;
    End;
End;

Function TCheckConflicts.checkConflictsInsert ( ttCombIds : string ): Boolean;
 Var t            : Integer;
  	 calc_lec_ids : string;
		 calc_gro_ids : string;
		 calc_rom_ids : string;

     myClass : TClass_;
Begin
 Result := True;
 If (Not CheckConflicts.empty) Or (CheckConflicts.Completion) Then
   If Not CheckConflicts.deleteConflictClasses Then Begin Result := False; Exit; End;

  if NewClassToCreate.Hour = -1 Then
    Info('Wyst¹pi³ problem IntToStr(NewClass.Hour) = -1. Zg³oœ problem serwisowi');

 With DModule Do Begin
  calc_lec_ids := '';
	calc_gro_ids := '';
	calc_rom_ids := '';

  For t:=1 To maxInClass Do Begin
   If NewClassToCreate.Lecturers[t] <> 0 Then calc_lec_ids := merge( calc_lec_ids, intToStr(NewClassToCreate.Lecturers[t]), ';');
   If NewClassToCreate.Groups[t]    <> 0 Then calc_gro_ids := merge( calc_gro_ids, intToStr(NewClassToCreate.Groups[t])   , ';');
   If NewClassToCreate.Rooms[t]     <> 0 Then calc_rom_ids := merge( calc_rom_ids, intToStr(NewClassToCreate.Rooms[t])    , ';');
  End;

  myClass.hour          := newClassToCreate.hour;
  myClass.day           := newClassToCreate.day;
  myClass.fill          := newClassToCreate.fill;
  myClass.class_colour  := newClassToCreate.colour;
  myClass.sub_id        := newClassToCreate.sub_id;
  myClass.for_id        := newClassToCreate.for_id;
  myClass.owner         := newClassToCreate._Owner;
  myClass.calc_lec_ids  := calc_lec_ids;
  myClass.calc_gro_ids  := calc_gro_ids;
  myClass.calc_rom_ids  := calc_rom_ids;
  myClass.desc1         := newClassToCreate.desc1;
  myClass.desc2         := newClassToCreate.desc2;
  myClass.desc3         := newClassToCreate.desc3;
  myClass.desc4         := newClassToCreate.desc4;

  result := planner_utils_insert_classes (myClass, ttCombIds, currentClassId);
 End;
End;

Procedure TCheckConflicts.GetDesc(SGNewClass, SGConflicts : TStringGrid; L : TLabel; var dataStamp : String);
 Function GetLecturers(Pointers : TPointers) : String;
 Var t : Integer;
 Begin
  Result := '';
  For t := 1 To maxInClass Do
    If Pointers[t]<>0 Then Result := Merge(Result,DModule.SingleValue(sql_LECDESC+IntToStr(Pointers[t])), ',');
 End;
 Function GetGroups(Pointers : TPointers) : String;
 Var t : Integer;
 Begin
  Result := '';
  For t := 1 To maxInClass Do
    If Pointers[t]<>0 Then Result := Merge(Result,DModule.SingleValue(sql_GRODESC+IntToStr(Pointers[t])), ',');
 End;
 Function GetRooms(Pointers : TPointers) : String;
 Var t : Integer;
 Begin
  Result := '';
  For t := 1 To maxInClass Do
    If Pointers[t]<>0 Then Result := Merge(Result,DModule.SingleValue(sql_ResCat0DESC+IntToStr(Pointers[t])), ',');
 End;
 Function GetSubject(ID : integer) : String;
 Begin
    Result := DModule.SingleValue(sql_SUBDESC+IntToStr(ID));
 End;
 Function GetForm(ID : Integer) : String;
 Begin
    Result := DModule.SingleValue(sql_FORDESC+IntToStr(ID));
 End;
 function toString ( Pointers : tpointers ) : string;
 var t : integer;
 begin
  result := '';
  For t := 1 To maxInClass Do
    If Pointers[t]<>0 Then result := Merge(Result,IntToStr(Pointers[t]), ',');
 end;

Var t : Integer;
var MarkL, MarkG, MarkR : string;
Begin
 L.Visible := Not CanDelete;

 SGNewClass.Cells[0,1] := GetDate(NewClassToCreate.Day.Date);
 SGNewClass.Cells[1,1] := IntToStr(NewClassToCreate.Hour);
 SGNewClass.Cells[2,1] := GetLecturers(NewClassToCreate.Lecturers);
 SGNewClass.Cells[3,1] := GetGroups(NewClassToCreate.Groups);
 SGNewClass.Cells[4,1] := GetRooms(NewClassToCreate.Rooms);
 SGNewClass.Cells[5,1] := GetSubject(NewClassToCreate.Sub_id);
 SGNewClass.Cells[6,1] := GetForm(NewClassToCreate.For_id);
 SGNewClass.Cells[7,1] := NewClassToCreate._Owner;

 dataStamp := 'New:'
             //+',D:'+GetDate(NewClassToCreate.Day.Date)
             //+',H:'+IntToStr(NewClassToCreate.Hour)
             +',L:'+toString(NewClassToCreate.Lecturers)
             +',G:'+toString(NewClassToCreate.Groups)
             +',R:'+toString(NewClassToCreate.Rooms)
             +',S:'+IntToStr(NewClassToCreate.Sub_id)
             +',F:'+IntToStr(NewClassToCreate.For_id)
             +',O:'+NewClassToCreate._Owner;

 With SGConflicts Do Begin
 RowCount := Count + 1; //+1 for header
   For t := 1 To Count Do Begin
    MarkL := ''; MarkG := ''; MarkR := '';
    if pos('W', ConflictsClasses[t].conflictReason)<>0 then MarkL := '>> ';
    if pos('G', ConflictsClasses[t].conflictReason)<>0 then MarkG := '>> ';
    if pos('S', ConflictsClasses[t].conflictReason)<>0 then MarkR := '>> ';
    Cells[0,t] := GetDate(ConflictsClasses[t].Day.Date);
    Cells[1,t] := IntToStr(ConflictsClasses[t].Hour);
    Cells[2,t] := MarkL+GetLecturers(ConflictsClasses[t].Lecturers);
    Cells[3,t] := MarkG+GetGroups(ConflictsClasses[t].Groups);
    Cells[4,t] := MarkR+GetRooms(ConflictsClasses[t].Rooms);
    Cells[5,t] := GetSubject(ConflictsClasses[t].Sub_id);
    Cells[6,t] := GetForm(ConflictsClasses[t].For_id);
    Cells[7,t] := ConflictsClasses[t]._Owner;
    Cells[8,t] := ConflictsClasses[t].conflictReason;

    dataStamp :=  dataStamp +
    'Conflick:'+IntToStr(t)
             //+',D:'+GetDate(ConflictsClasses[t].Day.Date)
             //+',H:'+IntToStr(ConflictsClasses[t].Hour)
             +',L:'+toString(ConflictsClasses[t].Lecturers)
             +',G:'+toString(ConflictsClasses[t].Groups)
             +',R:'+toString(ConflictsClasses[t].Rooms)
             +',S:'+IntToStr(ConflictsClasses[t].Sub_id)
             +',F:'+IntToStr(ConflictsClasses[t].For_id)
             +',O:'+ConflictsClasses[t]._Owner;
   End;
 End;
End;

Function GetCLASSESforL(colName, condition : String; const postfix : String = ''; const mode : shortstring ='e') : String;
var lmode : shortString;
    ChildsAndParents : string;
begin

    lmode := nvl(mode, 'e');
    if nvl(condition,'0=0') = '0=0' then begin result := '0=0'; exit; end;
    if lmode = 'e' then begin
      ChildsAndParents := '('+replace(getChildsAndParents(condition, '', true, false),';',',')+')';  //2024.07.25
      Result := colName+' in (SELECT CLA_ID FROM LEC_CLA'+postfix+' WHERE is_child=''N'' and LEC_ID in '+ChildsAndParents+')';
    end;
    if lmode = 'a' then
      Result := colName+' in (SELECT CLA_ID FROM LEC_CLA'+postfix+' WHERE LEC_ID IN (SELECT ID FROM LECTURERS WHERE '+condition+'))';
end;

Function GetCLASSESforG(colName, condition : String; const postfix : String = ''; const mode : shortstring='e') : String;
var lmode : shortString;
    ChildsAndParents : string;
begin
    lmode := nvl(mode, 'e');
    if nvl(condition,'0=0') = '0=0' then begin result := '0=0'; exit; end;
    if lmode = 'e' then begin
      ChildsAndParents := '('+replace(getChildsAndParents(condition, '', true, false),';',',')+')';  //2024.07.25
      Result := colName+' in (SELECT CLA_ID FROM GRO_CLA'+postfix+' WHERE is_child=''N'' and GRO_ID in '+ChildsAndParents+')';
    end;
    if lmode = 'a' then
      Result := colName+' in (SELECT CLA_ID FROM GRO_CLA'+postfix+' WHERE GRO_ID IN (SELECT ID FROM GROUPS WHERE '+condition+'))';
end;

Function GetCLASSESforR(colName, condition : String;
                        const postfix   : String = '';
                        const mode      : shortstring='e') : String;
var lmode : shortString;
    ChildsAndParents : string;
begin
    lmode := nvl(mode, 'e');
    if nvl(condition,'0=0') = '0=0' then begin result := '0=0'; exit; end;
    if lmode = 'e' then begin
      ChildsAndParents := '('+replace(getChildsAndParents(condition, '', true, false),';',',')+')';   //2024.07.25
      Result := colName+' in (SELECT CLA_ID FROM ROM_CLA'+postfix+' WHERE is_child=''N'' and ROM_ID in '+ChildsAndParents+')';
                                 //CLASSES.ID in (SELECT CLA_ID FROM ROM_CLA            WHERE ROM_ID =UPPER((select name from org_units where org_units.id = orguni_id)) LIKE UPPER('instytut budow%'))
    end;
    if lmode = 'a' then
      Result := colName+' in (SELECT CLA_ID FROM ROM_CLA'+postfix+' WHERE ROM_ID IN (SELECT ID FROM ROOMS WHERE '+condition+'))';
end;

Function GetCLASSESforPLA(ID : ShortString ) : String;
begin
  Result := 'CLASSES.OWNER = (SELECT NAME FROM PLANNERS WHERE ID ='+ID+')';
end;


{
Var IDs : String;
Begin
 IDs := '';
 With DModule Do Begin
 OPENSQL(
  'SELECT CLA_ID '+
  'FROM   ROM_CLA '+
  'WHERE  ROM_ID ='+ID);

  IDs := '';
  QWork.First;
  While Not QWOrk.EOF Do Begin
   If IDs <> '' Then IDs := IDs + ', ';
   IDs := IDs + QWork.Fields[0].AsString;
   QWork.Next;
  End;
 End;
 If IDs = '' Then IDs := 'CLASSES.ID = -1'
                   Else IDs := 'CLASSES.ID in ('+IDs+')';
 Result := IDs;
End;
}
Procedure DeleteOrphanedClasses;
Var I1, I2 : String;
    lClasses : shortString;
begin
  I1 := DModule.SingleValue('SELECT COUNT(1) FROM CLASSES WHERE NOT EXISTS (SELECT 1 FROM PERIODS WHERE DAY BETWEEN DATE_FROM AND DATE_TO) AND OWNER='''+CurrentUserName+'''');
  I2 := DModule.SingleValue('SELECT COUNT(1) FROM CLASSES WHERE NOT EXISTS (SELECT 1 FROM PERIODS WHERE DAY BETWEEN DATE_FROM AND DATE_TO) AND OWNER<>'''+CurrentUserName+'''');
  lClasses := fprogramSettings.profileObjectNameClasses.text;

  If I1 <> '0' Then Begin
   If Question('Znaleziono '+lClasses +' u¿ytkownika bez okreœlonego ' + fprogramSettings.profileObjectNamePeriodgen.Text+': '+I1+'. Czy chcesz je teraz usun¹æ ?')=ID_YES Then Begin
     dmodule.sql('begin api.delete_orphaned (:user ); end;'
                ,'user='+CurrentUserName
                );
     dmodule.CommitTrans;
     Info(lClasses + ' zosta³y usuniête');
   End;
  End Else Info('Nie ma ' +fprogramSettings.profileObjectNameClassgen.text+ ' u¿ytkownika bez okreœlonego ' + fprogramSettings.profileObjectNamePeriodgen.Text );

  If I2 <> '0' Then Begin
   If Question('Znaleziono ' +lClasses+ ' innych u¿ytkowników bez  okreœlonego ' + fprogramSettings.profileObjectNamePeriodgen.Text+': '+I2+'. ' +lClasses+ ' te mog¹ usun¹æ tylko u¿ytkownicy, którzy je utworzyli. Czy chcesz zobaczyæ listê u¿ytkowników, którzy maj¹ nie powi¹zane ' +lClasses+ ' ?')=ID_YES Then Begin
     DModule.SingleValue('SELECT DISTINCT OWNER FROM CLASSES WHERE NOT EXISTS (SELECT 1 FROM PERIODS WHERE DAY BETWEEN DATE_FROM AND DATE_TO) AND OWNER<>'''+CurrentUserName+'''');
     Info('U¿ytkownicy, którzy maj¹ nie powi¹zane ' +lClasses+ ': '+GetResultByComma(DModule.QWork));
   End;
  End Else Info('Baza danych jest prawid³owa - wszystkie ' +lClasses+ ' maj¹ okreœlony ' + fprogramSettings.profileObjectNamePeriod.text);
end;

procedure TConvertManyObjects.init(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean; ObjIds : Array of integer; ObjNames : Array of string);

  Procedure OmitDays(Var Date : Integer);
   Var Changed : Boolean;
       fuse    : Integer;
  Begin
    //If DayOfWeek(Date) = 1 Then Date := Date + 1;
    fuse := 0;

    Repeat
     inc(fuse);
     Changed := False;
     TimeStamp.Date := Date;
     TimeStamp.Time := 0;
     DateTime := TimeStampToDateTime(TimeStamp);
     day := DayOfWeek(DateTime);

     If day = 2 Then If Not SHOW_MON Then Begin Date := Date + 1; Changed := True; End;
     If day = 3 Then If Not SHOW_TUE Then Begin Date := Date + 1; Changed := True; End;
     If day = 4 Then If Not SHOW_WED Then Begin Date := Date + 1; Changed := True; End;
     If day = 5 Then If Not SHOW_THU Then Begin Date := Date + 1; Changed := True; End;
     If day = 6 Then If Not SHOW_FRI Then Begin Date := Date + 1; Changed := True; End;
     If day = 7 Then If Not SHOW_SAT Then Begin Date := Date + 1; Changed := True; End;
     If day = 1 Then If Not SHOW_SUN Then Begin Date := Date + 1; Changed := True; End;
     If fuse = 8 Then Begin SError(fprogramSettings.profileObjectNamePeriod.text+' musi zawieraæ przynajmniej jeden dzieñ'); dmodule.CloseDBConnection(true); halt; End;
    Until Changed = False;
  End;

  var t : integer;

Begin
 SetLength(ColDate, EndDate - StartDate + 3);       // inicjuje dlugosc tabeli dynamicznej

 MaxIloscGodzin := aMaxIloscGodzin;
 Len := 1;

 //_row := 2; // row 0 -> name of day
              // row 1 -> day
 if High(ObjIds) > MaxAllLecturers then
      info('Ups.. Wygl¹da na to, ¿e przekroczono maksymaln¹ liczbê obiektów, skontaktuj siê administratorem systemu.'+cr+'Je¿eli posiadasz aktywn¹ umowê serwisow¹ firma Software Factory pomo¿e w rozwi¹zaniu problemu, zadzwoñ pod numer +48 604224658. ');
 SetLength(ObjectIds, High(ObjIds) + 3);
 For t:= 0 To High(ObjIds)  do begin
  ObjectIds[t+1].id   := ObjIds[t];
  ObjectIds[t+1].name := ObjNames[t];
 end;
  _Col := 1; // col 0 -> object name
  Date := StartDate;
  if dmodule.dateRange='' then  OmitDays(Date);
  if Date<= EndDate then
  repeat
    ColDate[Len].Col  := 1 + ( (_Col- 1) * aMaxIloscGodzin );
   // Data[Len].Row  := _Row;
    ColDate[Len].Date := Date;
    Date := Date + 1;
    OmitDays(Date);

    Len := Len + 1;

    if Len > high ( ColDate ) then begin
      SError('2.Wyst¹pi³o zdarzenie "5 Liczba dni poza zakresem". Zg³oœ problem serwisowi. Len =' + intToStr(len)+' hdata='+ intToStr( high(ColDate) ));
      dmodule.CloseDBConnection(true);
      halt;
    end;

    inc ( _col );
  until Date > EndDate;
  //inc ( _row );
  LiczbaKolumn  := 1 + (_col-1) * aMaxIloscGodzin ;
  LiczbaWierszy := High(ObjIds) + 3;
End;

{function  TConvertDateObjColRow.dateObjToColRow(_Date, _Hour, _objId : Integer; var Col, Row : Integer) : Boolean;
Var i : Integer;
Begin
 i := 1;
 While (i<=Len) And (Data[i].Date<>_Date) and (Data[i].objId<>_objId ) Do
  Begin
   i := i + 1;
  End;

 If i>Len Then DateObjToColRow := false
 Else
  If (Data[i].Date = _Date) and (Data[i].objId = _objId) Then
   Begin
    Col := Data[i].Col + _Hour - 1;
    Row := Data[i].Row;
    result := True;
   End;
End;
}
function  TConvertManyObjects.colRowToDate(var objId : integer; var _Date : TTimeStamp; var _Hour : Integer;Col, Row : Integer) : Integer;
Var i : Integer;
    _D : Integer;
Begin

 result := -1;
 _Hour := ((Col-1) mod MaxIloscGodzin) + 1;

 if ((col = 0) and ((row = 0) or (row = 1))) or
    ((col = -1) and (row = -1)) then begin
  result := convOutOfRange;
  exit;
 end;

 if row = 0 then begin
  result := crossTableViewDayOfWeek;
  row := 2;
 end;

 if col = 0 then begin
  result := crossTableViewObjNames;
  objId := ObjectIds[Row-1].id;
  currentObjName :=  ObjectIds[Row-1].name;
  exit;
 end;

 if row = 1 then begin
  result := ConvNumeryZajec;
  exit;
 end;

 Col   := ((Col-1) Div MaxIloscGodzin)*MaxIloscGodzin+1;
 i := 1;
 While (i<=Len) And  (Not(ColDate[i].Col=Col)) Do i := i + 1;
 If i>Len Then Begin
   result := convOutOfRange;
   exit;
 End
 Else
  If ColDate[i].Col=Col Then
   Begin
     if result = -1 then result := ConvClass;
    _D := ColDate[i].Date;
    _Date.Date := _D;
    _Date.Time := 0;
    objId := ObjectIds[Row-1].id;
    currentObjName :=  ObjectIds[Row-1].name;
   End;
End;

Procedure TConvertGrid.initNOsingleChartMode(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean; ObjIds : Array of integer; ObjNames : Array of string);
begin
  convertManyObjects  := TconvertManyObjects.Create;
  //ConvertSingleObject := TConvertSingleObject.create;
  convertMode         := ConvManyObjects;
  convertManyObjects.init(StartDate, EndDate, LiczbaKolumn, LiczbaWierszy, aMaxIloscGodzin, SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN, ObjIds, ObjNames);
end;

Procedure TConvertGrid.initSingleChartMode(StartDate, EndDate : Integer; Var LiczbaKolumn, LiczbaWierszy : Integer; aMaxIloscGodzin : Integer; SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN : Boolean);
begin
  convertMode := ConvSingleObject;
  convertSingleObject.init(StartDate, EndDate, LiczbaKolumn, LiczbaWierszy, aMaxIloscGodzin, SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN);
end;

Function  TConvertGrid.ColRowToDate(var objId : integer; var _Date : TTimeStamp; var _Hour : Integer;Col, Row : Integer) : Integer;
begin
 case convertMode of
   ConvSingleObject :  begin result := convertSingleObject.ColRowToDate(_Date,_Hour,Col, Row); objId := -1; end;
   ConvManyObjects  :  result := convertManyObjects.ColRowToDate(objId, _Date,_Hour,Col, Row);
   else result := -1;
 end;
end;

function isOwnerSupervisor(classOwners : String): boolean;
var t : integer;
    classOwner : string;
    ClassOwnerSupervisor : string;
    currentUserRoleName  : string;
begin
  currentUserRoleName := nvl(fmain.CONROLE_VALUE.Text,'**NONE**');
  result := false;
  //fmain.wlog('START : isOwnerSupervisor');
  For t := 1 To WordCount(classOwners, [';']) Do Begin
    classOwner := Trim(ExtractWord(t,classOwners, [';']));
    ClassOwnerSupervisor := Fmain.MapPlannerSupervisors.getValue( classOwner );
    {
    if FProgramSettings.SQLLog.checked then  begin
      fmain.wlog('    classOwner : ' + classOwner);
      fmain.wlog('    ClassOwnerSupervisor.list : ' + Fmain.MapPlannerSupervisors.list);
      fmain.wlog('    ClassOwnerSupervisor : ' + ClassOwnerSupervisor);
      fmain.wlog('    CurrentUserName : ' + CurrentUserName);
      fmain.wlog('    currentUserRoleName : ' + currentUserRoleName);
    end;
    }
    if AnsiContainsText(';'+ClassOwnerSupervisor+';', ';'+CurrentUserName+';') then begin result := true; exit; end;
    if AnsiContainsText(';'+ClassOwnerSupervisor+';', ';'+currentUserRoleName+';') then begin result := true; exit; end;
  End;
  //fmain.wlog( 'STOP : isOwnerSupervisor : result : ' + BoolToStr(result));
end;

function isOwner(classOwners : String): boolean;
begin
  result := false;
  if AnsiContainsStr(';'+classOwners,';'+CurrentUserName) then begin result := true; exit; end;
  if isOwnerSupervisor(classOwners) then begin result := true; exit; end;
end;


Function DeleteClass(Class_ : TClass_; const currentClassId : integer =-1) : Boolean;
Var _Owner : String[255];
Begin
 Result := True;
 _Owner := Class_.owner;

 if Class_.id = currentClassId then
     //user can delete class providing it is an edit (edit = delete + insert )
 else
     if not UutilityParent.CanDelete then begin
       Info('Nie mo¿esz usuwaæ zajêæ');
       Result := False;
       Exit;
     end;

 If _Owner<>'' Then
  If (not isOwner(_Owner)) Then Begin
   Info('Nie mo¿esz zmieniaæ zajêæ u¿ytkownika '+_Owner);
   Result := False;
   Exit;
  End;

  If (confineCalendarId<>'') then
    If fmain.confineCalendar.getRatio(Class_.day, Class_.hour)<>calConfineOk then begin
       Info('Nie mo¿esz usun¹æ zajêcia poza obszarem planowania, który zosta³ ci przypisany');
       Result := False;
       Exit;
    End;

  dmodule.sql('begin api.delete_class (:id ); end;'
             ,'id='+intToStr(Class_.ID)
             );
  Fmain.AutoSaveCounterDown := 10;

 with fmain do begin
 ClassByLecturerCaches.ResetByCLA_ID(Class_.ID,Class_.day, Class_.hour);
 ClassByGroupCaches.ResetByCLA_ID   (Class_.ID,Class_.day, Class_.hour);
 ClassByRoomCaches.ResetByCLA_ID    (Class_.ID,Class_.day, Class_.hour);
 ClassByResCat1Caches.ResetByCLA_ID (Class_.ID,Class_.day, Class_.hour);
 BusyClassesCache.ClearCache;
 end;
End;

function canInsertClass ( theClass : TClass_; cla_id : integer;  var resultMessage : string; const fastCheck : boolean = false ) : boolean;
var sql_text, select_clause, from_clause : string;
    t : integer;
    free_capacity : integer;
    trace : string;
    instances : integer;
    idsp      : shortString;
    cl, cd1, cd2, cd3, cd4 : integer;
    serror, ferror : shortString;
    LWithChildsAndParents,GWithChildsAndParents,RWithChildsAndParents, value : String;
    var stringTokenizer : TStringTokenizer;
    //
    function countTokens (s : string) : integer;
    begin
      with stringTokenizer do begin
        s := searchAndReplace(s, ';', ',');
        init(s);
        result := count;
        close;
      end;
    end;
    //
    function classDesc : string;
    begin

      result := DateToYYYYMMDD(TimeStampToDateTime(theClass.day))+' godzina:'+intToStr(theClass.hour);
    end;
begin

  If cla_id <> -1 then
  //Edit = delete + insert. Do not check  CanInsert in edit mode.
  else
  if not UUtilityParent.CanInsert then begin
    Result := false;
    resultMessage := 'Nie mo¿esz wstawiaæ zajêæ';
    Exit;
  end;

  Result := true;
  resultMessage := '';

  sql_text :=
      'select nvl(group_capacity - resource_capacity,0) ' + cr +
      '  from (    select sum(nvl(number_of_peoples,0   )) group_capacity from groups where id in ( '+nvl(replace(theClass.calc_gro_ids, ';',','),'0')+' )    )  ' + cr +
      '     , (    select sum(nvl(attribn_01,9999)) resource_capacity from rooms  where id in ( '+nvl(replace(theClass.calc_rom_ids, ';',','),'0')+' )    )  ';

  free_capacity :=
    strToInt(
    dmodule.SingleValue(
    sql_text
    ));
  if free_capacity > 0 then begin
     resultMessage := classDesc+cr+'Licznoœæ grup/y przekracza pojemnoœæ sal/i o ' + intToStr(free_capacity);
     //Result := false;
     //exit;
  end;

  if theClass.sub_id<>0 then begin
    stringTokenizer := TStringTokenizer.Create;
    cl := wordCount(theClass.calc_lec_ids,[';']);
    if (cl <> 0) then begin
      cd1 := countTokens(theClass.desc1);
      cd2 := countTokens(theClass.desc2);
      cd3 := countTokens(theClass.desc3);
      cd4 := countTokens(theClass.desc4);
      serror := 'Liczba wyk³adowców('+intToStr(cl)+') nie zgadza siê z liczb¹ przedmiotów';
      ferror := 'Liczba wyk³adowców('+intToStr(cl)+') nie zgadza siê z liczb¹ form zajêæ';
      if fprogramSettings.CopyField1.ItemIndex = 2 then if (cl <> cd1) and (cd1<>1) then begin resultMessage := classDesc+serror+'('+intToStr(cd1)+')'; result := false; end;
      if fprogramSettings.CopyField2.ItemIndex = 2 then if (cl <> cd2) and (cd2<>1) then begin resultMessage := classDesc+serror+'('+intToStr(cd2)+')'; result := false; end;
      if fprogramSettings.CopyField3.ItemIndex = 2 then if (cl <> cd3) and (cd3<>1) then begin resultMessage := classDesc+serror+'('+intToStr(cd3)+')'; result := false; end;
      if fprogramSettings.CopyField4.ItemIndex = 2 then if (cl <> cd4) and (cd4<>1) then begin resultMessage := classDesc+serror+'('+intToStr(cd4)+')'; result := false; end;
      //
      if fprogramSettings.CopyField1.ItemIndex = 3 then if (cl <> cd1) and (cd1<>1) then begin resultMessage := classDesc+ferror+'('+intToStr(cd1)+')'; result := false; end;
      if fprogramSettings.CopyField2.ItemIndex = 3 then if (cl <> cd2) and (cd2<>1) then begin resultMessage := classDesc+ferror+'('+intToStr(cd2)+')'; result := false; end;
      if fprogramSettings.CopyField3.ItemIndex = 3 then if (cl <> cd3) and (cd3<>1) then begin resultMessage := classDesc+ferror+'('+intToStr(cd3)+')'; result := false; end;
      if fprogramSettings.CopyField4.ItemIndex = 3 then if (cl <> cd4) and (cd4<>1) then begin resultMessage := classDesc+ferror+'('+intToStr(cd4)+')'; result := false; end;
      if result=false then begin
        exit;
      end;
    end;
    stringTokenizer.free;
  end;

  if fastCheck then begin
    result := true;
    exit;
  end;

  //add dependency records: childs and parents

  LWithChildsAndParents := theClass.calc_lec_ids;
  For t := 1 To WordCount(theClass.calc_lec_ids,[';']) Do Begin
    value := ExtractWord(t, theClass.calc_lec_ids, [';']);
    LWithChildsAndParents := getChildsAndParents(value, LWithChildsAndParents, false, false);
  End;

  GWithChildsAndParents := theClass.calc_gro_ids;
  For t := 1 To WordCount(theClass.calc_gro_ids,[';']) Do Begin
    value := ExtractWord(t, theClass.calc_gro_ids, [';']);
    GWithChildsAndParents := getChildsAndParents(value, GWithChildsAndParents, false, false);
  End;

  RWithChildsAndParents := theClass.calc_rom_ids;
  For t := 1 To WordCount(theClass.calc_rom_ids,[';']) Do Begin
    value := ExtractWord(t, theClass.calc_rom_ids, [';']);
    RWithChildsAndParents := getChildsAndParents(value, RWithChildsAndParents, false, false);
  End;


  //check better room in condition of capacity
  //GetEnabledLGR(myClass.day,myClass.hour,myClass.calc_lec_ids, myClass.calc_gro_ids, myClass.calc_rom_ids, intToStr( myClass.sub_id ) , intToStr( myClass.for_id ) , User , true, CONDL, CONDG, CONDR, 'R');
  //'SELECT ROM.ID, '  || sql_ROMNAME
  //'  FROM ROOMS ROM, ROM_PLA '
  //' WHERE CONDR+' AND ROM_PLA.ROM_ID = ROM.ID AND PLA_ID = '+FMain.getUserOrRoleID
  //'   AND ROWNUM < 5000
  //'   and attribn_01 > ..
  //'ORDER BY attribn_01
  // i pomiesci studentow i ma free_capa < poprzedniego

  { procedura konstruuje zapytanie SQL o postaci
    select ''||'#'||lec1||'#'||gro1||'#'||rom1
    from(
    select ''
    ,(select unique (select TITLE||' '||LAST_NAME||' '||FIRST_NAME from lecturers where id=lec_id ) c from lec_cla lec, classes c where lec_id = 4012911 and lec.day = to_date('2015.07.31','yyyy.mm.dd') and lec.hour = '1' and c.id = lec.cla_id and (upper(c.owner)<>'PLANNER' or (upper(c.owner)='PLANNER' and cla_id <> 3986697)) ) lec1
    ,(select unique (select abbreviation from groups where id=gro_id ) c from gro_cla gro, classes c where gro_id = 4008505 and gro.day = to_date('2015.07.31','yyyy.mm.dd') and gro.hour = '1' and c.id = gro.cla_id and (upper(c.owner)<>'PLANNER' or (upper(c.owner)='PLANNER' and cla_id <> 3986697)) ) gro1
    ,(select unique (select NAME||' '||substr(attribs_01,1,55) from rooms where id=rom_id ) c from rom_cla rom, classes c where rom_id = 4010207 and rom.day = to_date('2015.07.31','yyyy.mm.dd') and rom.hour = '1' and c.id = rom.cla_id and (upper(c.owner)<>'PLANNER' or (upper(c.owner)='PLANNER' and cla_id <> 3986697)) ) rom1
    from dual)
  }

  instances := 0;

  // bugfix: passing owner by parameter does not work, so value is set directly!
  For t := 1 To WordCount(LWithChildsAndParents,[';']) Do Begin
   inc ( instances ); idsp := inttostr(instances);
   from_clause := from_clause + cr + ',(select unique (select '+sql_LECNAME+' from lecturers where id=lec_id ) c from lec_cla lec, classes c where no_conflict_flag is null and lec_id = :lec'+inttostr(t)+' and lec.day = :day'+idsp+' and lec.hour = :hour'+idsp+' and c.id = lec.cla_id and (upper(c.owner)<>'''+ upperCase(CurrentUserName)+''' or (upper(c.owner)='''+ upperCase(CurrentUserName)+''' and cla_id <> :cla_id'+idsp+')) ) lec'+inttostr(t);
   select_clause := select_clause + '||''#''||lec'+inttostr(t);
  End;

  For t := 1 To WordCount(GWithChildsAndParents,[';']) Do Begin
   inc ( instances ); idsp := inttostr(instances);
   from_clause := from_clause + cr + ',(select unique (select '+sql_GRONAME+' from groups where id=gro_id ) c from gro_cla gro, classes c where no_conflict_flag is null and gro_id = :gro'+inttostr(t)+' and gro.day = :day'+idsp+' and gro.hour = :hour'+idsp+' and c.id = gro.cla_id and (upper(c.owner)<>'''+ upperCase(CurrentUserName)+''' or (upper(c.owner)='''+ upperCase(CurrentUserName)+''' and cla_id <> :cla_id'+idsp+')) ) gro'+inttostr(t);
   select_clause := select_clause + '||''#''||gro'+inttostr(t);
  End;

  For t := 1 To WordCount(RWithChildsAndParents,[';']) Do Begin
   inc ( instances ); idsp := inttostr(instances);
   from_clause := from_clause + cr + ',(select unique (select '+sql_ResCat0NAME+' from rooms where id=rom_id ) c from rom_cla rom, classes c where no_conflict_flag is null and rom_id = :rom'+inttostr(t)+' and rom.day = :day'+idsp+' and rom.hour = :hour'+idsp+' and c.id = rom.cla_id and (upper(c.owner)<>'''+ upperCase(CurrentUserName)+''' or (upper(c.owner)='''+ upperCase(CurrentUserName)+''' and cla_id <> :cla_id'+idsp+')) ) rom'+inttostr(t);
   select_clause := select_clause+ '||''#''||rom'+inttostr(t);
  End;

  sql_text := 'select '''''+select_clause+cr+
       'from ('+cr+
       'select '''''+cr+
       from_clause+cr+
       'from dual)';

  trace :=
    sql_text + cr + cr +
    'hour:' + inttostr(theClass.hour) +cr+
    'day:'  + uutilityparent.dateToYYYYMMDD(timeStampTodateTime(theClass.day)) +cr+
    'cla_id:'+ inttostr(cla_id) +cr+
   ' owner:' + upperCase(CurrentUserName);

  with dmodule.QWork do begin
   SQL.Clear;
   SQL.Add(sql_text);
   //copyToClipboard(sql_text);
   //parameters.paramByName('DAY').DataType := ftDateTime;

   //param names must be unique. As I use many times the same parameter, I must assign new number to each instance in order to keep param name unique
   for t := 1 to instances do begin
    idsp := inttostr(t);
    parameters.paramByName('HOUR'+idsp).value   := theClass.hour;
    parameters.paramByName('DAY'+idsp).value    := timeStampTodateTime(theClass.day);
    parameters.paramByName('cla_id'+idsp).value := cla_id;
   end;

   For t := 1 To WordCount(LWithChildsAndParents,[';']) Do Begin
    parameters.paramByName('lec'+inttostr(t)).value := ExtractWord(t, LWithChildsAndParents, [';']);
    trace := trace + cr + 'lec'+inttostr(t)+':'+ ExtractWord(t, LWithChildsAndParents, [';']);
   End;

   For t := 1 To WordCount(GWithChildsAndParents,[';']) Do Begin
    parameters.paramByName('gro'+inttostr(t)).value := ExtractWord(t, GWithChildsAndParents, [';']);
    trace := trace + cr + 'gro'+inttostr(t)+':'+ ExtractWord(t, GWithChildsAndParents, [';']);
   End;

   For t := 1 To WordCount(RWithChildsAndParents,[';']) Do Begin
    parameters.paramByName('rom'+inttostr(t)).value := ExtractWord(t, RWithChildsAndParents, [';']);
    trace := trace + cr + 'rom'+inttostr(t)+':'+ ExtractWord(t, RWithChildsAndParents, [';']);
   End;

   //for t := 0 to dmodule.QWork.Parameters.Count -1 do begin
   // info( dmodule.QWork.Parameters[t].Name   );
   // info( dmodule.QWork.Parameters[t].value );
   //end;
   //copytoclipboard(' *** '+  trace);

   open;
   Result := replace(Fields[0].AsString,'#','') = '';
   if not result then
   begin
     resultMessage := format ( 'Wykryto konflikt w terminie: %s dla %s'
                      ,[classDesc, replace(Fields[0].AsString,'#',cr)]); //fprogramSettings.profileObjectNameClassgen.Text
   end
   else
   begin
   end;

  end;
end;

function planner_utils_insert_classes ( myClass : TClass_; pttCombIds : string; const currentClassId : integer =-1 ) : boolean;
 var  resultMessage   : string;
begin
  Result := False;
  myClass.created_by := upperCase(CurrentUserName);

  // te kontrole przenies na poziom BD

  if  (myClass.calc_lec_ids = '') and (myClass.calc_gro_ids = '') and  (myClass.calc_rom_ids = '') then
  begin
     //info('Nie mo¿na zapisaæ zajêcia bez wyk³adowcy, grupy i zasobu');
     //result := false;
     // zajêcie bez LGS nie ma sensu, wyjscie z procedury.
     // @@@przydaloby sie ostrzezenie dla usera
     result := true;
     exit;
  end;

  if not canInsertClass ( myClass , currentClassId, resultMessage, true ) then
  begin
    info (resultMessage);
    Result := False;
    exit;
  end;
  if resultMessage<>'' then begin
    FWarning.showMessage('SkipCapacityOverflow', resultMessage);
  end;

  try
    with dmodule.QWork do begin
      SQL.Clear;

      SQL.Add(
		   'begin '+ cr+
		   ' planner_utils.insert_classes(:DAY,:HOUR,:FILL,:SUBJECT,:FORM,:OWNER,:LEC,:GRO,:RES,:COL,:DESC1,:DESC2,:DESC3,:DESC4,:ptt_comb_ids); '+ cr+
		   ' Upsert_Recently_Used_class (:ppla_id, :RUL, :RUG, :RUR, :RUS, :RUF); '+ cr+
		   'end;'
		   );

      parameters.ParamByName('HOUR').value    := myClass.hour;
      parameters.ParamByName('DAY').value     := timeStampTodateTime(myClass.day);
      parameters.ParamByName('FILL').value    := myClass.fill;
      if myClass.sub_id = 0 then parameters.ParamByName('SUBJECT').value := ''
                            else parameters.ParamByName('SUBJECT').value := myClass.sub_id;
      parameters.ParamByName('FORM').value    := myClass.for_id;
      parameters.ParamByName('OWNER').value   := myClass.owner;
      parameters.ParamByName('LEC').value     := myClass.calc_lec_ids;
      parameters.ParamByName('GRO').value     := myClass.calc_gro_ids;
      parameters.ParamByName('RES').value     := myClass.calc_rom_ids;
      parameters.ParamByName('COL').value     := myClass.class_colour;
      parameters.ParamByName('DESC1').value   := myClass.desc1;
      parameters.ParamByName('DESC2').value   := myClass.desc2;
      parameters.ParamByName('DESC3').value   := myClass.desc3;
      parameters.ParamByName('DESC4').value   := myClass.desc4;
      parameters.ParamByName('ptt_comb_ids').value := pttCombIds;

      parameters.ParamByName('PPLA_ID').value   := fmain.getUserOrRoleID;
      parameters.ParamByName('RUL').value     := myClass.calc_lec_ids;
      parameters.ParamByName('RUG').value     := myClass.calc_gro_ids;
      parameters.ParamByName('RUR').value     := myClass.calc_rom_ids;
      if myClass.sub_id = 0 then parameters.ParamByName('RUS').value := ''
                            else parameters.ParamByName('RUS').value := myClass.sub_id;
      parameters.ParamByName('RUF').value    := myClass.for_id;
      logSQLStart('insert_classes', dmodule.QWork.SQL.CommaText);
      execSQL;
      logSQLStop;
      result := true;

      Fmain.AutoSaveCounterDown := 10;
    end;
  except
    on E:exception do Begin
      Result := False;
      Dmodule.RollbackTrans;

      if Pos(sKeyViolation, E.Message)<>0 then
        info('Nie mo¿na zapisaæ '+fprogramsettings.profileObjectNameClassgen.text +' za wzglêdu na konflikt '+cr+cr+
              'Szczegó³y: ' + cr+ e.message)
      else if Pos('ORA-20000', E.Message)<>0 then
        //show user message only
        info('Nie mo¿na zapisaæ '+fprogramsettings.profileObjectNameClassgen.text +cr+cr+cr
              + Copy(e.message, Pos('ORA-20000', E.Message)+10, Pos(chr(10), E.Message)-10 ) )
      else
        info('Nie mo¿na zapisaæ '+fprogramsettings.profileObjectNameClassgen.text +' za wzglêdu na nieoczekiwany b³¹d w bazie danych'+cr+cr+cr+
              'Komunikat, który zwróci³a baza danych jest nastêpuj¹cy: ' + cr+ e.message);

    end;
  end;

  if quickInsertMode=false then
    with fmain do begin
      classByLecturerCaches.ResetByDay(myClass.day, myClass.hour);
      classByGroupCaches.ResetByDay(myClass.day, myClass.hour);
      classByRoomCaches.ResetByDay(myClass.day, myClass.hour);
      classByResCat1Caches.ResetByDay(myClass.day, myClass.hour);
      busyClassesCache.ClearCache;
    end;
end;

procedure TConvertGrid.setupGrid(periodId: String;  singleChartMode: boolean; resType : integer; searchText: String; var pcolCnt, prowCnt: integer);
var DateFrom, DateTo            : TDateTime;
    ObjIDs                      : Array of integer;
    ObjNames                    : Array of string;
    Len                         : integer;
Begin
  With DModule Do Begin
        Dmodule.SingleValue(CustomdateRange('SELECT TO_CHAR(DATE_FROM,''YYYY''),TO_CHAR(DATE_FROM,''MM''),TO_CHAR(DATE_FROM,''DD''),TO_CHAR(DATE_TO,''YYYY''),TO_CHAR(DATE_TO,''MM''),TO_CHAR(DATE_TO,''DD''), PERIODS.* FROM PERIODS WHERE ID='+periodId));
        DateFrom := EncodeDate(QWork.Fields[0].AsInteger,QWork.Fields[1].AsInteger,QWork.Fields[2].AsInteger);
        DateTo := EncodeDate(QWork.Fields[3].AsInteger,QWork.Fields[4].AsInteger,QWork.Fields[5].AsInteger);
  End;
  HOURS_PER_DAY := DModule.QWork.FieldByName('HOURS_PER_DAY').AsInteger;

  if (singleChartMode = FALSE) then begin
   Case resType Of
     0:With DModule do
           OPENSQL2(
             'SELECT   ID, '+sql_LECNAME+' NAME' + CR +
             'FROM LECTURERS ' + CR +
             'WHERE ROWNUM <= '+GetSystemParam('CrossTableMaxRows','20')+' AND ID IN (SELECT LEC_ID FROM LEC_PLA WHERE PLA_ID = '+fmain.getUserOrRoleID+') ' + CR +
             'AND '+fmain.getWhereFastFilter(searchText,'LECTURERS')+CR+
             'ORDER BY ABBREVIATION');
     1:With DModule do
           OPENSQL2(
             'SELECT   ID, '+sql_GRONAME+' NAME' + CR +
             'FROM GROUPS ' + CR +
             'WHERE ROWNUM <= '+GetSystemParam('CrossTableMaxRows','20')+' AND ID IN (SELECT GRO_ID FROM GRO_PLA WHERE PLA_ID = '+fmain.getUserOrRoleID+') ' + CR +
             'AND '+fmain.getWhereFastFilter(searchText,'GROUPS')+CR+
             'ORDER BY ABBREVIATION ');
     2:With DModule do
           OPENSQL2(
             'SELECT   ID, '+sql_ResCat0NAME+' NAME' + CR +
             'FROM ROOMS ' + CR +
             'WHERE ROWNUM <= '+GetSystemParam('CrossTableMaxRows','20')+' AND ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = '+fmain.getUserOrRoleID+') ' + CR +
             'AND '+fmain.getWhereFastFilter(searchText,'ROOMS')+CR+
             'ORDER BY NAME ');
     3:With DModule do
           OPENSQL2(
             'SELECT   ID, '+sql_ResCat1NAME+' NAME' + CR +
             'FROM ROOMS ' + CR +
             'WHERE ROWNUM <= '+GetSystemParam('CrossTableMaxRows','20')+' AND ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = '+fmain.getUserOrRoleID+') ' + CR +
               'AND RESCAT_ID='+nvl( dmodule.pResCatId1 ,'-1') + CR +
             'AND '+fmain.getWhereFastFilter(searchText,'ROOMS')+CR+
             'ORDER BY NAME ');
   end;
   if resType in [0,1,2,3] then begin
         With DModule do begin
           Len := 0;
           SetLength(ObjIDs, Len);
           SetLength(ObjNames, Len);
           While not QWork2.Eof do begin
             inc ( len );
             setLength(ObjIDs  , Len);
             setLength(ObjNames, Len);
             ObjIDs  [len - 1] := QWork2.FieldByName('ID').AsInteger;
             ObjNames[len - 1] := QWork2.FieldByName('NAME').AsString;
             QWork2.Next;
           end;
         end;
   end;
  end;


  With DModule.QWork Do
    if singleChartMode
      then initSingleChartMode(DateTimeToTimeStamp(DateFrom).Date, DateTimeToTimeStamp(DateTo).Date, pcolCnt, prowCnt, FieldByName('HOURS_PER_DAY').AsInteger,FieldByName('SHOW_MON').AsString='+',FieldByName('SHOW_TUE').AsString='+',FieldByName('SHOW_WED').AsString='+',FieldByName('SHOW_THU').AsString='+',FieldByName('SHOW_FRI').AsString='+',FieldByName('SHOW_SAT').AsString='+',FieldByName('SHOW_SUN').AsString='+')
      else initNOsingleChartMode(DateTimeToTimeStamp(DateFrom).Date, DateTimeToTimeStamp(DateTo).Date, pcolCnt, prowCnt, FieldByName('HOURS_PER_DAY').AsInteger,FieldByName('SHOW_MON').AsString='+',FieldByName('SHOW_TUE').AsString='+',FieldByName('SHOW_WED').AsString='+',FieldByName('SHOW_THU').AsString='+',FieldByName('SHOW_FRI').AsString='+',FieldByName('SHOW_SAT').AsString='+',FieldByName('SHOW_SUN').AsString='+', ObjIDs, ObjNames );
End;

function TConvertGrid.DateToColRow(var objId: integer; _Date,
  _Hour: Integer; var Col, Row: Integer): Boolean;
begin

 if convertMode= ConvSingleObject then begin
   result := convertSingleObject.DateToColRow(_Date, -1,  Col, Row);
 end else begin
   info('W tym widoku funkcja nie jest obslugiwana');
   result := false;
 end;



end;



initialization
  quickInsertMode    := false;
  CheckConflicts     := tCheckConflicts.create;
  convertGrid        := tConvertGrid.create;
  gridDefinition     := tGridDefinition.create;
end.

