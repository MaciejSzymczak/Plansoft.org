unit UWebServices;

interface

function URLEncode(const S: string): string;
procedure HttpGet(const Url: string; out Response: string);
function httpPost(url : String; postData : String; header : String; port : Integer) : String;

implementation

uses
  Windows, SysUtils, WinInet;


function URLEncode(const S: string): string;
const
  HexChars: array[0..15] of Char = '0123456789ABCDEF';
var
  I: Integer;
  Ch: Byte;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    Ch := Byte(S[I]);
    if ((Ch >= Ord('A')) and (Ch <= Ord('Z'))) or
       ((Ch >= Ord('a')) and (Ch <= Ord('z'))) or
       ((Ch >= Ord('0')) and (Ch <= Ord('9'))) or
       (Ch in [Ord('-'), Ord('_'), Ord('.'), Ord('~')]) then
    begin
      Result := Result + Chr(Ch);
    end
    else
    begin
      Result := Result + '%' + HexChars[Ch shr 4] + HexChars[Ch and $0F];
    end;
  end;
end;

function httpPost(url : String; postData : String; header : String; port : Integer) : String;
var
  hSession, hConnect, hRequest: HINTERNET;
  URLComponents: TURLComponents;
  HostName, UrlPath: string;
  Response: string;
  Buffer: array[0..1023] of Char;
  BytesRead: DWORD;
  dwStatusCode: DWORD;
  dwSize: DWORD;
begin
  FillChar(URLComponents, SizeOf(URLComponents), 0);
  URLComponents.dwStructSize := SizeOf(URLComponents);
  SetLength(HostName, INTERNET_MAX_HOST_NAME_LENGTH);
  SetLength(UrlPath, INTERNET_MAX_PATH_LENGTH);
  URLComponents.lpszHostName := PChar(HostName);
  URLComponents.dwHostNameLength := INTERNET_MAX_HOST_NAME_LENGTH;
  URLComponents.lpszUrlPath := PChar(UrlPath);
  URLComponents.dwUrlPathLength := INTERNET_MAX_PATH_LENGTH;

  if not InternetCrackUrl(PChar(URL), Length(URL), 0, URLComponents) then
    raise Exception.CreateFmt('Error parsing URL: %s', [SysErrorMessage(GetLastError)]);

  HostName := Copy(URLComponents.lpszHostName, 1, URLComponents.dwHostNameLength);
  UrlPath := Copy(URLComponents.lpszUrlPath, 1, URLComponents.dwUrlPathLength);

  hSession := InternetOpen('DelphiApp', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hSession = nil then
    raise Exception.CreateFmt('InternetOpen failed: %s', [SysErrorMessage(GetLastError)]);

  try
    //not working when server has https but with no SSL
    //hConnect := InternetConnect(hSession, PChar(HostName), URLComponents.nPort, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    hConnect := InternetConnect(hSession, PChar(HostName), port, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);  //!!!
    if hConnect = nil then
      raise Exception.CreateFmt('InternetConnect failed: %s', [SysErrorMessage(GetLastError)]);

    try
      hRequest := HttpOpenRequest(hConnect, 'POST', PChar(UrlPath), nil, nil, nil, INTERNET_FLAG_RELOAD, 0);
      if hRequest = nil then
        raise Exception.CreateFmt('HttpOpenRequest failed: %s', [SysErrorMessage(GetLastError)]);

      try
        if not HttpSendRequest(hRequest, PChar(header), length(header), PChar(postData), Length(postData)) then
          raise Exception.CreateFmt('HttpSendRequest failed: %s', [SysErrorMessage(GetLastError)]);

        // Check the status code
        dwSize := SizeOf(dwStatusCode);
        //if HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @dwStatusCode, dwSize, nil) then
        //begin
        //  if dwStatusCode <> 200 then
        //    raise Exception.CreateFmt('HTTP Error: %d', [dwStatusCode]);
        //end;

        // Read the response
        Response := '';
        repeat
          if not InternetReadFile(hRequest, @Buffer, SizeOf(Buffer), BytesRead) then
            raise Exception.CreateFmt('InternetReadFile failed: %s', [SysErrorMessage(GetLastError)]);
          if BytesRead > 0 then
            Response := Response + Copy(Buffer, 1, BytesRead);
        until BytesRead = 0;

        Result :=  Response;
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
