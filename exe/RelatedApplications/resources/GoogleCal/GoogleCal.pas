unit GoogleCal;

{.$DEFINE DEMO}

{$IFDEF VER210}
  {$DEFINE AFTER2010}
{$ENDIF}

{$IFDEF VER220}
  {$DEFINE AFTER2010}
{$ENDIF}

{$IFDEF VER230}
  {$DEFINE AFTER2010}
{$ENDIF}

interface

uses Classes, Contnrs, IdHTTP, IdLogFile;

type
  TReminderMethod = (rmNone, rmPopUp, rmEmail, rmSMS);

  PGReminder = ^TGReminder;
  TGReminder = record
    Minutes: Integer;
    Method: TReminderMethod;
  end;

  TGCalendar = class;

  TEventPrivacy = (epDefault, epPublic, epPrivate);
  TEventStatus = (esConfirmed = 0, esCanceled, esTentative);

  TGEvent = class
  private
    FCalendar: TGCalendar;
    FXML: String;
    FID: String;
    FHRef: String;
    FETag: WideString;
    FTitle: WideString;
    FDescription: WideString;
    FAllDay: Boolean;
    FStartTime: TDateTime;
    FEndTime: TDateTime;
    FLocation: WideString;
    FPrivacy: TEventPrivacy;
    FRepeatRule: String;
    FReminders: TList;
    FDeleted: Boolean;
    FChanged: Boolean;
    FStatus: TEventStatus;
    FOriginalEventID: String;
    FOriginalStartTime: TDateTime;
    function GetXML: String;
    procedure SetXML(const Value: String);
    function GetReminderCount: Integer;
    function GetReminder(Index: Integer): PGReminder;
  protected
    constructor Create(Calendar: TGCalendar);
  public
    destructor Destroy; override;
    procedure Delete(Batch: Boolean = False);
    procedure Store(Batch: Boolean = False; Reload: Boolean = True);
    function NewReminder: PGReminder;
    procedure DeleteReminder(Index: Integer);
    function NewRecurrenceException(ExceptionStartTime: TDateTime): TGEvent;
    property Calendar: TGCalendar read FCalendar;
    property XML: String read GetXML write SetXML;
    property ID: String read FID;
    property HRef: String read FHRef;
    property Title: WideString read FTitle write FTitle;
    property Description: WideString read FDescription write FDescription;
    property AllDay: Boolean read FAllDay write FAllDay;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property EndTime: TDateTime read FEndTime write FEndTime;
    property Location: WideString read FLocation write FLocation;
    property Privacy: TEventPrivacy read FPrivacy write FPrivacy;
    property RepeatRule: String read FrepeatRule write FRepeatRule;
    property ReminderCount: Integer read GetReminderCount;
    property Reminders[Index: Integer]: PGReminder read GetReminder;
    property Status: TEventStatus read FStatus write FStatus;
    property OriginalEventID: String read FOriginalEventID;
    property OriginalStartTime: TDateTime read FOriginalStartTime;
  end;

  TGCalendars = class;

  TGCalendar = class
  private
    FCalendars: TGCalendars;
    FXML: String;
    FID: String;
    FHRef: String;
    FEventsHRef: String;
    FName: WideString;
    FDescription: WideString;
    FLocation: WideString;
    FTimeZone: String;
    FEvents: TObjectList;
    FChanged: Boolean;
    function GetXML: String;
    procedure SetXML(const Value: String);
    function GetEventCount: Integer;
    function GetEvent(Index: Integer): TGEvent;
    procedure SetName(const Value: WideString);
    procedure SetDescription(const Value: WideString);
    procedure SetLocation(const Value: WideString);
    procedure SetTimeZone(const Value: String);
  protected
    constructor Create(Calendars: TGCalendars);
    procedure IntenalLoadEvents(const Query: String);
  public
    destructor Destroy; override;
    function IndexOfEvent(Event: TGEvent): Integer;
    function NewEvent: TGEvent;
    procedure DeleteEvent(Index: Integer; Batch: Boolean = False);
    procedure LoadEvents; overload;
    procedure LoadEvents(StartMin,StartMax: TDateTime); overload;
    procedure LoadEvents(const Text: WideString); overload;
    procedure Store;
    property XML: String read GetXML write SetXML;
    property ID: String read FID;
    property HRef: String read FHRef;
    property Name: WideString read FName write SetName;
    property Description: WideString read FDescription write SetDescription;
    property Location: WideString read FLocation write SetLocation;
    property TimeZone: String read FTimeZone write SetTimeZone;
    property EventCount: Integer read GetEventCount;
    property Events[Index: Integer]: TGEvent read GetEvent; default;
  end;

  TIdHTTP = class(IdHTTP.TIdHTTP)
  public
    procedure DoRequest(const AMethod: TIdHTTPMethod; AURL: String; ASource,AResponseContent: TStream;
      AIgnoreReplies: Array of SmallInt); override;
  end;

  TGCalendars = class
  private
    FHTTP: TIdHTTP;
    FCalendars: TObjectList;
    FLogFile: TIdLogFile;
    FLogFileName: WideString;
    function GetCalendarCount: Integer;
    function GetCalendar(Index: Integer): TGCalendar;
    procedure SetLogFileName(const Value: WideString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect(const Email,Password: String; const ProxyServer: String = '';
      ProxyPort: Integer = 0);
    procedure Disconnect;
    function NewCalendar: TGCalendar;
    procedure DeleteCalendar(Index: Integer);
    procedure LoadCalendars;
    property CalendarCount: Integer read GetCalendarCount;
    property Calendars[Index: Integer]: TGCalendar read GetCalendar; default;
    property LogFileName: WideString read FLogFileName write SetLogFileName;
  end;

implementation

uses Windows, SysUtils, Variants, XMLDoc, XMLIntf, DateUtils, IdSSLOpenSSL;

const
  GCAL_CONNECT_URL = 'https://www.google.com/accounts/ClientLogin';
  GCAL_ALL_CALENDARS_URL = 'https://www.google.com/calendar/feeds/default/allcalendars/full';
  GCAL_CREATE_CALENDAR_URL = 'https://www.google.com/calendar/feeds/default/owncalendars/full';
  //GCAL_QUERY_URL = 'https://www.google.com/calendar/feeds/default/private/full';

  ReminderMethodString: Array[TReminderMethod] of String = ('none', 'alert', 'email', 'sms');
  EventPrivacyString: Array[TEventPrivacy] of String = ('default', 'public', 'private');

function Utf8Encode_(const WS: WideString): AnsiString;
var
  L: Integer;
  Temp: AnsiString;
begin
  Result := '';
  if WS = '' then
    Exit;
  L := Length(WS);
  SetLength(Temp, L * 3); // SetLength includes space for null terminator

  L := UnicodeToUtf8(PAnsiChar(Temp), Length(Temp) + 1, PWideChar(WS), L);
  if L > 0 then
    SetLength(Temp, L - 1)
  else
    Temp := '';
  Result := Temp;
end;

function GetDateTimeForBiasSystemTime(GivenDateTime: TSystemTime; GivenYear: Integer): TDateTime;
var
  Year,Month,Day: Word;
  Hour,Minute,Second,MilliSecond: Word;
begin
  GivenDateTime.wYear := GivenYear;
  while not TryEncodeDayOfWeekInMonth(GivenDateTime.wYear, GivenDateTime.wMonth, GivenDateTime.wDay,
   GivenDateTime.wDayOfWeek, Result) do
    Dec(GivenDateTime.wDay);
  DecodeDateTime(Result, Year, Month, Day, Hour, Minute, Second, MilliSecond);
  Result := EncodeDateTime(Year, Month, Day, GivenDateTime.wHour, GivenDateTime.wMinute,
   GivenDateTime.wSecond, GivenDateTime.wMilliseconds);
end;

function GetBiasForDate(GivenDateTime: TDateTime): Integer;
var
  tzi: TIME_ZONE_INFORMATION;
begin
  GetTimeZoneInformation(tzi);
  if (tzi.StandardDate.wMonth = 0) or (tzi.DaylightDate.wMonth = 0) then
   Result := -tzi.Bias
  else
   if tzi.StandardDate.wMonth > tzi.DaylightDate.wMonth then
    if (GivenDateTime < GetDateTimeForBiasSystemTime(tzi.StandardDate, YearOf(GivenDateTime))) and
     (GivenDateTime >= GetDateTimeForBiasSystemTime(tzi.DaylightDate, YearOf(GivenDateTime))) then
     Result := -tzi.Bias - tzi.DaylightBias
    else
     Result := -tzi.Bias - tzi.StandardBias
   else
    if (GivenDateTime >= GetDateTimeForBiasSystemTime(tzi.StandardDate, YearOf(GivenDateTime))) and
     (GivenDateTime < GetDateTimeForBiasSystemTime(tzi.DaylightDate, YearOf(GivenDateTime))) then
     Result := -tzi.Bias - tzi.StandardBias
    else
     Result := -tzi.Bias - tzi.DaylightBias;
end;

function UTCToLocalDateTime(UTC: TDateTime): TDateTime;
begin
  Result := IncMinute(UTC, GetBiasForDate(UTC));
end;

function LocalDateTimeToUTC(Local: TDateTime): TDateTime;
begin
  Result := IncMinute(Local, -GetBiasForDate(Local));
end;

function OleVariantToWideString(const Value: OleVariant): WideString;
begin
  if VarIsNull(Value) then Result := ''
  else Result := Value;
end;

function StrToDateTime(const Str: String): TDateTime;
begin
  if Str[5] = '-' then
    Result := EncodeDate(StrToInt(Copy(Str, 1, 4)), StrToInt(Copy(Str, 6, 2)), StrToInt(Copy(Str, 9, 2)))
  else
    Result := EncodeDate(StrToInt(Copy(Str, 1, 4)), StrToInt(Copy(Str, 5, 2)), StrToInt(Copy(Str, 7, 2)));
  if Pos('T', Str) > 0 then
    if Pos(':', Str) > 0 then
      Result := Result + EncodeTime(StrToInt(Copy(Str, 12, 2)), StrToInt(Copy(Str, 15, 2)),
        StrToInt(Copy(Str, 18, 2)), 0)
    else
      Result := Result + EncodeTime(StrToInt(Copy(Str, 10, 2)), StrToInt(Copy(Str, 12, 2)),
        StrToInt(Copy(Str, 14, 2)), 0);
  if Pos('Z', Str) <> 0 then
    Result := UTCToLocalDateTime(Result);
end;

function FindNode(const NodeList: IXMLNodeList; const Name: WideString): IXMLNode;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to NodeList.Count - 1 do
    if NodeList[I].NodeName = Name then
    begin
      Result := NodeList[I];
      Exit;
    end;
end;

procedure TIdHTTP.DoRequest(const AMethod: TIdHTTPMethod; AURL: String; ASource,AResponseContent: TStream;
  AIgnoreReplies: Array of SmallInt);
begin
  inherited;
end;

constructor TGEvent.Create(Calendar: TGCalendar);
begin
  FCalendar := Calendar;
  FReminders := TList.Create;
end;

destructor TGEvent.Destroy;
begin
  while FReminders.Count > 0 do
   DeleteReminder(FReminders.Count - 1);
  FReminders.Free;
  inherited;
end;

function TGEvent.GetXML: String;

  procedure StoreReminders(const Node: IXMLNode);
  var
    I: Integer;
    N: IXMLNode;
  begin
    while Node.ChildNodes.Delete('reminder') >= 0 do;
    for I := 0 to FReminders.Count - 1 do
      if I < 5 then
      begin
        if Node.NodeName = 'gd:when' then
          N := Node.AddChild('reminder')
        else
          N := Node.AddChild('gd:reminder', 'http://schemas.google.com/g/2005');
        N.Attributes['minutes'] := IntToStr(Reminders[I].Minutes);
        N.Attributes['method'] := ReminderMethodString[Reminders[I].Method];
      end;
  end;

var
  XMLDoc: TXMLDocument;
  I: Integer;
begin
  Result := FXML;
  if Result = '' then
    Result := '<?xml version="1.0" encoding="UTF-8"?>' +
      '<entry xmlns="http://www.w3.org/2005/Atom" xmlns:gd="http://schemas.google.com/g/2005">' +
      '<gd:when startTime="" endTime=""></gd:when><gd:where valueString=""/><gd:eventStatus value=""/>' +
      '<gd:visibility value=""/>' +
      '</entry>';
  XMLDoc := TXMLDocument.Create(FCalendar.FCalendars.FHTTP);
  try
    XMLDoc.XML.Text := Result;
    XMLDOC.Active := True;
    with XMLDOc.DocumentElement do
    begin
      ChildValues['title'] := FTitle;
      ChildValues['content'] := FDescription;
      I := 0;
      while I < ChildNodes.Count do
      begin
        with ChildNodes[I] do
          if NodeName = 'gd:when' then
            if FRepeatRule = '' then
            begin
              if FAllDay then
              begin
                Attributes['startTime'] := FormatDateTime('yyyy-mm-dd', FStartTime);
                Attributes['endTime'] := FormatDateTime('yyyy-mm-dd', FEndTime);
              end
              else
              begin
                Attributes['startTime'] := FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss.zzz', FStartTime);
                Attributes['endTime'] := FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss.zzz', FEndTime);
              end;
              StoreReminders(XMLDOc.DocumentElement.ChildNodes[I]);
            end
            else
            begin
              XMLDoc.DocumentElement.ChildNodes.Delete(I);
              XMLDoc.DocumentElement.AddChild('gd:recurrence', 'http://schemas.google.com/g/2005');
              Continue;
            end
          else
            if NodeName = 'gd:recurrence' then
              if FRepeatRule <> '' then
              begin
                if FAllDay then
                  Text := 'DTSTART:' + FormatDateTime('yyyymmdd'#13#10, FStartTime) +
                    'DTEND:' + FormatDateTime('yyyymmdd'#13#10, FEndTime) +
                    'RRULE:' + FRepeatRule + #13#10
                else
                  Text := 'DTSTART:' + FormatDateTime('yyyymmdd"T"hhnnss"Z"'#13#10, LocalDateTimeToUTC(FStartTime)) +
                    'DTEND:' + FormatDateTime('yyyymmdd"T"hhnnss"Z"'#13#10, LocalDateTimeToUTC(FEndTime)) +
                    'RRULE:' + FRepeatRule + #13#10;
                StoreReminders(XMLDOc.DocumentElement);
              end
              else
              begin
                XMLDoc.DocumentElement.ChildNodes.Delete(I);
                XMLDoc.DocumentElement.AddChild('gd:when');
                Continue;
              end
            else
              if NodeName = 'gd:eventStatus' then
              begin
                if FStatus = esTentative then
                  Attributes['value'] := 'http://schemas.google.com/g/2005#event.tentative'
                else if FStatus = esCanceled then
                  Attributes['value'] := 'http://schemas.google.com/g/2005#event.canceled'
                else
                  Attributes['value'] := 'http://schemas.google.com/g/2005#event.confirmed';
              end
              else
                if NodeName = 'gd:where' then
                  Attributes['valueString'] := FLocation
                else
                  if NodeName = 'gd:visibility' then
                    Attributes['value'] := 'http://schemas.google.com/g/2005#event.' + EventPrivacyString[FPrivacy];
        Inc(I);
      end;
      if FOriginalEventID <> '' then
        with AddChild('gd:originalEvent') do
        begin
          Attributes['id'] := FOriginalEventID;
          AddChild('gd:when').Attributes['startTime'] := FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss.zzz', FOriginalStartTime);
        end;
    end;
    if Pos('<?xml version="1.0"?>', XMLDoc.XML.Text) <> 0 then
      Result := '<?xml version="1.0" encoding="UTF-8"?>' + UTF8Encode_(XMLDoc.DocumentElement.XML)
    else
      Result := XMLDoc.XML.Text;
  finally
    XMLDoc.Free;
  end;
end;

procedure TGEvent.SetXML(const Value: String);

  procedure ParseReminders(const Node: IXMLNode);

    function ParseMethod(const MethodStr: String; var Method: TReminderMethod): Boolean;
    var
      M: TReminderMethod;
    begin
      Result := False;
      for M := Low(TReminderMethod) to High(TReminderMethod) do
        if ReminderMethodString[M] = MethodStr then
        begin
         Method := M;
         Result := True;
         Exit;
        end;
    end;

  var
    I: Integer;
    Reminder: TGReminder;
  begin
    while FReminders.Count > 0 do
      DeleteReminder(FReminders.Count - 1);
    for I := 0 to Node.ChildNodes.Count - 1 do
      with Node.ChildNodes[I] do
        if (NodeName = 'gd:reminder') and ParseMethod(Attributes['method'], Reminder.Method) then
        begin
          Reminder.Minutes := StrToIntDef(Attributes['minutes'], 0);
          NewReminder^ := Reminder;
        end;
  end;

  function ParsePrivacy(const PrivacyStr: String; var Privacy: TEventPrivacy): Boolean;
  var
    P: TEventPrivacy;
  begin
    Result := False;
    for P := Low(TEventPrivacy) to High(TEventPrivacy) do
      if Pos(EventPrivacyString[P], PrivacyStr) > 0 then
      begin
        Privacy := P;
        Result := True;
        Exit;
      end;
  end;

var
  XMLDoc: TXMLDocument;
  I,J: Integer;
  Strings: TStringList;
  S: String;
begin
  if FXML <> Value then
  begin
    FXML := Value;
    XMLDoc := TXMLDocument.Create(FCalendar.FCalendars.FHTTP);
    try
      XMLDoc.XML.Text := Value;
      XMLDOC.Active := True;
      with XMLDOc.DocumentElement do
      begin
        FID := ChildValues['id'];
        FETag := OleVariantToWideString(Attributes['gd:etag']);
        FTitle := OleVariantToWideString(ChildValues['title']);
        FDescription := OleVariantToWideString(ChildValues['content']);
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
            if (NodeName = 'link') and (Attributes['rel'] = 'edit') then
              FHRef := Attributes['href']
            else
              if NodeName = 'gd:when' then
              begin
                FAllDay := Length(Attributes['startTime']) <= 11;
                FStartTime := StrToDateTime(Attributes['startTime']);
                FEndTime := StrToDateTime(Attributes['endTime']);
                ParseReminders(XMLDOc.DocumentElement.ChildNodes[I]);
              end
              else
                if NodeName = 'gd:recurrence' then
                begin
                  Strings := TStringList.Create;
                  try
                    Strings.Text := Text;
                    for J := 0 to Strings.Count - 1 do
                    begin
                      S := Copy(Strings[J], Pos(':', Strings[J]) + 1, MaxInt);
                      if Pos('DTSTART', Strings[J]) = 1 then
                      begin
                        FAllDay := Length(S) <= 9;
                        FStartTime := StrToDateTime(S);
                      end
                      else
                        if Pos('DTEND', Strings[J]) = 1 then
                          FEndTime := StrToDateTime(S)
                        else
                          if Pos('RRULE', Strings[J]) = 1 then
                            FRepeatRule := S
                          else
                            if Pos('BEGIN', Strings[J]) = 1 then Break;
                    end;
                  finally
                    Strings.Free;
                  end;
                  ParseReminders(XMLDOc.DocumentElement);
                end
                else
                  if NodeName = 'gd:eventStatus' then
                  begin
                    if OleVariantToWideString(Attributes['value']) = 'http://schemas.google.com/g/2005#event.tentative' then
                      FStatus := esTentative
                    else if OleVariantToWideString(Attributes['value']) = 'http://schemas.google.com/g/2005#event.canceled' then
                      FStatus := esCanceled
                    else
                      FStatus := esConfirmed;
                  end
                  else
                    if NodeName = 'gd:originalEvent' then
                    begin
                      FOriginalEventID := OleVariantToWideString(Attributes['id']);
                      FOriginalStartTime := StrToDateTime(ChildNodes[0].Attributes['startTime']);
                    end
                    else
                      if NodeName = 'gd:where' then
                        FLocation := OleVariantToWideString(Attributes['valueString'])
                      else
                        if NodeName = 'gd:visibility' then
                          ParsePrivacy(Attributes['value'], FPrivacy)
      end;
    finally
      XMLDoc.Free;
    end;
    FChanged := False;
  end;
end;

procedure TGEvent.Delete(Batch: Boolean = False);
begin
  FCalendar.DeleteEvent(FCalendar.IndexOfEvent(Self), Batch);
end;

procedure TGEvent.Store(Batch: Boolean = False; Reload: Boolean = True);
var
  S, StrResp: TStringStream;
begin
  if Batch then
    FChanged := True
  else
   with FCalendar.FCalendars.FHTTP do
   begin
    Disconnect;
    S := TStringStream.Create(GetXML);
    try
      if FHRef <> '' then
      begin
        StrResp := TStringStream.Create('');
        try
          Put(FHRef, S, StrResp);
{$IFNDEF AFTER2010}
          XML := StrResp.DataString;
{$ELSE}
          XML := UTF8Decode(StrResp.DataString);
{$ENDIF}
        finally
          StrResp.Free;
        end;
      end
      else
      begin
       //RedirectMaximum := 1;
       DoRequest('POST', FCalendar.FEventsHRef, S, nil, []);
      end;
    finally
      S.Free;
    end;
    if ResponseCode = 201 then
    begin
      Disconnect;
      if Reload then
      begin
        StrResp := TStringStream.Create('');
        try
          Get(Response.Location, StrResp);
{$IFNDEF AFTER2010}
          XML := StrResp.DataString;
{$ELSE}
          XML := UTF8Decode(StrResp.DataString);
{$ENDIF}
        finally
          StrResp.Free;
        end;
      end
      else
        FHRef := Response.Location;
    end;
    FChanged := False;
  end;
end;

function TGEvent.GetReminderCount: Integer;
begin
  Result := FReminders.Count;
end;

function TGEvent.GetReminder(Index: Integer): PGReminder;
begin
  Result := PGReminder(FReminders[Index]);
end;

function TGEvent.NewReminder: PGReminder;
begin
  New(Result);
  FReminders.Add(Result);
  Result^.Minutes := 10;
  Result^.Method := rmPopUp;
end;

procedure TGEvent.DeleteReminder(Index: Integer);
begin
  FreeMem(FReminders[Index]);
  FReminders.Delete(Index);
end;

function TGEvent.NewRecurrenceException(ExceptionStartTime: TDateTime): TGEvent;
var
  Diff: TDateTime;
begin
  Result := FCalendar.NewEvent;
  Result.XML := XML;
  Result.FID := '';
  Result.FHRef := '';
  Result.FRepeatRule := '';
  Diff := FEndTime - FStartTime;
  Result.FOriginalEventID := FID;
  Result.FOriginalStartTime := ExceptionStartTime;
  Result.FStartTime := ExceptionStartTime;
  Result.FEndTime := ExceptionStartTime + Diff;
end;

constructor TGCalendar.Create(Calendars: TGCalendars);
begin
  inherited Create;
  FCalendars := Calendars;
  if Calendars.CalendarCount > 0 then
   FTimeZone := Calendars.Calendars[0].TimeZone
  else
   FTimeZone := 'Etc/GMT';
  FEvents := TObjectList.Create;
  FChanged := True;
end;

destructor TGCalendar.Destroy;
begin
  FEvents.Free;
  inherited;
end;

function TGCalendar.GetXML: String;
var
  XMLDoc: TXMLDocument;
  I: Integer;
begin
  Result := FXML;
  if Result = '' then
    Result := '<?xml version="1.0" encoding="UTF-8"?>' +
      '<entry xmlns="http://www.w3.org/2005/Atom" xmlns:gd="http://schemas.google.com/g/2005"' +
      ' xmlns:gCal="http://schemas.google.com/gCal/2005">' +
      '<gCal:timezone value=""/><gd:where valueString=""/>' +
      '<gCal:selected value="true"/>' +
      '</entry>';
  XMLDoc := TXMLDocument.Create(FCalendars.FHTTP);
  try
    XMLDoc.XML.Text := Result;
    XMLDOC.Active := True;
    with XMLDOc.DocumentElement do
    begin
      ChildValues['title'] := FName;
      ChildValues['summary'] := FDescription;
      for I := 0 to ChildNodes.Count - 1 do
        with ChildNodes[I] do
          if NodeName = 'gd:where' then
            Attributes['valueString'] := FLocation
          else
            if NodeName = 'gCal:timezone' then
              Attributes['value'] := FTimeZone;
    end;
    if Pos('<?xml version="1.0"?>', XMLDoc.XML.Text) <> 0 then
      Result := '<?xml version="1.0" encoding="UTF-8"?>' + UTF8Encode_(XMLDoc.DocumentElement.XML)
    else
      Result := XMLDoc.XML.Text;
  finally
    XMLDoc.Free;
  end;
end;

procedure TGCalendar.SetXML(const Value: String);
var
  XMLDoc: TXMLDocument;
  I: Integer;
begin
  if FXML <> Value then
  begin
    FXML := Value;
    XMLDoc := TXMLDocument.Create(FCalendars.FHTTP);
    try
      XMLDoc.XML.Text := Value;
      XMLDOC.Active := True;
      with XMLDOc.DocumentElement do
      begin
        FID := ChildValues['id'];
        FName := OleVariantToWideString(ChildValues['title']);
        FDescription := OleVariantToWideString(ChildValues['summary']);
        for I := 0 to ChildNodes.Count - 1 do
          with ChildNodes[I] do
           if (NodeName = 'link') and (Attributes['rel'] = 'edit') then
             FHRef := Attributes['href']
           else
            if (NodeName = 'link') and (Attributes['rel'] = 'alternate') then
              FEventsHRef := Attributes['href']
            else
              if NodeName = 'gd:where' then
                FLocation := OleVariantToWideString(Attributes['valueString'])
              else
                if NodeName = 'gCal:timezone' then
                  FTimeZone := Attributes['value'];
      end;
    finally
      XMLDoc.Free;
    end;
    FChanged := False;
  end;
end;

function TGCalendar.GetEventCount: Integer;
begin
  Result := FEvents.Count;
end;

function TGCalendar.GetEvent(Index: Integer): TGEvent;
begin
  Result := TGEvent(FEvents[Index]);
end;

procedure TGCalendar.SetName(const Value: WideString);
begin
  if FName <> Value then
  begin
    FName := Value;
    FChanged := True;
  end;
end;

procedure TGCalendar.SetDescription(const Value: WideString);
begin
  if FDescription <> Value then
  begin
    FDescription := Value;
    FChanged := True;
  end;
end;

procedure TGCalendar.SetLocation(const Value: WideString);
begin
  if FLocation <> Value then
  begin
    FLocation := Value;
    FChanged := True;
  end;
end;

procedure TGCalendar.SetTimeZone(const Value: String);
begin
  if FTimeZone <> Value then
  begin
    FTimeZone := Value;
    FChanged := True;
  end;
end;

function TGCalendar.IndexOfEvent(Event: TGEvent): Integer;
begin
  Result := FEvents.IndexOf(Event);
end;

function TGCalendar.NewEvent: TGEvent;
begin
  Result := TGEvent.Create(Self);
  FEvents.Add(Result);
end;

procedure TGCalendar.DeleteEvent(Index: Integer; Batch: Boolean = False);
begin
  if Batch then
    Events[Index].FDeleted := True
  else
  begin
    if Events[Index].FHRef <> '' then
    begin
      FCalendars.FHTTP.Disconnect;
      FCalendars.FHTTP.Request.CustomHeaders.Add('If-Match: *');
      try
        FCalendars.FHTTP.DoRequest(Id_HTTPMethodDelete, Events[Index].FHRef, nil, nil, []);
      finally
        FCalendars.FHTTP.Request.CustomHeaders.Delete(FCalendars.FHTTP.Request.CustomHeaders.Count - 1);
      end;
    end;
    FEvents.Delete(Index);
  end;
end;

procedure TGCalendar.IntenalLoadEvents(const Query: String);
var
  StrResp: TStringStream;
  Resp: String;
  XMLDoc: TXMLDocument;
  I: Integer;
begin
  FEvents.Clear;
  FCalendars.FHTTP.Disconnect;
  StrResp := TStringStream.Create('');
  try
    FCalendars.FHTTP.Get(Query, StrResp);
    Resp := StrResp.DataString;
  finally
    StrResp.Free;
  end;
  if FCalendars.FHTTP.ResponseCode = 200 then
  begin
    XMLDoc := TXMLDocument.Create(FCalendars.FHTTP);
    try
{$IFNDEF AFTER2010}
      XMLDoc.XML.Text := Resp;
{$ELSE}
      XMLDoc.XML.Text := UTF8Decode(Resp);
{$ENDIF}
      XMLDOC.Active := True;
      for I := 0 to XMLDOc.DocumentElement.ChildNodes.Count - 1 do
        with XMLDOc.DocumentElement.ChildNodes[I] do
          if NodeName = 'entry' then
{$IFNDEF AFTER2010}
            NewEvent.XML := '<?xml version="1.0" encoding="UTF-8"?>' + UTF8Encode_(XML);
{$ELSE}
            NewEvent.XML := '<?xml version="1.0"?>' + XML;
{$ENDIF}
    finally
      XMLDoc.Free;
    end;
  end;
end;

procedure TGCalendar.LoadEvents;
begin
  IntenalLoadEvents(FEventsHRef + '?max-results=100000');
end;

procedure TGCalendar.LoadEvents(StartMin,StartMax: TDateTime);
begin
  IntenalLoadEvents(FEventsHRef + '?max-results=100000&start-min=' +
    FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss.zzz', StartMin) + '&start-max=' +
    FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss.zzz', StartMax));
end;

procedure TGCalendar.LoadEvents(const Text: WideString);
begin
  IntenalLoadEvents(FEventsHRef + '?max-results=100000&q=' + UTF8Encode_(Text));
end;

procedure TGCalendar.Store;
var
  S, StrResp: TStringStream;
  I, J, BatchCount: Integer;
  FBatch, FCXML: TXMLDocument;
  ToDelete: TStringList;
  BatchStr,SaveTZ: String;
  SaveName: WideString;
begin
  if FChanged then
   with FCalendars.FHTTP do
   begin
    Disconnect;
    S := TStringStream.Create(GetXML);
    try
      if FHRef <> '' then
      begin
        StrResp := TStringStream.Create('');
        try
          Put(FHRef, S, StrResp);
{$IFNDEF AFTER2010}
          XML := StrResp.DataString;
{$ELSE}
          XML := UTF8Decode(StrResp.DataString);
{$ENDIF}
        finally
          StrResp.Free;
        end;
      end
      else
      begin
       RedirectMaximum := 1;
       DoRequest('POST', GCAL_CREATE_CALENDAR_URL, S, nil, []);
      end;
    finally
      S.Free;
    end;
    if ResponseCode = 201 then
    begin
      Disconnect;
      StrResp := TStringStream.Create('');
      try
        Get(Response.Location, StrResp);
        SaveName := FName;
        SaveTZ := FTimeZone;
{$IFNDEF AFTER2010}
        XML := StrResp.DataString;
{$ELSE}
        XML := UTF8Decode(StrResp.DataString);
{$ENDIF}
      finally
        StrResp.Free;
      end;
      if FName <> SaveName then
      begin
        FName := SaveName;
        FTimeZone := SaveTZ;
        FChanged := True;
        Store;
      end;
    end;
    FChanged := False;
   end;

  if EventCount = 0 then Exit;
  FBatch := TXMLDocument.Create(FCalendars.FHTTP);
  FCXML := TXMLDocument.Create(FCalendars.FHTTP);
  ToDelete := TStringList.Create;
  try
    I := 0;
    repeat
      FBatch.XML.Text := '<?xml version="1.0" encoding="UTF-8"?>' +
        '<feed xmlns="http://www.w3.org/2005/Atom"' +
        '      xmlns:gCal="http://schemas.google.com/gCal/2005"' +
        '      xmlns:gd="http://schemas.google.com/g/2005"' +
        '      xmlns:batch="http://schemas.google.com/gdata/batch">' +
        '  <category scheme="http://schemas.google.com/g/2005#kind"' +
        ' term="http://schemas.google.com/g/2005#event" /></feed>';
      FBatch.Active := True;
      BatchCount := 0;
      repeat
        with Events[I] do
          if not FDeleted and FChanged then
          begin
            FCXML.XML.Text := XML;
            FCXML.Active := True;
            with FBatch.DocumentElement.ChildNodes[FBatch.DocumentElement.ChildNodes.Add(FCXML.DocumentElement)] do
            begin
              AddChild('batch:id', 1).NodeValue := I;
              if ID = '' then
                AddChild('batch:operation', 2).Attributes['type'] := 'insert'
              else
                AddChild('batch:operation', 2).Attributes['type'] := 'update';
            end;
            Inc(BatchCount);
          end;
        Inc(I);
      until (I = EventCount) or (BatchCount = 25);
      if BatchCount = 0 then Break;
      S := TStringStream.Create(FBatch.XML.Text);
      //FCalendars.FHTTP.Request.CustomHeaders.Add('If-Match: *');
      try
        FBatch.XML.Text := FCalendars.FHTTP.Post(FEventsHRef + '/batch', S);
      finally
        //FCalendars.FHTTP.Request.CustomHeaders.Delete(FCalendars.FHTTP.Request.CustomHeaders.Count - 1);
        S.Free;
      end;
      FBatch.Active := True;
      for J := 0 to FBatch.DocumentElement.ChildNodes.Count - 1 do
       with FBatch.DocumentElement.ChildNodes[J] do
        if NodeName = 'entry' then
          if (FindNode(ChildNodes, 'batch:operation').Attributes['type'] = 'update') and
           (FindNode(ChildNodes, 'batch:status').Attributes['code'] = 200) then
            Events[FindNode(ChildNodes, 'batch:id').NodeValue].XML := '<?xml version="1.0" ' +
             'encoding="UTF-8"?>' + UTF8Encode_(XML)
          else
            if (FindNode(ChildNodes, 'batch:operation').Attributes['type'] = 'insert') and
             (FindNode(ChildNodes, 'batch:status').Attributes['code'] = 201) then
              Events[FindNode(ChildNodes, 'batch:id').NodeValue].XML := '<?xml version="1.0" ' +
               'encoding="UTF-8"?>' + UTF8Encode_(XML);
    until I = EventCount;

    I := 0;
    repeat
      BatchStr := '<?xml version="1.0" encoding="UTF-8"?>' +
        '<feed xmlns="http://www.w3.org/2005/Atom"' +
        '      xmlns:gCal="http://schemas.google.com/gCal/2005"' +
        '      xmlns:gd="http://schemas.google.com/g/2005"' +
        '      xmlns:batch="http://schemas.google.com/gdata/batch">' +
        ' <category scheme="http://schemas.google.com/g/2005#kind"' +
        ' term="http://schemas.google.com/g/2005#event" />'#13#10;
      FBatch.Active := True;
      repeat
        with Events[I] do
          if FDeleted and (FHRef <> '') then
          begin
            BatchStr := BatchStr + '<entry><id>' + FHRef + '</id><batch:operation type="delete"/>' +
              '<batch:id>' + IntToStr(BatchCount) + '</batch:id></entry>'#13#10;
            Inc(BatchCount);
          end;
        Inc(I);
      until (I = EventCount) or (BatchCount = 50);
      if BatchCount = 0 then Break;
      S := TStringStream.Create(BatchStr + '</feed>');
      FCalendars.FHTTP.Request.CustomHeaders.Add('If-Match: *');
      try
        FBatch.XML.Text := FCalendars.FHTTP.Post(FEventsHRef + '/batch', S);
      finally
        FCalendars.FHTTP.Request.CustomHeaders.Delete(FCalendars.FHTTP.Request.CustomHeaders.Count - 1);
        S.Free;
      end;
      FBatch.Active := True;
      for J := 0 to FBatch.DocumentElement.ChildNodes.Count - 1 do
        with FBatch.DocumentElement.ChildNodes[J] do
          if (NodeName = 'entry') and
            (FindNode(ChildNodes, 'batch:operation').Attributes['type'] = 'delete') and
            (FindNode(ChildNodes, 'batch:status').Attributes['code'] = 200) then
              ToDelete.Add(Events[FindNode(ChildNodes, 'batch:id').NodeValue].FHRef);
    until I = EventCount;
    for I := EventCount - 1 downto 0 do
      with Events[I] do
        if FDeleted and ((FHRef = '') or (ToDelete.IndexOf(FHRef) <> -1)) then
          FEvents.Delete(I);
  finally
    ToDelete.Free;
    FCXML.Free;
    FBatch.Free;
  end;
end;

constructor TGCalendars.Create;
begin
  inherited Create;
  FHTTP := TIdHTTP.Create(nil);
  FHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(FHTTP);
  FHTTP.AllowCookies := True;
  FHTTP.HandleRedirects := True;
  FHTTP.RedirectMaximum := 0;
  FHTTP.ConnectTimeout := 15000;
  FHTTP.ReadTimeout := 10000;
  FCalendars := TObjectList.Create;
end;

destructor TGCalendars.Destroy;
begin
  FCalendars.Free;
  FLogFile.Free;
  FHTTP.Free;
  inherited;
end;

procedure TGCalendars.Connect(const Email,Password: String; const ProxyServer: String = '';
  ProxyPort: Integer = 0);

function ParamsEncode(const S: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    Result := Result + '%' + IntToHex(Ord(S[I]), 2);
end;

var
  Resp: String;
begin
  FHTTP.Disconnect;
  FHTTP.ProxyParams.ProxyServer := ProxyServer;
  FHTTP.ProxyParams.ProxyPort := ProxyPort;
  FHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  Resp := FHTTP.Get(GCAL_CONNECT_URL + '?accountType=HOSTED_OR_GOOGLE&Email=' + Email +
    '&Passwd=' + ParamsEncode(Password) + '&source=TGCalendars&service=cl');
  if FHTTP.ResponseCode = 200 then
  begin
    FHTTP.Request.CustomHeaders.Text := 'Authorization: GoogleLogin ' + Copy(Resp, Pos('Auth=', Resp), MaxInt);
    FHTTP.Request.CustomHeaders.Add('GData-Version: 2.0');
  end;
  FHTTP.Request.ContentType := 'application/atom+xml';
end;

procedure TGCalendars.Disconnect;
begin
  FHTTP.Disconnect;
end;

function TGCalendars.GetCalendarCount: Integer;
begin
  Result := FCalendars.Count;
end;

function TGCalendars.GetCalendar(Index: Integer): TGCalendar;
begin
  Result := TGCalendar(FCalendars[Index]);
end;

function TGCalendars.NewCalendar: TGCalendar;
begin
  Result := TGCalendar.Create(Self);
  FCalendars.Add(Result);
end;

procedure TGCalendars.DeleteCalendar(Index: Integer);
var
  URL: String;
  I: Integer;
begin
  if Calendars[Index].FHRef <> '' then
  begin
    URL := Calendars[Index].FHRef;
    I := Pos('/allcalendars/', URL);
    if I <> 0 then
      URL := Copy(URL, 1, I) + 'owncalendars' + Copy(URL, I + 13, MaxInt);
    FHTTP.Disconnect;
    FHTTP.DoRequest(Id_HTTPMethodDelete, URL, nil, nil, []);
  end;
  FCalendars.Delete(Index);
end;

procedure TGCalendars.LoadCalendars;
var
  Resp: String;
  StrResp: TStringStream;
  XMLDoc: TXMLDocument;
  I: Integer;
  Calendar: TGCalendar;
begin
  FCalendars.Clear;
  FHTTP.Disconnect;
  StrResp := TStringStream.Create('');
  try
    FHTTP.Get(GCAL_ALL_CALENDARS_URL, StrResp);
    if FHTTP.ResponseCode = 302 then
    begin
      FHTTP.Disconnect;
      FHTTP.Get(FHTTP.Response.Location, StrResp);
    end;
    Resp := StrResp.DataString;
  finally
    StrResp.Free;
  end;
  if FHTTP.ResponseCode = 200 then
  begin
    XMLDoc := TXMLDocument.Create(FHTTP);
    try
{$IFNDEF AFTER2010}
      XMLDoc.XML.Text := Resp;
{$ELSE}
      XMLDoc.XML.Text := UTF8Decode(Resp);
{$ENDIF}
      XMLDOC.Active := True;
      for I := 0 to XMLDOc.DocumentElement.ChildNodes.Count - 1 do
        with XMLDOc.DocumentElement.ChildNodes[I] do
          if NodeName = 'entry' then
          begin
            Calendar := NewCalendar;
{$IFNDEF AFTER2010}
            Calendar.XML := '<?xml version="1.0" encoding="UTF-8"?>' + UTF8Encode_(XML);
{$ELSE}
            Calendar.XML := '<?xml version="1.0"?>' + XML;
{$ENDIF}
            Calendar.FChanged := False;
          end;
    finally
      XMLDoc.Free;
    end;
  end;
end;

procedure TGCalendars.SetLogFileName(const Value: WideString);
begin
  if FLogFileName = Value then
    Exit;
  FLogFileName := Value;
  if Trim(FLogFileName) <> '' then
  begin
    if FLogFile = nil then
    begin
      FLogFile := TIdLogFile.Create;
      FLogFile.ReplaceCRLF := False;
      FHTTP.Intercept := FLogFile;
    end;
    FLogFile.Filename := FLogFileName;
    FLogFile.Active := True;
  end
  else
  begin
    FLogFile.Free;
  end;
end;

{$IFDEF DEMO}
initialization
  if DebugHook = 0 then
  begin
   MessageBox(0, 'GoogleCalendar trial version requires Delphi IDE!', 'Error', 0);
   Halt(1);
  end;
{$ENDIF}
end.
