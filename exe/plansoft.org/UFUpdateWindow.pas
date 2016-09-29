unit UFUpdateWindow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, StrHlder, UUtilityParent, DB,
  DBTables, DBLists ,{OpenGL} math, UrlMon, xmldom, XMLIntf, msxmldom,
  XMLDoc;

type
  TFUpdateWindow = class(TFormConfig)
    Panel1: TPanel;
    Timer1: TTimer;
    glPanel: TPanel;
    LastActivity: TLabel;
    Timer2: TTimer;
    XML: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer2Timer(Sender: TObject);
  private
    {uchwytDC :HDC; //uchwyt do "display device context (DC)"
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
    procedure GL_Oswietlenie;}
    procedure switchToMainApplication;
    procedure launchProcess;
    function downloadfiles ( pConfigFileName : string ) : boolean;
  public
    n : single;
    ratioinside : single;
  end;

var
  FUpdateWindow: TFUpdateWindow;

implementation

{$R *.DFM}




{procedure TFUpdateWindow.Swiatlo0;
const
  kolor0_rozproszone :TGLArrayf4 =(0.5,0.5,0.5,1.0);
begin
glLightfv(GL_LIGHT0, GL_DIFFUSE, @kolor0_rozproszone);
glENABLE(GL_LIGHT0);
end;

procedure TFUpdateWindow.Swiatlo1;
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

procedure TFUpdateWindow.GL_Oswietlenie;
const   kolor_otoczenie :TGLArrayf3 =(0.5,0.5,0.5); //biel
begin
//exit; @@@!!!
 glEnable(GL_LIGHTING); //wlaczenie systemu oswietlania

 glLightModelfv(GL_LIGHT_MODEL_AMBIENT,@kolor_otoczenie); //swiatlo tla

 glEnable(GL_COLOR_MATERIAL);
 glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);

 Swiatlo0;
 Swiatlo1;
end;


function TFUpdateWindow.GL_UstalFormatPikseli(uchwytDC :HDC) :Boolean;
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

procedure TFUpdateWindow.GL_UstawienieSceny;
begin
 //ustawienie punktu projekcji
 glMatrixMode(GL_PROJECTION); //macierz projekcji
 //left,right,bottom,top,znear,zfar
 glFrustum(-0.1, 0.1, -0.1, 0.1, 0.3, 25.0); //mnozenie macierzy przez macierz perspektywy
 glMatrixMode(GL_MODELVIEW); //powrot do macierzy widoku
 glEnable(GL_DEPTH_TEST); //z-buffer aktywny = ukrywanie niewidocznych trojkatow !!!
end;
}


procedure TFUpdateWindow.FormCreate(Sender: TObject);
{var
  polozenieMyszy :TPoint;
  t : integer;
  r : integer;
  procedure setRGB ( t, r, g, b : integer);
  begin
    colors[t].r := r;
    colors[t].g := g;
    colors[t].b := b;
  end;
}
begin

//glIsOff
exit;
{
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
}
end;

procedure TFUpdateWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
{ wglMakeCurrent(0,0);
 wglDeleteContext(uchwytRC);
 ReleaseDC(glPanel.Handle,uchwytDC);
}
end;

{procedure TFUpdateWindow.drawCube(x0,y0,z0 :Single);
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

procedure TFUpdateWindow.Rysuj;
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
}

procedure TFUpdateWindow.FormPaint(Sender: TObject);
begin
  inherited;
 //glIsOff
 //Rysuj;
 //Timer1.Enabled :=true;
end;

procedure TFUpdateWindow.Timer1Timer(Sender: TObject);
var dphi,dth : single;

begin
{  inherited;
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
}
end;

procedure TFUpdateWindow.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
const wsp=0.1;
begin
//proporcjonalna zmiana pozycji wszystkich wsp. kamery
{KameraX:=KameraX*(1+Sign(WheelDelta)*wsp);
KameraY:=KameraY*(1+Sign(WheelDelta)*wsp);
KameraZ:=KameraZ*(1+Sign(WheelDelta)*wsp);
Rysuj;
}end;

procedure TFUpdateWindow.switchToMainApplication;
var
  FullProgPath: PChar;
begin
  FullProgPath := PChar(extractFilePath(Application.ExeName)+'planowanie.exe');
  WinExec(FullProgPath, SW_SHOW);
  Application.Terminate;
end;

function TFUpdateWindow.downloadfiles (pConfigFileName : string) : boolean;
      {---------------------------------------------------------------}
      Function cutApostrophe(S : ShortString) : ShortString;
      Var I : Integer;
      Begin
       Result := '';
       For I := 1 To Length(S) Do
        If S[I] <> '"' Then Result := Result + S[I];
      End;
      {---------------------------------------------------------------}
      function downloadFile ( downloadFrom, downloadTo : string ) : boolean;
      var pfileName : string;
      begin
        downloadTo := PChar(replace(downloadTo,'$(currentDir)\',extractFilePath(Application.ExeName)));
        {$I-} ForceDirectories(CutApostrophe( extractFilePath(downloadTo) )); {$I+};
        pfileName := extractFileName( downloadTo );
        LastActivity.caption := 'Pobieranie pliku ' + pfileName;
        LastActivity.Refresh;
        self.Refresh;
        if fileExists(downloadTo) then
        if not deleteFile(downloadTo) then
          begin SError('Aktualizacja nie powiod³a siê. Nie mo¿na skasowaæ pliku '+pfileName); result := false;  exit; end;
        if not URLDownloadToFile(nil,PAnsiChar(downloadFrom), PAnsiChar(downloadTo),0, nil) = 0 then
          begin SError('Aktualizacja pliku '+pfileName+' nie powiod³a siê'+cr+'SprawdŸ, czy komputer jest pod³aczony do Internetu'); result := false; exit; end;
        if not fileExists(downloadTo) then
          begin SError('Aktualizacja pliku '+pfileName+' nie powiod³a siê'+cr+'SprawdŸ, czy plik znajduje siê na serwerze'); result := false; exit; end;
        result := true;
      end;
      {---------------------------------------------------------------}
      function getAttrValue (node : IXMLNode; attributeName : string) : string;
      begin
         if node.HasAttribute(attributeName)
           Then result := node.Attributes[attributeName]
           Else result := '';
      end;
      var t,t2, length : integer;
{---------------------------------------------------------------}
begin
   XML.XML.Clear;
   XML.Active := True;
   try
    XML.LoadFromFile( pConfigFileName );
   except
    showmessage('Nie mo¿na otworzyæ pliku ' + pConfigFileName);
    application.Terminate;
   end;

   length := xml.DocumentElement.ChildNodes.Count;
   for t := 0 to length-1 do begin
     if XML.DocumentElement.ChildNodes[t].NodeName = 'version' then begin
        if XML.DocumentElement.ChildNodes[t].Text <> '1.0' then begin
            info('Zmieni³a siê wersja programu instalacyjnego. Pobierz aktualne oprogramowanie ze strony www.plansoft.org.');
            exit;
        end;
     end;
     if XML.DocumentElement.ChildNodes[t].NodeName = 'question' then begin
        if question(XML.DocumentElement.ChildNodes[t].Text) = id_no then begin
            result := false;
            exit;
        end;
     end;
     if XML.DocumentElement.ChildNodes[t].NodeName = 'files' then begin
         for t2 := 0 to xml.DocumentElement.ChildNodes[t].ChildNodes.Count-1 do begin
             //showmessage ( XML.DocumentElement.ChildNodes[t].ChildNodes[t2].NodeName );
             //showmessage ( getAttrValue( XML.DocumentElement.ChildNodes[t].ChildNodes[t2], 'from')  );
             //showmessage ( getAttrValue( XML.DocumentElement.ChildNodes[t].ChildNodes[t2], 'to')  );
             if not downloadFile ( getAttrValue( XML.DocumentElement.ChildNodes[t].ChildNodes[t2], 'from')
                                 , getAttrValue( XML.DocumentElement.ChildNodes[t].ChildNodes[t2], 'to')
                                 )
             then begin result := false; exit; end;
         end;
     end;

     result := true;
   end;
end;

procedure TFUpdateWindow.launchProcess;
var FullProgPath : string;
    temporaryFilePath : pchar;
    F : TextFile;
begin
  temporaryFilePath := PChar(extractFilePath(Application.ExeName)+'$$$temporary$$$');
  //permissions granted ?
  try
    AssignFile(F, temporaryFilePath);
    Rewrite(F);
    WriteLn(f, '<any text>');
    closeFile(f);
    deletefile(temporaryFilePath);
  except
    info ('Nie mo¿na dokonaæ aktualizacji programu z powodu braku uprawnieñ do zapisu na dysku w lokalizacji'+cr+cr+extractFilePath(Application.ExeName)+cr+cr+'Uruchom program ponownie z poziomu administratora systemu');
    Application.Terminate;
  end;

  if downloadfiles ( extractFilePath(Application.ExeName)+'update.xml' ) then
  begin
    ShowMessage('Aktualizacja zakoñczy³a siê pomyœlnie');
    switchToMainApplication;
  end
  else
  begin
    //SError('Aktualizacja nie powiod³a siê');
    application.Terminate;
  end;
end;

procedure TFUpdateWindow.Timer2Timer(Sender: TObject);
begin
  inherited;
  timer2.Enabled := false;
  launchProcess;
end;

end.
