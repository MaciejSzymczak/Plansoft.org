unit SqlUtils;

interface

uses DBTables, SysUtils;

function QueryLocate(Q:TQuery;Column:Integer;Value:String):Boolean;
function QuerySeek(Q:TQuery;Column:Integer;Value:String;Soft:Boolean):Boolean;

implementation

function QueryLocate(Q:TQuery;Column:Integer;Value:String):Boolean;
begin
  Q.DisableControls;
  Q.First;
  while not(Q.EOF) AND (Q.Fields[Column].AsString<>Value) do Q.Next;
  if Q.EOF then QueryLocate:=FALSE else QueryLocate:=TRUE;
  Q.EnableControls;
end;

function QuerySeek(Q:TQuery;Column:Integer;Value:String;Soft:Boolean):Boolean;
var back:LONGINT;
begin
  Result:=FALSE;
  Q.DisableControls;
  if (Value='') OR (Q.RecordCount=0) then begin
    Q.First;
    Q.EnableControls;
    exit;
  end;
  back:=0;
  if AnsiCompareStr(Value,Q.Fields[Column].AsString)>0 then begin
    while (not Q.EOF) AND (AnsiCompareStr(Q.Fields[Column].AsString,Value)<0) do
    begin
      Dec(back);
      Q.Next;
    end;
    if Q.EOF then begin
      QuerySeek:=FALSE;
      Q.MoveBy(back);
    end else begin
      if Pos(Value,Q.Fields[Column].AsString)=0 then begin
        if not soft then begin
          QuerySeek:=FALSE;
          Q.MoveBy(back);
        end else begin
          QuerySeek:=TRUE;
        end;
      end;
    end;
  end else begin
    while (not Q.BOF) AND (AnsiCompareStr(Value,Q.Fields[Column].AsString)<0) do begin
      Inc(back);
      Q.Prior;
     end;
  end;
  if Q.BOF then begin
    if Soft OR (Pos(Value,Q.Fields[Column].AsString)<>0) then begin
      Q.First;
      QuerySeek:=TRUE;
      Q.EnableControls;
      exit;
    end;
    QuerySeek:=FALSE;
    Q.MoveBy(back);
  end else begin
    if Pos(Value,Q.Fields[Column].AsString)=0 then begin
      if not soft then begin
        QuerySeek:=FALSE;
        Q.MoveBy(back);
      end else begin
        if AnsiCompareStr(Value,Q.Fields[Column].AsString)>0 then begin
          Q.Next;
          if Q.EOF then Q.Last;
        end;
        QuerySeek:=TRUE;
      end;
    end;
  end;
  Q.EnableControls;
end;

end.
