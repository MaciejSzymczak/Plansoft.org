unit UFListOrganizer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFListOrganizer = class(TFormConfig)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    BUp: TSpeedButton;
    BDown: TSpeedButton;
    lbNames: TListBox;
    BCancel: TBitBtn;
    BDelete: TBitBtn;
    BAdd: TBitBtn;
    lbIds: TListBox;
    BDeleteAll: TBitBtn;
    BitBtn1: TBitBtn;
    procedure lbNamesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbNamesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbNamesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BUpClick(Sender: TObject);
    procedure BDownClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure lbNamesDblClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BDeleteAllClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    resType: string;
  public
    function showList (presType: string; Sender: TObject; ids, displayedItems : string; WordDelim : Char) : tmodalResult;
  end;

var
  FListOrganizer: TFListOrganizer;

var
  NumY, NumX: Integer;

implementation

{$R *.dfm}

Uses UUtilityParent, AutoCreate, UFProgramSettings, DM, UUtilities, UCommon;

function TFListOrganizer.showList (presType: string; Sender: TObject; ids, displayedItems : string; WordDelim : Char) : tmodalResult;
var t, len : integer;
    point : tpoint;
    btn   : tcontrol;
begin
  lbNames.Items.Clear;
  lbIds.Items.Clear;
  len := WordCount(displayedItems,[WordDelim]);

  for t := 1 to len do begin
    lbNames.Items.Add( ExtractWord(t,displayedItems,[WordDelim]) );
      lbIds.Items.Add( ExtractWord(t,ids           ,[WordDelim]) );
  end;

 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 FListOrganizer.Left:= Point.X;
 FListOrganizer.Top := Point.Y;

 lbNames.ItemIndex := 0;
 resType := presType;
 //BSelect.Enabled := lbNames.Items.Count >0;
 result := showModal;
end;

procedure TFListOrganizer.lbNamesDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Num1, Num2: Integer;
  Point1, Point2: TPoint;
begin
  Point1.X:=NumX;
  Point1.Y:=NumY;
  Point2.X:=X;
  Point2.Y:=Y;
  with Source as TListBox do
  begin
    Num2:=lbNames.ItemAtPos(Point1, True);
    Num1:=lbNames.ItemAtPos(Point2, True);
    lbNames.Items.Move(Num2, Num1);
    lbNames.ItemIndex := Num1;

    lbIds.Items.Move(Num2, Num1);
    lbIds.ItemIndex := Num1;
  end;
end;



procedure TFListOrganizer.lbNamesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=Source=lbNames;
end;

procedure TFListOrganizer.lbNamesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  NumY:=Y;
  NumX:=X;
end;

procedure TFListOrganizer.BUpClick(Sender: TObject);
var i : integer;
begin
  i := lbNames.ItemIndex;
  if i >0 then begin
    lbNames.Items.Move(i, i-1);
    lbNames.ItemIndex := i-1;
    lbIds.Items.Move(i, i-1);
    lbIds.ItemIndex := i-1;
  end
end;

procedure TFListOrganizer.BDownClick(Sender: TObject);
var i : integer;
begin
  i := lbNames.ItemIndex;
  if i <lbNames.Items.Count-1 then begin
    lbNames.Items.Move(i, i+1);
    lbNames.ItemIndex := i+1;
    lbIds.Items.Move(i, i+1);
    lbIds.ItemIndex := i+1;
  end
end;

procedure TFListOrganizer.BDeleteClick(Sender: TObject);
var i : integer;
begin
 i := lbNames.ItemIndex;
 if (i <> -1) then begin
   lbNames.Items.Delete(i);
   lbIds.Items.Delete(i);
   if (i <lbNames.Items.Count) then begin
     lbNames.ItemIndex := i;
     lbIds.ItemIndex := i;
   end
   else begin
     lbNames.ItemIndex := i-1;
     lbIds.ItemIndex := i-1;
   end
 end;

 //BSelect.Enabled := lbNames.Items.Count >0;
end;

procedure TFListOrganizer.lbNamesDblClick(Sender: TObject);
var i : integer;
begin
  i := lbNames.ItemIndex;
  if i >0 then begin
    lbNames.Items.Move(i, 0);
    lbNames.ItemIndex := 0;
    lbIds.Items.Move(i, 0);
    lbIds.ItemIndex := 0;
  end;
 modalResult := mrOK;
end;

procedure TFListOrganizer.BAddClick(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t, i      : integer;
begin
if resType ='L' then begin
  KeyValue := '';
  If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue( replace(lbIds.Items.CommaText,',',';') , [';'], KeyValue)
     Then Info('Nie mo¿na wybraæ ponownie tego samego elementu:' + fprogramsettings.profileObjectNameL.Text)
     Else begin
       lbIds.Items.Add(KeyValue);
       lbNames.Items.Add( DModule.SingleValue(sql_LECDESC+KeyValue) );
       i := lbNames.Items.Count-1;
       lbNames.Items.Move(i, 0);
       lbIds.Items.Move(i, 0);
       lbNames.ItemIndex := 0;
     end;
   end;
  End;
end;

if resType='G' then begin
  KeyValue := '';
  If GROUPSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue( replace(lbIds.Items.CommaText,',',';'), [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego elementu:' + fprogramsettings.profileObjectNameG.Text)
      Else begin
       lbIds.Items.Add(KeyValue);
       lbNames.Items.Add( DModule.SingleValue(sql_GRODESC+KeyValue) );
       i := lbNames.Items.Count-1;
       lbNames.Items.Move(i, 0);
       lbIds.Items.Move(i, 0);
       lbNames.ItemIndex := 0;
      end;
   end;
  End;
end;

if resType='R' then begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId0,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue( replace(lbIds.Items.CommaText,',',';'), [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else begin
       lbIds.Items.Add(KeyValue);
       lbNames.Items.Add( DModule.SingleValue(sql_ResCat0DESC+KeyValue) );
       i := lbNames.Items.Count-1;
       lbNames.Items.Move(i, 0);
       lbIds.Items.Move(i, 0);
       lbNames.ItemIndex := 0;
      end;
   end;
  End;
end;

if resType='R2' then begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId1,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If existsValue(replace(lbIds.Items.CommaText,',',';'), [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else begin
       lbIds.Items.Add(KeyValue);
       lbNames.Items.Add( DModule.SingleValue(sql_ResCat1DESC+KeyValue) );
       i := lbNames.Items.Count-1;
       lbNames.Items.Move(i, 0);
       lbIds.Items.Move(i, 0);
       lbNames.ItemIndex := 0;
      end;
   end;
  End;
end;

 //BSelect.Enabled := lbNames.Items.Count >0;
end;

procedure TFListOrganizer.BDeleteAllClick(Sender: TObject);
begin
  lbNames.Items.Clear;
  lbIds.Items.Clear;
  BAddClick(Sender);
end;

procedure TFListOrganizer.BitBtn1Click(Sender: TObject);
var InItems, OutItems, OutItems_dsp: String;
    t, len : integer;
    WordDelim : char;
    sqlS : string;
begin
  WordDelim := ';';
  InItems := replace(FListOrganizer.lbIds.Items.CommaText,',',';');
  OutItems := getChildsAndParents(InItems, '', true, false);
  //ConGroup.Text := getChildsAndParents(InItems, '', true, false);
  //conResCat0.Text := getChildsAndParents(InItems, '', true, false);
  //conResCat1.Text := getChildsAndParents(InItems, '', true, false);

  lbIds.Items.Clear;
  len := WordCount(OutItems,[WordDelim]);
  for t := 1 to len do begin
      lbIds.Items.Add( ExtractWord(t,OutItems ,[WordDelim]) );
  end;

  if resType ='L'  then sqlS := sql_LECDESC;
  if resType ='G'  then sqlS := sql_GRODESC;
  if resType ='R'  then sqlS := sql_ResCat0DESC;
  if resType ='R2' then sqlS := sql_ResCat1DESC;

  OutItems_dsp := FChange(OutItems, sqlS);

  lbNames.Items.Clear;
  len := WordCount(OutItems_dsp,[WordDelim]);
  for t := 1 to len do begin
      lbNames.Items.Add( ExtractWord(t,OutItems_dsp ,[WordDelim]) );
  end;


end;

end.

