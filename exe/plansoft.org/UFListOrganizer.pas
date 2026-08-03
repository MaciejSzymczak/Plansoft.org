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
    BitBtn1: TBitBtn;
    BClearAndSelect: TBitBtn; //2026-07: renamed from beditpopup - no longer opens a popup menu, directly clears the list and reopens the picker
    BSetPrimary: TBitBtn; //2026-07: renamed from BitBtn2 - moves the selected resource to the top of the list and confirms the dialog (shared with lbNamesDblClick), making it the primary resource
    PanelRowButtons: TPanel; //2026-07: hosts dynamically-created per-row SetPrimary/Delete buttons for lbNames
    procedure lbNamesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbNamesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbNamesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbNamesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbNamesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BUpClick(Sender: TObject);
    procedure BDownClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure lbNamesDblClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BClearAndSelectClick(Sender: TObject);
  private
    resType: string;
    RowButtonsHooked: boolean;
    OldLbNamesWndProc: TWndMethod;
    RowSetButtons: array of TSpeedButton;
    RowDelButtons: array of TSpeedButton;
    RowDetailsButtons: array of TSpeedButton;
    procedure NewLbNamesWndProc(var Message: TMessage);
    procedure RefreshRowButtons;
    procedure RowSetPrimaryClick(Sender: TObject);
    procedure RowDeleteClick(Sender: TObject);
    procedure RowDetailsClick(Sender: TObject);
    procedure WMRowDelete(var Msg: TMessage); message WM_USER + 100; //2026-07: deletion is deferred via PostMessage - freeing the row TSpeedButton synchronously from within its own OnClick caused an intermittent Access Violation
  public
    function showList (presType: string; Sender: TObject; ids, displayedItems : string; WordDelim : Char) : tmodalResult;
  end;

var
  FListOrganizer: TFListOrganizer;

var
  NumY, NumX: Integer;

implementation

{$R *.dfm}

Uses UUtilityParent, AutoCreate, UFProgramSettings, DM, UUtilities, UCommon,
  UFMain;

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

 if not RowButtonsHooked then begin
   OldLbNamesWndProc := lbNames.WindowProc;
   lbNames.WindowProc := NewLbNamesWndProc;
   RowButtonsHooked := true;
 end;
 RefreshRowButtons;

 ActiveControl := lbNames;
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

procedure TFListOrganizer.lbNamesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var s : string;
begin
  with (Control as TListBox).Canvas do begin
    if odSelected in State then begin
      Brush.Color := clHighlight;
      Font.Color  := clHighlightText;
    end else begin
      Brush.Color := (Control as TListBox).Color;
      Font.Color  := (Control as TListBox).Font.Color;
    end;
    FillRect(Rect);
    s := (Control as TListBox).Items[Index];
    TextOut(Rect.Left + 4, Rect.Top + (Rect.Bottom - Rect.Top - TextHeight(s)) div 2, s);
  end;
  if odFocused in State then (Control as TListBox).Canvas.DrawFocusRect(Rect);
end;

procedure TFListOrganizer.lbNamesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    lbNamesDblClick(Sender);
    Key := 0;
  end;
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
 RefreshRowButtons;
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
     Then Info('Ten zasób ju¿ zosta³ wybrany')
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
      Then Info('Ten zasób ju¿ zosta³ wybrany')
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
      Then Info('Ten zasób ju¿ zosta³ wybrany')
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
      Then Info('Ten zasób ju¿ zosta³ wybrany')
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
 RefreshRowButtons;
end;

procedure TFListOrganizer.BitBtn1Click(Sender: TObject);
var InItems, OutItems, OutItems_dsp: String;
    t, len : integer;
    WordDelim : char;
    sqlS : string;
begin
  WordDelim := ';';
  InItems := replace(FListOrganizer.lbIds.Items.CommaText,',',';');
  OutItems := getChildsAndParents(InItems, '', true, false, true);
  //ConGroup.Text := getChildsAndParents(InItems, '', true, false, true);
  //conResCat0.Text := getChildsAndParents(InItems, '', true, false, true);
  //conResCat1.Text := getChildsAndParents(InItems, '', true, false, true);

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

  RefreshRowButtons;
end;

procedure TFListOrganizer.BClearAndSelectClick(Sender: TObject);
begin
  lbNames.Items.Clear;
  lbIds.Items.Clear;
  BAddClick(Sender);
end;

procedure TFListOrganizer.NewLbNamesWndProc(var Message: TMessage);
begin
  OldLbNamesWndProc(Message);
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then
    RefreshRowButtons;
end;

procedure TFListOrganizer.RefreshRowButtons;
const
  RowBtnGapH = 19; //~0.5cm at 96dpi
  RowBtnGapV = 3;
var
  i, row, y, lastVisible, btnWidth, btnHeight : integer;
  btnSet, btnDel, btnDetails : TSpeedButton;
begin
  for i := 0 to High(RowSetButtons) do begin
    RowSetButtons[i].Free;
    RowDelButtons[i].Free;
    RowDetailsButtons[i].Free;
  end;
  SetLength(RowSetButtons, 0);
  SetLength(RowDelButtons, 0);
  SetLength(RowDetailsButtons, 0);

  if lbNames.Items.Count = 0 then Exit;

  SetLength(RowSetButtons, lbNames.Items.Count);
  SetLength(RowDelButtons, lbNames.Items.Count);
  SetLength(RowDetailsButtons, lbNames.Items.Count);

  btnHeight := lbNames.ItemHeight - RowBtnGapV*2;
  btnWidth  := (PanelRowButtons.ClientWidth - RowBtnGapH*4) div 3;

  lastVisible := lbNames.TopIndex + (lbNames.ClientHeight div lbNames.ItemHeight);
  for i := lbNames.TopIndex to lastVisible do begin
    if (i < 0) or (i >= lbNames.Items.Count) then continue;
    row := i - lbNames.TopIndex;
    y := row * lbNames.ItemHeight + RowBtnGapV;
    if y + btnHeight > lbNames.ClientHeight then break;

    btnSet := TSpeedButton.Create(PanelRowButtons);
    btnSet.Parent := PanelRowButtons;
    btnSet.SetBounds(RowBtnGapH, y, btnWidth, btnHeight);
    btnSet.Glyph.Assign(BSetPrimary.Glyph);
    btnSet.Hint := 'Wybierz ten zasób';
    btnSet.ShowHint := true;
    btnSet.Tag := i;
    btnSet.OnClick := RowSetPrimaryClick;
    RowSetButtons[i] := btnSet;

    btnDel := TSpeedButton.Create(PanelRowButtons);
    btnDel.Parent := PanelRowButtons;
    btnDel.SetBounds(RowBtnGapH*2+btnWidth, y, btnWidth, btnHeight);
    btnDel.Glyph.Assign(BDelete.Glyph);
    btnDel.Hint := 'Usuñ z listy';
    btnDel.ShowHint := true;
    btnDel.Tag := i;
    btnDel.OnClick := RowDeleteClick;
    RowDelButtons[i] := btnDel;

    btnDetails := TSpeedButton.Create(PanelRowButtons);
    btnDetails.Parent := PanelRowButtons;
    btnDetails.SetBounds(RowBtnGapH*3+btnWidth*2, y, btnWidth, btnHeight);
    btnDetails.Caption := '...';
    btnDetails.Hint := 'Edytuj szczegó³y zasobu';
    btnDetails.ShowHint := true;
    btnDetails.Tag := i;
    btnDetails.OnClick := RowDetailsClick;
    RowDetailsButtons[i] := btnDetails;
  end;
end;

procedure TFListOrganizer.RowSetPrimaryClick(Sender: TObject);
begin
  lbNames.ItemIndex := TSpeedButton(Sender).Tag;
  lbNamesDblClick(Sender);
end;

procedure TFListOrganizer.RowDeleteClick(Sender: TObject);
begin
  lbNames.ItemIndex := TSpeedButton(Sender).Tag;
  PostMessage(Handle, WM_USER + 100, 0, 0);
end;

procedure TFListOrganizer.RowDetailsClick(Sender: TObject);
var recId : ShortString;
    idx   : integer;
begin
  idx := TSpeedButton(Sender).Tag;
  recId := lbIds.Items[idx];

  if resType = 'L'  then LECTURERSShowModalAsSingleRecord(AEdit, recId);
  if resType = 'G'  then GROUPSShowModalAsSingleRecord(AEdit, recId);
  if (resType = 'R') or (resType = 'R2') then ROOMSShowModalAsSingleRecord(AEdit, recId);

  if resType ='L'  then lbNames.Items[idx] := DModule.SingleValue(sql_LECDESC+recId);
  if resType ='G'  then lbNames.Items[idx] := DModule.SingleValue(sql_GRODESC+recId);
  if resType ='R'  then lbNames.Items[idx] := DModule.SingleValue(sql_ResCat0DESC+recId);
  if resType ='R2' then lbNames.Items[idx] := DModule.SingleValue(sql_ResCat1DESC+recId);
end;

procedure TFListOrganizer.WMRowDelete(var Msg: TMessage);
begin
  BDeleteClick(Self);
end;

end.

