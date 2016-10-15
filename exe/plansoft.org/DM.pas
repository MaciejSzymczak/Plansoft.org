unit DM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, StrHlder, UUtilityParent, dbctrls, stdctrls, ADODB, DateUtils,
  OleServer, ExcelXP,
  UFormConfig, Buttons, ExtCtrls,  Grids, DBGrids,
  ComCtrls,  Menus,
  {used by export to excel} ActiveX, TlHelp32,  Variants;

Const MaxAllLecturers     =   5000;
      MaxAllGroups        =   5000;
      MaxAllRooms         =   3000;
      MaxAllRoles         =   2000;
      MaxAllPlanners      =    100;
      MaxAllSubjects      =   6000;
      MaxAllForms         =   3000;
      maxInClass          =     40; //maksymalna liczba obiektow w jednym zajeciu
      maxHours            =     60;

      gpassString         = 'SoftwareFactory';

      //have to be coherent with package tt_planner
      g_form              = -2;
      g_subject           = -3;
      g_lecturer          = -4;
      g_group             = -5;
      g_planner           = -6;
      g_period            = -7;
      g_date_hour         = -8;
      sql_LECNAME         = 'TITLE||'' ''||LAST_NAME||'' ''||FIRST_NAME';
      sql_LECNAMEORG      = 'TITLE||'' ''||LAST_NAME||'' ''||FIRST_NAME ||''   (''||(SELECT CODE FROM ORG_UNITS WHERE ID = ORGUNI_ID)||'')''';
      sql_GRONAME         = 'abbreviation';
      sql_ResCat0NAME     = 'NAME||'' ''||substr(attribs_01,1,55)';
      sql_ResCat1NAME     = 'NAME';
      sql_SUBNAME         = 'NAME';
      sql_FORNAME         = 'NAME||''(''||abbreviation||'')''';
      sql_PERNAME         = 'NAME';
      sql_PLANAME         = 'NAME';

      sql_LECDESC         = 'SELECT '+sql_LECNAME+    ' FROM LECTURERS WHERE ID=';
      sql_GRODESC         = 'SELECT '+sql_GRONAME+    ' FROM groups WHERE ID=';
      sql_ResCat0DESC     = 'SELECT '+sql_ResCat0NAME+' FROM ROOMS WHERE ID=';
      sql_ResCat1DESC     = 'SELECT '+sql_ResCat1NAME+' FROM ROOMS WHERE ID=';
      sql_SUBDESC         = 'SELECT '+sql_SUBNAME+    ' FROM SUBJECTS WHERE ID=';
      sql_FORDESC         = 'SELECT '+sql_FORNAME+    ' FROM FORMS WHERE ID=';
      sql_PERDESC         = 'SELECT '+sql_PERNAME+    ' FROM PERIODS WHERE ID=';
      sql_PLADESC         = 'SELECT '+sql_PLANAME+    ' FROM PLANNERS WHERE ID=';

      sql_TTRESCATDESC    = 'SELECT tt_planner.get_resource_cat_names (id) NAME FROM TT_RESCAT_COMBINATIONS WHERE ID=';

      ClassNotFound  =    0;
      ClassFound     =    1;
      ClassError     =    2;

      bool_reloadFromDatbase = true;
      bool_NOTreloadFromDatbase = false;


Type
     TColors = Array[0..maxInClass] Of integer;

type
  TDModule = class(TDataModule)
    AdditionalPerrmisions: TStrHolder;
    ADOConnection: TADOConnection;
    QWork: TADOQuery;
    QWork2: TADOQuery;
    QWork3: TADOQuery;
    ExcelApplication1: TExcelApplication;
    procedure DatabaseLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Private declarations }
  public
    pResCatId0   : string[50];
    pResCatName0 : string[255];
    pResCatId1   : string[50];
    pResCatName1 : string[255];
    dateRange    : string[50];

    pAbolitionTime: string[30];
    procedure loadMap(sqlString : string; map : tmap; lpadKey : boolean);
    Function LecturerGetColour(ID : string) : integer;
    Function GroupGetColour(ID : string) : Integer;
    Function RoomGetColour(ID : string) : Integer;
    Procedure SQL         (var query : tadoquery;S : String; const pparams : String = ''); overload;
    Procedure SQL         (S : String; const pparams : String = ''); overload;
    Procedure SQL2        (S : String; const pparams : String = '');
    Procedure openSQL     (var query : tadoquery; S : String; const pparams : String = ''); overload;
    Procedure openSQL     (S : String; const pparams : String = '');                 overload;
    Procedure openSQL2    (S : String; const pparams : String = '');
    Procedure openSQL3    (S : String; const pparams : String = '');
    Function  SingleValue (S : String; const pparams : String = '') : String;
    Function  SingleValue2(S : String; const pparams : String = '') : String;
    Function  SingleValueParamDateTime(S : String; const paramName : String ; paramValue : tDateTime) : String;
    Function  recordSetIsEmpty(S : String) : Boolean;

    Procedure InsertIntoEventLog(OWNER, KIND, MODULE, PARAM_1, COMMENT_1, COMMENT_2, COMMENT_3, SQL_COMMAND, USERNAME  : String);
    Procedure RefreshLookupEdit(S : TForm; DBEditName, DisplayField, TableName, WhereClause : String);
    function  getDBType : string;

    procedure CloseDBConnection;
    function  commitTrans : boolean;
    procedure RollbackTrans;

    procedure resetConnection ( var q : tadoQuery );
    procedure createQuery     ( var q : tadoQuery );

    function  dbGetSystemParam(Name : ShortString) : ShortString; overload;
    function  dbgetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString; overload;
    procedure dbSetSystemParam(Name, Value : ShortString);
    function  dbEncGetSystemParam(Name : ShortString) : ShortString; overload;
    function  dbEncGetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString; overload;
    Procedure dbEncSetSystemParam(Name, Value : ShortString);
    procedure generateGrid ( pnos, phours_from, phours_to : array of string );
    function  CustomdateRange(s : string):string;
    Procedure ExportToExcel(aGrid : TDBGrid );
  end;

type TMacros = class ( Tobject )
       QueriesCnt : integer;
       Queries : Array[1..1000] of record
                  Q : TAdoQuery;
                  sql : tstrings;
                  macroCnt : integer;
                  macros : array[1..100] of record
                    name : string;
                    value : string;
                  end;
                 end;
       private
        function findQuery(query : tadoquery) : integer;
        function registerQuery (query : tadoquery) : integer;
        procedure parseMacros(query : tadoquery);
        procedure addMacro (query : tadoquery; macroName, macroValue : string);
       public
        procedure init;
        procedure setMacro ( query : tadoquery; macroName, macroValue : string );
     end;

type TDBMamp = class ( tobject )
        cnt : integer;
        messages : array[1..1000] of record
                     abbr    : string[30];
                     message : string[200];
                   end;
        procedure init;
        procedure addMessage(abbr : string; message : string);
        function get(inMessage : string; var outMessage : string) : boolean;
     end;

var
  DModule: TDModule;
  UserName, Password, DBname : String;

Procedure logSQLStart (pprocedureName : string; pSQL : string);
procedure logSQLStop;
function getResultByComma(Query: TADOQuery) : String;
function ExactlyLocate(Q : TadoQuery; KeyField: string; KeyValue: String; MaxFetches : Integer): Boolean;

//function elementEnabled(elementName : string; daysLimit : integer) : boolean;
function elementEnabled(elementName : string; toDate : string; silentMode : boolean) : boolean;


var Macros     : TMacros;
    DBMap : TDBMamp;

implementation

uses UFProgramSettings, UFMain;

{$R *.DFM}

var StartTime, EndTime : TDateTime;

//----------------------------------------------------------------
function elementEnabled(elementName : string; toDate : string; silentMode : boolean) : boolean;
 var installMarker : string;
     //installDate   : integer;
     //daysRemaining : integer;
     //todayMarker   : integer;
begin
    result := true;
    if dmodule.pAbolitionTime <> '' then begin
      if copy(dmodule.pAbolitionTime,5,1) <> '.' then begin
        serror('Wykryto próbê ominiêcia zabezpieczeñ programu - abolition time. Uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia');
        dmodule.CloseDBConnection;
        halt;
      end;
      if toDate < dmodule.pAbolitionTime then exit; //yyyy.mm.dd
    end;

    installMarker := encGetSystemParam('installMarker');

    if getTerminalName <> extractWord(2,installMarker,[';']) then begin
      serror('Wykryto próbê ominiêcia zabezpieczeñ programu (4). Uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia getTerminalName='+getTerminalName+' installMarker=' + installMarker);
      dmodule.CloseDBConnection;
      halt;
    end;

    //installDate := strToInt ( nvl( extractWord(1,installMarker,[';']), '0') );
    //todayMarker := datetimeToTimeStamp ( DateUtils.Today ).Date;
    //daysRemaining := installDate + daysLimit - todayMarker;

    if not ( currentYear + '.' + currentMonth + '.' + currentDay > toDate )  then begin
      if not silentMode then info(elementName + ' to demonstracyjny element programu, który jest dostêpny do dnia '+toDate+'. Mo¿esz korzystaæ z tej funkcji do tego dnia ', showMonthly, elementName);
    end else begin
      //if GetTerminalName = 'SOFT' then exit;
      if not silentMode then warning( 'Uruchomiono demonstracyjn¹ wersjê elementu: '+elementName+'. Nie mo¿esz ju¿ korzystaæ z tej funkcji. Skontaktuj siê z dostawc¹ oprogramowania');
      result := false;
    end;
end;

{
function elementEnabled(elementName : string; daysLimit : integer) : boolean;
 var installMarker : string;
     installDate   : integer;
     daysRemaining : integer;
     todayMarker   : integer;
begin
    result := true;
    installMarker := encGetSystemParam('installMarker');

    if getTerminalName <> extractWord(2,installMarker,[';']) then begin
      serror('Wykryto próbê ominiêcia zabezpieczeñ programu (4). Uruchomienie programu nie bêdzie mo¿liwe do czasu, gdy nie zostan¹ przywrócone poprzednie ustawienia getTerminalName='+getTerminalName+' installMarker=' + installMarker);
      dmodule.CloseDBConnection;
      halt;
    end;

    installDate := strToInt ( nvl( extractWord(1,installMarker,[';']), '0') );
    todayMarker := datetimeToTimeStamp ( DateUtils.Today ).Date;
    daysRemaining := installDate + daysLimit - todayMarker;
    if daysRemaining > 0 then begin
      info(elementName + ' to demonstracyjny element programu, który jest dostêpny przez '+intToStr(daysLimit)+' dni od czasu uruchomienia programu. Mo¿esz korzystaæ z tej funkcji jeszcze przez nastêpuj¹c¹ liczbê dni: ' + intToStr(daysRemaining), showOneTimeaDay, elementName);
    end else begin
      warning('Uruchomiono demonstracyjn¹ wersjê elementu: '+elementName+'. Nie mo¿esz ju¿ korzystaæ z tej funkcji, poniewa¿ minê³o '+intToStr(daysLimit)+' dni od dnia, kiedy program zosta³ zainstalowany. Skontaktuj siê z dostawc¹ oprogramowania');
      result := false;
    end;
end;
}

// macro implementation
////////////////////////////////////////////////////////

//----------------------------------------------------------------
procedure TMacros.init;
begin
 QueriesCnt := 0;
end;

//----------------------------------------------------------------
function TMacros.findQuery(query : tadoquery) : integer;
var t : integer;
begin
 for t := 1 to QueriesCnt do begin
   if  Queries[t].Q = query then begin
     result := t;
     exit;
   end;
 end;
 result := -1;
end;

//----------------------------------------------------------------
function TMacros.registerQuery (query : tadoquery) : integer;
var t : integer;
begin
 t := findQuery(query);
 if t <> -1 then begin result := t; exit; end;

 QueriesCnt := QueriesCnt + 1;
 with Queries[QueriesCnt] do begin
  Q := query;
  sql      := TStringList.Create;
  sql.Assign ( query.sql );
  macroCnt := 0;
 end;
 result := QueriesCnt;
end;

//----------------------------------------------------------------
procedure TMacros.addMacro (query : tadoquery; macroName, macroValue : string);
var t,m : integer;
begin
 t := registerQuery (query);

 for m := 1 to Queries[t].macroCnt do begin
   if  Queries[t].macros[m].name = macroName then
   begin
     Queries[t].macros[m].value := macroValue;
     exit;
   end;
 end;
 Queries[t].macroCnt := Queries[t].macroCnt + 1;
 m := Queries[t].macroCnt;
 Queries[t].macros[m].name  := macroName;
 Queries[t].macros[m].value := macroValue;
end;

//----------------------------------------------------------------
procedure TMacros.parseMacros( query : tadoquery);
var t,m : integer;
    tempsql : tstrings;
begin
 t := findQuery (query);

 tempsql := TStringList.Create;
 tempsql.Assign( Queries[t].sql );

 for m := 1 to Queries[t].macroCnt do begin
  tempsql.Text := StringReplace(tempsql.Text, Queries[t].macros[m].name, Queries[t].macros[m].value, [rfReplaceAll, rfIgnoreCase]);
  //tempsql.Text := searchAndReplace(tempsql.Text, lowerCase( Queries[t].macros[m].name ), Queries[t].macros[m].value );
  //tempsql.Text := searchAndReplace(tempsql.Text, upperCase( Queries[t].macros[m].name ), Queries[t].macros[m].value );
 end;
  //info(tempsql.CommaText + Queries[t].macros[m].name + Queries[t].macros[m].value );

 dmodule.resetConnection ( queries[t].Q );
 queries[t].Q.SQL.text := tempsql.text;

 tempsql.Free;
end;

//----------------------------------------------------------------
procedure TMacros.setMacro ( query : tadoquery; macroName, macroValue : string );
begin
 addMacro(query,'%'+lowerCase( macroName ) ,macroValue);
 parseMacros(query);
end;

////////////////////////////////////////////////////////

//----------------------------------------------------------------
procedure TDBMamp.init;
var lmeaning : string;
begin
  cnt := 0;
  //
  dmodule.openSQL('select code, meaning from lookups where lookup_type = ''DBMESSAGE_TRANSLATION'' order by 1');
  with dmodule.QWork do begin
    first;
    while not Eof do
    begin
      lmeaning := fieldByName('MEANING').AsString;
      lmeaning := fprogramSettings.translateMessages(lmeaning);
      DBMap.addMessage( fieldByName('CODE').AsString  , lmeaning );
      next;
    end;
    close;
  end;
  //
  dmodule.openSQL('select pattern_code, id from forms where pattern_code is not null');
  with dmodule.QWork do begin
    first;
    while not Eof do
    begin
      DBMap.addMessage( fieldByName('pattern_code').AsString  , fieldByName('id').AsString );
      next;
    end;
    close;
  end;
end;

//----------------------------------------------------------------
procedure TDBMamp.addMessage(abbr : string; message : string);
begin
 inc( cnt );
 messages[cnt].abbr    := abbr;
 messages[cnt].message := message;
end;

//----------------------------------------------------------------
function  TDBMamp.get(inMessage : string; var outMessage : string) : boolean;
var t : integer;
begin
  for t := 1 to cnt do begin
    if Pos( messages[t].abbr , inMessage )<>0 then begin
      outMessage := messages[t].message;
      result := true;
      exit;
    end;
  end;
  result := false;
end;

//----------------------------------------------------------------
Procedure logSQLStart (pprocedureName : string; pSQL : string);
begin
 //if not assigned ( FProgramSettings ) then exit;
  StartTime := Now;
 if FProgramSettings.SQLLog.checked then
  writeLog (GetNowMarker + ' start : ' + pprocedureName + ' : ' + pSQL + ' ');
end;

//----------------------------------------------------------------
procedure logSQLStop;

  function AsString(I: Extended): string;
  var
    S: Shortstring;
  begin
    I := I * 100 * 60 * 24;
    Str(I:5:5, S);
    Result:=S;
    if I>1 then Result:= Result + ' : ??? ';
  end;

begin
 //if not assigned ( FProgramSettings ) then exit;
 EndTime := Now;
 if FProgramSettings.SQLLog.checked then
  writeLog (GetNowMarker + ' stop : ' + AsString(EndTime - StartTime) );
end;


//----------------------------------------------------------------
Procedure TDModule.SQL(S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 logSQLStart ('SQL', S);
 With Dmodule.QWork Do Begin
  SQL.Clear;
  //param check must be set false when you are trying to install package which contains characters : inside the body
  ParamCheck := pparams<>'';
  SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := searchAndReplace ( paramValue , '!chr(61)', '=') ;
   end;
  ExecSQL;
  //revert original settings
  ParamCheck := true;
 End;
 logSQLStop;
End;

//----------------------------------------------------------------
Procedure TDModule.SQL(var query : tadoquery; S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 logSQLStart ('SQL', S);
 query.Connection      := ADOConnection;
 query.CursorLocation  := clUseServer;
 With query Do Begin
  SQL.Clear;
  SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
  ExecSQL;
 End;
 logSQLStop;
End;

//----------------------------------------------------------------
Procedure TDModule.SQL2(S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 logSQLStart ('SQL2', S);
 With Dmodule.QWork2 Do Begin
  SQL.Clear;
  SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
  ExecSQL;
 End;
 logSQLStop;
End;

//----------------------------------------------------------------
Procedure TDModule.openSQL(S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 //2011.05.14 to aviod problem "object was open"
 resetConnection ( Dmodule.QWork );

 if pparams <> '' then logSQLStart ('openSQL', S + ' : params = ' + pparams)
                  else logSQLStart ('openSQL', S);
 With Dmodule.QWork Do Begin
   SQL.Clear;
   SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
   open;
 End;
 logSQLStop;
End;

//----------------------------------------------------------------
Procedure TDModule.openSQL(var query : tadoquery; S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
  query.Connection      := ADOConnection;
  query.CursorLocation  := clUseServer;

 //this causes error 216 during closing appl !
 if pparams <> '' then logSQLStart ('openSQL', S + ' : params = ' + pparams)
                  else logSQLStart ('openSQL', S);
 With query Do Begin
   SQL.Clear;
   SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
   open;
 End;
 logSQLStop;
End;


//----------------------------------------------------------------
Procedure TDModule.openSQL2(S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 if pparams <> '' then logSQLStart ('openSQL2', S + ' : params = ' + pparams)
                  else logSQLStart ('openSQL2', S);
 With Dmodule.QWork2 Do Begin
   SQL.Clear;
   SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
   open;
 End;
 logSQLStop;
End;

//----------------------------------------------------------------
Procedure TDModule.openSQL3(S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 if pparams <> '' then logSQLStart ('openSQL3', S + ' : params = ' + pparams)
                  else logSQLStart ('openSQL3', S);
 With Dmodule.QWork3 Do Begin
   SQL.Clear;
   SQL.Add(S);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
   open;
 End;
 logSQLStop;
End;


//----------------------------------------------------------------
Function  TDModule.SingleValueParamDateTime(S : String; const paramName : String ; paramValue : tDateTime) : String;
Begin
 logSQLStart ('singleValue', S);
 With Dmodule.QWork Do Begin
   SQL.Clear;
   SQL.Add(S);
     //http://edn.embarcadero.com/tw/article/20420
     Parameters.ParseSQL(SQL.Text, True);
     parameters.ParamByName(paramName).value   := paramValue;
   Open;
   Result := Fields[0].AsString;
 end;
 logSQLStop;
End;


//----------------------------------------------------------------
procedure tdmodule.resetConnection ( var q : tadoQuery );
begin
 //2011.05.14 to aviod problem "object was open"
 //http://www.delphigroups.info/2/6/298577.html
 Q.close;
 Q.connection := nil;
 Q.connection := dm.dmodule.ADOConnection;
end;


//----------------------------------------------------------------
procedure tdmodule.createQuery ( var q : tadoQuery );
begin
 //if assigned(q) then begin
 //  q.Close;
 //  q.Free;
 //end;
 q := tadoquery.Create(self);
 q.Connection      := ADOConnection;
 q.CursorLocation  := clUseServer;
end;


//----------------------------------------------------------------
Function  TDModule.SingleValue(S : String; const pparams : String = '') : String;
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 logSQLStart ('singleValue', S);

 //2011.05.14 to aviod problem "object was open"
 resetConnection ( Dmodule.QWork );

 Dmodule.QWork.Close;
 With Dmodule.QWork Do Begin
   SQL.Clear;
   SQL.Add(S);
   Parameters.ParseSQL(SQL.Text, True);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
   Open;
   Result := Fields[0].AsString;
 end;

 logSQLStop;
End;


//----------------------------------------------------------------
Function  TDModule.SingleValue2(S : String; const pparams : String = '') : String;
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 logSQLStart ('singleValue2', S);
 With Dmodule.QWork2 Do Begin
   SQL.Clear;
   SQL.Add(S);
   Parameters.ParseSQL(SQL.Text, True);
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     parameters.ParamByName(paramName).value   := paramValue;
   end;
   Open;
 end;
 Result := QWork2.Fields[0].AsString;
 logSQLStop;
End;

//----------------------------------------------------------------
Function  TDModule.recordSetIsEmpty(S : String) : Boolean;
Begin
 OPENSQL(S);
 Result := QWork.IsEmpty;
 QWork.Close;
End;


//----------------------------------------------------------------
procedure TDModule.DatabaseLogin(Database: TDatabase;
  LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := UserName;
  LoginParams.Values['PASSWORD']  := Password;
end;

//----------------------------------------------------------------
Procedure TDModule.InsertIntoEventLog(OWNER, KIND, MODULE, PARAM_1, COMMENT_1, COMMENT_2, COMMENT_3, SQL_COMMAND, USERNAME  : String);
  Function FormatString(S : String) : String;
  Var S2 : String;
      t  : Integer;
  Begin
   S2 := '';
   For t := 1 To Length(S) Do
    If S[t] = '''' Then
      S2 := S2 + S[t]+S[t]
    Else S2 := S2 + S[t];

   Result := ''''+S2+'''';
  End;
Begin
 KIND        := FormatString(KIND);
 MODULE      := FormatString(MODULE);
 PARAM_1     := FormatString(PARAM_1);
 COMMENT_1   := FormatString(COMMENT_1);
 COMMENT_2   := FormatString(COMMENT_2);
 COMMENT_3   := FormatString(COMMENT_3);
 SQL_COMMAND := FormatString(SQL_COMMAND);

 IF USERNAME = '' Then USERNAME := 'USER'
                  Else USERNAME := FormatString(USERNAME);
 Try
  SQL('INSERT INTO '+OWNER+'.EVENTLOG (ID,KIND, MODULE, PARAM_1, COMMENT_1, COMMENT_2, COMMENT_3, SQL_COMMAND, USERNAME) VALUES ('+OWNER+'.ELO_SEQ.NEXTVAL,'+KIND+','+MODULE+','+PARAM_1+','+COMMENT_1+','+COMMENT_2+','+COMMENT_3+','+SQL_COMMAND+','+USERNAME+')');
 Except
  Try
    SQL('INSERT INTO '+OWNER+'.EVENTLOG (ID,KIND, MODULE, PARAM_1, COMMENT_1, COMMENT_2, COMMENT_3, SQL_COMMAND, USERNAME) VALUES ('+OWNER+'.ELO_SEQ.NEXTVAL,''INSERT_LOG_FAIL'','+MODULE+','+''''''+','+KIND+','+''''''+','+''''''+','+''''''+','+USERNAME+')');
  Except
     //silent
     //SError('Nastapi³ b³¹d podczas próby odnotowania b³êdu w Dzienniku zdarzeñ');
  End;
 End;
End;

//----------------------------------------------------------------
Procedure TDModule.RefreshLookupEdit(S : TForm; DBEditName, DisplayField, TableName, WhereClause : String);
Var DBEdit     : TDBEdit;
    Edit       : TEdit;
    Edit_Value : TEdit;
Begin

  Edit_Value   := TEdit(S.FindComponent(DBEditName+'_VALUE'));

  If S.FindComponent(DBEditName) is TDBEdit Then Begin
    DBEdit := TDBEdit(S.FindComponent(DBEditName));
    If WhereClause = '' Then WhereClause := 'ID='+DBEdit.TEXT
                        Else WhereClause := WhereClause;
    If Trim(DBEdit.TEXT) <> '' Then Edit_Value.Text := SingleValue('SELECT '+DisplayField+' FROM '+TableName+' WHERE '+WhereClause)
                               Else Edit_Value.Text := '-';
  End Else Begin
   Edit := TEdit(S.FindComponent(DBEditName));
   If WhereClause = '' Then WhereClause := 'ID='+Edit.TEXT
                       Else WhereClause := WhereClause+Edit.TEXT;

   If Trim(Edit.TEXT) <> '' Then Edit_Value.Text := SingleValue('SELECT '+DisplayField+' FROM '+TableName+' WHERE ID='+Edit.TEXT)
                            Else Edit_Value.Text := '-';
  End;
End;

//----------------------------------------------------------------
function TDModule.getDBType : string;
begin
 if copy(ADOConnection.Provider,1,8) = 'OraOLEDB'
   then result := 'ORACLE'
   else result := ADOConnection.Provider;
end;

//----------------------------------------------------------------
Function GetResultByComma(Query: TADOQuery) : String;
Begin
 Result := '';
 Query.First;
 While Not Query.Eof Do Begin
   Result := Merge(Result, Query.Fields[0].AsString, ',');
   Query.Next;
 End;
End;

//----------------------------------------------------------------
function ExactlyLocate(Q : TadoQuery; KeyField: string; KeyValue: String; MaxFetches : Integer): Boolean;
Var Counter : Integer;
Begin
 If KeyValue = '' Then Begin Result := True; Exit; End;
 KeyValue := UpperCase(KeyValue);
 Counter  := 0;
 Q.DisableControls;
 Q.First;
 while (not Q.EOF) AND (KeyValue <> Q.FieldByName(KeyField).AsString) AND (Counter < MaxFetches) do
 begin
   Inc(Counter);
   Q.Next;
 end;
 Q.EnableControls;
 If Counter < MaxFetches Then Result := True Else Result := False;
End;

//----------------------------------------------------------------
procedure tdmodule.CloseDBConnection;
begin
 with dmodule.ADOConnection do
 begin
  if dmodule.ADOConnection.InTransaction then begin
   try
     CommitTrans;
   except
     info('Brak po³¹czenia z baz¹ danych, zmiany mog³y zostaæ nie zapisane. Proszê ponownie uruchomiæ program');
   end;
   //Attributes :=  dmodule.ADOConnection.Attributes - [xaCommitRetaining];
   //Attributes :=  dmodule.ADOConnection.Attributes - [xaAbortRetaining];
   //try
   //  CommitTrans;
   //except
   //end;
   dModule.ADOConnection.close;
  end;
 end;
end;


//----------------------------------------------------------------
function tdmodule.CommitTrans : boolean;
begin
 with dmodule.ADOConnection do
 begin
  if dmodule.ADOConnection.InTransaction then begin
   try
     CommitTrans;
     BeginTrans;
     logSQLStart('CommitTrans', 'CommitTrans');
     result := true;
   except
     info('Brak po³¹czenia z baz¹ danych, zmiany mog³y nie zostaæ zapisane');
     result := false;
   end;
  end;
 end;
end;

//----------------------------------------------------------------
procedure TDModule.RollbackTrans;
begin
  if dmodule.ADOConnection.InTransaction then begin
    Dmodule.ADOConnection.RollbackTrans;
    Dmodule.ADOConnection.BeginTrans;
    logSQLStart('RollbackTrans', 'RollbackTrans');
  end;
end;

procedure tdmodule.loadMap(sqlString : string; map : tmap; lpadKey : boolean);
begin
  map.init(lpadKey);
  with dmodule do begin
    DModule.openSQL(sqlString);
    while not QWork.Eof do begin
      map.addKeyValue(qwork.Fields[0].AsString, qwork.Fields[1].AsString);
      qwork.Next;
    end;
    map.prepare;
  end;
end;

//----------------------------------------------------------------
Function TDModule.LecturerGetColour(ID : string) : Integer;
Var resString : string;
Begin
  resString := FMain.MapLecColors.getValue(id);
  if resString='' then begin
    dmodule.loadMap('select id,NVL(COLOUR,0) from lecturers order by id', Fmain.MapLecColors, true);
    resString := FMain.MapLecColors.getValue(id);
  end;
  result := strtoInt (nvl(resString,'0'));
End;

//----------------------------------------------------------------
Function TDModule.GroupGetColour(ID : string) : Integer;
Var resString : string;
Begin
  resString := FMain.MapGroColors.getValue(id);
  if resString='' then begin
    dmodule.loadMap('select id,NVL(COLOUR,0) from groups order by id', Fmain.MapGroColors, true);
    resString := FMain.MapGroColors.getValue(id);
  end;
  result := strtoInt (nvl(resString,'0'));
End;

//----------------------------------------------------------------
Function TDModule.RoomGetColour(ID : string) : Integer;
Var resString : string;
Begin
  resString := FMain.MapRomColors.getValue(id);
  if resString='' then begin
    dmodule.loadMap('select id,NVL(COLOUR,0) from rooms order by id', Fmain.MapRomColors, true);
    resString := FMain.MapRomColors.getValue(id);
  end;
  result := strtoInt (nvl(resString,'0'));
End;

//----------------------------------------------------------------
function  TDModule.dbGetSystemParam(Name : ShortString) : ShortString;
begin
 result := dmodule.SingleValue('select value from system_parameters where name = :paramName', 'paramName='+Name);
end;

//----------------------------------------------------------------
function  TDModule.dbgetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString;
begin
 result := nvl( dmodule.SingleValue('select value from system_parameters where name = :paramName', 'paramName='+Name), defaultValue);
end;

//----------------------------------------------------------------
Procedure TDModule.dbSetSystemParam(Name, Value : ShortString);
begin
 dmodule.SQL(
 'merge into system_parameters s'+cr+
   'using (select :name name, :value value from dual) new'+cr+
   'on (s.name = new.name)'+cr+
 'when matched then'+cr+
   'update set s.value = new.value'+cr+
 'when not matched then'+cr+
   'insert (s.name, s.value)'+cr+
   'values (new.name, new.value)'
 , 'name='+name+';value='+value);
end;

//----------------------------------------------------------------
function  TDModule.dbEncGetSystemParam(Name : ShortString) : ShortString;
begin
  result := DecryptShortString (1, dbGetSystemParam(name) , gpassString) ;
end;

//----------------------------------------------------------------
function  TDModule.dbEncGetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString;
begin
  result := DecryptShortString (1, dbGetSystemParam(name, defaultValue) , gpassString) ;
end;

//----------------------------------------------------------------
Procedure TDModule.dbEncSetSystemParam(Name, Value : ShortString);
begin
 DbSetSystemParam(Name, EncryptShortString(1,Value, gpassString));
end;


//----------------------------------------------------------------
procedure TDModule.generateGrid ( pnos, phours_from, phours_to : array of string );
var t,v : integer;
var s : string;
var content : string;
begin
  v := 1;
  for t := low(pnos) to high(pnos) do begin
    content := content + 'insert into grids (id, no, caption, hour_from, hour_to, duration) values (main_seq.nextval, '+intTostr(v)+', '''+pnos[t]+''', '''+phours_from[t]+''', '''+phours_to[t]+''', 1);'+cr;
    inc ( v );
  end;
  s :=
    'begin'+cr+
    'delete from grids;'+cr+
    content+cr+
    'commit;'+cr+
    'end;';
  dmodule.SQL(s);
end;

//'TODAY:+1:+7'
function TDModule.CustomdateRange(s: string): string;
var command : shortString;
    days   : shortString;
    duration   : shortString;
begin
 command := extractWord(1,dateRange,[':']);
 days := extractWord(2,dateRange,[':']);
 duration := nvl(extractWord(3,dateRange,[':']),'+0');
 result := uppercase(s);
 if command = 'TODAY' then begin
   result := replace(result,'DATE_TO-DATE_FROM',duration);
   result := replace(result,'(DATE_FROM','(TRUNC(SYSDATE'+days+')');
   result := replace(result,'(DATE_TO','(TRUNC(SYSDATE'+days+duration+')');
   result := replace(result,'DATE_FROM','TRUNC(SYSDATE'+days+') DATE_FROM');
   result := replace(result,'DATE_TO','TRUNC(SYSDATE'+days+duration+') DATE_TO');
 end;
end;

Procedure TDModule.ExportToExcel(aGrid : TDBGrid );
    var FileName : string;
        aQuery : TADOQuery;

    Procedure doExport;
    var LineNumber, LCID : Integer;
        LineString : string;
        t : integer;
        index : integer;
        rangeTo : string;
        headers : array of variant;
        //
        Field            : OleVariant;
        Criteria1        : OleVariant;
        Operator         : TOleEnum; //  ActiveX, OfficeXP, StdVCL, VBIDEXP;
        Criteria2        : OleVariant;
        VisibleDropDown  : OleVariant;
          {-----------------------------------}
          function excelIsRunning : boolean;
          var
            Uchwyt:tHandle;
            Proces:tProcessEntry32;
          begin
            result := false;
            Uchwyt:=CreateToolHelp32SnapShot(TH32CS_SNAPALL,0);
            Proces.dwSize:=SizeOf(Proces);
            if Integer(Process32First(Uchwyt,Proces))<>0 then
            repeat
              if uppercase(Proces.szExeFile) = 'EXCEL.EXE' then
              begin
                result := true;
                exit;
              end;
            until Integer(Process32Next(Uchwyt,Proces))=0;
            closehandle(Uchwyt);
          end;
          {-----------------------------------}
          function getExcelColName ( colNum : integer) : string;
          var char1 : string[1];
              char2 : string[1];
          begin
            if colNum > 26
              then char1 := char (( (colNum-1) div 26) + 64)
              else char1 := '';
            char2 := char (( (colNum-1) mod 26) + 65);
            result := char1 + char2;
          end;
    
    begin
          //if excelIsRunning then begin
          //  showMessage ('Wy³¹cz program Excel i wykonaj operacjê ponownie');
          //  exit;
          //end;

          //DeleteFile( FileName );
          LCID := GetUserDefaultLCID;
          with ExcelApplication1 do
          begin
            connect;
            try
              visible[LCID] := true;
              Workbooks.Add(EmptyParam,LCID);

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    inc ( index );
                end;;

              rangeTo := getExcelColName ( index );
              setlength(headers, index);

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    headers[index] := agrid.Columns[t].Title.Caption;
                    inc ( index );
                end;;

              Range['A1',rangeTo+'1'].Value2 := headers;

              with Range['A1',rangeTo+'1'] do
              begin
                HorizontalAlignment := xlcenter;
                VerticalAlignment := xlBottom;
                Wraptext := false;
                Orientation := 0;
                ShrinkTofit := false;
                MergeCells := false;
                Font.Bold := true;
              end;

              LineNumber := 1;
              aQuery.First;
              While not aQuery.Eof do
              begin
                Inc(lineNumber);

                index := 0;
                for t := 0 to agrid.Columns.Count-1 do
                  if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                  if aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).IsNull then
                    headers[index] := ''
                  else
                    Case aGrid.Columns.Items[t].Field.DataType of
                      //ftUnknown    : ;
                      ftString     : headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                      //ftSmallint   : ;
                      //ftInteger    : ;
                      //ftWord       : ;
                      //ftBoolean    : ;
                      //ftFloat      : ;
                      //ftCurrency   : ;
                      //ftBCD        : ;
                      //ftDate       : ;
                      //ftTime       : ;
                      ftDateTime   : headers[index] := FormatDateTime('yyyy-mm-dd', aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value );
                      //ftBytes      : ;
                      //ftVarBytes   : ;
                      //ftAutoInc    : ;
                      //ftBlob       : ;
                      //ftMemo       : ;
                      //ftGraphic    : ;
                      //ftFmtMemo    : ;
                      //ftParadoxOle : ;
                      //ftDBaseOle   : ;
                      //ftTypedBinary: ;
                      //ftCursor     : ;
                      //ftFixedChar  : ;
                      ftWideString : headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                      //ftLargeint   : ;
                      //ftADT        : ;
                      //ftArray      : ;
                      //ftReference  : ;
                      //ftDataSet    : ;
                      //ftOraBlob    : ;
                      //ftOraClob    : ;
                      //ftVariant    : ;
                      //ftInterface  : ;
                      //ftIDispatch  : ;
                      //ftGuid       : ;
                      //ftTimeStamp  : ;
                      else headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                     End;
                  inc(index);
                  end;

                 LineString := IntToStr(LineNumber);
                Range['A'+LineString, rangeTo+LineString].Value2 := headers;
                {
                Range['A'+LineString, 'J'+LineString].Value2 :=
                  VarArrayof(['aQuery1OrderNo.value', 'aQuery1CustNo.Value',
                    FormatDateTime('yyyy-mmm-dd',now()),
                    'aQuery1EmpNo.Value', 'aQuery1ShipVIA.Value',
                    'aQuery1Terms.Value', 'aQuery1ItemsTotal.Value',
                    'aQuery1TaxRate.Value', 'aQuery1Freight.Value',
                    'aQuery1AmountPaid.Value']);
                }
                aQuery.Next;
                if LineNumber = 65000 then
                  if question('Liczba wierszy do wyeksportowania przekracza 65000. Je¿eli u¿ywasz starszej wersji programu Excel to mo¿e wyst¹piæ b³¹d. Czy kontynuowaæ ?') <> id_yes then break;
              end;
              LineString := IntToStr(LineNumber);
              //Range['H2','H'+LineString].NumberFormat := '0.00%';
              //Range['G2','G'+LineString].NumberFormat := '$#,##0.00';
              //Range['I2','I'+LineString].NumberFormat := '$#,##0.00';
              //Range['J2','J'+LineString].NumberFormat := '$#,##0.00';
              Range['A1',rangeTo+LineString].AutoFormat(xlRangeAutoFormatlist2, true,true,true,true,true,true);
              Range['A1',rangeTo+LineString].Columns.AutoFit;

              Field := 1;
              Criteria1 := '<>';
              Operator := xlAnd;
              Criteria2 := '<>';
              VisibleDropDown := true;
              Range['A1',rangeTo+LineString].AutoFilter(Field,Criteria1,Operator,Criteria2,VisibleDropDown);

              Range['A2','A2'].Select;
              ActiveWindow.FreezePanes := True;


              //ActiveWorkbook.SaveAs( FileName ,xlNormal,EmptyParam,EmptyParam,EmptyParam,EmptyParam,xlNochange,xlUserResolution,false,EmptyParam,EmptyParam,EmptyParam,LCID);

              //ActiveWorkbook.SaveCopyAs(FileName,LCID);
              //ActiveWorkbook.Close(false,emptyParam,emptyParam,LCID);
              //Quit;
            finally
             disconnect;
            end;
          end;

     //ExecuteFile('excel.exe',FileName,'',SW_MAXIMIZE);
    end;

Begin
 //FileName:= uutilityParent.ApplicationDocumentsPath + 'temp.xlsx';
 aQuery  := TADOQuery( aGrid.DataSource.DataSet );

 If Not aQuery.Active Then Begin
  Exit;
 End;

 aQuery.DisableControls;
 doExport;
 aQuery.EnableControls;
End;


initialization
 Macros     := tmacros.Create;
 DBMap := TDBMamp.create;
end.
