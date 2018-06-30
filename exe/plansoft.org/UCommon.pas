unit UCommon;

interface

Uses DM, UUtilityParent, SysUtils, StdCtrls, StrUtils;


Procedure ValidValues(TableName : ShortString; Var Values: String; ValueColumn :String; Var IDs :String; const separator : char = ';');
procedure FChange(field, field_value : TEdit; SQLString : String; const separator : char = ';');
procedure GetEnabledLGR(ConLecturer, ConGroup, ConRoom, ConSubject, ConForm, Owner : String;
                        SingleClassContext : Boolean;
                        var CONDL, CONDG, CONDR : String;
                        pctAvailable : string;
                        const objectType : string = ''
                       );
function getWhereClause ( tableName  : string; const tableAlias : String = ''; const columnName : String = 'ID'): string;
function getWhereClausefromPeriod(periodSelector : string; const tablePrefix : String = '') : string;
function getResourcesByType(pResCatId : string; pResCatIds : string; pdesc : string) : string;
function repeatString(pStr : string; pcnt : integer; pSep : string) : string;

type TString = class(TObject)
   private
     fStr: String;
   public
     constructor Create(const AStr: String) ;
     property value: String read FStr write FStr;
   end;
function getCode ( pcombobox : tcombobox ) : shortString; overload;
function getValue ( pcombobox : tcombobox ) : shortString;
function getCode ( pcombobox : tcombobox; pindex : integer ) : shortString; overload;
function getItemIndex ( pcombobox : tcombobox; pcode : shortString ) : integer;

implementation

uses UFMain, db;

function getCode ( pcombobox : tcombobox ) : shortString;
begin
  if pcombobox.ItemIndex = -1 then exit;
  result := TString(pcombobox.Items.Objects[pcombobox.ItemIndex]).value;
end;

function getValue ( pcombobox : tcombobox ) : shortString;
begin
  if pcombobox.ItemIndex = -1 then exit;
  result := pcombobox.Items[pcombobox.ItemIndex];
end;

function getCode ( pcombobox : tcombobox; pindex: integer ) : shortString;
begin
  result := TString(pcombobox.Items.Objects[pindex]).value;
end;

function getItemIndex ( pcombobox : tcombobox; pcode : shortString ) : integer;
var t : integer;
begin
  result := -1;
  for t := 0 to pcombobox.Items.Count-1 do
    if getCode (pcombobox, t) = pcode then begin
      result := t;
      break;
    end;
end;

constructor TString.Create(const AStr: String) ;
begin
   inherited Create;
   FStr := AStr;
end;

//--------------------------------------------------------------------------------------
Procedure ValidValues(TableName : ShortString; Var Values: String; ValueColumn :String; Var IDs :String; const separator : char = ';');
Var t : Integer;
    Token      : String;
    TempValues : String;
    ID         : ShortString;
Begin
 IDs := '';
 TempValues := '';

 For t := 1 To WordCount(Values, [separator]) Do Begin
   Token := Trim(ExtractWord(t,Values, [separator]));
   if tableName='ROOMS' then
     if pos(' ',Token)=0 then Token := Token + ' ';
     If Not isBlank(Token) Then Begin
                            ID := DModule.SingleValue('SELECT ID,'+ValueColumn+' FROM '+TableName+' WHERE ('+getWhereClause(tableName)+') and upper('+ValueColumn+') =    '''+ansiUpperCase(Token)+'''');
       if  isBlank(ID) then ID := DModule.SingleValue('SELECT ID,'+ValueColumn+' FROM '+TableName+' WHERE ('+getWhereClause(tableName)+') and upper('+ValueColumn+') like '''+ansiUpperCase(Token)+'%'' order by '+ValueColumn);
       if  isBlank(ID) then ID := DModule.SingleValue('SELECT ID,'+ValueColumn+' FROM '+TableName+' WHERE ('+getWhereClause(tableName)+') and upper('+ValueColumn+') like ''%'+ansiUpperCase(Token)+'%'' order by '+ValueColumn);
         If Not isBlank(ID) Then Begin
         IDs        := Merge(IDs,ID, separator);
         TempValues := Merge(TempValues,dmodule.QWork.Fields[1].AsString, separator);
         End Else Begin
         //Info('Nie odnaleziono elementu "'+Token+'". Element zostanie usuniêty');
         End;
     End;
 End;
 Values := TempValues;
End;

//--------------------------------------------------------------------------------------
procedure FChange(field, field_value : TEdit; SQLString : String; const separator : char = ';');
Var t : Integer;
    value : String;
begin
  FIELD_VALUE.Text := '';
  For t := 1 To WordCount( field.Text,[ separator ]) Do Begin
   value := ExtractWord(t, field.Text, [ separator ]);
   field_value.Text := Merge( field_value.Text,DModule.SingleValue(SQLString+VALUE), separator);
  End;
end;



//--------------------------------------------------------------------------------------
procedure GetEnabledLGR
  (ConLecturer, ConGroup, ConRoom, ConSubject, ConForm, Owner : String;
   SingleClassContext : Boolean;
   var CONDL, CONDG, CONDR : String;
   pctAvailable : string;
   const objectType : string = ''
  );
Var sqlText : String;
begin
  CONDL := '';
  CONDG := '';
  CONDR := '';

  FMain.set_tmp_selected_dates;

  if (objectType = 'R') or (objectType = '') then begin
   if pctAvailable = '100' then
   sqlText :=
    'SELECT ID FROM ROOMS MINUS '+
    'SELECT DISTINCT ROM_ID '+
    'FROM ROM_CLA '+
    'WHERE ( ROM_CLA.DAY,ROM_CLA.HOUR ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''SESSIONID'') )'
   else
   sqlText :=
    'select id from rooms minus '+
    'select rom_id from '+
    '( '+
    'select count(1) '+
    '      ,x.rom_id '+
    '  from rom_cla x'+
    ' where 0=0 '+
    '   and ( x.day, x.hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''sessionid'') ) '+
    ' group by x.rom_id '+
    ' having planner_utils.get_classes_selected_count  = count(1)' +
    ' )';

    if (SingleClassContext) and (pctAvailable = '100')
      then CONDR := '(ROOMS.ID IN ('+sqlText+') AND ROOMS.ID NOT IN ('+SearchAndReplace(NVL(ConRoom,'-1'),';',',')+'))'
      else CONDR := ' ROOMS.ID IN ('+sqlText+')';
  end;

  if (objectType = 'G') or (objectType = '') then begin
   // the same for groups
   if pctAvailable = '100' then
   sqlText :=
    'SELECT ID FROM GROUPS MINUS '+
    'SELECT DISTINCT GRO_ID        '+
    'FROM   GRO_CLA   '+
    'WHERE ( GRO_CLA.DAY,GRO_CLA.HOUR ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''SESSIONID'') )'
   else
   sqlText :=
    'SELECT ID FROM GROUPS MINUS '+
    'select gro_id from '+
    '( '+
    'select count(1) '+
    '      ,x.gro_id '+
    '  from gro_cla x'+
    ' where 0=0 '+
    '   and ( x.day, x.hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''sessionid'') ) '+
    ' group by x.gro_id '+
    ' having planner_utils.get_classes_selected_count  = count(1)' +
    ' )';

    if (SingleClassContext) and (pctAvailable = '100')
      then CONDG := '(GROUPS.ID IN ('+sqlText+') AND GROUPS.ID NOT IN ('+SearchAndReplace(NVL(ConGroup,'-1'),';',',')+'))'
      else CONDG := ' GROUPS.ID IN ('+sqlText+')';

  end;

  if (objectType = 'L') or (objectType = '') then begin
   // the same for lecturers
   if pctAvailable = '100' then
   sqlText :=
    'SELECT ID FROM LECTURERS MINUS '+
    'SELECT DISTINCT LEC_ID        '+
    'FROM   LEC_CLA   '+
    'WHERE ( LEC_CLA.DAY,LEC_CLA.HOUR ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''SESSIONID'') )'
   else
   sqlText :=
    'SELECT ID FROM LECTURERS MINUS '+
    'select lec_id from '+
    '( '+
    'select count(1) '+
    '      ,x.lec_id '+
    '  from lec_cla x'+
    ' where 0=0 '+
    '   and ( x.day, x.hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''sessionid'') ) '+
    ' group by x.lec_id '+
    ' having planner_utils.get_classes_selected_count  = count(1)' +
    ' )';

    if (SingleClassContext) and (pctAvailable = '100')
      then CONDL := '(LECTURERS.ID IN ('+sqlText+') AND LECTURERS.ID NOT IN ('+SearchAndReplace(NVL(ConLecturer,'-1'),';',',')+'))'
      else CONDL := ' LECTURERS.ID IN ('+sqlText+')';
  end;
end;

//--------------------------------------------------------------------------------------
function getWhereClause ( tableName  : string; const tableAlias : String = ''; const columnName : String = 'ID' ): string;
 var tAlias : string;
begin
 tableName := UpperCase(tableName);
 tableName := replace(tableName,'PLANNER.','');
 result := '0=1';
 tAlias := tableAlias;
 if tAlias='' then tAlias := tableName;
 if tableName = 'LECTURERS' then result := tAlias+'.'+columnName+' IN (SELECT LEC_ID FROM LEC_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
 if tableName = 'GROUPS'    then result := tAlias+'.'+columnName+' IN (SELECT GRO_ID FROM GRO_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
 if tableName = 'ROOMS'     then result := tAlias+'.'+columnName+' IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
 if tableName = 'SUBJECTS'  then result := tAlias+'.'+columnName+' IN (SELECT SUB_ID FROM SUB_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
 if tableName = 'FORMS'     then result := tAlias+'.'+columnName+' IN (SELECT FOR_ID FROM FOR_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+')';
 if tableName = 'PERIODS'   then result := '0=0';
 if tableName = 'PLANNERS'  then result := '0=0';
 if result = '0=1' then SError('B³¹d programu - funkcja getWhereClause, wartoœæ ' + tableName);
end;

//--------------------------------------------------------------------------------------
var previousperiodSelector : string;
var previoustablePrefix : string;
var previousResult : string;
function getWhereClausefromPeriod(periodSelector : string; const tablePrefix : String = '') : string;
  var  HOURS_PER_DAY, DateFrom, DateTo : string;
       days : string;
  begin
    if  (periodSelector=previousperiodSelector) and (previoustablePrefix=tablePrefix) then begin
      result :=  previousResult;
      exit;
    end;

    days := '';
    result := '0=0';
    if periodSelector = '' then exit;

    With DModule Do Begin
      Dmodule.OPENSQL('SELECT min(TO_CHAR(DATE_FROM,''YYYY/MM/DD''))'+
                          ', max(TO_CHAR(DATE_TO,''YYYY/MM/DD''))'+
                          ', max(date_to-date_from)'+
                          ', min(DATE_FROM)'+
                          ', min(SHOW_MON) SHOW_MON'+
                          ', min(SHOW_TUE) SHOW_TUE'+
                          ', min(SHOW_WED) SHOW_WED'+
                          ', min(SHOW_THU) SHOW_THU'+
                          ', min(SHOW_FRI) SHOW_FRI'+
                          ', min(SHOW_SAT) SHOW_SAT'+
                          ', min(SHOW_SUN) SHOW_SUN'+
                          ', min(HOURS_PER_DAY) HOURS_PER_DAY '+
                          'FROM PERIODS WHERE '+ periodSelector );
      DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
      DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';

      if QWork.FieldByName('SHOW_MON').AsString = '+' then days := merge(days, '1', ',');
      if QWork.FieldByName('SHOW_TUE').AsString = '+' then days := merge(days, '2', ',');
      if QWork.FieldByName('SHOW_WED').AsString = '+' then days := merge(days, '3', ',');
      if QWork.FieldByName('SHOW_THU').AsString = '+' then days := merge(days, '4', ',');
      if QWork.FieldByName('SHOW_FRI').AsString = '+' then days := merge(days, '5', ',');
      if QWork.FieldByName('SHOW_SAT').AsString = '+' then days := merge(days, '6', ',');
      if QWork.FieldByName('SHOW_SUN').AsString = '+' then days := merge(days, '7', ',');
      if days = '1,2,3,4,5,6,7' then days := '';

      HOURS_PER_DAY := QWork.FieldByName('HOURS_PER_DAY').AsString;
    End;

    result := tablePrefix + 'DAY BETWEEN ' + DateFrom+' AND ' + DateTo + CR;
    result := merge(result, tablePrefix+'HOUR <=' + HOURS_PER_DAY, ' AND ');
    if not isBlank(days) then result := merge(result, 'TO_CHAR('+tablePrefix+'DAY,''D'') IN ('+days+')', ' AND ');
    result :=  '(' + result + ')';
    //
    previousperiodSelector :=  periodSelector;
    previoustablePrefix := tablePrefix;
    previousResult :=  result;
end;


//--------------------------------------------------------------------------------------
function getResourcesByType(pResCatId : string; pResCatIds : string; pdesc : string) : string;
var t : integer;
begin
 if pResCatId = 'ALL' then begin
   result := pdesc;
   exit;
 end;
 result := '';
 for t := 1 To WordCount(pResCatIds, [';']) Do
    if ExtractWord(t,pResCatIds,[';'])= pResCatId then
      result := merge( result, trim(ExtractWord(t,pdesc,[';'])), ';');
end;

//--------------------------------------------------------------------------------------
function repeatString(pStr : string; pcnt : integer; pSep : string) : string;
var t : integer;
begin
 result := '';
 for t := 1 to pcnt do begin
  result := merge(result, pStr, pSep);
 end;
end;






end.
