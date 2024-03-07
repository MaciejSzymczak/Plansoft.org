unit DM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DBTables, Db, StrHlder, UUtilityParent, dbctrls, stdctrls, ADODB, DateUtils, Buttons, ExtCtrls,  Grids, DBGrids,
  ComCtrls,  Menus,
  {used by export to excel} ActiveX,  TlHelp32, Variants, OleServer,
  ExcelXP;

Const MaxAllLecturers     =   5000;
      MaxAllGroups        =  10000;
      MaxAllRooms         =   3000;
      MaxAllRoles         =   2000;
      MaxAllPlanners      =    300;
      MaxAllSubjects      =  10000;
      MaxAllForms         =   3000;
      maxInClass          =    150; //maksymalna liczba obiektow w jednym zajeciu
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
      sql_LECNAMEORG      = 'TITLE||'' ''||LAST_NAME||'' ''||FIRST_NAME||''   (''||(SELECT CODE FROM ORG_UNITS WHERE ID = ORGUNI_ID)||'')''';
      sql_GRONAME         = 'nvl(abbreviation,name)';
      sql_ResCat0NAME     = 'NAME||'' ''||substr(attribs_01,1,55)';
      sql_ResCat0NAMEROM  = 'ROM.NAME||'' ''||substr(ROM.attribs_01,1,55)';
      sql_ResCat1NAME     = 'NAME';
      sql_SUBNAME         = 'NAME';
      sql_FORNAME         = 'NAME||''(''||abbreviation||'')''';
      sql_PERNAME         = 'NAME';
      sql_PLANAME         = 'NAME';

      sql_SUB_SEARCH = '(xxmsz_tools.erasePolishChars(upper(org_units.name||subjects.abbreviation||subjects.desc1||subjects.desc2||subjects.name|| subjects.attribs_01||subjects.attribs_02||subjects.attribs_03||subjects.attribs_04||subjects.attribs_05'+
          '||subjects.attribs_06||subjects.attribs_07||subjects.attribs_08||subjects.attribs_09||subjects.attribs_10||subjects.attribs_11||'
          +'subjects.attribs_12||subjects.attribs_13||subjects.attribs_14||subjects.attribs_15||''#''||subjects.integration_id||''#'')) like ''%%%s%%'')';

      sql_FOR_SEARCH      = '(xxmsz_tools.erasePolishChars(upper(forms.abbreviation||forms.name||forms.attribs_01||forms.attribs_02||forms.attribs_03||forms.attribs_04'+
           '||forms.attribs_05||forms.attribs_06||forms.attribs_07||forms.attribs_08||forms.attribs_09||forms.attribs_10||forms.attribs_11||forms.attribs_12||forms.attribs_13||forms.attribs_14||forms.attribs_15'+
           '||forms.desc1||forms.desc2||''#''||forms.integration_id||''#'')) like ''%%%s%%'')';

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

// info ( intToStr(sizeOf(TClass_)) );
Type TClass_    = Record
                  id              : integer;
                  day             : TTimeStamp;
                  hour            : integer;
                  fill            : integer;
                  sub_id          : integer;
                  sub_abbreviation: string[30];
                  sub_name        : string[100];
                  sub_colour      : integer;
                  for_colour      : integer;
                  owner_colour    : integer;
                  creator_colour  : integer;
                  class_colour    : integer;
                  for_id          : integer;
                  for_abbreviation: string[30];
                  for_name        : string[30];
                  for_kind        : string[1];
                  calc_lecturers  : string;
                  calc_groups     : string;
                  calc_rooms      : string;
                  calc_lec_ids    : string;
                  calc_gro_ids    : string;
                  calc_rom_ids    : string;
                  calc_rescat_ids : string;
                  created_by      : string[30];
                  owner           : string[255];
                  desc1           : string[255];
                  desc2           : string[255];
                  desc3           : string[255];
                  desc4           : string[255];
                 End;

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
    Procedure openSQL     (var query : tadoquery; S : String; const pparams : String = ''; const quoteFlag : boolean = true); overload;
    Procedure openSQL     (S : String; const pparams : String = '');                 overload;
    Procedure openSQL2    (S : String; const pparams : String = '');
    Procedure openSQL3    (S : String; const pparams : String = '');
    Function  SingleValue (S : String; const pparams : String = '') : String;
    Function  SingleValue2(S : String; const pparams : String = '') : String;
    Function  SingleValueParamDateTime(S : String; const paramName : String ; paramValue : tDateTime) : String;

    //--
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
    Procedure ExportToHtml(aGrid : TDBGrid );
  end;

Function QWorkToClass : TClass_;
Procedure DBGetClassByLecturer(DAY1, DAY2 : String; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
Procedure DBGetClassByGroup   (DAY1, DAY2 : String; Zajecia: Integer; GRO_ID        : String; Var Status : Integer; Var Class_ : TClass_);
Procedure DBGetClassByRoom    (DAY1, DAY2 : String; Zajecia: Integer; ROM_ID        : String; Var Status : Integer; Var Class_ : TClass_);
Procedure DBGetClassByClassId (classId : String; Var Status : Integer; Var Class_ : TClass_);


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
  sql := TStringList.Create;
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
  fmain.wlog ('start : ' + pprocedureName + ' : ' + pSQL + ' ');
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
 fmain.wlog ('stop : ' + AsString(EndTime - StartTime) );
end;


//----------------------------------------------------------------
Procedure TDModule.SQL(S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 try
 logSQLStart ('SQL', S);
 With Dmodule.QWork Do Begin
  SQL.Clear;
  //param check must be set false when you are trying to install package which contains characters : inside the body
  ParamCheck := pparams<>'';

  //SQL.Add(S);
  // for t := 1 to wordCount(pparams,[';']) do begin
  //   wholeString  := extractWord(t,pparams,[';']);
  //   paramName  := extractWord(1,wholeString,['=']);
  //   paramValue := extractWord(2,wholeString,['=']);
  //   parameters.ParamByName(paramName).value   := searchAndReplace ( paramValue , '!chr(61)', '=') ;
  // end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+ searchAndReplace(searchAndReplace ( paramValue , '!chr(61)', '=') , '<scolon>', ';')  +'''');
   end;
   SQL.Add(S);


  ExecSQL;
  //revert original settings
  ParamCheck := true;
 End;
 logSQLStop;
 except
  //Set DModule.ADOConnection.Connected = false
  CloseDBConnection;
  raise;
 End;
End;

//----------------------------------------------------------------
Procedure TDModule.SQL(var query : tadoquery; S : String; const pparams : String = '');
 var wholeString : String;
     paramName   : String;
     paramValue  : String;
     t : integer;
Begin
 try
 logSQLStart ('SQL', S);
 query.Connection      := ADOConnection;
 query.CursorLocation  := clUseServer;
 With query Do Begin
  SQL.Clear;

   //SQL.Add(S);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);

  ExecSQL;
 End;
  logSQLStop;
 except
  CloseDBConnection;
  raise;
 End;
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
  //SQL.Add(S);
  // for t := 1 to wordCount(pparams,[';']) do begin
  //   wholeString  := extractWord(t,pparams,[';']);
  //   paramName  := extractWord(1,wholeString,['=']);
  //   paramValue := extractWord(2,wholeString,['=']);
  //   parameters.ParamByName(paramName).value   := paramValue;
  // end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);

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

   //SQL.Add(S);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //  //xx := parameters.ParamByName(paramName).datatype;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);

   open;
 End;
 logSQLStop;
End;

//----------------------------------------------------------------
Procedure TDModule.openSQL(var query : tadoquery; S : String; const pparams : String = ''; const quoteFlag : boolean = true);
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

   //SQL.Add(S);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     if quoteFlag
       then S := searchAndReplace(S,':'+paramName,''''+paramValue+'''')
       else S := searchAndReplace(S,':'+paramName,paramValue);
   end;
   SQL.Add(S);
   //copytoclipboard(s);
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

   //SQL.Add(S);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);

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

   //SQL.Add(S);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);

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

   //SQL.Add(S);
   //Parameters.ParseSQL(SQL.Text, True);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);


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

   //SQL.Add(S);
   //Parameters.ParseSQL(SQL.Text, True);
   //for t := 1 to wordCount(pparams,[';']) do begin
   //  wholeString  := extractWord(t,pparams,[';']);
   //  paramName  := extractWord(1,wholeString,['=']);
   //  paramValue := extractWord(2,wholeString,['=']);
   //  parameters.ParamByName(paramName).value   := paramValue;
   //end;

   //terrible workaround for an error ORA-01036 on Oracle 18 XE
   for t := 1 to wordCount(pparams,[';']) do begin
     wholeString  := extractWord(t,pparams,[';']);
     paramName  := extractWord(1,wholeString,['=']);
     paramValue := extractWord(2,wholeString,['=']);
     S := searchAndReplace(S,':'+paramName,''''+paramValue+'''');
   end;
   SQL.Add(S);
      
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
      //the map is not working for _ char correctly. Replace with 'UNDERSCORE'
      map.addKeyValue( replace(qwork.Fields[0].AsString,'_','UNDERSCORE'), qwork.Fields[1].AsString);
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
 , 'name='+name+';value='+searchAndReplace(value ,';', '<scolon>'));   
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
                if LineNumber = 2000 then
                  if question('Liczba wierszy przekracza 2000. Zaleca siê przerwanie eksportu i wykonanie eksportu w formacie pliku Html. Plik html mo¿na otworzyæ w programie Excel. Czy przerwaæ?') <> id_yes then break;
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


procedure TDModule.ExportToHtml(aGrid: TDBGrid);
    var FileName : string;
        F : TextFile;
        aQuery : TADOQuery;

    Procedure doExport;
    var LineNumber : Integer;
        LineString : string;
        t : integer;
        index : integer;
        headers : array of String;
        {------------------------------------}
        procedure flush(tag : string);
        var t : integer;
        begin
          Writeln(f, '<tr>');
          for t := 0 to index-1 do begin
              writeLn(f, '<'+tag+'>'+headers[t]+'</'+tag+'>');
          end;
          Writeln(f, '</tr>');
        end;
    begin
          DeleteFile( FileName );

          AssignFile(F, FileName);
          ReWrite(F);

          Writeln(f, '<!DOCTYPE html>');
          Writeln(f, '<HTML>');
          Writeln(f, '<HEAD>');
          Writeln(f, '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">');
          Writeln(f, '<TITLE>Plansoft.org - eksport danych</TITLE>');
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

          WriteLn(F, '<TABLE ID="mytable">');

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    inc ( index );
                end;
              setlength(headers, index);

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    headers[index] := agrid.Columns[t].Title.Caption;
                    inc ( index );
                end;
              flush('th');

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
                flush('td');
                aQuery.Next;
              end;
              LineString := IntToStr(LineNumber);

     WriteLn(F, '</TABLE>');

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
     CloseFile(F);

     ExecuteFile(FileName,'','',SW_SHOWMAXIMIZED);
    end;

Begin
 FProgramSettings.generateJsFiles;
 FileName:= uutilityParent.ApplicationDocumentsPath + '\temp.html';
 aQuery  := TADOQuery( aGrid.DataSource.DataSet );

 If Not aQuery.Active Then Begin
  Exit;
 End;

 aQuery.DisableControls;
 doExport;
 aQuery.EnableControls;
End;


Function QWorkToClass : TClass_;
Var Class_ : TClass_;
Begin
   //@@@ komuniat o bledzie, gdy rozmiar pola przekracza rozmiar rekordu
   Class_.ID                 := DModule.QWork.FieldByName('ID').AsInteger;
   Class_.DAY                := dateTimeToTimeStamp ( DModule.QWork.FieldByName('DAY').asDateTime );
   Class_.HOUR               := DModule.QWork.FieldByName('HOUR').AsInteger;
   Class_.FILL               := DModule.QWork.FieldByName('FILL').AsInteger;
   Class_.SUB_ID             := DModule.QWork.FieldByName('SUB_ID').AsInteger;
   Class_.FOR_ID             := DModule.QWork.FieldByName('FOR_ID').AsInteger;
   Class_.FOR_KIND           := DModule.QWork.FieldByName('FOR_KIND').AsString;
   CLASS_.SUB_abbreviation   := DModule.QWork.FieldByName('SUB_abbreviation').AsString;
   CLASS_.SUB_NAME           := DModule.QWork.FieldByName('SUB_NAME').AsString;
   CLASS_.SUB_COLOUR         := DModule.QWork.FieldByName('SUB_COLOUR').AsInteger;
   CLASS_.FOR_COLOUR         := DModule.QWork.FieldByName('FOR_COLOUR').AsInteger;
   CLASS_.OWNER_COLOUR       := DModule.QWork.FieldByName('OWNER_COLOUR').AsInteger;
   CLASS_.CREATOR_COLOUR     := DModule.QWork.FieldByName('CREATOR_COLOUR').AsInteger;
   CLASS_.CLASS_COLOUR       := DModule.QWork.FieldByName('CLASS_COLOUR').AsInteger;
   CLASS_.DESC1              := DModule.QWork.FieldByName('DESC1').AsString;
   CLASS_.DESC2              := DModule.QWork.FieldByName('DESC2').AsString;
   CLASS_.DESC3              := DModule.QWork.FieldByName('DESC3').AsString;
   CLASS_.DESC4              := DModule.QWork.FieldByName('DESC4').AsString;
   //CLASS_.SUB_DESC1        := DModule.QWork.FieldByName('SUB_DESC1').AsString;
   //CLASS_.SUB_DESC2        := DModule.QWork.FieldByName('SUB_DESC2').AsString;
   CLASS_.FOR_abbreviation   := DModule.QWork.FieldByName('FOR_abbreviation').AsString;
   CLASS_.FOR_NAME           := DModule.QWork.FieldByName('FOR_NAME').AsString;
   //CLASS_.FOR_DESC1        := DModule.QWork.FieldByName('FOR_DESC1').AsString;
   //CLASS_.FOR_DESC2        := DModule.QWork.FieldByName('FOR_DESC2').AsString;
   CLASS_.CALC_LECTURERS     := DModule.QWork.FieldByName('CALC_LECTURERS').AsString;
   CLASS_.CALC_GROUPS        := DModule.QWork.FieldByName('CALC_GROUPS').AsString;
   CLASS_.CALC_ROOMS         := DModule.QWork.FieldByName('CALC_ROOMS').AsString;
   CLASS_.CALC_LEC_IDS       := DModule.QWork.FieldByName('CALC_LEC_IDS').AsString;
   CLASS_.CALC_GRO_IDS       := DModule.QWork.FieldByName('CALC_GRO_IDS').AsString;
   CLASS_.CALC_ROM_IDS       := DModule.QWork.FieldByName('CALC_ROM_IDS').AsString;
   CLASS_.CALC_RESCAT_IDS    := DModule.QWork.FieldByName('CALC_RESCAT_IDS').AsString;
   CLASS_.Created_by         := DModule.QWork.FieldByName('Created_by').AsString;
   CLASS_.Owner              := DModule.QWork.FieldByName('Owner').AsString;

   Result := Class_;
End;

Procedure DBGetClassByLecturer(DAY1, DAY2 : String; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
var d1, d2 : string;
Begin
   //DModule.SingleValue(
   //'SELECT count(*) c '+
   //'FROM CLASSES CLA ');
   //info ( DModule.QWork.fieldByName('c').AsString);

   d1 := copy(day1,10,10);
   d2 := copy(day2,10,10);

   if d1<>d2 then
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR, FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR,CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, '+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     LEC_CLA, '+
   '     subjects SUB,'+
   '     FORMS FRM,'+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE LEC_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      LEC_CLA.LEC_ID =:lec AND no_conflict_flag is null and '+
   '      CLA.DAY BETWEEN TO_DATE(:day1,''YYYY/MM/DD'') AND TO_DATE(:day2,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';day2='+d2+';hour='+IntToStr(Zajecia)+';lec='+ExtractWord(1,childId,[';']))
   else
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR, FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR,CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, '+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     LEC_CLA, '+
   '     subjects SUB,'+
   '     FORMS FRM,'+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE LEC_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      LEC_CLA.LEC_ID =:lec AND no_conflict_flag is null and '+
   '      CLA.DAY =TO_DATE(:day1,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';hour='+IntToStr(Zajecia)+';lec='+ExtractWord(1,childId,[';']));

   Class_ := dm.QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
     //copyToClipboard('Wyslij te informacje na email soft@home.pl: DBGetClassByLecturer: DAY1='+DAY1+' DAY2='+DAY2+' Zajecia='+intToStr(Zajecia)+'childId='+childId);
   end;
   End;
End;

Procedure DBGetClassByGroup(DAY1, DAY2 : String; Zajecia: Integer; GRO_ID : String; Var Status : Integer; Var Class_ : TClass_);
var d1, d2 : string;
Begin
   d1 := copy(day1,10,10);
   d2 := copy(day2,10,10);

   if d1<>d2 then
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     GRO_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE GRO_CLA.CLA_ID = CLA.ID AND  SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      GRO_CLA.GRO_ID =:gro AND no_conflict_flag is null and '+
   '      CLA.DAY BETWEEN TO_DATE(:day1,''YYYY/MM/DD'') AND TO_DATE(:day2,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';day2='+d2+';hour='+IntToStr(Zajecia)+';gro='+ExtractWord(1,GRO_ID,[';']))
   else
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     GRO_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE GRO_CLA.CLA_ID = CLA.ID AND  SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      GRO_CLA.GRO_ID =:gro AND no_conflict_flag is null and '+
   '      CLA.DAY =TO_DATE(:day1,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';hour='+IntToStr(Zajecia)+';gro='+ExtractWord(1,GRO_ID,[';']));

   Class_ := dm.QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
     //copyToClipboard('Wyslij te informacje na email soft@home.pl: DBGetClassByGroup: DAY1='+DAY1+' DAY2='+DAY2+' Zajecia='+intToStr(Zajecia)+'GRO_ID='+GRO_ID);
   end;
   End;
End;

Procedure DBGetClassByRoom(DAY1, DAY2 : String; Zajecia: Integer; ROM_ID : String; Var Status : Integer; Var Class_ : TClass_);
var d1, d2 : string;
Begin
   d1 := copy(day1,10,10);
   d2 := copy(day2,10,10);

   if d1<>d2 then
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     ROM_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE ROM_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      ROM_CLA.ROM_ID=:rom AND no_conflict_flag is null and '+
   '      CLA.DAY BETWEEN TO_DATE(:day1,''YYYY/MM/DD'') AND TO_DATE(:day2,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';day2='+d2+';hour='+IntToStr(Zajecia)+';rom='+ExtractWord(1,ROM_ID,[';']))
   else
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     ROM_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE ROM_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      ROM_CLA.ROM_ID=:rom AND no_conflict_flag is null and '+
   '      CLA.DAY =TO_DATE(:day1,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';hour='+IntToStr(Zajecia)+';rom='+ExtractWord(1,ROM_ID,[';']));

   Class_ := dm.QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
     //copyToClipboard('Wyslij te informacje na email soft@home.pl: DBGetClassByRoom: DAY1='+DAY1+' DAY2='+DAY2+' Zajecia='+intToStr(Zajecia)+'ROM_ID='+ROM_ID);
   end;
   End;
End;

procedure DBGetClassByClassId(classId: String; var Status: Integer; var Class_: TClass_);
Begin
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR, FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR,CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, '+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     subjects SUB,'+
   '     FORMS FRM,'+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID'+
   '  AND CLA.ID =:classId'
   ,'classId='+classId);

   Class_ := dm.QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
   end;
   End;
End;


initialization
 Macros     := tmacros.Create;
 DBMap := TDBMamp.create;
end.
