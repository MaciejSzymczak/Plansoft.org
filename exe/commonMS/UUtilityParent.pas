unit UUtilityParent;
{$R-}

interface

Uses Forms, Controls, Windows, classes, DBTables, stdctrls, Rxlookup, Rxdbctrl, dbctrls, comctrls, shellapi, SysUtils,
     bde, rxstrUtils, menus, FileCtrl, graphics, StrHlder, CheckLst, DBGrids;

Type  TCharSet = Set of Char;

type TStringTokenizer = Class
         tokens: TStringList;
         procedure init(commaText : String);
         procedure deleteToken(token : String);
         procedure addToken(token : String; ignoreDuplicate, deleteCommas : boolean);
         function count : integer;
         function get : string;
         procedure sort;
         procedure close;
         function deleteComma(s : string) : string;
     End;

type TMap = Class
         tokens: TStringList;
         map : array of record key: string; value: string; end;
         cnt : integer;
         lpadKey : boolean;
         procedure init (plpadKey : boolean);
         procedure addKeyValue(key, value: string);
         procedure prepare;
         function  getIndex (key : string) : integer;
         function  getValue (key : string) : string;
     End;

Const showDiagnosticsMessage = False;

function checkListBoxToText (c : tchecklistbox) : string;
procedure checkListBoxToBool (c : tchecklistbox; values: string);

function CenterString(aStr: String; Len: Integer): String;

function defaultBrowserIsChrome : boolean;

//zmienia niedozwolone znaki XML na kody
//wiÍcej na ten temat w Wikipedii i http://www.kurshtml.boo.pl/generatory/unicode.html
function XMLescapeChars (buffer : string) : string;

// odpowiedniki Oracle PL/SQL
Function nvl(S, S1 : string) : string;   overload;
function substr(S : string; Index : integer; const Count: Integer = 65000): string;
function instr(str : string; substr : string; const fromPos : integer = 1) : integer;
{function xxmsz_tools_extractWord(poz: Integer; const words: string; Sep : char): string;}
function replace(sSrc, sLookFor, sReplaceWith : string) : string;
FUNCTION replacePolishChars(S : string): string;
// zastepuje polskie znaki ich odpowiednikami bez ogonkow np. ≥Ûøko -> lozko

// szyfruje, deszyfruje ciag znakow
// id - identyfikator algorytmu szyfrujacego np. 1 ( opis w apps/utils/dcscript/mydemo )
Function EncryptShortString(id : Integer; Text, Password : ShortString) : ShortString; far; external 'ENCRYPT.DLL' name 'EncryptShortString';
Function DecryptShortString(id : Integer; Text, Password : ShortString) : ShortString; far; external 'ENCRYPT.DLL' name 'DecryptShortString';

function easyEncrypt (text : shortstring) : shortstring;
function easyDecrypt (text : shortstring) : shortstring;

function iif( cond : boolean; str1 : string; str2 : string ) : string;   overload;
function iif( cond : boolean; str1 : integer; str2 : integer ) : integer; overload;
function iif( cond : boolean; str1 : boolean; str2 : boolean ) : boolean; overload;

function currentYEAR: ShortString;
function currentMONTH: ShortString;
function currentDAY: ShortString;

//Function get first token from variable in CSV format eg. for "100",100,,"","...""..."," function will return: 100 next 100 next null next null next ..."... next <Error>
//stop iteration when Tokens is null
function popToken(Var Tokens, FirstToken : string) : Boolean;

procedure diagnosticsMessage(S : string);
function stringToValidDatabaseString(S : String) : String;

function stringToValidFileName(S : String) : String;
function isValidNumber(S : String) : Boolean;
function delphiColourToHTML(I : Integer) : String;

Function dateToYYYYMM(Data : TDateTime) : ShortString;
Function dateToYYYYMMDD(Data : TDateTime) : ShortString;
Function dateToYYYYMMDD_HHMMSSMI(Data : TDateTime) : ShortString;

Procedure deleteFiles(Path, Mask : String);
//dzia≥anie analiczne to StrToInt, dodatkowo String('')=0
Function  stringToInt(S : String) : Integer;
// zwraca bieøπcy katalog
Function  getD : String;
Procedure lockFormComponents(F : TForm; const A : Array Of TControl);
Procedure unLockFormComponents(F : TForm);

Procedure lockComponents(F : TTabSheet);
Procedure unLockComponents(F : TTabSheet);

Function merge(S1, S2: string; const Sep : String = '') : String;
Function mergeStrings(Sep : String; const strings : Array Of string ) : String;
Function isBlank(S : String) : Boolean;
Function floatToAmount(K : Extended) : String;

Procedure warning(S : String);

const showAlways      = 1;
      showOneTime     = 2;
      showOnceaday    = 3;
      showMonthly     = 4;

Procedure info(S : String; const showMode : integer = showAlways; const infoID : string = 'DISPL_KOM002');
Procedure sError(S : String);
Function  question(S : String) : Integer; //returns ID_YES, ID_NO

function  getSystemParam(Name : ShortString) : ShortString; overload;
function  getSystemParam(Name : ShortString; defaultValue : shortString) : ShortString; overload;
Procedure SetSystemParam(Name, Value : ShortString; const configurationSet : String = '');

function  encGetSystemParam(Name : ShortString) : ShortString; overload;
function  encgetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString; overload;
Procedure encSetSystemParam(Name, Value : ShortString; const configurationSet : String = '');

// przyk≥adowe wywo≥anie: ExecuteFile('NotePad.exe',OpenDialog1.FileName,'',SW_SHOW);
//                        ExecuteFile('Winword.exe',NAZWAPLIKU.Text,'',SW_SHOWMAXIMIZED);
function  executeFile(const FileName, Params, DefaultDir: string;  ShowCmd: Integer): THandle;
Procedure executeFileAndWait(FileNameAndParams : String);

function  wordCount(const S: string; WordDelims: TCharSet): Integer;
function  ExtractWord(N: Integer; const S: string; WordDelims: TCharSet): string;
function stringBetween( s : string; stringBefore : string; stringAfter : string; const stringNo : integer = 1) : string;
Function  existsValue(const S: string; WordDelims: TCharSet; Value : String) : Boolean;
Procedure copyToClipBoard(S : String);

Function  isHour(S : ShortString) : Boolean; //Sprawdza, czy godzina jest w formacie HH24:MI

Function  DateToOracle(Data : TDateTime) : ShortString;
Function  FloatToOracle(F : Extended) : String;

Function  DateTimeToOracle(Data : TDateTime) : ShortString;
Function  FormatString(S : String) : String;

Function  TSDateToOracle(Data : TTimeStamp) : ShortString;
Function  TSDateTimeToOracle(Data : TTimeStamp) : ShortString;
Function  StrToTime(S : ShortString) : TDateTime; //zamienia HH?MM na TDateTime (TimeSeparator bez znaczenia)

Function  StrToBool(S : ShortString) : Boolean;
Function  BoolToStr(B : Boolean) : ShortString;

Function  AmountFormat(K : Extended) : String;
Function  GetTableName(SQL : String) : String;

function  TFontStylesToString (f : TFontStyles) : string;
function  stringToTFontStyles(s : string) : TFontStyles;

Function GetTerminalName : String;

var currentBaloonHint: THandle;
    currentHintedObject : shortstring;
function  ShowBaloonHint(Point: TPoint; Handle: THandle; Title: String;Msg: String; Icon: Integer): Boolean;
procedure HideBaloonHint;

function concatElements ( pelems : array of string; psep : string ) : string;

procedure webBrowser( purl : string);

//source: http://www.delphifaq.com/faq/delphi_windows_API/f899.shtml
function isAltDown : Boolean;
function isCtrlDown : Boolean;
function isShiftDown : Boolean;


Var
    CurrentUserName : ShortString;
    IsAdmin      : boolean;
    EditOrgUnits : boolean;
    EditFlex     : boolean;
    LogChanges   : boolean;
    manySubjectsFlag : boolean;
    editReservations : boolean;
    editSharing      : boolean;
    CanEditL   : boolean;
    CanEditG   : boolean;
    CanEditR   : boolean;
    CanEditS    : boolean;
    CanEditF   : boolean;
    CanEditO   : boolean;
    CanEditD   : boolean;
    CanEditAll   : boolean;
    CanDelete  : boolean;
    CanInsert   : boolean;
    gFirstResourceFlag : boolean;
    confineCalendarId : ShortString;
    UserID    : ShortString;
    VersionOfApplication : ShortString;
    NazwaAplikacji : ShortString;

Type PString = ^ShortString;

Const CR = #13 + #10;

Type TCheckValid = class
       CanClose_ : Boolean;
       S         : String;
       _ActiveControl : TWinControl;
       Form          : TForm;

       Procedure init(_Form : TForm);
       Procedure addError(K : String);
       Procedure addWarning(K : String);
       Procedure singleRestrictEmpty(WinControl : TWinControl);
       Procedure restrictEmpty(WinControls : Array of TWinControl);
       Function  reducRestrictEmpty(_Form : TForm; WinControls : Array of TWinControl) : Boolean;
       Function  showMessage : Boolean;
     End;

Var CheckValid : TCheckValid;

Type TAmounts = Object
       Amounts : Array[1..100] Of Record Amount : Extended; Currency : String End;
       Count  : Integer;
       Procedure Init;
       Procedure Add(Amount : Extended; Currency : String);
       Function Get : String;
     End;

Const  AInsert = 0;
       ADelete = 1;
       AEdit   = 2;
       ACopy   = 3;
       AOpen   = 4;
       APost   = 5;
       ActionNames : Array[0..5] of String[10] = ('INSERT','DELETE','EDIT','COPY','OPEN','POST');

Var  StringsPath              : ShortString = '';
     ApplicationDir           : ShortString = '';
     NowMarker                : ShortString = '';
     ApplicationDocumentsPath : ShortString = '';

Type TSString = String[230];

Var  sKeyViolation         : TSString = 'ORA-00001';
       sUWAGA                : TSString = 'Uwaga';
       sINFORMACJA           : TSString = 'Informacja';
       sBLAD                 : TSString = 'B≥πd';
       sPYTANIE              : TSString = 'Pytanie';
       sAfterEdit            : TSString = 'Edycja pliku konfiguracyjnego zosta≥a zakoÒczona';

// deprecated, use Replace instead
function SearchAndReplace( sSrc, sLookFor, sReplaceWith : string; const replace : integer = 0 ) : string;

procedure writelog ( m : string; const pworkPath: string = '');
Function GetNowMarker: String;
Function GetNowGMT(offset: integer): String;

procedure loadFromIni(iniFileName : string; sectionName : string; controls : Array of TObject; const insertNulls : boolean = false );  overload;
procedure saveToIni(iniFileName : string; sectionName : string; controls : Array of TObject );   overload;
function loadFromIni(iniFileName : string; sectionName : string; Name, value : string ) : string; overload;
procedure saveToIni(iniFileName : string; sectionName : string; Name, value : string );  overload;

function Encode64(S: string): string;
function Decode64(S: string): string;

Procedure GridLayoutLoadFromFile (formName : String; Grid: TDBGrid);
Procedure GridLayoutSaveToFile(formName : String; Grid: TDBGrid);

implementation

Uses Dialogs, registry, messages, commCtrl, inifiles, ToolEdit, ExtCtrls, EncdDecd;

//------------------------------------------------------------------
Procedure GridLayoutLoad (Grid: TDBGrid; Strings : TStrings);
Var L : Integer;
    FieldName, Title,Width : ShortString;
    Temp       : TColumn;
begin
 Grid.Columns.Clear;
 For L:=0 To Strings.Count - 1 Do Begin
   FieldName   := ExtractWord(1,Strings[L],['|']);
   Title       := ExtractWord(2,Strings[L],['|']);
   Width       := ExtractWord(3,Strings[L],['|']);

   Temp := Grid.Columns.Add;
   Temp.Title.Caption := Title;
   Temp.Width := StrToInt(Width);
   Temp.FieldName := FieldName;
 end;
end;

//------------------------------------------------------------------
Procedure GridLayoutSave(Grid: TDBGrid; var Strings : TStrings);
Var l : Integer;
begin
  Strings.Clear;
  For l:=0 To Grid.Columns.Count - 1 Do Begin
   Strings.Add(
     AnsiUpperCase(Grid.Columns[l].FieldName) + '|' +
     Grid.Columns[l].Title.Caption + '|' +
     IntToStr(Grid.Columns[l].Width) +
     '|CATEGORY:');
  End;
end;

//------------------------------------------------------------------
Function getGridFileName(formName : String; Grid: TDBGrid) : String;
Var l : Integer;
    sortedColumNames : TStrings;
Begin
 sortedColumNames := TStringList.Create;

 result := UUtilityParent.StringsPATH + extractFileName(Application.ExeName) +'.' + formName + '.' + Grid.Name;
  For l:=0 To Grid.Columns.Count - 1 Do
    sortedColumNames.Add(Copy(Grid.Columns[l].FieldName,1,10));
  TStringList(sortedColumNames).Sort;
  For l:=0 To sortedColumNames.Count-1 Do
   result := result +'.'+ sortedColumNames[l];
 result := result + '.cfg';

End;

//------------------------------------------------------------------
Procedure GridLayoutLoadFromFile (formName : String; Grid: TDBGrid);
var fileName: TFileName;
    tmp : TStrings;
Begin
 //info(Grid.name+'    LOAD');
 fileName := getGridFileName(formName,Grid);

 if fileExists(fileName) then begin
    //info('EXISTS');
    tmp := TStringList.Create;
    tmp.LoadFromFile(fileName);
    GridLayoutLoad (Grid, tmp);
 end;

End;

//------------------------------------------------------------------
Procedure GridLayoutSaveToFile(formName : String; Grid: TDBGrid);
var fileName: TFileName;
    tmp : TStrings;
Begin
 //info(Grid.name+'    SAVE');
 fileName := getGridFileName(formName,Grid);
 tmp := TStringList.Create;
 GridLayoutSave (Grid, tmp);
 tmp.SaveToFile(fileName);
End;



//------------------------------------------------------------------
function checkListBoxToText (c : tchecklistbox) : string;
var i : integer;
    res : string;
begin
  res := '';
  for i := 0 to c.Items.Count-1 do
   res := res + uutilityparent.BoolToStr(c.Checked[i]);
  result := res;
  //info('checkListBoxToText='+res);
end;

procedure checkListBoxToBool (c : tchecklistbox; values: string);
var i : integer;
begin
  if length(values)<>c.Items.Count then info('uutility.checkListBoxToBool - internal error');
  for i := 0 to c.Items.Count-1 do
    c.Checked[i] := StrToBool(values[i+1]);
  //info('checkListBoxToBool='+values+'  !!! '+values[1]);
end;

procedure TStringTokenizer.init(commaText : String);
begin
   tokens := TStringList.Create;
   tokens.text := replace(commaText,',',#13#10);
end;

function TStringTokenizer.deleteComma(s: string): string;
begin
 result := searchAndReplace(s,',',' ');
end;

procedure TStringTokenizer.deleteToken(token : String);
var t : integer;
    againFlag : boolean;
begin
  token := deleteComma(token);
  repeat
  againFlag := false;
  for t := 0 to tokens.Count-1 do
    if tokens[t]=token then begin
      tokens.Delete(t);
      againFlag := true;
      break;
    end;
  until againFlag = false;
end;

procedure TStringTokenizer.addToken(token : String; ignoreDuplicate, deleteCommas : boolean);
begin
 if deleteCommas then
     token := deleteComma(token);
 if token = '' then exit;
 if ignoreDuplicate then deleteToken(token);
 tokens.Add(token);
end;

procedure TStringTokenizer.sort;
begin
 tokens.Sort;
end;

procedure TStringTokenizer.close;
begin
  tokens.Free;
end;

function TStringTokenizer.get : string;
begin
 result := replace(tokens.text,#13#10,',');
 if length(result)<>0 then
   if result[length(result)]=',' then
     result := copy(result,0,length(result)-1);
end;

function TStringTokenizer.count: integer;
begin
 result := tokens.Count;
end;

function Encode64(S: string): string;
begin
  result := replace(EncdDecd.EncodeString(S),cr,'');
end;

function Decode64(S: string): string;
begin
 result := EncdDecd.DecodeString(s);
end;

function ShowBaloonHint(Point: TPoint; Handle: THandle; Title: String; Msg: String; Icon: Integer): Boolean;
var
  ti: TToolInfo;
  Rect: TRect;

const
  TTS_BALLOON = $40;
  TTS_CLOSE = $80;

  procedure SetToolTipTitle(tt: THandle; IconType: Integer; Title: string);
  var
    buffer: array[0..255] of Char;
  const
    TTM_SETTITLE = (WM_USER + 32);
  begin
    FillChar(buffer, SizeOf(buffer), #0);
    lstrcpy(buffer, PChar(Title));
    SendMessage(tt, TTM_SETTITLE, IconType, Integer(@buffer));
  end;

begin
  if isCtrlDown then exit;
  
  currentBaloonHint:= CreateWindowEx(0,
                        TOOLTIPS_CLASS,
                        nil,
                        TTS_ALWAYSTIP or TTS_BALLOON or TTS_CLOSE,
                        CW_USEDEFAULT,
                        CW_USEDEFAULT,
                        1000,
                        1000,
                        Application.MainForm.Handle,
                        0,
                        Application.Handle,
                        0);

  SetWindowPos( currentBaloonHint,
                HWND_TOPMOST,
                0,
                0,
                1000,
                1000,
                SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);

  GetClientRect(Handle, Rect);

  with ti do
    begin
      cbSize:= Sizeof(TToolInfo);
      uFlags:= TTF_TRACK;
      hwnd:= Handle;
      hInst:= Application.Handle;
      uId:= Handle;
      lpszText:= PChar(Msg);
    end;

  ti.Rect.Left:= Rect.Left;
  ti.Rect.Top:= Rect.Top;
  ti.Rect.Right:= Rect.Right;
  ti.Rect.Bottom:= Rect.Bottom;

  SendMessage(currentBaloonHint,TTM_ADDTOOL,1,Integer(@ti));
  SetToolTipTitle(currentBaloonHint,Icon,Title);

  SendMessage(currentBaloonHint, TTM_SETMAXTIPWIDTH, 0, 1000);
  SendMessage(currentBaloonHint, TTM_TRACKPOSITION, 0, MakeLParam(Point.x,Point.y));

  SendMessage(currentBaloonHint, TTM_TRACKACTIVATE, Integer(True), Integer(@ti));
  //sleep(1000);
  //SendMessage(hwnd, TTM_TRACKACTIVATE, Integer(false), Integer(@ti));
end;

procedure HideBaloonHint;
begin
  if currentBaloonHint <> 0 then
    DestroyWindow(currentBaloonHint);
  currentBaloonHint := 0;
  currentHintedObject := '';
end;

Procedure TAmounts.Init;
Begin
 Count := 0;
End;

Procedure TAmounts.Add(Amount : Extended; Currency : String);
Var t : Integer;
    Found : Boolean;
Begin
 Found := False;
 If Currency = '' Then Currency := '   ';
 For t := 1 To Count Do
  If Amounts[t].Currency = Currency Then Begin Found := True; Break; End;

 If Found Then
   Amounts[t].Amount := Amounts[t].Amount + Amount
 Else Begin
  Count := Count + 1;
  Amounts[Count].Amount   := Amount;
  Amounts[Count].Currency := Currency;
 End;
End;

Function  TAmounts.Get : String;
Var t : Integer;
Begin
 Result := '';
 For t := 1 To Count Do Begin
  If Result <> '' Then Result := Result + CR;
  Result := Result + AmountFormat(Amounts[t].Amount) +' '+ Amounts[t].Currency;
 End;
End;

Function StringToInt(S : String) : Integer;
Begin
 S := Trim(S);
 If S = '' Then S := '0';
 try
  Result := StrToInt(S);
 except
  Result := 0;
 End;
End;

Function GetD : String;
Var S : String;
Begin
 GetDir(0,S);
 Result := S;
End;

Function mergeStrings(sep : String; const strings : Array Of string) : String;
Var I : Integer;
begin
  result := '';
  For I := 0 to High(strings) do
   result := merge(result,strings[I],sep);
end;

Procedure LockFormComponents(F : TForm; const A : Array Of TControl);
Var t : Integer;
 Function ComponentInA : Boolean;
 Var I : Integer;
 Begin
  Result := False;
  For I := 0 to High(A) do
   If TControl(F.Components[t]).Name = TControl(A[I]).Name Then Begin Result := True; Exit; End;
 End;

Begin
 For t := 0 To F.ComponentCount-1 Do
  If F.Components[t] is TControl Then
   If Not ComponentInA Then
    If TControl(F.Components[t]).Enabled = True Then Begin
     TControl(F.Components[t]).Enabled := False;
     TControl(F.Components[t]).Tag := TControl(F.Components[t]).Tag Or 134217728;
    End;
End;

Procedure UnLockFormComponents(F : TForm);
Var t : Integer;
Begin
 For t := 0 To F.ComponentCount-1 Do
  If F.Components[t] is TControl Then
   If TControl(F.Components[t]).Tag And 134217728 = 134217728 Then TControl(F.Components[t]).Enabled := True;
End;

Procedure LockComponents(F : TTabSheet);
Var t : Integer;
Begin
 For t := 0 To F.ControlCount-1 Do
  If (F.Controls[t] is TControl) And (F.Controls[t].Name <> 'UpdPanel') Then Begin
    If TControl(F.Controls[t]).Enabled = True Then Begin
     TControl(F.Controls[t]).Enabled := False;
     TControl(F.Controls[t]).Tag := TControl(F.Controls[t]).Tag Or 134217728;
    End;
  End;
End;

Procedure UnlockComponents(F : TTabSheet);
Var t : Integer;
Begin
 For t := 0 To F.ControlCount -1 Do
  If F.Controls[t] is TControl Then
   If TControl(F.Controls[t]).Tag And 134217728 = 134217728 Then TControl(F.Controls[t]).Enabled := True;
End;

Function Merge(S1, S2: string; const Sep : String = '') : String;
Begin
 If S1='' Then Result := S2 Else
  Begin
   If S2='' Then Result := S1
    Else Result := S1 + Sep + S2;
  End;
End;

Function isBlank(S : String) : Boolean;
Begin
 Result := Trim(S)='';
End;

Procedure TCheckValid.Init;
Begin
 S := '';
 _ActiveControl := Nil;
 Form      := _Form;
 CanClose_ := True;
End;

Procedure TCheckValid.SingleRestrictEmpty(WinControl : TWinControl);
Begin
 If WinControl is TEdit Then Begin
  If isBlank(TEdit(WinControl).Text) Then Begin
    If isBlank(WinControl.Hint) Then addError(WinControl.Name+' jest polem wymaganym')
                              Else addError(WinControl.Hint+' jest polem wymaganym');
    If _ActiveControl = Nil Then _ActiveControl := WinControl;
  End;
 End Else
 If WinControl is TDBEdit Then Begin
  If isBlank(TDBEdit(WinControl).Text) Then Begin
    If isBlank(WinControl.Hint) Then addError(WinControl.Name+' jest polem wymaganym')
                              Else addError(WinControl.Hint+' jest polem wymaganym');
    If _ActiveControl = Nil Then _ActiveControl := WinControl;
  End;
 End Else
 If WinControl is TDBRadioGroup Then Begin
  If TDBRadioGroup(WinControl).ItemIndex=-1 Then Begin
    If isBlank(WinControl.Hint) Then addError(WinControl.Name+' jest polem wymaganym')
                              Else addError(WinControl.Hint+' jest polem wymaganym');
    If _ActiveControl = Nil Then _ActiveControl := WinControl;
  End;
 End Else
 If WinControl is TRxDbLookupCombo Then Begin
  If isBlank(TRxDbLookupCombo(WinControl).Value) Then Begin
    If isBlank(WinControl.Hint) Then addError(WinControl.Name+' jest polem wymaganym')
                              Else addError(WinControl.Hint+' jest polem wymaganym');
    If _ActiveControl = Nil Then _ActiveControl := WinControl;
  End;
 End Else
 If WinControl is TDBDateEdit Then Begin
  Try
    TDBDateEdit(WinControl).CheckValidDate;
    If TDBDateEdit(WinControl).Date=0 Then Begin
    If isBlank(WinControl.Hint) Then addError(WinControl.Name+' jest polem wymaganym')
                              Else addError(WinControl.Hint+' jest polem wymaganym');
      If _ActiveControl = Nil Then _ActiveControl := WinControl;
    End;
  Except
    If isBlank(WinControl.Hint) Then addError(WinControl.Name+' musi zawieraÊ prawid≥owπ datÍ')
                              Else addError(WinControl.Hint+' musi zawieraÊ prawid≥owπ datÍ');
    If _ActiveControl = Nil Then _ActiveControl := WinControl;
  End;
 End Else SError('Nieznany typ pola:'+WinControl.Name);
End;

Procedure TCheckValid.RestrictEmpty(WinControls : Array of TWinControl);
// Tylko dla TEdit, TDBEdit, TDBDateEdit, TRxDbLookupCombo
//RestrictEmpty([NAZWA, ID_APARAT, ID_PRAC, P_DNAST]);
// Uzup. hint dla edytÛw itd.
// W przypadku, gdy puste zostanie wyúwietlona w≥aúciwoúÊ HINT+Komunikat, a jeøeli pusta, to NAME+Komunikat

Var t : Integer;
Begin
 For t:= 0 To High(WinControls) do SingleRestrictEmpty(WinControls[t]);
End;

Procedure TCheckValid.AddError(K : String);
Begin
 If S<>'' Then S := S + CR + K Else S := K;
 CanClose_ := False;
End;

Procedure TCheckValid.AddWarning(K : String);
Begin
 If S<>'' Then S := S + CR + 'OSTRZEØENIE: ' + K Else S := 'OSTRZEØENIE: ' + K;
End;

Function  TCheckValid.ReducRestrictEmpty(_Form : TForm; WinControls : Array of TWinControl) : Boolean;
Begin
 Init(_Form);
 RestrictEmpty(WinControls);
 Result := ShowMessage;
End;


Function TCheckValid.ShowMessage : Boolean;
Begin
 if S<>'' Then
  If CanClose_ Then Warning(S) Else Begin
    Try
      If _ActiveControl <> Nil Then Form.ActiveControl := _ActiveControl;
    Except End;
    SError(S);
  End;
 Result := CanClose_;
End;

Procedure ZachowajParametry;
{Var F : TextFile;}
Begin
 SetSystemParam('Common\Warning'       ,sUwaga);
 SetSystemParam('Common\Information'  ,sINFORMACJA);
 SetSystemParam('Common\Error'        ,sBLAD);
 SetSystemParam('Common\Question'     ,sPYTANIE);
 SetSystemParam('Common\AfterEdit'   ,sAfterEdit);
End;

Procedure OdczytajParametry;
{Var F : TextFile;}
Begin
 sUwaga        := GetSystemParam('Common\Warning');
 SINFORMACJA   := GetSystemParam('Common\Information');
 sBLAD         := GetSystemParam('Common\Error');
 sPYTANIE      := GetSystemParam('Common\Question');
 sAfterEdit    := GetSystemParam('Common\AfterEdit');

 If sUwaga        = '' Then sUwaga        := 'Uwaga';
 If sINFORMACJA   = '' Then sINFORMACJA   := 'Informacja';
 If sBLAD         = '' Then sBLAD         := 'B≥πd';
 If sPYTANIE      = '' Then sPYTANIE      := 'Pytanie';
 If sAfterEdit    = '' Then sAfterEdit    := 'Edycja pliku konfiguracyjnego zosta≥a zakoÒczona';;

End;

Procedure info(S : String; const showMode : integer = showAlways; const infoID : string = 'DISPL_KOM002');
Var H : String;
Begin
 S := S + Char(0);
 H := sINFORMACJA;

 Case showMode of
  showAlways:
   MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
  showOneTime:
   If GetSystemParam('MESSAGE.' + infoID) <> 'SHOWN' Then Begin
     MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
     SetSystemParam('MESSAGE.' + infoID,'SHOWN');
   End;
  showOnceaday:
   If GetSystemParam('MESSAGE.' + infoID) <> DateToYYYYMMDD(Date) Then Begin
     MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
     SetSystemParam('MESSAGE.' + infoID,DateToYYYYMMDD(Date));
   End;
  showMonthly:
   If GetSystemParam('MESSAGE.' + infoID) <> DateToYYYYMM(Date) Then Begin
     MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
     SetSystemParam('MESSAGE.' + infoID,DateToYYYYMM(Date));
   End;
 end;

End;

Procedure Warning(S : String);
Var H : String;
Begin
 S := S + Char(0);
 H := sUWAGA;
 MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONWARNING + MB_TASKMODAL);
End;

Procedure SError(S : String);
Var H : String;
Begin
 S := S + Char(0);
 H := sBLAD;
 MessageBox(0, @S[1], @H[1], MB_OK + MB_ICONERROR + MB_TASKMODAL);
End;

Function Question(S : String) : Integer;
Var H : String;
Begin
 S := S + Char(0);
 H := sPYTANIE;
 Result := MessageBox(0, @S[1], @H[1], MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL);
End;


Var R : TRegistry;

Function  GetSystemParam(Name : ShortString) : ShortString;
 var appName : string;
Begin
 DiagnosticsMessage('GetSystemParam:1');
 R:=TRegistry.Create;
 DiagnosticsMessage('GetSystemParam:2');
 R.RootKey:=HKEY_CURRENT_USER;
 DiagnosticsMessage('GetSystemParam:3');
 appName := lowercase ( extractFileName ( Application.ExeName ));
 appName := searchAndReplace(appName,'.exe','');
 R.OpenKey('SOFTWARE\Software Factory\'+ appName ,TRUE);
 DiagnosticsMessage('GetSystemParam:4');

 NAME := UPPERCASE(NAME);
 DiagnosticsMessage('GetSystemParam:5');

 If Name = 'PRE_UPPERCASE' Then If R.ReadString(Name)      = '' Then R.WriteString(Name,'UPPER('); //UPPER(
 If Name = 'POST_UPPERCASE' Then If R.ReadString(Name)     = '' Then R.WriteString(Name,')'); //)
 If Name = 'PRE_UPPERCASE_TEXT' Then If R.ReadString(Name) = '' Then R.WriteString(Name,'DUØE('); //DUØE(
 If Name = 'POST_UPPERCASE_TEXT' Then If R.ReadString(Name)= '' Then R.WriteString(Name,')'); //)
 If Name = 'ANY_CHARS' Then If R.ReadString(Name)          = '' Then R.WriteString(Name,'%');
 If Name = 'ANY_CHAR' Then If R.ReadString(Name)           = '' Then R.WriteString(Name,'_');
 If Name = 'DATEFORMAT' Then If R.ReadString('DATEFORMAT')           = '' Then R.WriteString('DATEFORMAT','Daty wprowadzaj w formacie RRRR.MM.DD');
 If Name = 'PRE_DATEFORMAT' Then If R.ReadString('PRE_DATEFORMAT')       = '' Then R.WriteString('PRE_DATEFORMAT','TO_DATE(''');
 If Name = 'POST_DATEFORMAT' Then If R.ReadString('POST_DATEFORMAT')      = '' Then R.WriteString('POST_DATEFORMAT',''',''YYYY.MM.DD'')');
 If Name = 'PRE_DATEFORMAT_TEXT' Then If R.ReadString('PRE_DATEFORMAT_TEXT')  = '' Then R.WriteString('PRE_DATEFORMAT_TEXT',' ');
 If Name = 'POST_DATEFORMAT_TEXT' Then If R.ReadString('POST_DATEFORMAT_TEXT') = '' Then R.WriteString('POST_DATEFORMAT_TEXT',' ');
 If Name = 'ODBC' Then If R.ReadString('ODBC')                 = '' Then R.WriteString('ODBC','Nie');

 If Name = 'STRINGSPATH' Then
   If Trim(R.ReadString(Name))  = '' Then Begin
    ForceDirectories(GetD);
    R.WriteString(Name,GetD+'\');
   End;

 If Name = 'SAVERESOURCES' Then
   If Trim(R.ReadString(Name))  = '' Then Begin
    R.WriteString(Name,'No');
   End;

 Result  := R.ReadString(Name);
 R.CloseKey;
 R.Destroy;
End;

function  GetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString;
begin
 result := nvl( GetSystemParam(Name), defaultValue);
end;

procedure webBrowser( purl : string);
var
  zUrl, zParams : array[0..79] of Char;
begin
  ShellExecute(Application.MainForm.Handle,nil, StrPCopy(zUrl, purl) , StrPCopy(zParams, '') ,nil,sw_maximize);
end;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  lParams : string;
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  lParams := Params;
  if ( instr(lParams,' ')<>0 ) and ( instr(lParams,'"')=0 ) then  lParams := '"'+ lParams + '"';
  Result := ShellExecute({Application.MainForm.Handle}0, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, lParams),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function WordCount(const S: string; WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do Begin Inc(I); Break; End;
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
  If SLen<>0 Then If S[SLen] in WordDelims Then Inc(Result);
end;

function WordPosition(const N: Integer; S: string; WordDelims: TCharSet): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do begin

    while (I <= Length(S)) and (S[I] in WordDelims) do Begin
      Inc(I);
      Break;
    End;

    if I <= Length(S) then
      Inc(Count);

    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do
        Inc(I)
    else Result := I;
  end;
end;

function ExtractWord(N: Integer; const S: string; WordDelims: TCharSet): string;
var
  I: Word;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

     function SUBSTR(S : string; Index : integer; const Count: Integer = 65000): string;
     begin
      result := copy(S, Index, count);
     end;

     function INSTR(str : string; substr : string; const fromPos : integer = 1) : integer;
      var truncatedStr : string;
     begin
       truncatedStr := copy( str, 1, fromPos - 1);
       str          := copy( str, fromPos , 65000);

       result := pos (substr, str );
       if result > 0 then result := result + ( length(truncatedStr) );
     end;



Function ExistsValue(const S: string; WordDelims: TCharSet; Value : String) : Boolean;
Var t : Integer;
Begin
 Result := False;
 For t:=1 To WordCount(S, WordDelims) Do
  If ExtractWord(t,S,WordDelims)=Value Then Begin Result := True; Break; End;
End;

Procedure CopyToClipBoard(S : String);
Var Edit : TEdit;
Begin
 If Not Assigned(Application.MainForm) Then Begin SError('Nie moøna wykonaÊ CopyToClipBoard S='+S); Exit; End;
 Edit := TEdit.Create(nil);
 Edit.Parent := Application.MainForm;
 Edit.Name := 'TemporaryEdit';
 Edit.Text := S;
 Edit.SelectAll;
 Edit.CopyToClipboard;
 Edit.Free;
End;

Procedure DeleteFiles(Path, Mask : String);
// Path + Mask = 'c:\apps\*.ooo'
Var   SearchRec : TSearchRec;
      Found     : Integer;
Begin
  Found := FindFirst(Path + Mask, faAnyFile, SearchRec);
  while Found = 0 do
  begin
    Try DeleteFile(Path + SearchRec.Name); Except End;
    Found := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
End;

Procedure  SetSystemParam(Name, Value : ShortString; const configurationSet : String = '');
 var aconfigurationSet : string;
     appName           : string;
Begin

 if isBlank(configurationSet) then begin
   appName := lowercase ( extractFileName ( Application.ExeName ));
   appName := searchAndReplace(appName,'.exe','');
   aconfigurationSet := appName
 end else aconfigurationSet := configurationSet;
 R:=TRegistry.Create;
 R.RootKey:=HKEY_CURRENT_USER;
 R.OpenKey('SOFTWARE\Software Factory\'+aconfigurationSet,TRUE);
 R.WriteString(Name, Value);
 R.CloseKey;
 R.Destroy;
End;

function  encGetSystemParam(Name : ShortString) : ShortString; overload;
begin
  result := DecryptShortString(1,GetSystemParam(Name), 'SoftwareFactory');
end;

function  encgetSystemParam(Name : ShortString; defaultValue : shortString) : ShortString; overload;
begin
  result := DecryptShortString(1,GetSystemParam(Name, defaultValue), 'SoftwareFactory');
end;

Procedure encSetSystemParam(Name, Value : ShortString; const configurationSet : String = '');
begin
  SetSystemParam(Name, EncryptShortString(1,Value,'SoftwareFactory'), configurationSet);
end;

Function NVL(S, S1 : String) : String;
Begin
 If Trim(S) = '' Then Result := S1 Else Result := S;
End;

  FUNCTION replacePolishChars(S : string) : string;
  	var S2 : string;
  BEGIN
    S2 := S;
    S2 := REPLACE(S2,' ','E');
    S2 := REPLACE(S2,'”','O');
    S2 := REPLACE(S2,'•','A');
    S2 := REPLACE(S2,'å','S');
    S2 := REPLACE(S2,'£','L');
    S2 := REPLACE(S2,'Ø','Z');
    S2 := REPLACE(S2,'è','Z');
    S2 := REPLACE(S2,'∆','C');
    S2 := REPLACE(S2,'—','N');
    S2 := REPLACE(S2,'Í','e');
    S2 := REPLACE(S2,'Û','o');
    S2 := REPLACE(S2,'π','a');
    S2 := REPLACE(S2,'ú','s');
    S2 := REPLACE(S2,'≥','l');
    S2 := REPLACE(S2,'ø','z');
    S2 := REPLACE(S2,'ü','z');
    S2 := REPLACE(S2,'Ê','c');
    S2 := REPLACE(S2,'Ò','n');
    result :=  S2;
  END;


Procedure ExecuteFileAndWait(FileNameAndParams : String);
var SI:TStartupInfo;
    PI:TProcessInformation;
begin

 FillChar(SI,sizeof(SI),0);
 with SI do
 begin
  dwFlags:=STARTF_USESHOWWINDOW;
  wShowWindow:=SW_SHOW;
  cb:=sizeof(TStartupInfo);
 end;

 if CreateProcess(nil,PChar(FileNameAndParams),nil,nil,FALSE,NORMAL_PRIORITY_CLASS,nil,nil,SI,PI) then
  with PI do
  begin
   WaitForInputIdle(hProcess,1000);
   WaitForSingleObject(hProcess,100000000);
   WaitForSingleObject(hThread,100000000);
   CloseHandle(hProcess);
   CloseHandle(hThread);
  end;
end;

Function isHour(S : ShortString) : Boolean;
Var H, M : Integer;
Begin
 Result := False;
 If Length(S) <> 5 Then Exit;
 Try H := StrToInt(Copy(S,1,2)) Except Exit; End;
 Try M := StrToInt(Copy(S,4,2)) Except Exit; End;
 If Not ((H >= 0) and (H <= 24)) Then Exit;
 If Not ((M >= 0) and (M <= 59)) Then Exit;
 Result := True;
End;

Function DateToYYYYMM(Data : TDateTime) : ShortString;
  Var Year,Month,Day : Word;
      TS : TTimeStamp;
Begin
 TS := DateTimeToTimeStamp(Data);
 TS.Time := 0;
 decodeDate(TimeStampToDateTime(TS) ,Year,Month,Day);

 Result := FormatFloat('0000',Year)+'.'+FormatFloat('00',Month);
End;

Function DateToYYYYMMDD(Data : TDateTime) : ShortString;
  Var Year,Month,Day : Word;
      TS                      : TTimeStamp;
Begin
 TS := DateTimeToTimeStamp(Data);
 TS.Time := 0;
 decodeDate(TimeStampToDateTime(TS) ,Year,Month,Day);

 Result := FormatFloat('0000',Year)+'.'+FormatFloat('00',Month)+'.'+FormatFloat('00',Day);
End;

Function DateToYYYYMMDD_HHMMSSMI(Data : TDateTime) : ShortString;
//DD-MM-YYYY HH24:MI:SS:MI
  Var Year,Month,Day      : Word;
      TS                  : TTimeStamp;
      Hour, Min, Sec, MSec: Word;
Begin
 TS := DateTimeToTimeStamp(Data);
 TS.Time := 0;
 decodeDate(TimeStampToDateTime(TS) ,Year,Month,Day);

 TS := DateTimeToTimeStamp(Data);
 TS.Date := 0;
 DecodeTime(Data ,Hour, Min, Sec, MSec);

 Result := FormatFloat('0000',Year)+'-'+FormatFloat('00',Month)+'-'+FormatFloat('00',Day)+' '+FormatFloat('00',Hour)+':'+FormatFloat('00',Min)+':'+FormatFloat('00',Sec)+':'+FormatFloat('000',MSec);
End;

Function DateToOracle(Data : TDateTime) : ShortString;
  Var Year,Month,Day : Word;
      TS                      : TTimeStamp;
Begin
 TS := DateTimeToTimeStamp(Data);
 TS.Time := 0;
 decodeDate(TimeStampToDateTime(TS) ,Year,Month,Day);

 Result := 'TO_DATE('''+FormatFloat('0000',Year)+'.'+FormatFloat('00',Month)+'.'+FormatFloat('00',Day)+''',''YYYY.MM.DD'')';
End;

Function CurrentYEAR: ShortString;
  Var Year,Month,Day : Word;
Begin
 decodeDate(now ,Year,Month,Day);
 Result := FormatFloat('0000',Year);
End;
Function CurrentMONTH: ShortString;
  Var Year,Month,Day : Word;
Begin
 decodeDate(now ,Year,Month,Day);
 Result := FormatFloat('00',Month);
End;
Function CurrentDAY: ShortString;
  Var Year,Month,Day : Word;
Begin
 decodeDate(now ,Year,Month,Day);
 Result := FormatFloat('00',Day);
End;

Function FloatToOracle(F : Extended) : String;
Var x : String;
begin
 x := FormatFloat('###############0.################', F);
 Result := SearchAndReplace(x,SysUtils.DecimalSeparator,'.');
End;

Function DateTimeToOracle(Data : TDateTime) : ShortString;
  Var Year,Month,Day : Word;
      OldLongTimeFormat, Time : ShortString;
      TS                      : TTimeStamp;
Begin
 TS := DateTimeToTimeStamp(Data);
 TS.Time := 0;
 decodeDate(TimeStampToDateTime(TS) ,Year,Month,Day);

 TS := DateTimeToTimeStamp(Data);
 TS.Date := 1;
 OldLongTimeFormat := LongTimeFormat;
 LongTimeFormat := 'hh:mm';
 Time := TimeToStr(TimeStampToDateTime(TS));
 LongTimeFormat := OldLongTimeFormat;

 Result := 'TO_DATE('''+FormatFloat('0000',Year)+'.'+FormatFloat('00',Month)+'.'+FormatFloat('00',Day)+' '+Time+''',''YYYY.MM.DD HH24:MI'')';
End;

Function TSDateToOracle(Data : TTimeStamp) : ShortString;
Begin
 Result := DateToOracle(TimeStampToDateTime(Data));
End;

Function TSDateTimeToOracle(Data : TTimeStamp) : ShortString;
Begin
 Result := DateTimeToOracle(TimeStampToDateTime(Data));
End;

Function FormatString(S : String) : String;
Begin
 If S = '' Then Result := 'NULL'
           Else Result := ''''+StringToValidDatabaseString(S)+'''';
End;

function Replace( sSrc, sLookFor, sReplaceWith : string ) : string;
begin
 result := stringReplace( sSrc, sLookFor, sReplaceWith, [rfReplaceAll]);
end;

Function IsValidNumber(S : String) : Boolean;
Begin
 S := SearchAndReplace(S,'0','');
 S := SearchAndReplace(S,'1','');
 S := SearchAndReplace(S,'2','');
 S := SearchAndReplace(S,'3','');
 S := SearchAndReplace(S,'4','');
 S := SearchAndReplace(S,'5','');
 S := SearchAndReplace(S,'6','');
 S := SearchAndReplace(S,'7','');
 S := SearchAndReplace(S,'8','');
 S := SearchAndReplace(S,'9','');
 S := SearchAndReplace(S,DecimalSeparator,'');
 Result := isBlank(S);
End;

Function StringToValidDatabaseString(S : String) : String;
Begin
 Result := S;
 Result := SearchAndReplace(Result,'"',' ');
 Result := SearchAndReplace(Result,'''',' ');
End;

Function StringToValidFileName(S : String) : String;
Begin
 Result := replacePolishChars( S );
 Result := SearchAndReplace(Result,'/','');
 Result := SearchAndReplace(Result,'\','');
 Result := SearchAndReplace(Result,':','');
 Result := SearchAndReplace(Result,'?','');
 Result := SearchAndReplace(Result,'*','');
 Result := SearchAndReplace(Result,'"','');
 Result := SearchAndReplace(Result,'''','');
 Result := SearchAndReplace(Result,'<','');
 Result := SearchAndReplace(Result,'>','');
 Result := SearchAndReplace(Result,'|','');
 Result := SearchAndReplace(Result,' ','_');
 Result := SearchAndReplace(Result,#9,'');
End;

Function StrToTime(S : ShortString) : TDateTime;
Begin
 If Not isHour(S) Then Begin
  Result := 0;
  Exit;
 End;

 S[3]   := TimeSeparator;
 Result := SysUtils.StrToTime(S);
End;

Function StrToBool(S : ShortString) : Boolean;
Begin
 Result := UpperCase(S)='+';
End;

Function BoolToStr(B : Boolean) : ShortString;
Begin
 If B Then Result := '+' Else Result := '-';
End;

Function DelphiColourToHTML(I : Integer) : String;
 Var S, R, G, B : ShortString;
Begin
  S := IntToHex(I,6);
  B := Copy(S,1,2);
  G := Copy(S,3,2);
  R := Copy(S,5,2);
  Result := '#'+R + G + B;
End;

Function GetTableName(SQL : String) : String;
Var L : String;
    i,j : Integer;
Begin
  L:=UpperCase(DelRSpace(ReplaceStr(SQL,#13+#10,' ')));
  L:= ReplaceStr(L,',',' ');
  i:=Pos(' FROM ',L);
  L:=Copy(L,i+6,65535);
  L:=Trim(L);
  j:=pos(' ',L);
  if j<>0 then L:=Copy(L,1,j-1);

  Result := L;
End;

Function FloatToAmount(K : Extended) : String;
Begin
 Result := FormatFloat('#,##0.00;;Zero',K);
End;

Function AmountFormat(K : Extended) : String;
Begin
 Result := FormatFloat('#,##0.00;;Zero',K);
End;


Procedure DiagnosticsMessage(S : String);
Begin
 If ShowDiagnosticsMessage Then Info(s);
End;

Function GetTerminalName : String;
Var S : Pchar;
    C : Cardinal;
Begin
 C := 100;
 S := AllocMem(100);
 GetComputerName(S, C);
 Result := StringToValidFileName(StrPas(S));
 FreeMem(S);
End;

Function PopToken(Var Tokens, FirstToken : String) : Boolean;
Var CommaCount : Integer;
    i          : Integer;
    //bufor      : String;
Begin
  Result := True;
  CommaCount := 0;
  //Bufor      := '';
  FirstToken := '';
  For i := 1 To Length(Tokens) Do Begin
   If Tokens[i] = '"' Then Inc(CommaCount);
   //Bufor := Bufor + Tokens[i];
   //showmessage(Bufor+' '+IntToStr(CommaCount));
   If ((Tokens[i]=',') or (i = Length(Tokens))) And ((CommaCount mod 2) = 0) Then Begin
    FirstToken := Copy(Tokens,1,i-1);
    If Length(FirstToken)>0 Then Begin
      If FirstToken[1]='"' Then FirstToken := Copy(FirstToken, 2, Length(FirstToken)-1);
      If FirstToken[Length(FirstToken)]='"' Then FirstToken := Copy(FirstToken, 1, Length(FirstToken)-1);
      FirstToken := SearchAndReplace(FirstToken,'""','"');
    End;
    Tokens := Copy(Tokens,i+1,Length(Tokens));
    exit;
   End;
  End;
  Result := False; //ErrorIfCSVFormat
End;

     function TFontStylesToString (f : TFontStyles) : string;
      // fsBold, fsItalic, fsUnderline, fsStrikeOut
     begin
      result := '';
      if fsBold      in f then result := merge ( result, 'fsBold',      ',');
      if fsItalic    in f then result := merge ( result, 'fsItalic',    ',');
      if fsUnderline in f then result := merge ( result, 'fsUnderline', ',');
      if fsStrikeOut in f then result := merge ( result, 'fsStrikeOut', ',');
     end;

     function stringToTFontStyles(s : string) : TFontStyles;
     begin
      result := [];
      if pos('fsBold',s)      <> 0 then result := result + [fsBold];
      if pos('fsItalic',s)    <> 0 then result := result + [fsItalic];
      if pos('fsUnderline',s) <> 0 then result := result + [fsUnderline];
      if pos('fsStrikeOut',s) <> 0 then result := result + [fsStrikeOut];
     end;

function iif( cond : boolean; str1 : string; str2 : string ) : string;
begin
  if cond then result := str1
          else result := str2;
end;

function iif( cond : boolean; str1 : integer; str2 : integer ) : integer;
begin
  if cond then result := str1
          else result := str2;
end;


function iif( cond : boolean; str1 : boolean; str2 : boolean ) : boolean;
begin
  if cond then result := str1
          else result := str2;
end;
function easyEncrypt (text : shortstring) : shortstring;
begin
  result := EncryptShortString(1,text,'SoftwareFactory.' + UUtilityParent.GetTerminalName);
end;

function easyDecrypt (text : shortstring) : shortstring;
begin
  result := DecryptShortString(1,text,'SoftwareFactory.' + UUtilityParent.GetTerminalName);
end;

function SearchAndReplace( sSrc, sLookFor, sReplaceWith : string; const replace : integer = 0 ) : string;
var
  nPos,
  nLenLookFor : integer;
  replaceCount : integer;
begin
  replaceCount := 0;
  nPos        := Pos( sLookFor, sSrc );
  nLenLookFor := Length( sLookFor );
  while(nPos > 0)do
  begin
    Delete( sSrc, nPos, nLenLookFor );
    Insert( sReplaceWith, sSrc, nPos );
    nPos := Pos( sLookFor, sSrc );
    replaceCount := replaceCount + 1;
    if replace > 0 then
      if replaceCount = replace then break;
  end;
  Result := sSrc;
end;

function stringBetween( s : string; stringBefore : string; stringAfter : string; const stringNo : integer = 1) : string;
   function xxmsz_tools_extractWord(poz: Integer; const words: string; Sep : char): string;
   var
     word  : string;
     word2 : string;
     str2  : string;
     i     : integer;

   BEGIN
     word  := '';
     word2 := '';
     str2  := words + Sep;
     FOR i:= 1 to poz do begin
      IF i = 1 THEN begin
       word:=SUBSTR(str2,1,INSTR(str2,sep,poz)-1);
       word2:=str2;
      end ELSE begin
       word2 := SUBSTR(word2,LENGTH(word2)+2-LENGTH(SUBSTR(word2,INSTR(word2,sep,1))));
       word  := SUBSTR(word2,1,INSTR(word2,sep,1)-1);
      END;
     End;
     result :=  Word;
   END;
begin
 if pos(stringBefore,s) = 0 then begin
  result := '';
  exit;
 end;

 s := replace(s,'^', '$$$|$$$');
 s := replace(s,stringBefore, '^');
 s := replace(s,stringAfter,  '^');
 result := xxmsz_tools_extractWord(stringNo*2, s ,'^');
 result := replace(result,'$$$|$$$','^');
end;


Procedure  ExamineADOOracle;
Var R : TRegistry;
  Procedure ExecuteFile(FileNameAndParams : String);
  var SI:TStartupInfo;
      PI:TProcessInformation;
  begin

   FillChar(SI,sizeof(SI),0);
   with SI do
   begin
    dwFlags:=STARTF_USESHOWWINDOW;
    wShowWindow:=SW_SHOW;
    cb:=sizeof(TStartupInfo);
   end;

   if CreateProcess(nil,PChar(FileNameAndParams),nil,nil,FALSE,NORMAL_PRIORITY_CLASS,nil,nil,SI,PI) then
    with PI do
    begin
     WaitForInputIdle(hProcess,1);
     WaitForSingleObject(hProcess,1);
     WaitForSingleObject(hThread,1);
     CloseHandle(hProcess);
     CloseHandle(hThread);
    end;
  end;

Begin
 exit;
 R:=TRegistry.Create;
 R.RootKey:=HKEY_LOCAL_MACHINE;
 R.OpenKey('SOFTWARE\ORACLE',False);
 if (R.readString('ORACLE_HOME') = '') and (R.readString('ORACLE_HOME_NAME') = '') then begin
   info('Uwaga dla uøytkownikÛw serwera bazy danych Oracle : Do poprawnego dzia≥ania programu '+Application.Title+' niezbÍdne jest zainstalowanie klienta Oracle ze sk≥adnikiem "Oracle Provider for OLE DB". Oprogramowanie to moøna úciπgnπÊ ze strony Oracle - zob. zak≥adka links. Zainstaluj najpierw klienta Oracle, a nastÍpnie ponownie uruchom program '+Application.Title);
   //application.Terminate;
 end;
 R.CloseKey;
 R.Destroy;

 R:=TRegistry.Create;
 R.RootKey:=HKEY_LOCAL_MACHINE;
 R.OpenKey('SOFTWARE\Classes\OraOLEDB.Oracle',False);
 if r.CurrentPath <> 'SOFTWARE\Classes\OraOLEDB.Oracle' then begin
   info('Uwaga dla uøytkownikÛw serwera bazy danych Oracle : Do poprawnego dzia≥ania programu '+Application.Title+' niezbÍdne jest zainstalowanie sk≥adnika "Oracle Provider for OLE DB". Oprogramowanie to moøna úciπgnπÊ ze strony Oracle - zob. zak≥adka links. Zainstaluj najpierw ten sk≥adnik, a nastÍpnie ponownie uruchom program '+Application.Title);
   //application.Terminate;
 end;
 R.CloseKey;
 R.Destroy;
End;

Function GetNowMarker: String;
var Year, Month, Day: Word;
    Hour, Min, Sec, MSec: Word;
Begin
 decodedate(Now, Year, Month, Day);
 decodetime(Now,Hour, Min, Sec, MSec);
 Result := FormatFloat('0000',Year)+'.'+FormatFloat('00',Month)+'.'+FormatFloat('00',Day)+'_'+FormatFloat('00',Hour)+'.'+FormatFloat('00',Min)+'.'+FormatFloat('00',Sec);
End;

Function GetNowGMT(offset: integer): String;
var Year, Month, Day: Word;
    Hour, Min, Sec, MSec: Word;
Begin
 decodedate(Now+offset/24, Year, Month, Day);
 decodetime(Now+offset/24,Hour, Min, Sec, MSec);
 Result := FormatFloat('0000',Year)+FormatFloat('00',Month)+FormatFloat('00',Day)+'T'+FormatFloat('00',Hour)+FormatFloat('00',Min)+FormatFloat('00',Sec)+'Z';
End;


procedure writelog ( m : string; const pworkPath: string = '');
 var f : textFile;
     workPath : string;
begin
 if pworkPath = '' then workPath := uutilityParent.ApplicationDocumentsPath
                   else workPath := pworkPath;

 AssignFile(F, workPath + nowMarker+'.log');
 if fileExists (workPath + nowMarker+'.log')
   then append(f)
   else rewrite(f);

 writeLn(f, m);
 Flush(f);
 CloseFile(f);
end;

function XMLescapeChars (buffer : string) : string;
begin
 result := replace(replace(replace(replace(replace(buffer , '&', '&amp;'), '>', '&gt;'), '<', '&lt;'), '''', '&apos;'), '"', '&quot;');
end;

function concatElements ( pelems : array of string; psep : string ) : string;
var t : integer;
begin
 for t := 0 to high(pelems) do begin
   if pelems[t]='' then continue;
   if result = ''  then result := pelems[t]
                   else result := result + psep + pelems[t];
 end;
end;

procedure loadFromIni(iniFileName : string; sectionName : string; controls : Array of TObject; const insertNulls : boolean = false );
var iniFile : TIniFile;
    t       : integer;
begin
  iniFile := TIniFile.Create( iniFileName );
  with iniFile do begin
    for t:= 0 To High(controls) do begin
      if (controls[t] is tcheckbox)  then (controls[t] as tcheckbox).Checked := readBool  (sectionName, (controls[t] as tcheckbox).name , (controls[t] as tcheckbox).Checked);
      if (controls[t] is tdateedit)  then (controls[t] as tdateedit).text    := readString(sectionName, (controls[t] as tdateedit).name , (controls[t] as tdateedit).text);
      if (controls[t] is tedit)      then (controls[t] as     tedit).text    := readString(sectionName, (controls[t] as     tedit).name , (controls[t] as     tedit).text);
      if (controls[t] is tfilenameedit)      then (controls[t] as     tfilenameedit).text    := readString(sectionName, (controls[t] as     tfilenameedit).name , (controls[t] as     tfilenameedit).text);
      if (controls[t] is tmenuitem)  then (controls[t] as tmenuitem).Checked := readBool  (sectionName, (controls[t] as tmenuitem).name , (controls[t] as tmenuitem).Checked);
      if (controls[t] is tPageControl)  then (controls[t] as tPageControl).ActivePageIndex := readInteger  (sectionName, (controls[t] as tPageControl).name , (controls[t] as tPageControl).ActivePageIndex);
      if insertNulls then begin
        if (controls[t] is tstrholder) then (controls[t] as tstrholder).Strings.Text := decode64(readString  (sectionName, (controls[t] as tstrholder).name , ''));
        if (controls[t] is tmemo) then (controls[t] as tmemo).lines.Text := decode64(readString  (sectionName, (controls[t] as tmemo).name , ''));
      end else begin
        if (controls[t] is tstrholder) then (controls[t] as tstrholder).Strings.Text := nvl(decode64(readString  (sectionName, (controls[t] as tstrholder).name , '')),(controls[t] as tstrholder).Strings.Text);
        if (controls[t] is tmemo) then (controls[t] as tmemo).lines.Text := nvl(decode64(readString  (sectionName, (controls[t] as tmemo).name , '')),(controls[t] as tmemo).lines.Text);
      end;
      if (controls[t] is tradiogroup)  then (controls[t] as tradiogroup).itemIndex := readInteger  (sectionName, (controls[t] as tradiogroup).name , (controls[t] as tradiogroup).itemIndex);
      if (controls[t] is tcombobox)  then (controls[t] as tcombobox).itemIndex := readInteger  (sectionName, (controls[t] as tcombobox).name , (controls[t] as tcombobox).itemIndex);
    end;
  end;
  iniFile.Free;
end;

procedure saveToIni(iniFileName : string; sectionName : string; controls : Array of TObject );
var iniFile : TIniFile;
    t       : integer;
begin
  iniFile := TIniFile.Create( iniFileName );
  with iniFile do begin
    for t:= 0 To High(controls) do begin
      if (controls[t] is tcheckbox)     then   writeBool  (sectionName, (controls[t] as tcheckbox).name , (controls[t] as tcheckbox).Checked);
      if (controls[t] is tdateedit)     then   writeString(sectionName, (controls[t] as tdateedit).name , (controls[t] as tdateedit).text);
      if (controls[t] is tedit)         then   writeString(sectionName, (controls[t] as     tedit).name , (controls[t] as     tedit).text);
      if (controls[t] is tfilenameedit) then   writeString(sectionName, (controls[t] as     tfilenameedit).name , (controls[t] as     tfilenameedit).text);
      if (controls[t] is tmenuitem)     then   writeBool  (sectionName, (controls[t] as tmenuitem).name , (controls[t] as tmenuitem).Checked);
      if (controls[t] is tPageControl)  then   writeInteger  (sectionName, (controls[t] as tPageControl).name , (controls[t] as tPageControl).ActivePageIndex);
      //encode to aviod issues with special chars
      if (controls[t] is tstrholder)    then  writeString(sectionName, (controls[t] as tstrholder).name, encode64((controls[t] as tstrholder).Strings.Text));
      if (controls[t] is tmemo)         then  writeString(sectionName, (controls[t] as tmemo).name, encode64((controls[t] as tmemo).Lines.Text));
      if (controls[t] is tcombobox)     then   writeInteger(sectionName, (controls[t] as tcombobox).name, (controls[t] as tcombobox).ItemIndex);
      if (controls[t] is tradiogroup)     then   writeInteger(sectionName, (controls[t] as tradiogroup).name, (controls[t] as tradiogroup).ItemIndex);
    end;
  end;
  iniFile.Free;
end;

procedure saveToIni(iniFileName : string; sectionName : string; Name, value : string );
var iniFile : TIniFile;
begin
  iniFile := TIniFile.Create( iniFileName );
  with iniFile do begin
    writeString(sectionName, name ,value);
  end;
  iniFile.Free;
end;

function loadFromIni(iniFileName : string; sectionName : string; Name, value : string ) : string;
var iniFile : TIniFile;
begin
  iniFile := TIniFile.Create( iniFileName );
  with iniFile do begin
    result := ReadString(sectionName, name ,value);
  end;
  iniFile.Free;
end;

function defaultBrowserIsChrome : boolean;
var
  f: System.Text;
  temp: string;
	//====================================================
	function GetAppName(Doc: string): string;
	var
	  FN, DN, RES: array[0..255] of char;
	begin
	  StrPCopy(FN, DOC);
	  DN[0]  := #0;
	  RES[0] := #0;
	  FindExecutable(FN, DN, RES);
	  Result := extractFileName(StrPas(RES));
	end;

	//====================================================
	function GetTempFile(const Extension: string): string;
	var
	  Buffer: array[0..MAX_PATH] of char;
	  aFile: string;
	begin
	  GetTempPath(SizeOf(Buffer) - 1, Buffer);
	  GetTempFileName(Buffer, 'TMP', 0, Buffer);
	  SetString(aFile, Buffer, StrLen(Buffer));
	  Result := ChangeFileExt(aFile, Extension);
	end;
begin
  temp := GetTempFile('.xml');
  AssignFile(f, temp);
  rewrite(f);
  closefile(f);
  result := pos('CHROME',upperCase(GetAppName(temp)))<>0;
  Erase(f);
end;


//https://dzone.com/articles/delphi-left-pad-function
function LeftPad(PadString : string ; HowMany : integer ; PadValue : string): string;
var
   Counter : integer;
   x : integer;
   NewString : string;
begin
   Counter := HowMany - Length(PadString);
   for x := 1 to Counter do
   begin
      NewString := NewString + PadValue;
   end;
   Result := NewString + PadString;
end;

//http://delphi.cjcsoft.net/viewthread.php?tid=43221
function CenterString(aStr: String; Len: Integer): String;
var
  posStr : integer;
begin
  if Length(aStr)>Len then
    Result := Copy(aStr, 1, Len)
  else
  begin
    posStr := (len - Length(aStr)) div 2;
    Result := Format('%*s', [len, aStr + Format('%-*s', [posStr, ''])]);
  end;
end;


procedure TMap.init(plpadKey : boolean);
begin
  tokens := TStringList.Create;
  lpadKey := plpadKey;
end;

procedure TMap.addKeyValue(key, value: string);
begin
 if lpadKey then key := LeftPad(key,10,'0');
 tokens.Add(key+'='+value);
end;

procedure TMap.prepare;
var t : integer;
begin
  tokens.Sort;
  cnt := tokens.Count;
  setLength(map, cnt);
  for t := 0 to cnt-1 do begin
   map[t].key   := ExtractWord(1,tokens.Strings[t],['=']);
   map[t].value := ExtractWord(2,tokens.Strings[t],['=']);
  end;
  tokens.Free;
end;

function TMap.getIndex(key: string): integer;
//based on http://www.swissdelphicenter.ch/torry/showcode.php?id=1916
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin
  First  := 0; //Sets the first item of the range
  Last   := cnt-1; //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if map[Pivot].key = key then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if map[Pivot].key > key then
      Last := Pivot - 1
        //else select the second half
    else
      First := Pivot + 1;
  end;
end;

function TMap.getValue(key: string): string;
var i : integer;
begin
 if lpadKey then key := LeftPad(key,10,'0');
 i := getIndex(key);
 if i = -1 then
   result := key
 else
   result := map [ i ].value;
end;

function isAltDown : Boolean;
var
  State: TKeyboardState;
begin { isAltDown }
  GetKeyboardState(State);
  Result := ((State[vk_Menu] and 128)<>0);
end; { isAltDown }

function isCtrlDown : Boolean;
var
  State: TKeyboardState;
begin { isCtrlDown }
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128)<>0);
end; { isCtrlDown }

function isShiftDown : Boolean;
var
  State: TKeyboardState;
begin { isShiftDown }
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128)<>0);
end; { isShiftDown }

initialization
 NowMarker := GetNowMarker;
 ExamineADOOracle;
 StringsPath := nvl(sysUtils.GetEnvironmentVariable('USERPROFILE'),'c:\Documents_and_Settings') + '\'+copy(extractFileName(application.ExeName), 1,   length ( extractFileName(application.ExeName) ) - 4)+'\settings\';
  { na starszych typach komputerÛw zmienna úrodowiskowa moøe zwrÛciÊ wartoúÊ pustπ
    more about env variables:
    http://vlaurie.com/computers2/Articles/environment.htm
    http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/ntcmds_shelloverview.mspx?mfr=true
  }
 FileCtrl.ForceDirectories(StringsPath);

 ApplicationDocumentsPath := nvl(sysUtils.GetEnvironmentVariable('USERPROFILE'),'c:\Documents_and_Settings') + '\'+copy(extractFileName(application.ExeName), 1,   length ( extractFileName(application.ExeName) ) - 4) +'\documents\';
 FileCtrl.ForceDirectories(ApplicationDocumentsPath);

 ApplicationDir := extractFileDir(application.exename);
 //FileCtrl.ForceDirectories(GetD+ '\'+GetTerminalName);

 VersionOfApplication := '2020-01-18';
 NazwaAplikacji := Application.Title+' ('+VersionOfApplication+')';

 try
 If GetSystemParam('Version') <> VersionOfApplication Then Begin
   //Info('Zainstalowano nowπ wersjÍ programu "'+Application.Title+'" na tym komputerze (nowa wersja to "'+VersionOfApplication+'", stara wersja to "'+GetSystemParam('Version')+'" ) Zostanπ utworzone nowe pliki konfiguracyjne (cfg, rap, scr)');
   SetSystemParam('Version',VersionOfApplication);
   DeleteFiles(StringsPath,extractFileName(Application.ExeName) + '.*.bin');
   DeleteFiles(StringsPath,extractFileName(Application.ExeName) + '.*.cfg');
   DeleteFiles(StringsPath,extractFileName(Application.ExeName) + '.*.rap');
   DeleteFiles(StringsPath,extractFileName(Application.ExeName) + '.*.scr');
   DeleteFiles(StringsPath,extractFileName(Application.ExeName) + '.*.ini');
 End;
 except
  SError('Nie powid≥o siÍ usuniÍcie plikÛw. Sprawdü, czy moøesz usuwaÊ pliki z folderu:'+StringsPath);
 End;

 try
 OdczytajParametry;
 except
  SError('Pojawi≥ siÍ b≥πd podczas prÛby odczytania parametrÛw konfiguracyjnych. Sprawdü, czy zmienna StringsPath jest prawid≥owo ustawiona. Ma ona wartoúÊ: '+StringsPath);
 end;

 CheckValid := TCheckValid.Create;
finalization
 ZachowajParametry;
end.
