unit TBRichEd;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ToolWin, ComCtrls, Menus, RXCtrls, IntlFunc, ImgList,
  RxCombos;

type

  TToolDial1 = class(TForm)
    IMLIST: TImageList;
    TB: TToolBar;
    Fonty: TFontComboBox;
    Rozmiar: TComboBox;
    Kolory: TColorComboBox;
    ToolButton1: TToolButton;
    Bold: TToolButton;
    Italic: TToolButton;
    Underline: TToolButton;
    Strikeout: TToolButton;
    LeftJust: TToolButton;
    RightJust: TToolButton;
    CenterJust: TToolButton;
    ToolButton5: TToolButton;
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

  TTBRichEdit=class(TRichEdit)
  private
    FFIndent:Integer;
    FIndent:Integer;
    FOSTOnFocus:Boolean;
    FTools:TToolDial1;
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
  RegisterComponents('Kamil', [TTBRichEdit]);
end;

constructor TTBRichEdit.Create(AOwner: TComponent);
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

procedure TTBRichEdit.OnSelChg(Sender: TObject);
begin
  if FTools<>NIL then begin
    FTools.SetFontParams;
    FTools.SetParagraphParams;
  end;
end;

procedure TTBRichEdit.OnToolClick(Sender:TObject);
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
     FTools:=TToolDial1.Create(self);
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

procedure TTBRichEdit.SetToolsCaption(V:STRING);
begin
  if FToolsCaption<>V then begin
    FToolsCaption:=V;
    self.PopupMenu.Items[0].Caption:=V;
  end;
end;

procedure TTBRichEdit.WMSetFocus(var Msg:TWMSetFocus);
begin
  if (FTools=NIL) AND FWasTool then OnToolClick(PopupMenu.Items[0]);
  FWasTool:=FALSE;
  inherited;
end;

procedure TTBRichEdit.WMKillFocus(var Msg:TWMKillFocus);
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

procedure TToolDial1.BoldClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBRichEdit(self.Owner).SelAttributes;
  if Bold.Down then begin
    TA.Style:=TA.Style+[fsBold];
  end else begin
    TA.Style:=TA.Style-[fsBold];
  end;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.FontyChange(Sender: TObject);
begin
  with TTBRichEdit(self.Owner).SelAttributes do begin
    Name:=Fonty.FontName;
    CharSet:=1;
  end;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TPopupMenu(self.Owner.Components[0]).Items[0].OnClick(self);
end;

procedure TToolDial1.FormCreate(Sender: TObject);
begin
  SetCaptionsEx('ITLLIB1.DLL',2,self);
  self.SetFontParams;
  self.SetParagraphParams;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.ItalicClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBRichEdit(self.Owner).SelAttributes;
  if Italic.Down then begin
    TA.Style:=TA.Style+[fsItalic];
  end else begin
    TA.Style:=TA.Style-[fsItalic];
  end;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.JustClick(Sender: TObject);
var TB:TToolButton;
    Al:TAlignment;
begin
  TB:=TToolButton(Sender);
  Al:=taRightJustify;
  if TB.Down then begin
    if TB=CenterJust then Al:=taCenter
    else if TB=LeftJust then Al:=taLeftJustify;
  end;
  TTBRichEdit(self.Owner).Paragraph.Alignment:=Al;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.KoloryChange(Sender: TObject);
begin
  TTBRichEdit(self.Owner).SelAttributes.Color:=Kolory.ColorValue;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.RozmiarChange(Sender: TObject);
begin
  TTBRichEdit(self.Owner).SelAttributes.Size:=StrToInt(Rozmiar.Items.Strings[Rozmiar.ItemIndex]);
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.SetFontParams;
var TA:TTextAttributes;
    i:Integer;
begin
  TA:=TTBRichEdit(self.Owner).SelAttributes;
  Fonty.FontName:=TA.Name;
  i:=Rozmiar.Items.IndexOf(IntToStr(TA.Size));
  if Rozmiar.ItemIndex<>i then Rozmiar.ItemIndex:=i;
  Kolory.Colorvalue:=TA.Color;
  Bold.Down:=(TA.Style>=[fsBold]);
  Italic.Down:=(TA.Style>=[fsItalic]);
  Underline.Down:=(TA.Style>=[fsUnderline]);
  Strikeout.Down:=(TA.Style>=[fsStrikeOut]);
end;

procedure TToolDial1.SetParagraphParams;
var PA:TParaAttributes;
begin
  PA:=TTBRichEdit(self.Owner).Paragraph;
  LeftJust.Down:=FALSE;
  RightJust.Down:=FALSE;
  CenterJust.Down:=FALSE;
  case PA.Alignment of
    taLeftJustify:LeftJust.Down:=TRUE;
    taRightJustify:RightJust.Down:=TRUE;
    taCenter:CenterJust.Down:=TRUE;
  end;
end;

procedure TToolDial1.StrikeoutClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBRichEdit(self.Owner).SelAttributes;
  if Strikeout.Down then begin
    TA.Style:=TA.Style+[fsStrikeOut];
  end else begin
    TA.Style:=TA.Style-[fsStrikeOut];
  end;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.UnderlineClick(Sender: TObject);
var TA:TTextAttributes;
begin
  TA:=TTBRichEdit(self.Owner).SelAttributes;
  if Underline.Down then begin
    TA.Style:=TA.Style+[fsUnderline];
  end else begin
    TA.Style:=TA.Style-[fsUnderline];
  end;
  TTBRichEdit(self.Owner).SetFocus;
end;

procedure TToolDial1.FstIndentClick(Sender: TObject);
var RE:TTBRichEdit;
begin
  RE:=Owner as TTBRichEdit;
  if FstIndent.Down then begin
    RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent+RE.FFIndent;
    RE.Paragraph.LeftIndent:=RE.Paragraph.LeftIndent-RE.FFIndent;
  end else begin
    RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent-RE.FFIndent;
    RE.Paragraph.LeftIndent:=0;
  end;
  RE.SetFocus;
end;

procedure TToolDial1.AddIndentClick(Sender: TObject);
var RE:TTBRichEdit;
begin
  RE:=Owner as TTBRichEdit;
  RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent+RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial1.DelIndenClick(Sender: TObject);
var RE:TTBRichEdit;
begin
  RE:=Owner as TTBRichEdit;
  if (FstIndent.Down) AND (RE.Paragraph.FirstIndent>30) OR not(FstIndent.Down) then
    RE.Paragraph.FirstIndent:=RE.Paragraph.FirstIndent-RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial1.AddRIndClick(Sender: TObject);
var RE:TTBRichEdit;
begin
  RE:=Owner as TTBRichEdit;
  RE.Paragraph.RightIndent:=RE.Paragraph.RightIndent+RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial1.DelRIndClick(Sender: TObject);
var RE:TTBRichEdit;
begin
  RE:=Owner as TTBRichEdit;
  RE.Paragraph.RightIndent:=RE.Paragraph.RightIndent-RE.FIndent;
  RE.SetFocus;
end;

procedure TToolDial1.NumberClick(Sender: TObject);
var RE:TTBRichEdit;
begin
  RE:=Owner as TTBRichEdit;
  if RE.Paragraph.Numbering=nsBullet then RE.Paragraph.Numbering:=nsNone
  else RE.Paragraph.Numbering:=nsBullet;
  RE.SetFocus;
end;

end.
