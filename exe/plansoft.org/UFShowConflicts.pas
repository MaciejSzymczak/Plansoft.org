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
begin
  PanelIs.Visible    := ShowConflicts;
  Panel5.Visible     := ShowConflicts;
  PanelHints.Visible := ShowHints;

  //2026-08: compute an ABSOLUTE target height from each panel's own design Height, instead of
  //deriving a "baseline" by subtracting from the form's CURRENT ClientHeight. TFormConfig.FormCreate
  //(ancestor class, see UFormConfig.pas LoadFormConfiguration) restores Form.Height from a saved
  //.cfg file on every app start - if that saved value predates this dynamic-resize feature (or is
  //otherwise stale), the previous relative/subtractive formula treated that stale height as ground
  //truth and could never recover from it, and FormClose would then re-save the wrong size, locking
  //the bug in permanently ("window doesn't grow at all"). Panel1/PanelNew/Panel3's own Height are
  //never touched by config restore (only Form.Height/Width/Left/Top are), so summing them directly
  //is immune to this.
  ClientHeight := Panel1.Height + PanelNew.Height + Panel3.Height
    + (ord(ShowConflicts) * (PanelIs.Height + Panel5.Height))
    + (ord(ShowHints) * PanelHints.Height);
end;

end.