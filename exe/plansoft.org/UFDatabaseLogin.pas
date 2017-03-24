unit UFDatabaseLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, StrHlder, UUtilityParent, DB,
  DBTables, DBLists ,OpenGL, math;

type
  TFDatabaseLogin = class(TFormConfig)
    Panel1: TPanel;
    BAnuluj: TBitBtn;
    Bok: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    UserName: TEdit;
    Password: TEdit;
    Timer1: TTimer;
    glPanel: TPanel;
    DatabaseName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Label1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    uchwytDC :HDC; //uchwyt do "display device context (DC)"
    uchwytRC :HGLRC; //uchwyt do "OpenGL rendering context"
    Phi, Theta :Single;
    PozycjaX, PozycjaY, PozycjaZ :Single;
    RuchKamery :Boolean;
    KameraX, KameraY, KameraZ :Single;
    autoClose : boolean;
  colors : array[0..95] of record r, g, b : integer end;
    function GL_UstalFormatPikseli(uchwytDC :HDC) :Boolean;
    procedure GL_UstawienieSceny;
    procedure Rysuj;
    procedure drawCube(x0,y0,z0 :Single);
    procedure Swiatlo1;
    procedure Swiatlo0;
    procedure GL_Oswietlenie;
  public
    n : single;
    ratioinside : single;
  end;

var
  FDatabaseLogin: TFDatabaseLogin;

Function Login(var aDataBaseName, aUserName, aPassword : ShortString) : TModalResult;

implementation

uses UFChangePassword;

{$R *.DFM}


Function Login(var aDataBaseName, aUserName, aPassword : ShortString) : TModalResult;
Begin
 Application.CreateForm(TFDatabaseLogin, FDatabaseLogin);
 //FDatabaseLogin :=  TFDatabaseLogin.Create(Application);

 With FDatabaseLogin Do Begin

  //UserName.Text := aUserName;
  //Password.Text := aPassword;

  ActiveControl := password;
  UserName.Text := aUserName;
  Password.Text := aPassword;
  DatabaseName.text := aDataBaseName;

  autoClose := aPassword <> '';

  UserName.Enabled := not autoClose;
  Password.Enabled := not autoClose;
  if not Password.Enabled then activeControl := Bok;


  Result := ShowModal;

  aUserName := UserName.Text;
  aPassword := Password.Text;
  aDataBaseName :=  DatabaseName.text;

  Free;
 End;
End;


procedure TFDatabaseLogin.Swiatlo0;
const
  kolor0_rozproszone :TGLArrayf4 =(0.5,0.5,0.5,1.0);
begin
glLightfv(GL_LIGHT0, GL_DIFFUSE, @kolor0_rozproszone);
glENABLE(GL_LIGHT0);
end;

procedure TFDatabaseLogin.Swiatlo1;
const
  kolor1_rozproszone :TGLArrayf4 =(0.3,0.3,0.3,1.0);
  kolor1_reflektora :TGLArrayf4 =(1.0,1.0,1.0,1.0);
  pozycja :TGLArrayf4 =(0.0,-10.0,0.0,1.0);
  szerokosc_wiazki = 60.0; //w stopniach
begin
glLightfv(GL_LIGHT1, GL_POSITION, @pozycja);
glLightfv(GL_LIGHT1, GL_DIFFUSE, @kolor1_rozproszone);
glLightfv(GL_LIGHT1, GL_SPECULAR, @kolor1_reflektora);
glLightf(GL_LIGHT1, GL_SPOT_CUTOFF, szerokosc_wiazki);
glENABLE(GL_LIGHT1);
end;

procedure TFDatabaseLogin.GL_Oswietlenie;
const   kolor_otoczenie :TGLArrayf3 =(0.5,0.5,0.5); //biel
begin
exit;
glEnable(GL_LIGHTING); //wlaczenie systemu oswietlania

glLightModelfv(GL_LIGHT_MODEL_AMBIENT,@kolor_otoczenie); //swiatlo tla

glEnable(GL_COLOR_MATERIAL);
glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);

Swiatlo0;
Swiatlo1;
end;


function TFDatabaseLogin.GL_UstalFormatPikseli(uchwytDC :HDC) :Boolean;
{const OpisFormatuPikseli :PIXELFORMATDESCRIPTOR=(
        nSize:      sizeof(PIXELFORMATDESCRIPTOR);	// wielkoœæ
        nVersion:   1;			// wersja
        dwFlags:    PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or PFD_DOUBLEBUFFER;	// udostêpnienie podwójnego buforowania
        iPixelType: PFD_TYPE_RGBA;	// typ koloru
        cColorBits: 24;			// ¿¹dana rozdzielczoœæ koloru
        cRedBits:   0;  cRedShift:  0;	// bity koloru(ignorowane)
        cGreenBits: 0;  cGreenShift:0;
        cBlueBits:  0;  cBlueShift: 0;
        cAlphaBits: 0;  cAlphaShift:0;   // wy³¹czenie buforu alfa
        cAccumBits: 0;
        cAccumRedBits:    0;  		// wy³¹czenie akumulacji bufora
        cAccumGreenBits:  0;     	// akumulowanie bitów (ignorowane)
        cAccumBlueBits:   0;
        cAccumAlphaBits:  0;
        cDepthBits:       16;			// wielkoœæ bufora
        cStencilBits:     0;			// bez buforu szablonu
        cAuxBuffers:      0;			// bez buforu pomocniczego
        iLayerType:       PFD_MAIN_PLANE;  	// g³ówna pow³oka
   bReserved:       0;
   dwLayerMask:     0;
   dwVisibleMask:   0;
   dwDamageMask:    0;  // brak widocznoœci pow³oki, zniszczenie maski
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
  cColorBits:=32; //jakosc kolorów 4 bajty
  cDepthBits:=16; //glebokosc bufora Z (z-buffer)
  iLayerType:=PFD_MAIN_PLANE;
  end;
formatPikseli:=ChoosePixelFormat(uchwytDC, @opisFormatuPikseli);
if (formatPikseli=0) then Exit;
if (SetPixelFormat(uchwytDC, formatPikseli, @opisFormatuPikseli) <> True) then Exit;
Result:=True;
end;

procedure TFDatabaseLogin.GL_UstawienieSceny;
begin
//ustawienie punktu projekcji
glMatrixMode(GL_PROJECTION); //macierz projekcji
//left,right,bottom,top,znear,zfar
glFrustum(-0.1, 0.1, -0.1, 0.1, 0.3, 25.0); //mnozenie macierzy przez macierz perspektywy
glMatrixMode(GL_MODELVIEW); //powrot do macierzy widoku
glEnable(GL_DEPTH_TEST); //z-buffer aktywny = ukrywanie niewidocznych trojkatow !!!
end;


procedure TFDatabaseLogin.FormCreate(Sender: TObject);
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
 ratioinside := 1;
 for t := 0 to 95 do begin
   r := random(6);
   //setRgb(t,random(255),random(255),random(255));
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


KameraZ:=10;
RuchKamery:=True;
polozenieMyszy.X:=ClientWidth div 2;
polozenieMyszy.Y:=ClientHeight div 2;
if RuchKamery then Mouse.CursorPos:=ClientToScreen(polozenieMyszy);
//glClearColor (0.92,0.92,0.92,0);
gl_oswietlenie;
end;

procedure TFDatabaseLogin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
 wglMakeCurrent(0,0);
 wglDeleteContext(uchwytRC);
 ReleaseDC(glPanel.Handle,uchwytDC);
end;

procedure TFDatabaseLogin.drawCube(x0,y0,z0 :Single);
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

procedure TFDatabaseLogin.Rysuj;
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

procedure TFDatabaseLogin.FormPaint(Sender: TObject);
begin
  inherited;
Rysuj;
Timer1.Enabled :=true;
end;

procedure TFDatabaseLogin.Timer1Timer(Sender: TObject);
var dphi,dth : single;

begin
  inherited;
 n := n + 0.3;

 if autoClose then
  if n > 100 then modalResult := mrOK;

 if n < 500 then begin
 Phi:=Phi + 1;
 theta:=theta +1 ;
 end
 else
 begin
 Phi:=Phi + sin (n * 2*pi/360) + 1;
 theta:=theta + cos (n * 2*pi/360) +1 ;
 end;

 if n > 1000 then  ratioinside := 1 + 0.5 + sin (2 * n * 2*pi/360) / 2;

 Rysuj;
end;

procedure TFDatabaseLogin.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
const wsp=0.1;
begin
//proporcjonalna zmiana pozycji wszystkich wsp. kamery
KameraX:=KameraX*(1+Sign(WheelDelta)*wsp);
KameraY:=KameraY*(1+Sign(WheelDelta)*wsp);
KameraZ:=KameraZ*(1+Sign(WheelDelta)*wsp);
Rysuj;
end;

procedure TFDatabaseLogin.Label1DblClick(Sender: TObject);
begin
  inherited;
  DatabaseName.Text := '127.0.0.1:1521/xe';
end;

procedure TFDatabaseLogin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose := true;
  if self.ModalResult = mrOK then
    if (DatabaseName.text = '') or (UserName.Text = '') or (Password.Text = '') then begin
      info ('WprowadŸ nazwê bazy danych (np. dok), nazwê u¿ytkownika oraz has³o');
      canClose := false;
    end;
end;

end.
