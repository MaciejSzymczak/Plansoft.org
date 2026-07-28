unit UFShowConflicts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids;

type
  TFShowConflicts = class(TFormConfig)
    Panel1: TPanel;
    BCancel: TButton;
    BDelete: TButton;
    PanelNew: TPanel;
    Panel3: TPanel;
    PanelIs: TPanel;
    Panel5: TPanel;
    SGNewClass: TStringGrid;
    SGConflicts: TStringGrid;
    SGHints: TStringGrid;
    PanelHints: TPanel;
    infoDeleteForbiden: TLabel;
    procedure SGConflictsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    dataStamp : String;
    Procedure SetSectionsVisible(ShowConflicts, ShowHints : Boolean);
  end;

var
  FShowConflicts: TFShowConflicts;

implementation

{$R *.DFM}

Uses UUtilityParent;

procedure TFShowConflicts.SGConflictsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
with SGConflicts do
   begin
      if pos('>>',Cells[ACol,ARow])<>0 then begin
        Canvas.Brush.Color := clRed;
        Canvas.Font.Style := [fsBold];
        Canvas.Font.Color := clHighlightText;
      end;

     Canvas.FillRect(Rect);
     Canvas.TextOut(Rect.Left + 3, Rect.Top + 5, replace(Cells[ACol,ARow],'>>',''));
   end
end;

Procedure TFShowConflicts.SetSectionsVisible(ShowConflicts, ShowHints : Boolean);
Const cConflictsSectionHeight = 31 + 222; //PanelIs + Panel5 design heights (see .dfm)
      cHintsSectionHeight     = 140;      //PanelHints design height (see .dfm)
Var baseHeight : integer;
begin
  //2026-07: derive the "both sections hidden" baseline from the CURRENT ClientHeight and CURRENT
  //visibility instead of blindly adding/subtracting relative to the previous call. The old code
  //could drift (window shrinking/growing over repeated calls) if this form's visible state ever
  //got out of step with what it last set - this version is idempotent: calling it repeatedly with
  //the same or different values always converges to the same, correct height.
  baseHeight := ClientHeight;
  if PanelIs.Visible    then baseHeight := baseHeight - cConflictsSectionHeight;
  if PanelHints.Visible then baseHeight := baseHeight - cHintsSectionHeight;

  PanelIs.Visible    := ShowConflicts;
  Panel5.Visible     := ShowConflicts;
  PanelHints.Visible := ShowHints;

  ClientHeight := baseHeight
    + (ord(ShowConflicts) * cConflictsSectionHeight)
    + (ord(ShowHints) * cHintsSectionHeight);
end;

end.