unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL, StdCtrls, ExtCtrls, Math;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    glPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    uchwytDC :HDC; //uchwyt do "display device context (DC)"
    uchwytRC :HGLRC; //uchwyt do "OpenGL rendering context"
    Phi, Theta :Single;
    PozycjaX, PozycjaY, PozycjaZ :Single;
    RuchKamery :Boolean;
    KameraX, KameraY, KameraZ :Single;
    step : single;
    ratioinside : single;
    colors : array[0..95] of record r, g, b : integer end;
    function GL_UstalFormatPikseli(uchwytDC :HDC) :Boolean;
    procedure GL_UstawienieSceny;
    procedure Rysuj;
    procedure drawCube(x0,y0,z0 :Single);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.GL_UstalFormatPikseli(uchwytDC :HDC) :Boolean;
{const OpisFormatuPikseli :PIXELFORMATDESCRIPTOR=(
        nSize:      sizeof(PIXELFORMATDESCRIPTOR);	// wielko��
        nVersion:   1;			// wersja
        dwFlags:    PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or PFD_DOUBLEBUFFER;	// udost�pnienie podw�jnego buforowania
        iPixelType: PFD_TYPE_RGBA;	// typ koloru
        cColorBits: 24;			// ��dana rozdzielczo�� koloru
        cRedBits:   0;  cRedShift:  0;	// bity koloru(ignorowane)
        cGreenBits: 0;  cGreenShift:0;
        cBlueBits:  0;  cBlueShift: 0;
        cAlphaBits: 0;  cAlphaShift:0;   // wy��czenie buforu alfa
        cAccumBits: 0;
        cAccumRedBits:    0;  		// wy��czenie akumulacji bufora
        cAccumGreenBits:  0;     	// akumulowanie bit�w (ignorowane)
        cAccumBlueBits:   0;
        cAccumAlphaBits:  0;
        cDepthBits:       16;			// wielko�� bufora
        cStencilBits:     0;			// bez buforu szablonu
        cAuxBuffers:      0;			// bez buforu pomocniczego
        iLayerType:       PFD_MAIN_PLANE;  	// g��wna pow�oka
   bReserved:       0;
   dwLayerMask:     0;
   dwVisibleMask:   0;
   dwDamageMask:    0;  // brak widoczno�ci pow�oki, zniszczenie maski
   );}
var
  opisFormatuPikseli :PIXELFORMATDESCRIPTOR;
  formatPikseli :Integer;
begin
Result:=False;
with opisFormatuPikseli do
  begin
  dwFlags:=PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or PFD_DOUBLEBUFFER;	//w oknie, podwojne buforowanie
  iPixelType:=PFD_TYPE_RGBA; //typ koloru RGB
  cColorBits:=32; //jakosc kolor�w 4 bajty
  cDepthBits:=16; //glebokosc bufora Z (z-buffer)
  iLayerType:=PFD_MAIN_PLANE;
  end;
formatPikseli:=ChoosePixelFormat(uchwytDC, @opisFormatuPikseli);
if (formatPikseli=0) then Exit;
if (SetPixelFormat(uchwytDC, formatPikseli, @opisFormatuPikseli) <> True) then Exit;
Result:=True;
end;

procedure TForm1.GL_UstawienieSceny;
begin
//ustawienie punktu projekcji
glMatrixMode(GL_PROJECTION); //macierz projekcji
//left,right,bottom,top,znear,zfar
glFrustum(-0.1, 0.1, -0.1, 0.1, 0.3, 25.0); //mnozenie macierzy przez macierz perspektywy
glMatrixMode(GL_MODELVIEW); //powrot do macierzy widoku
glEnable(GL_DEPTH_TEST); //z-buffer aktywny = ukrywanie niewidocznych trojkatow !!!
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  polozenieMyszy :TPoint;
  t : integer;
  r : integer;
  procedure setRGB ( t, r, g, b : integer);
  begin
    colors[t].r := r;
    colors[t].g := g;
    colors[t].b := b;
  end;
begin
 step := 0;
 ratioinside := 1;
 //self.AlphaBlend := true;
 for t := 0 to 95 do begin
   r := random(6);
   case r of
    0:setRgb(t,255,0,0);
    1:setRgb(t,0,255,0);
    2:setRgb(t,0,0,255);
    3:setRgb(t,255,255,0);
    4:setRgb(t,255,0,255);
    5:setRgb(t,0,255,255);
   end;
 end;

//biezace okno staje sie oknem OpenGL
uchwytDC:=GetDC(glPanel.Handle);
GL_UstalFormatPikseli(uchwytDC);
uchwytRC:=wglCreateContext(uchwytDC);
wglMakeCurrent(uchwytDC,uchwytRC);
GL_UstawienieSceny;
Caption:='OpenGL '+glGetString(GL_VERSION);


KameraZ:=10;
RuchKamery:=True;
polozenieMyszy.X:=ClientWidth div 2;
polozenieMyszy.Y:=ClientHeight div 2;
if RuchKamery then Mouse.CursorPos:=ClientToScreen(polozenieMyszy);

glClearColor (1, 1, 1, 0.0);


end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
wglMakeCurrent(0,0);
wglDeleteContext(uchwytRC);
ReleaseDC(glPanel.Handle,uchwytDC);
end;

procedure TForm1.drawCube(x0,y0,z0 :Single);
var size : single;
    ratio : single;
    t1,t2,n : integer;
    inside : single;
const
  GLF_START_LIST = 1000;
  programName : PChar = 'TrickSQL';


 procedure drawX (x,y,z : Single);
 var d : single;
 begin
  x := x + ratio;
  y := y + ratio;
  d := size - 2*ratio;
  z := z * inside;
  glVertex3f(z, x,        y        );
  glVertex3f(z, x+d   ,   y        );
  glVertex3f(z, x+d   ,   y+d      );
  glVertex3f(z, x,        y+d      );
 end;
 procedure drawY (x,y,z : Single);
 var d : single;
 begin
  x := x + ratio;
  y := y + ratio;
  d := size - 2*ratio;
  z := z * inside;
  glVertex3f(x,        z, y        );
  glVertex3f(x+d   ,   z, y        );
  glVertex3f(x+d   ,   z, y+d      );
  glVertex3f(x,        z, y+d      );
 end;
 procedure drawZ (x,y,z : Single);
 var d : single;
 begin
  x := x + ratio;
  y := y + ratio;
  d := size - 2*ratio;
  z := z * inside;
  glVertex3f(x,        y,        z);
  glVertex3f(x+d   ,   y,        z);
  glVertex3f(x+d   ,   y+d   ,   z);
  glVertex3f(x,        y+d   ,   z);
 end;

begin
 glBegin(GL_QUADS);
 inside := 0.9;
 size := 2 * x0;
 ratio := 0;
 glColor3ub( 0 ,0, 200 );
 drawX ( -x0 , -y0,   z0 );
 drawX ( -x0 , -y0,  -z0 );
 drawY ( -x0 , -y0,   z0 );
 drawY ( -x0 , -y0,  -z0 );
 drawZ ( -x0 , -y0,   z0 );
 drawZ ( -x0 , -y0,  -z0 );

 inside := ratioinside;
 size   := x0 / 2;
 ratio  := x0 / 60;

 n:= -1;
 for t1 := 0 to 3 do
  for t2 := 0 to 3 do
  begin
    n := n + 1; glColor3ub( colors[n].r ,colors[n].g, colors[n].b );
    drawZ ( -x0 + t1*size , -y0 + t2*size ,  z0 );
    n := n + 1; glColor3ub( colors[n].r ,colors[n].g, colors[n].b );
    drawZ ( -x0 + t1*size , -y0 + t2*size , -z0 );
    n := n + 1; glColor3ub( colors[n].r ,colors[n].g, colors[n].b );
    drawX ( -x0 + t1*size , -y0 + t2*size ,  z0 );
    n := n + 1; glColor3ub( colors[n].r ,colors[n].g, colors[n].b );
    drawX ( -x0 + t1*size , -y0 + t2*size , -z0 );
    n := n + 1; glColor3ub( colors[n].r ,colors[n].g, colors[n].b );
    drawY ( -x0 + t1*size , -y0 + t2*size ,  z0 );
    n := n + 1; glColor3ub( colors[n].r ,colors[n].g, colors[n].b );
    drawY ( -x0 + t1*size , -y0 + t2*size , -z0 );
  end;
glEnd;
end;

procedure TForm1.Rysuj;
const x0=1.5; y0=1.5; z0=1.5;
begin
//Przygotowanie bufora
glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
glLoadIdentity; //biezaca macierz = I
//glTranslatef(0.0, 0.0, -10.0); //odsuniecie calosci o 10

gluLookAt(KameraX,KameraY,KameraZ,  //polozenie oka
          0,0,0,  //polozenie srodka ukladu wsp.
          0,1,0); //kierunek "do gory"

//obroty
glRotatef(Phi, 0.0, 1.0, 0.0); //wokol OY
glRotatef(Theta, 1.0, 0.0, 0.0); //wokol OX

//przesuniecia
glTranslatef(PozycjaX,PozycjaY,PozycjaZ);

drawCube(x0,y0,z0);

//Z bufora na ekran
SwapBuffers(wglGetCurrentDC);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
Rysuj;
//do not enable timer ealier !
//Timer1.Enabled :=true;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
  Ord('Q'):  Timer1.Enabled:=not Timer1.Enabled;
  Ord('W'):  RuchKamery:=not RuchKamery;
  VK_ESCAPE: Close;
end;
//obroty
if Shift=[] then
case Key of
  VK_LEFT :Phi:=Phi-3;
  VK_RIGHT :Phi:=Phi+3;
  VK_UP :Theta:=Theta-3;
  VK_DOWN :Theta:=Theta+3;
end;
//przesuniecia
if Shift=[ssCtrl] then
case Key of
  VK_LEFT :PozycjaX:=PozycjaX-0.1;
  VK_RIGHT :PozycjaX:=PozycjaX+0.1;
  VK_UP :PozycjaY:=PozycjaY+0.1;
  VK_DOWN :PozycjaY:=PozycjaY-0.1;
end;
if Shift=[ssShift] then
case Key of
  VK_LEFT :PozycjaX:=PozycjaX-0.1;
  VK_RIGHT :PozycjaX:=PozycjaX+0.1;
  VK_UP :PozycjaZ:=PozycjaZ-0.1;
  VK_DOWN :PozycjaZ:=PozycjaZ+0.1;
end;
//rysowanie
Rysuj;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 //http://www.plansoft.org/

 step := step + 0.3;


 if step < 100 then begin
 Phi:=Phi + 1;
 theta:=theta +1 ;
 end
 else
 begin
 Phi:=Phi + sin (step * 2*pi/360) + 1;
 theta:=theta + cos (step * 2*pi/360) +1 ;
 end;

 if step > 1000 then  ratioinside := 1 + 0.5 + sin (2 * step * 2*pi/360) / 2;

 Rysuj;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const wsp=0.1;
begin
//proporcjonalna zmiana pozycji wszystkich wsp. kamery
KameraX:=KameraX*(1+Sign(WheelDelta)*wsp);
KameraY:=KameraY*(1+Sign(WheelDelta)*wsp);
KameraZ:=KameraZ*(1+Sign(WheelDelta)*wsp);
Rysuj;
end;

end.
