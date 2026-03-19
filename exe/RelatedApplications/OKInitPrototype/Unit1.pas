unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    okinitPath: TEdit;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Username: TEdit;
    Password: TEdit;
    Label4: TLabel;
    Tokenlocation: TEdit;
    log: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

/// Uruchamia okinit.exe i przekazuje has³o przez stdin.
/// APrincipal np. 'jan.kowalski@PS.LOCAL'
/// AOkinitPath - pe³na œcie¿ka do okinit.exe
/// AKrb5CCName - œcie¿ka do pliku cache, np. 'FILE:C:\Users\jan\krb5cc'
///   (ustawiana te¿ jako KRB5CCNAME w env procesu)
function OkinitGetTicket(
  const APrincipal  : string;
  const APassword   : string;
  const AOkinitPath : string;
  const AKrb5CCName : string;
  out   AExitCode   : DWORD;
  out   AErrorMsg   : string
): Boolean;
var
  SA               : TSecurityAttributes;
  hReadPipe        : THandle;
  hWritePipe       : THandle;
  SI               : TStartupInfo;
  PI               : TProcessInformation;
  sCmd             : string;
  sPassword        : AnsiString;
  BytesWritten     : DWORD;
  sEnvBlock        : string;
  pEnvBlock        : Pointer;
  WaitResult       : DWORD;
begin
  Result     := False;
  AExitCode  := $FFFFFFFF;
  AErrorMsg  := '';
  hReadPipe  := INVALID_HANDLE_VALUE;
  hWritePipe := INVALID_HANDLE_VALUE;
 
  // --- 1. Pipe dla stdin procesu okinit ---
  SA.nLength              := SizeOf(SA);
  SA.bInheritHandle       := True;          // okinit musi dziedziczyæ uchwyt
  SA.lpSecurityDescriptor := nil;

  Form1.log.Lines.Add('Running CreatePipe...');
  if not CreatePipe(hReadPipe, hWritePipe, @SA, 0) then
  begin
    AErrorMsg := 'CreatePipe failed: ' + SysErrorMessage(GetLastError);
    Form1.log.Lines.Add(AErrorMsg);
    Exit;
  end;
  Form1.log.Lines.Add('No error');

  // Strona zapisu NIE powinna byæ dziedziczona przez potomka
  Form1.log.Lines.Add('Running SetHandleInformation...');
  SetHandleInformation(hWritePipe, HANDLE_FLAG_INHERIT, 0);

  try
    // --- 2. Environment block z nadpisanym KRB5CCNAME ---
    // Najpierw kopiujemy bie¿¹ce œrodowisko, potem dopisujemy zmienn¹.
    // Proœciej: SetEnvironmentVariable wp³ywa te¿ na blok budowany przez
    // CreateProcess gdy pEnvBlock=nil, ale to brudne dla wielow¹tkowych apps.
    // Zamiast tego - budujemy blok rêcznie lub ustawiamy i przywracamy.
    Form1.log.Lines.Add('Running SetEnvironmentVariable... KRB5CCNAME='+AKrb5CCName);
    SetEnvironmentVariable('KRB5CCNAME', PChar(AKrb5CCName));

    // --- 3. Uruchomienie okinit.exe ---
    ZeroMemory(@SI, SizeOf(SI));
    SI.cb          := SizeOf(SI);
    SI.dwFlags     := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    SI.wShowWindow := SW_HIDE;
    SI.hStdInput   := hReadPipe;
    // stdout/stderr - mo¿na przekierowaæ do osobnych pipe, tu ukrywamy
    SI.hStdOutput  := INVALID_HANDLE_VALUE;
    SI.hStdError   := INVALID_HANDLE_VALUE;

    // okinit [opcjonalne flagi] <principal>
    sCmd := Format('"%s" %s', [AOkinitPath, APrincipal]);
    Form1.log.Lines.Add('Running CreateProcess... sCmd='+sCmd);

    if not CreateProcess(
      nil,               // lpApplicationName
      PChar(sCmd),       // lpCommandLine
      nil, nil,
      True,              // bInheritHandles - wa¿ne!
      CREATE_NO_WINDOW,
      nil,               // lpEnvironment - nil = dziedziczy bie¿¹ce (z KRB5CCNAME)
      nil,               // lpCurrentDirectory
      SI, PI)
    then
    begin
      AErrorMsg := 'CreateProcess failed: ' + SysErrorMessage(GetLastError);
      Form1.log.Lines.Add(AErrorMsg);
      Exit;
    end;
    Form1.log.Lines.Add('CreateProcess: No errors');

    // --- 4. Zamknij stronê odczytu po przekazaniu do procesu ---
    // Muszê zamkn¹æ ZANIM napiszê, bo inaczej ReadFile w okinit mo¿e wisieæ
    CloseHandle(hReadPipe);
    hReadPipe := INVALID_HANDLE_VALUE;

    // --- 5. Wyœlij has³o + Enter przez stdin ---
    sPassword := AnsiString(APassword) + #10;   // LF wystarczy; #13#10 te¿ OK
    Form1.log.Lines.Add('Running WriteFile... Password: ' + sPassword);
    if not WriteFile(hWritePipe, sPassword[1], Length(sPassword),
                     BytesWritten, nil) then
      AErrorMsg := 'WriteFile (password): ' + SysErrorMessage(GetLastError);

    Form1.log.Lines.Add(AErrorMsg);

    // Zamknij stronê zapisu - okinit dostanie EOF i bêdzie wiedzia³,
    // ¿e nie bêdzie wiêcej danych
    Form1.log.Lines.Add('Running CloseHandle...');
    CloseHandle(hWritePipe);
    hWritePipe := INVALID_HANDLE_VALUE;
 
    // --- 6. Czekaj na zakoñczenie (max 15 s) ---
    Form1.log.Lines.Add('Running WaitForSingleObject...');
    WaitResult := WaitForSingleObject(PI.hProcess, 15000);
    if WaitResult = WAIT_TIMEOUT then
    begin
      Form1.log.Lines.Add('Running TerminateProcess...');
      TerminateProcess(PI.hProcess, 1);
      AErrorMsg := 'okinit timeout';
      Form1.log.Lines.Add(AErrorMsg);
    end
    else
    begin
      Form1.log.Lines.Add('Running GetExitCodeProcess');
      GetExitCodeProcess(PI.hProcess, AExitCode);
      if AExitCode = 0 then begin
        Result := True;
        Form1.log.Lines.Add('Success');
      end else begin
        AErrorMsg := Format('ERROR. Exitcode: %d', [AExitCode]);
        Form1.log.Lines.Add(AErrorMsg);
      end;
    end;

    CloseHandle(PI.hProcess);
    CloseHandle(PI.hThread);

  finally
    if hReadPipe  <> INVALID_HANDLE_VALUE then CloseHandle(hReadPipe);
    if hWritePipe <> INVALID_HANDLE_VALUE then CloseHandle(hWritePipe);
  end;
end;



procedure TForm1.BitBtn1Click(Sender: TObject);
var
  ExCode : DWORD;
  ErrMsg : string;
begin
 log.Lines.Clear;
  if OkinitGetTicket(
       Username.text,
       Password.Text,
       okinitPath.Text,
       Tokenlocation.text,
       ExCode, ErrMsg)
  then
    ShowMessage('Ticket uzyskany - mo¿na siê po³¹czyæ z baz¹')
  else
    ShowMessage('B³¹d: ' + ErrMsg);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Unikalny cache per u¿ytkownik na serwerze terminali
  Tokenlocation.text := Format('FILE:C:\Users\%s\krb5cc',
                   [GetEnvironmentVariable('USERNAME')]);
end;

end.
