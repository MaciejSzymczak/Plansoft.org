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
begin
  if ShowConflicts <> PanelIs.Visible then begin
    PanelIs.Visible := ShowConflicts;
    Panel5.Visible  := ShowConflicts;
    if ShowConflicts then ClientHeight := ClientHeight + cConflictsSectionHeight
                      else ClientHeight := ClientHeight - cConflictsSectionHeight;
  end;
  if ShowHints <> PanelHints.Visible then begin
    PanelHints.Visible := ShowHints;
    if ShowHints then ClientHeight := ClientHeight + cHintsSectionHeight
                  else ClientHeight := ClientHeight - cHintsSectionHeight;
  end;
end;

end.