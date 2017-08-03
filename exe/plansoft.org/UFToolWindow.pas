unit UFToolWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons;

type
  TFToolWindow = class(TForm)
    moveRight: TSpeedButton;
    moveUp: TSpeedButton;
    moveDown: TSpeedButton;
    moveLeft: TSpeedButton;
    Shape8a: TShape;
    AddClass: TSpeedButton;
    EditClass: TSpeedButton;
    BDeleteClass: TSpeedButton;
    Shape1a: TShape;
    Shape9a: TShape;
    bclearselection: TSpeedButton;
    bpastearea: TSpeedButton;
    bcutarea: TSpeedButton;
    bcopyarea: TSpeedButton;
    Shape1: TShape;
    bdelpopup: TSpeedButton;
    beditpopup: TSpeedButton;
    SeeAvailable: TSpeedButton;
    Shape2: TShape;
    bfavpopup: TSpeedButton;
    procedure Shape1aContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure AddClassClick(Sender: TObject);
    procedure EditClassClick(Sender: TObject);
    procedure BDeleteClassClick(Sender: TObject);
    procedure Shape8aContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure moveLeftClick(Sender: TObject);
    procedure moveDownClick(Sender: TObject);
    procedure moveRightClick(Sender: TObject);
    procedure moveUpClick(Sender: TObject);
    procedure bcopyareaClick(Sender: TObject);
    procedure bcutareaClick(Sender: TObject);
    procedure bpasteareaClick(Sender: TObject);
    procedure bclearselectionClick(Sender: TObject);
    procedure moveUpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure bdelpopupClick(Sender: TObject);
    procedure SeeAvailableClick(Sender: TObject);
    procedure bfavpopupClick(Sender: TObject);
    procedure AddClassDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure showtoolwindow;
  end;

var
  FToolWindow: TFToolWindow;

implementation

uses UFMain;

{$R *.dfm}

procedure TFToolWindow.Shape1aContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
 fmain.bAddClassClick(nil);
end;

procedure TFToolWindow.AddClassClick(Sender: TObject);
begin
   Fmain.AddClassToGrid(true);
end;

procedure TFToolWindow.EditClassClick(Sender: TObject);
begin
 fmain.bEditClassClick(nil);
end;

procedure TFToolWindow.BDeleteClassClick(Sender: TObject);
begin
 fmain.bDeleteClassClick(nil);
end;

procedure TFToolWindow.Shape8aContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
 fmain.bmoveLeftClick(nil);
end;

procedure TFToolWindow.moveLeftClick(Sender: TObject);
begin
 fmain.bmoveLeftClick(nil);
end;

procedure TFToolWindow.moveDownClick(Sender: TObject);
begin
 fmain.bmoveDownClick(nil);
end;

procedure TFToolWindow.moveRightClick(Sender: TObject);
begin
 fmain.bmoveRightClick(nil);
end;

procedure TFToolWindow.moveUpClick(Sender: TObject);
begin
 fmain.bmoveUpClick(nil);
end;

procedure TFToolWindow.bcopyareaClick(Sender: TObject);
begin
 fmain.CopyArea;
end;

procedure TFToolWindow.bcutareaClick(Sender: TObject);
begin
 fmain.cutArea;
end;

procedure TFToolWindow.bpasteareaClick(Sender: TObject);
begin
 fmain.pasteArea;
end;

procedure TFToolWindow.bclearselectionClick(Sender: TObject);
begin
 fmain.ClearSelection;
end;

procedure TFToolWindow.moveUpMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 self.AlphaBlendValue := 255;
end;

procedure TFToolWindow.bdelpopupClick(Sender: TObject);
begin
 fmain.bdelpopupClick(sender);
end;

procedure tftoolwindow.showtoolwindow;
  var point : tpoint;
      cursorPos       : TPoint;
begin
  //“A call to an OS function failed” problem
 //Use cursorPos.Y instead of Mouse.CursorPos.Y
 GetCursorPos(cursorPos);

 point.X := cursorPos.x - 20;
 point.Y := cursorPos.y - 70;
 FToolWindow.AlphaBlend := true;
 FToolWindow.AlphaBlendValue := 30;
 FToolWindow.Left := point.X;
 FToolWindow.Top  := point.Y;
 FToolWindow.show;
 fmain.Show;
end;


procedure TFToolWindow.SeeAvailableClick(Sender: TObject);
begin
 fmain.ShowAvailableTerms;
end;

procedure TFToolWindow.bfavpopupClick(Sender: TObject);
begin
 fmain.bdelpopupClick(sender);
end;

procedure TFToolWindow.AddClassDblClick(Sender: TObject);
begin
  Fmain.AddClassToGrid(true);
end;

end.
