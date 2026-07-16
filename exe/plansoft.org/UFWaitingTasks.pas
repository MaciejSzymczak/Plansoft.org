unit UFWaitingTasks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, Db, ADODB;

type
  TFWaitingTasks = class(TFormConfig)
    Grid: TDBGrid;
    DS: TDataSource;
    Query: TADOQuery;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FWaitingTasks: TFWaitingTasks;

implementation

{$R *.dfm}

uses dm, UUtilityParent;

procedure TFWaitingTasks.FormShow(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    Query.Close;
    Query.SQL.Text :=
      'select id, code, description, per_id, status, priority, creation_date, created_by '+
      'from waiting_tasks order by priority, creation_date desc';
    try
      Query.Open;
    except
      copyToClipboard(Query.SQL.Text);
      raise;
    end;
    Query.FieldByName('id').DisplayLabel           := 'Id';
    Query.FieldByName('code').DisplayLabel         := 'Kod';
    Query.FieldByName('description').DisplayLabel  := 'Opis';
    Query.FieldByName('per_id').DisplayLabel       := 'Okres';
    Query.FieldByName('status').DisplayLabel       := 'Status';
    Query.FieldByName('priority').DisplayLabel     := 'Priorytet';
    Query.FieldByName('creation_date').DisplayLabel:= 'Utworzono';
    Query.FieldByName('created_by').DisplayLabel   := 'Utworzy³';
    UFormConfig.AutoFitGridColumns(Grid, Query);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFWaitingTasks.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;
end.
