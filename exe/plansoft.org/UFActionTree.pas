unit UFActionTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, Buttons, StdCtrls, ExtCtrls, dm;

type
  TFActionTree = class(TFormConfig)
    Oprion2: TSpeedButton;
    Option1: TSpeedButton;
    frame: TShape;
    Option3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure Oprion2Click(Sender: TObject);
    procedure Option1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Option3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    selectedOption : integer;
    procedure showList(actionType :  shortString);
  end;

var
  FActionTree: TFActionTree;

implementation

{$R *.dfm}

procedure TFActionTree.Oprion2Click(Sender: TObject);
begin
  selectedOption := 0; //'Edit';
  close;
end;

procedure TFActionTree.Option1Click(Sender: TObject);
begin
  selectedOption := 1; //'TimeTable';
  close;
end;

procedure TFActionTree.SpeedButton3Click(Sender: TObject);
begin
  selectedOption := 2; //'Stats';
  close;
end;

procedure TFActionTree.showList;
var    cursorPos       : TPoint;
begin
 if actionType = 'L' then Option1.Caption := 'Przejdü do rozk≥adu';
 if actionType = 'G' then Option1.Caption := 'Przejdü do rozk≥adu';
 if actionType = 'R' then Option1.Caption := 'Przejdü do rozk≥adu';
 if actionType = 'C' then Option1.Caption := 'Przejdü do kalendarza';
 if actionType = 'P' then Option1.Caption := 'Ustaw aktywny okres';
 if actionType = 'S' then Option1.Caption := 'Ustaw aktywny przedmiot';
 if actionType = 'F' then Option1.Caption := 'Ustaw aktywnπ formÍ';

 Option3.Visible := actionType <>'C';

  //ìA call to an OS function failedî problem
 //Use cursorPos.Y instead of Mouse.CursorPos.Y
 GetCursorPos(cursorPos);
 self.Left := cursorPos.x;
 self.Top := cursorPos.y;
 FActionTree.Height := frame.Height;
 FActionTree.Width := frame.Width;
 showModal;
end;

procedure TFActionTree.FormShow(Sender: TObject);
begin
  //inherited;
end;

procedure TFActionTree.Option3Click(Sender: TObject);
begin
  selectedOption := 2;
  close;
end;

procedure TFActionTree.SpeedButton1Click(Sender: TObject);
begin
  selectedOption := 3;
  close;
end;

end.
