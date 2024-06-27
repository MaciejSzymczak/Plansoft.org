unit UWebServices;

interface

procedure HttpGet(const Url: string; out Response: string);
procedure HttpPost(const Url: string; const Data: string; out Response: string);

implementation

uses
  Windows, SysUtils, WinInet;


procedure HttpPost(const Url: string; const Data: string; out Response: string);
const
  BufferSize = 1024;
var
  hSession, hConnect, hRequest: HINTERNET;
  Headers: string;
  Buffer: array[0..BufferSize - 1] of Char;
  BytesRead: DWORD;
  DataPointer: PAnsiChar;
  DataSize: DWORD;
begin
  Response := '';
  hSession := InternetOpen('DelphiApp', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then
  try
    hConnect := InternetConnect(hSession, PChar(Url), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    if Assigned(hConnect) then
    try
      hRequest := HttpOpenRequest(hConnect, 'POST', PChar(Url), nil, nil, nil, INTERNET_FLAG_RELOAD, 0);
      if Assigned(hRequest) then
      try
        Headers := 'Content-Type: application/x-www-form-urlencoded';
        DataPointer := PAnsiChar(AnsiString(Data));
        DataSize := Length(Data);
        if HttpSendRequest(hRequest, PChar(Headers), Length(Headers), DataPointer, DataSize) then
        begin
          repeat
            InternetReadFile(hRequest, @Buffer, BufferSize, BytesRead);
            if BytesRead = 0 then Break;
            Response := Response + Copy(Buffer, 1, BytesRead);
          until False;
        end;
      finally
        InternetCloseHandle(hRequest);
      end;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;

procedure HttpGet(const Url: string; out Response: string);
const
  BufferSize = 1024;
var
  hSession, hConnect, hRequest: HINTERNET;
  Buffer: array[0..BufferSize - 1] of Char;
  BytesRead: DWORD;
begin
  Response := '';
  hSession := InternetOpen('DelphiApp', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then
  try
    hConnect := InternetOpenUrl(hSession, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if Assigned(hConnect) then
    try
      repeat
        InternetReadFile(hConnect, @Buffer, BufferSize, BytesRead);
        if BytesRead = 0 then Break;
        Response := Response + Copy(Buffer, 1, BytesRead);
      until False;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;

{

var
  Response: string;
begin
  HttpPost('http://example.com/api', 'param1=value1&param2=value2', Response);
  ShowMessage(Response);
end;

var
  Response: string;
begin
  HttpGet('http://wp.pl', Response);
  ShowMessage(Response);
end;

}

end.
