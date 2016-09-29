unit TBDBRich;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ToolWin, DBCtrls, Menus, RXCtrls, IntlFunc, ComCtrls,
  ImgList, RxCombos;

type

  TToolDial2 = class(TForm)
    IMLIST: TImageList;
    CoolBar1: TCoolBar;
    Fonty: TFontComboBox;
    Rozmiar: TComboBox;
    Kolory: TColorComboBox;
    TB: TToolBar;
    Bold: TToolButton;
    Italic: TToolButton;
    Underline: TToolButton;
    Strikeout: TToolButton;
    ToolButton5: TToolButton;
    LeftJust: TToolButton;
    RightJust: TToolButton;
    CenterJust: TToolButton;
    ToolButton2: TToolButton;
    AddIndent: TToolButton;
    DelInden: TToolButton;
    FstIndent: TToolButton;
    AddRInd: TToolButton;
    DelRInd: TToolButton;
    Number: TToolButton;
    procedure AddIndentClick(Sender: TObject);
    procedure BoldClick(Sender: TObject);
    procedure FontyChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FstIndentClick(Sender: TObject);
    procedure ItalicClick(Sender: TObject);
    procedure JustClick(Sender: TObject);
    procedure KoloryChange(Sender: TObject);
    procedure RozmiarChange(Sender: TObject);
    procedure StrikeoutClick(Sender: TObject);
    procedure UnderlineClick(Sender: TObject);
    procedure DelIndenClick(Sender: TObject);
    procedure AddRIndClick(Sender: TObject);
    procedure DelRIndClick(Sender: TObject);
    procedure NumberClick(Sender: TObject);
  private
    procedure SetFontParams;
    procedure SetParagraphParams;
  public
  end;

  TTBDBRichEdit=class(TDBRichEdit)
  private
    FFIndent:Integer;
    FIndent:Integer;
    FOSTOnFocus:Boolean;
    FTools:TToolDial2;
    FToolsCaption:STRING;
    FWasTool:Boolean;
    procedure WMSetFocus(var Msg:TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg:TWMKillFocus); message WM_KILLFOCUS;
    procedure OnSelChg(Sender:TObject);
    procedure OnToolClick(Sender:TObject);
    procedure SetToolsCaption(V:STRING);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property KeepCreatedToolbar:Boolean read FOSTOnFocus write FOSTOnFocus default FALSE;
    property ToolsDialogCaption:STRING read FToolsCaption write SetToolsCaption;
  end;

  procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('KamilDB', [TTBDBRichEdit]);
end;

constructor TTBDBRichEdit.Create(AOwner: TComponent);
var PM:TPopUpMenu;
    MI:TMenuItem;
begin
  inherited Create(AOwner);
  FTools:=NIL;
  PM:=TPopupMenu.Create(self);
  MI:=TMenuItem.Create(self);
  MI.Caption:=FToolsCaption;
  MI.OnClick:=OnToolClick;
  PM.Items.Add(MI);
  self.PopupMenu:=PM;
  self.OnSelectionChange:=OnSelChg;
  FIndent:=20;
  FFIndent:=30;
  FWasTool:=FALSE;
  FOSTOnFocus:=FALSE;
end;

procedure TTBDBRichEdit.OnSelChg(Sender: TObject);
begin
  if FTools<>NIL then begin
    FTools.SetFontParams;
    FTools.SetParagraphParams;
  end;
end;

procedure TTBDBRichEdit.OnToolClick(Sender:TObject);
var P:TPoint;
    maxx:Integer;
begin
  if Sender<>TPopupMenu(self.Components[0]).Items[0] then begin
     FTools.Release;
     FTools:=NIL;
     self.PopupMenu.Items[0].Checked:=FALSE;
     exit;
  end;
  if FTools=NIL then begin
     FTools:=TToolDial2.Create(self);
     FTools.Caption:=FToolsCaption;
     P.x:=0;
     P.y:=-2-FTools.Height;
     Windows.ClientToScreen(Handle,P);
     maxx:=GetDeviceCaps(FTools.Canvas.Handle,HORZRES);
     if P.x+FTools.Width>maxx then FTools.Left:=maxx-Ftools.Width
       else FTools.Left:=P.x;
     FTools.Top:=P.y;
     FTools.Show();
     self.PopupMenu.Items[0].Checked:=TRUE;
     self.SetFocus;
  end else begin
     FTools.Release;
     self.PopupMenu.Items[0].Checked:=FALSE;
     FTools:=NIL;
  end;
end;

procedure TTBDBRichEdit.SetToolsCaption(V:STRING);
begin
  if FToolsCaption<>V then begin
    FToolsCaption:=V;
    self.PopupMenu.Items[0].Caption:=V;
  end;
end;

procedure TTBDBRichEdit.WMSetFocus(var Msg:TWMSetFocus);
begin
  if (FTools=NIL) AND FWasTool then OnToolClick(PopupMenu.Items[0]);
  FWasTool:=FALSE;
  inherited;
end;

procedure TTBDBRichEdit.WMKillFocus(var Msg:TWMKillFocus);
var C:TControl;
begin
  FWasTool:=FALSE;
  C:=FindControl(Msg.FocusedWnd);
  if (FTools<>NIL) AND (Msg.FocusedWnd<>FTools.Handle) AND
     (C<>NIL) AND (C<>self) AND (C.Owner<>FTools) then begin
    OnToolClick(PopupMenu.Items[0]);
    if FOSTOnFocus then FWasTool:=TRUE;
  end;
  inherited;
end;

procedure TToolDial2.BoldClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBDBRichEdit(self.Owner).SelAttributes;
  if Bold.Down then begin
    TA.Style:=TA.Style+[fsBold];
  end else begin
    TA.Style:=TA.Style-[fsBold];
  end;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.FontyChange(Sender: TObject);
begin
  with TTBDBRichEdit(self.Owner).SelAttributes do begin
    Name:=Fonty.FontName;
    CharSet:=1;
  end;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TPopupMenu(self.Owner.Components[0]).Items[0].OnClick(self);
end;

procedure TToolDial2.FormCreate(Sender: TObject);
begin
  SetCaptionsEx('ITLLIB1.DLL',2,self);
  self.SetFontParams;
  self.SetParagraphParams;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.ItalicClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBDBRichEdit(self.Owner).SelAttributes;
  if Italic.Down then begin
    TA.Style:=TA.Style+[fsItalic];
  end else begin
    TA.Style:=TA.Style-[fsItalic];
  end;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.JustClick(Sender: TObject);
var TB:TToolButton;
    Al:TAlignment;
begin
  TB:=TToolButton(Sender);
  Al:=taRightJustify;
  if TB.Down then begin
    if TB=CenterJust then Al:=taCenter
    else if TB=LeftJust then Al:=taLeftJustify;
  end;
  TTBDBRichEdit(self.Owner).Paragraph.Alignment:=Al;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.KoloryChange(Sender: TObject);
begin
  TTBDBRichEdit(self.Owner).SelAttributes.Color:=Kolory.ColorValue;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.RozmiarChange(Sender: TObject);
begin
  TTBDBRichEdit(self.Owner).SelAttributes.Size:=StrToInt(Rozmiar.Items.Strings[Rozmiar.ItemIndex]);
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.SetFontParams;
var TA:TTextAttributes;
    i:Integer;
begin
  TA:=TTBDBRichEdit(self.Owner).SelAttributes;
  Fonty.FontName:=TA.Name;
  i:=Rozmiar.Items.IndexOf(IntToStr(TA.Size));
  if Rozmiar.ItemIndex<>i then Rozmiar.ItemIndex:=i;
  Kolory.Colorvalue:=TA.Color;
  Bold.Down:=(TA.Style>=[fsBold]);
  Italic.Down:=(TA.Style>=[fsItalic]);
  Underline.Down:=(TA.Style>=[fsUnderline]);
  Strikeout.Down:=(TA.Style>=[fsStrikeOut]);
end;

procedure TToolDial2.SetParagraphParams;
var PA:TParaAttributes;
begin
  PA:=TTBDBRichEdit(self.Owner).Paragraph;
  LeftJust.Down:=FALSE;
  RightJust.Down:=FALSE;
  CenterJust.Down:=FALSE;
  case PA.Alignment of
    taLeftJustify:LeftJust.Down:=TRUE;
    taRightJustify:RightJust.Down:=TRUE;
    taCenter:CenterJust.Down:=TRUE;
  end;
end;

procedure TToolDial2.StrikeoutClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBDBRichEdit(self.Owner).SelAttributes;
  if Strikeout.Down then begin
    TA.Style:=TA.Style+[fsStrikeOut];
  end else begin
    TA.Style:=TA.Style-[fsStrikeOut];
  end;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.UnderlineClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBDBRichEdit(self.Owner).SelAttributes;
  if Underline.Down then begin
    TA.Style:=TA.Style+[fsUnderline];
  end else begin
    TA.Style:=TA.Style-[fsUnderline];
  end;
  TTBDBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial2.FstIndentClick(Sender: TObject);
var RE:TTBDBRichEdit;
begin
  RE:=Owner as TTBDBRichEdit;
  if FstIndent.Down then begin
    RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent+RE.FFIndent;
    RE.Paragraph.LeftIndent:=RE.Paragraph.LeftIndent-RE.FFIndent;
  end else begin
    RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent-RE.FFIndent;
    RE.Paragraph.LeftIndent:=0;
  end;
  RE.SetFocus;
end;

procedure TToolDial2.AddIndentClick(Sender: TObject);
var RE:TTBDBRichEdit;
begin
  RE:=Owner as TTBDBRichEdit;
  RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent+RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial2.DelIndenClick(Sender: TObject);
var RE:TTBDBRichEdit;
begin
  RE:=Owner as TTBDBRichEdit;
  if (FstIndent.Down) AND (RE.Paragraph.FirstIndent>30) OR not(FstIndent.Down) then
    RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent-RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial2.AddRIndClick(Sender: TObject);
var RE:TTBDBRichEdit;
begin
  RE:=Owner as TTBDBRichEdit;
  RE.Paragraph.RightIndent:=RE.Paragraph.RightIndent+RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial2.DelRIndClick(Sender: TObject);
var RE:TTBDBRichEdit;
begin
  RE:=Owner as TTBDBRichEdit;
  RE.Paragraph.RightIndent:=RE.Paragraph.RightIndent-RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial2.NumberClick(Sender: TObject);
var RE:TTBDBRichEdit;
begin
  RE:=Owner as TTBDBRichEdit;
  if RE.Paragraph.Numbering=nsBullet then RE.Paragraph.Numbering:=nsNone
  else RE.Paragraph.Numbering:=nsBullet;
  RE.SetFocus;
end;

end.
