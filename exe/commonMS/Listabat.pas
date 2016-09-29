unit listabat;

interface
uses WinProcs, WinTypes, Classes, Graphics, Controls, Forms, Buttons;

type

  TBtnListEvent=procedure(Sender:TObject;No:WORD) of object;

  TLBitBtn=class(TBitBtn)
  protected
    FFixedHeight:WORD;
    FMrg:WORD;
    FResult:STRING;
    FClic:Boolean;
    procedure OwnDragOver(Sender, Source: TObject; X, Y: Integer;
              State: TDragState;var Accept: Boolean);
    procedure OwnDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure OwnMouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState;X, Y: Integer);
    procedure OwnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OwnMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
  public
    BitmapFile:STRING;
    constructor Create(AOwner:TCOmponent);override;
    procedure CalcHeight;
    procedure Click;override;
  published
    property FixedHeight:WORD read FFixedHeight write FFixedHeight;
    property Margins:WORD read FMrg write FMrg;
    property Result_:STRING read FResult write FResult;
  end;

  TBtnList=class(TScrollBox)
  private
    FClientOnResize:TNotifyEvent;
    FFixedBtnHeight:WORD;
    FHSp:Integer;
    FiColWidth:Integer;
    FLButtons:TList;
    FOnBtnClick:TBtnListEvent;
    FwColumns:WORD;
    FVSp:Integer;
    procedure Resize;override;
    procedure SetFixBtnHeight(H:WORD);
    procedure SetFwColumns(N:WORD);
    procedure SetHSp(V:Integer);
    procedure SetVSp(V:Integer);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure AddButton(sCaption,sResult,sHint:STRING;tpicBitmap:TBitmap;
              Font_:TFont;Marg:WORD;Layout_:TButtonLayout);
    function ButtonCount:Integer;
    function DeleteButton(B:TLBitBtn):Integer;
    function DeleteButtonNo(N:WORD):Boolean;
    function GetButton(N:WORD):TLBitBtn;
    function GetButtonNo(B:TLbitBtn):Integer;
    function GetCurHeight:Integer;
    function GetCurWidth:Integer;
    procedure Rearrange;
  published
    property ColCount:WORD read FwColumns write SetFwColumns default 1;
    property FixedButtonHeight:WORD read FFixedBtnHeight write SetFixBtnHeight default 0;
    property HorizontalSpaceing:Integer read FHSp write SetHSp default 0;
    property OnBtnClick:TBtnListEvent read FOnBtnClick write FOnBtnClick;
    property VerticalSpaceing:Integer read FVSp write SetVSp default 0;
  end;

  procedure Register;

implementation

type RWys=class(TObject)
          public
            H:Integer;
            constructor CreateRWys(Wys:Integer);
          end;
     LWys=class(TList)
          public
            function GetMax:WORD;
            function GetMin:WORD;
          end;

procedure Register;
begin
  RegisterComponents('Kamil',[TBtnList]);
end;

constructor RWys.CreateRWys(Wys:Integer);
begin
  inherited Create;
  H:=Wys;
end;

function LWys.GetMax:WORD;
var R:RWys;
    i,M:Integer;
begin
  M:=0;
  Result:=0;
  if Count=0 then exit;
  for i:=0 to Count-1 do begin
    R:=Items[i];
    if R.H>M then begin
      Result:=i;
      M:=R.H;
    end;
  end;
end;

function LWys.GetMin:WORD;
var R:RWys;
    i,M:Integer;
begin
  M:=32000;
  Result:=0;
  if Count=0 then exit;
  for i:=0 to Count-1 do begin
    R:=Items[i];
    if R.H<M then begin
      Result:=i;
      M:=R.H;
    end;
  end;
end;

constructor TBtnList.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FLButtons:=TList.Create;
  Fwcolumns:=1;
  FiColWidth:=GetCurWidth;
  FClientOnResize:=NIL;
  FFixedBtnHeight:=0;
  FHSp:=0;
  FVSp:=0;
end;

destructor TBtnList.Destroy;
begin
 FLButtons.Destroy;
 inherited Destroy;
end;

procedure TBtnList.AddButton(sCaption,sResult,sHint:STRING;tpicBitmap:TBitmap;
          Font_:TFont;Marg:WORD;Layout_:TButtonLayout);
var B:TLBitBtn;
begin
  B:=TLBitBtn.Create(self);
  B.Parent:=self;
  B.Caption:=sCaption;
  B.ShowHint:=TRUE;
  B.Hint:=sHint;
  B.FResult:=sResult;
  if Font_<>NIL then B.Font.Assign(Font_);
  if tpicBitmap<>NIL then begin
    B.Glyph:=tpicBitmap;
    B.Glyph.Width:=tpicBitmap.Width;
    B.Glyph.Height:=tpicBitmap.Height;
  end else B.Glyph:=NIL;
  B.Margins:=Marg;
  B.Layout:=Layout_;
  B.FixedHeight:=FixedButtonHeight;
  B.CalcHeight;
  FLButtons.Add(B);
  Rearrange;
end;

function TBtnList.ButtonCount:Integer;
begin
  Result:=FLButtons.Count;
end;

function TBtnList.DeleteButton(B:TLBitBtn):Integer;
begin
  Result:=FLButtons.IndexOf(B)+1;
  FLButtons.Remove(B);
  FLButtons.Pack;
  B.Destroy;
  Rearrange;
end;

function TBtnList.DeleteButtonNo(N:WORD):Boolean;
var B:TLBitBtn;
begin
  if FLButtons.Count<N then begin
    Result:=FALSE;
    exit;
  end;
  B:=TLBitBtn(FLButtons[N-1]);
  FLButtons.Delete(N-1);
  B.Destroy;
  Rearrange;
  Result:=TRUE;
end;

function TBtnList.GetButton(N:WORD):TLBitBtn;
begin
  if N>FLButtons.Count then Result:=NIL
  else Result:=FLButtons.Items[N-1];
end;

function TBtnList.GetButtonNo(B:TLbitBtn):Integer;
begin
  Result:=FLButtons.IndexOf(B)+1;
end;

function TBtnList.GetCurHeight:Integer;
begin
  Result:=Height;
  if BorderStyle=bsSingle then Dec(Result,4*GetSystemMetrics(SM_CYBORDER));
end;

function TBtnList.GetCurWidth:Integer;
var i,Col,H:Integer;
    L:LWys;
begin
  L:=LWys.Create;
  for i:=1 to FwColumns do L.Add(RWys.CreateRWys(0));
  i:=0;
  while i<FLButtons.Count do begin
    Col:=L.GetMin;
    Inc(RWys(L[Col]).H,TLBitBtn(FLButtons[i]).Height+2*FVSp);
    Inc(i);
  end;
  if L.Count=0 then H:=0 else H:=RWys(L[L.GetMax]).H;
  L.Destroy;
  if H>GetCurHeight then
    Result:=Width-GetSystemMetrics(SM_CXVSCROLL)-4*GetSystemMetrics(SM_CXBORDER)
  else Result:=self.Width-4*GetSystemMetrics(SM_CXBORDER);
  if BorderStyle=bsNone then Inc(Result,4*GetSystemMetrics(SM_CXBORDER));
end;

procedure TBtnlist.Rearrange;
var i,Col,CW:Integer;
    B:TLBitBtn;
    L:LWys;
begin
  if FFixedBtnHeight=0 then begin
    i:=0;
    while i<FLButtons.Count do begin
      TLBitBtn(FLButtons[i]).CalcHeight;
      Inc(i);
    end;
  end;
  L:=LWys.Create;
  for i:=1 to FwColumns do L.Add(RWys.CreateRWys(0));
  i:=0;
  CW:=GetCurWidth;
  while i<FLButtons.Count do begin
    B:=TLBitBtn(FLButtons[i]);
    Col:=L.GetMin;
    B.Left:=(Col)*FiColWidth+FHSp;
    B.Top:=RWys(L[Col]).H+FVSp;
    Inc(RWys(L[Col]).H,B.Height+2*FVSp);
    if Col+1<>FwColumns then B.Width:=FiColWidth-2*FHSp else B.Width:=CW-Col*FiColWidth-2*FHSp;
    Inc(i);
  end;
  L.Destroy;
end;

procedure TBtnList.Resize;
begin
  inherited Resize;
  ColCount:=ColCount;
  Rearrange;
end;

procedure TBtnList.SetFixBtnHeight(H:WORD);
var i:WORD;
begin
  if FFixedBtnHeight=H then exit;
  FFixedBtnHeight:=H;
  i:=0;
  while i<FLButtons.Count do begin
    TLBitBtn(FLButtons[i]).FixedHeight:=H;
    TLBitBtn(FLButtons[i]).CalcHeight;
    Inc(i);
  end;
  Rearrange;
end;

procedure TBtnList.SetFwColumns(N:WORD);
begin
  if (N>0) AND (GetCurWidth div N>0) then begin
    FwColumns:=N;
    FiColWidth:=GetCurWidth div N;
    Rearrange;
  end;
end;

procedure TBtnList.SetHSp(V:Integer);
begin
  if V<>FHSp then begin
    FHSp:=V;
    Rearrange;
  end;
end;

procedure TBtnList.SetVSp(V:Integer);
begin
  if V<>FVSp then begin
    FVSp:=V;
    Rearrange;
  end;
end;

constructor TLBitBtn.Create(AOwner:TCOmponent);
begin
  inherited Create(AOwner);
  OnDragOver:=OwnDragOver;
  OnDragDrop:=OwnDragDrop;
  OnMouseDown:=OwnMouseDown;
  OnMouseMove:=OwnMouseMove;
  OnMouseUp:=OwnMouseUp;
  FClic:=FALSE;
end;

procedure TLBitBtn.CalcHeight;
var oldFon:TFont;
    C:TCanvas;
    SH,BH:Integer;
begin
  if FFixedHeight=0 then begin
    C:=Glyph.Canvas;
    oldFon:=TFont.Create;
    oldfon.Assign(C.Font);
    C.Font.Assign(Font);
    SH:=C.TextHeight(Caption);
    C.Font.Assign(oldfon);
    if Glyph<>NIL then BH:=Glyph.Height else BH:=0;
    case Layout of
      blGlyphBottom,blGlyphTop:Height:=BH+SH+Spacing+2*FMrg+4;
      blGlyphRight,blGlyphLeft:begin
        if BH>SH then Height:=BH+2*FMrg+4 else Height:=SH+2*FMrg+4;
      end;
    end;
  end else Height:=FFixedHeight;
end;

procedure TLBitBtn.Click;
var i:Integer;
begin
  inherited Click;
    if self.Owner is TBtnList then begin
      i:=TBtnList(self.Owner).GetButtonNo(self);
      if i=0 then exit;
      if Assigned(TBtnList(self.Owner).FOnBtnClick) then
        TBtnList(self.Owner).OnBtnClick(self,i);
    end;
end;

procedure TLBitBtn.OwnDragDrop(Sender, Source: TObject; X, Y: Integer);
var L:TList;
    i:Integer;
begin
  if Source<>self then begin
    L:=TBtnList(self.Owner).FLButtons;
    L.Remove(Source);
    L.Insert(L.IndexOf(self),Source);
    L.Pack;
    for i:=0 to L.Count-1 do TLBitBtn(L[i]).TabOrder:=-1;
    for i:=0 to L.Count-1 do TLBitBtn(L[i]).TabOrder:=i;
    TBtnList(self.Owner).Rearrange;
  end;
end;

procedure TLBitBtn.OwnDragOver(Sender, Source: TObject; X, Y: Integer;
          State: TDragState;var Accept: Boolean);
begin
  Accept:=TRUE;
end;

procedure TLBitBtn.OwnMouseDown(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState;X, Y: Integer);
begin
  FClic:=TRUE;
end;

procedure TLBitBtn.OwnMouseMove(Sender: TObject; Shift: TShiftState;
          X, Y: Integer);
begin
  if FClic AND  not Dragging then begin
    if (x<0) OR (x>Width) OR (y<0) OR (y>Height) then
      BeginDrag(FALSE);
  end;
end;

procedure TLBitBtn.OwnMouseUp(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
begin
  FClic:=FALSE;
end;

end.
