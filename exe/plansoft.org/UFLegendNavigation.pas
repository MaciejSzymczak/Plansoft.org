unit UFLegendNavigation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UCommon, UFListOrganizer;

type
  TFLegendNavigation = class(TForm)
    LabelL: TLabel;
    LabelG: TLabel;
    LabelR: TLabel;
    LabelS: TLabel;
    LabelF: TLabel;
    ListL: TListBox;
    ListG: TListBox;
    ListR: TListBox;
    ListS: TListBox;
    ListF: TListBox;
    PanelRowL: TPanel;
    PanelRowG: TPanel;
    PanelRowR: TPanel;
    PanelRowS: TPanel;
    PanelRowF: TPanel;
    Bcancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BcancelClick(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure ListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    WndProcsHooked : Boolean;
    OldWndProcL, OldWndProcG, OldWndProcR, OldWndProcS, OldWndProcF : TWndMethod;
    // per category (0=L,1=G,2=R,3=S,4=F): one row-button per visible listbox row
    RowSelectBtns : array[0..4] of array of TSpeedButton;
    RowEditBtns   : array[0..4] of array of TSpeedButton;
    RowStatBtns   : array[0..4] of array of TSpeedButton;

    function  GetListForCat(catIdx : Integer) : TListBox;
    function  GetPanelForCat(catIdx : Integer) : TPanel;
    function  GetCatChar(catIdx : Integer) : ShortString;

    procedure FillList(list : TListBox; items : TStrings);
    procedure ClearListObjects(list : TListBox);
    function  layoutSection(catIdx : Integer; lbl : TLabel; list : TListBox; panel : TPanel; top : integer) : integer;
    procedure RefreshRowButtons(catIdx : Integer; list : TListBox; panel : TPanel);

    procedure RowSelectClick(Sender : TObject);
    procedure RowEditClick(Sender : TObject);
    procedure RowStatClick(Sender : TObject);

    procedure NewWndProcL(var Message: TMessage);
    procedure NewWndProcG(var Message: TMessage);
    procedure NewWndProcR(var Message: TMessage);
    procedure NewWndProcS(var Message: TMessage);
    procedure NewWndProcF(var Message: TMessage);
  public
    selectedOption : ShortString;
    selectedId : ShortString; // matches the 'Var ID : ShortString' params of *ShowModalAsSingleRecord etc.
    // items* : one line per object, formatted 'id|display name' - the id is stripped from what's
    // shown (only the name is visible) and kept per-row via TListBox.Items.Objects instead.
    function Open(itemsL, itemsG, itemsR, itemsF, itemsS : TStrings) : tModalResult;
  end;

var
  FLegendNavigation: TFLegendNavigation;

implementation

{$R *.dfm}

{ TFLegendNavigation }

function TFLegendNavigation.GetListForCat(catIdx : Integer) : TListBox;
begin
  case catIdx of
    0: Result := ListL;
    1: Result := ListG;
    2: Result := ListR;
    3: Result := ListS;
    4: Result := ListF;
    else Result := nil;
  end;
end;

function TFLegendNavigation.GetPanelForCat(catIdx : Integer) : TPanel;
begin
  case catIdx of
    0: Result := PanelRowL;
    1: Result := PanelRowG;
    2: Result := PanelRowR;
    3: Result := PanelRowS;
    4: Result := PanelRowF;
    else Result := nil;
  end;
end;

function TFLegendNavigation.GetCatChar(catIdx : Integer) : ShortString;
begin
  case catIdx of
    0: Result := 'L';
    1: Result := 'G';
    2: Result := 'R';
    3: Result := 'S';
    4: Result := 'F';
    else Result := '';
  end;
end;

procedure TFLegendNavigation.ClearListObjects(list : TListBox);
var i : Integer;
begin
  for i := 0 to list.Items.Count - 1 do
    if Assigned(list.Items.Objects[i]) then begin
      TString(list.Items.Objects[i]).Free;
      list.Items.Objects[i] := nil;
    end;
end;

// splits each 'id|display name' input line so the listbox shows only the name;
// the id travels along as Items.Objects[i] (a TString wrapper), never displayed.
procedure TFLegendNavigation.FillList(list : TListBox; items : TStrings);
var i, sepPos : Integer;
    line, id, dispName : string;
begin
  ClearListObjects(list);
  list.Items.Clear;
  for i := 0 to items.Count - 1 do begin
    line := items[i];
    sepPos := Pos('|', line);
    if sepPos > 0 then begin
      id := Copy(line, 1, sepPos - 1);
      dispName := Copy(line, sepPos + 1, Length(line));
    end else begin
      id := '';
      dispName := line;
    end;
    list.Items.AddObject(dispName, TString.Create(id));
  end;
end;

// positions one category's header/listbox/row-button-panel starting at `top`, or hides the
// whole section when it has no items; returns the Y to start the next section at.
function TFLegendNavigation.layoutSection(catIdx : Integer; lbl : TLabel; list : TListBox; panel : TPanel; top : integer) : integer;
var visibleRows : integer;
begin
  if list.Items.Count = 0 then begin
    lbl.Visible := False;
    list.Visible := False;
    panel.Visible := False;
    Result := top;
    Exit;
  end;

  lbl.Visible := True;
  list.Visible := True;
  panel.Visible := True;
  list.ItemIndex := 0;

  lbl.Top  := top;
  list.Top := top + 18;
  panel.Top := top + 18;

  // enough rows to show up to 6 items without scrolling; the listbox itself scrolls beyond that
  visibleRows := list.Items.Count;
  if visibleRows > 6 then visibleRows := 6;
  list.Height  := 18 + visibleRows * list.ItemHeight;
  panel.Height := list.Height;

  RefreshRowButtons(catIdx, list, panel);

  Result := list.Top + list.Height + 12;
end;

function TFLegendNavigation.Open(itemsL, itemsG, itemsR, itemsF, itemsS : TStrings) : tModalResult;
var y : integer;
begin
  FillList(ListL, itemsL);
  FillList(ListG, itemsG);
  FillList(ListR, itemsR);
  FillList(ListF, itemsF);
  FillList(ListS, itemsS);

  if not WndProcsHooked then begin
    OldWndProcL := ListL.WindowProc; ListL.WindowProc := NewWndProcL;
    OldWndProcG := ListG.WindowProc; ListG.WindowProc := NewWndProcG;
    OldWndProcR := ListR.WindowProc; ListR.WindowProc := NewWndProcR;
    OldWndProcS := ListS.WindowProc; ListS.WindowProc := NewWndProcS;
    OldWndProcF := ListF.WindowProc; ListF.WindowProc := NewWndProcF;
    // keyboard-driven scrolling (arrows/PageUp/PageDown/Home/End) does not always emit
    // WM_VSCROLL, but it does fire OnClick via LBN_SELCHANGE - catch it there too, so row
    // buttons stay correctly positioned even with a very long list (100+ items).
    ListL.OnClick := ListClick;
    ListG.OnClick := ListClick;
    ListR.OnClick := ListClick;
    ListS.OnClick := ListClick;
    ListF.OnClick := ListClick;
    WndProcsHooked := True;
  end;

  y := 8;
  y := layoutSection(0, LabelL, ListL, PanelRowL, y);
  y := layoutSection(1, LabelG, ListG, PanelRowG, y);
  y := layoutSection(2, LabelR, ListR, PanelRowR, y);
  y := layoutSection(3, LabelS, ListS, PanelRowS, y);
  y := layoutSection(4, LabelF, ListF, PanelRowF, y);

  Bcancel.Top := y;
  ClientHeight := y + Bcancel.Height + 8;

  Result := ShowModal;
end;

// (re)creates one Wybierz/.../Podsumowanie button trio per currently-visible row of `list`,
// laid out side by side inside `panel` (which sits immediately to the right of the listbox).
// Mirrors FListOrganizer.RefreshRowButtons (same per-row-overlay idea, generalised per category).
procedure TFLegendNavigation.RefreshRowButtons(catIdx : Integer; list : TListBox; panel : TPanel);
const
  GapH = 6;
  GapV = 2;
var
  i, row, y, lastVisible, totalWidth, setWidth, otherWidth, btnHeight : integer;
  btnSel, btnEdit, btnStat : TSpeedButton;
begin
  for i := 0 to High(RowSelectBtns[catIdx]) do begin
    RowSelectBtns[catIdx][i].Free;
    RowEditBtns[catIdx][i].Free;
    RowStatBtns[catIdx][i].Free;
  end;
  SetLength(RowSelectBtns[catIdx], 0);
  SetLength(RowEditBtns[catIdx], 0);
  SetLength(RowStatBtns[catIdx], 0);

  if list.Items.Count = 0 then Exit;

  SetLength(RowSelectBtns[catIdx], list.Items.Count);
  SetLength(RowEditBtns[catIdx], list.Items.Count);
  SetLength(RowStatBtns[catIdx], list.Items.Count);

  btnHeight := list.ItemHeight - GapV*2;
  // Rozklad carries an icon AND a caption, so it needs more room than the two text-only buttons.
  totalWidth := panel.ClientWidth - GapH*4;
  setWidth   := (totalWidth * 2) div 5;
  otherWidth := (totalWidth - setWidth) div 2;

  lastVisible := list.TopIndex + (list.ClientHeight div list.ItemHeight);
  for i := list.TopIndex to lastVisible do begin
    if (i < 0) or (i >= list.Items.Count) then continue;
    row := i - list.TopIndex;
    y := row * list.ItemHeight + GapV;
    if y + btnHeight > list.ClientHeight then break;

    btnSel := TSpeedButton.Create(panel);
    btnSel.Parent := panel;
    btnSel.SetBounds(GapH, y, setWidth, btnHeight);
    if Assigned(FListOrganizer) then btnSel.Glyph.Assign(FListOrganizer.BSetPrimary.Glyph); // reuse the same icon as the Rozklad row-button in FListOrganizer
    btnSel.Caption := 'Rozk³ad';
    btnSel.Hint := 'Rozk³ad';
    btnSel.ShowHint := True;
    btnSel.Tag := catIdx*1000 + i;
    btnSel.OnClick := RowSelectClick;
    RowSelectBtns[catIdx][i] := btnSel;

    btnEdit := TSpeedButton.Create(panel);
    btnEdit.Parent := panel;
    btnEdit.SetBounds(GapH*2 + setWidth, y, otherWidth, btnHeight);
    btnEdit.Caption := 'Szczegó³y';
    btnEdit.Hint := 'Szczegó³y';
    btnEdit.ShowHint := True;
    btnEdit.Tag := catIdx*1000 + i;
    btnEdit.OnClick := RowEditClick;
    RowEditBtns[catIdx][i] := btnEdit;

    btnStat := TSpeedButton.Create(panel);
    btnStat.Parent := panel;
    btnStat.SetBounds(GapH*3 + setWidth + otherWidth, y, otherWidth, btnHeight);
    btnStat.Caption := 'Podsum.';
    btnStat.Hint := 'Podsumowanie';
    btnStat.ShowHint := True;
    btnStat.Tag := catIdx*1000 + i;
    btnStat.OnClick := RowStatClick;
    RowStatBtns[catIdx][i] := btnStat;
  end;
end;

procedure TFLegendNavigation.RowSelectClick(Sender : TObject);
var catIdx, rowIdx : Integer;
    list : TListBox;
begin
  catIdx := TSpeedButton(Sender).Tag div 1000;
  rowIdx := TSpeedButton(Sender).Tag mod 1000;
  list := GetListForCat(catIdx);
  selectedOption := 'dsp' + GetCatChar(catIdx);
  selectedId := TString(list.Items.Objects[rowIdx]).value;
  Close;
end;

procedure TFLegendNavigation.RowEditClick(Sender : TObject);
var catIdx, rowIdx : Integer;
    list : TListBox;
begin
  catIdx := TSpeedButton(Sender).Tag div 1000;
  rowIdx := TSpeedButton(Sender).Tag mod 1000;
  list := GetListForCat(catIdx);
  selectedOption := 'Edit' + GetCatChar(catIdx);
  selectedId := TString(list.Items.Objects[rowIdx]).value;
  Close;
end;

procedure TFLegendNavigation.RowStatClick(Sender : TObject);
var catIdx, rowIdx : Integer;
    list : TListBox;
begin
  catIdx := TSpeedButton(Sender).Tag div 1000;
  rowIdx := TSpeedButton(Sender).Tag mod 1000;
  list := GetListForCat(catIdx);
  selectedOption := 'Stat' + GetCatChar(catIdx);
  selectedId := TString(list.Items.Objects[rowIdx]).value;
  Close;
end;

procedure TFLegendNavigation.NewWndProcL(var Message: TMessage);
begin
  OldWndProcL(Message);
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then RefreshRowButtons(0, ListL, PanelRowL);
end;

procedure TFLegendNavigation.NewWndProcG(var Message: TMessage);
begin
  OldWndProcG(Message);
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then RefreshRowButtons(1, ListG, PanelRowG);
end;

procedure TFLegendNavigation.NewWndProcR(var Message: TMessage);
begin
  OldWndProcR(Message);
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then RefreshRowButtons(2, ListR, PanelRowR);
end;

procedure TFLegendNavigation.NewWndProcS(var Message: TMessage);
begin
  OldWndProcS(Message);
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then RefreshRowButtons(3, ListS, PanelRowS);
end;

procedure TFLegendNavigation.NewWndProcF(var Message: TMessage);
begin
  OldWndProcF(Message);
  if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_MOUSEWHEEL) then RefreshRowButtons(4, ListF, PanelRowF);
end;

// owner-drawn listboxes (Style = lbOwnerDrawFixed, required so ItemHeight is actually honoured
// for layout - see RefreshRowButtons) do not paint their own items; mirrors FListOrganizer.lbNamesDrawItem.
procedure TFLegendNavigation.ListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
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

procedure TFLegendNavigation.ListClick(Sender: TObject);
var catIdx : Integer;
    list : TListBox;
begin
  list := Sender as TListBox;
  if list = ListL then catIdx := 0
  else if list = ListG then catIdx := 1
  else if list = ListR then catIdx := 2
  else if list = ListS then catIdx := 3
  else if list = ListF then catIdx := 4
  else Exit;

  RefreshRowButtons(catIdx, list, GetPanelForCat(catIdx));
end;

procedure TFLegendNavigation.ListDblClick(Sender: TObject);
var catIdx : Integer;
    list : TListBox;
begin
  list := Sender as TListBox;
  if list.ItemIndex < 0 then Exit;

  if list = ListL then catIdx := 0
  else if list = ListG then catIdx := 1
  else if list = ListR then catIdx := 2
  else if list = ListS then catIdx := 3
  else if list = ListF then catIdx := 4
  else Exit;

  selectedOption := 'dsp' + GetCatChar(catIdx);
  selectedId := TString(list.Items.Objects[list.ItemIndex]).value;
  Close;
end;

procedure TFLegendNavigation.FormShow(Sender: TObject);
begin
  selectedOption := '';
  selectedId := '';
end;

procedure TFLegendNavigation.BcancelClick(Sender: TObject);
begin
 Close;
end;

end.