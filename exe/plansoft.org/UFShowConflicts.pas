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
    infoDeleteForbiden: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FShowConflicts: TFShowConflicts;

implementation

{$R *.DFM}

end.
