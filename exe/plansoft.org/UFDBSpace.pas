unit UFDBSpace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, Db, ADODB;

const
  cCollapsedHeight = 150;
  cExpandedHeight  = 420;

type
  TFDBSpace = class(TFormConfig)
    TopPanel: TPanel;
    LUsed: TLabel;
    LLimit: TLabel;
    LFree: TLabel;
    BDetails: TBitBtn;
    Grid: TDBGrid;
    DS: TDataSource;
    SummaryQuery: TADOQuery;
    SegmentsQuery: TADOQuery;
    UsageBar: TPaintBox;
    procedure FormShow(Sender: TObject);
    procedure BDetailsClick(Sender: TObject);
    procedure UsageBarPaint(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FUsedPercent    : Extended;
    FSegmentsLoaded : Boolean;
    Procedure RefreshSummary;
    Procedure LoadSegments;
  public
    { Public declarations }
  end;

var
  FDBSpace: TFDBSpace;

implementation

{$R *.dfm}

uses dm, UUtilityParent;

procedure TFDBSpace.FormShow(Sender: TObject);
begin
  inherited;
  Grid.Visible    := False;
  Height          := cCollapsedHeight;
  FSegmentsLoaded := False;
  RefreshSummary;
end;

procedure TFDBSpace.BDetailsClick(Sender: TObject);
begin
  Grid.Visible := not Grid.Visible;
  if Grid.Visible then begin
    Height := cExpandedHeight;
    BDetails.Caption := 'Ukryj szczeg'#243#179'y';
    if not FSegmentsLoaded then LoadSegments;
  end else begin
    Height := cCollapsedHeight;
    BDetails.Caption := 'Szczeg'#243#179'y';
  end;
end;

Procedure TFDBSpace.RefreshSummary;
Var SummarySQL : String;
begin
  Screen.Cursor := crHourGlass;
  try
    SummarySQL :=
      'SELECT ROUND(SUM(bytes)/1024/1024/1024,2) AS used_gb, '+
      '       12 AS limit_gb, '+
      '       ROUND((12-SUM(bytes)/1024/1024/1024),2) AS free_gb, '+
      '       ROUND(SUM(bytes)/1024/1024/1024/12*100,2) AS used_percent '+
      'FROM dba_segments';
    SummaryQuery.Close;
    SummaryQuery.SQL.Text := SummarySQL;
    try
      SummaryQuery.Open;
    except
      copyToClipboard(SummarySQL);
      raise;
    end;
    LUsed.Caption  := 'Wykorzystano: ' + SummaryQuery.FieldByName('used_gb').AsString  + ' GB';
    LLimit.Caption := 'Limit: '        + SummaryQuery.FieldByName('limit_gb').AsString + ' GB';
    LFree.Caption  := 'Wolne: '        + SummaryQuery.FieldByName('free_gb').AsString  + ' GB';
    FUsedPercent   := SummaryQuery.FieldByName('used_percent').AsFloat;
    SummaryQuery.Close;
    UsageBar.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

Procedure TFDBSpace.LoadSegments;
Var SegmentsSQL : String;
begin
  Screen.Cursor := crHourGlass;
  try
    SegmentsSQL :=
      'SELECT owner, segment_name, segment_type, '+
      '       ROUND(bytes/1024/1024,2) MB '+
      'FROM dba_segments '+
      'ORDER BY bytes DESC '+
      'FETCH FIRST 20 ROWS ONLY';
    SegmentsQuery.Close;
    SegmentsQuery.SQL.Text := SegmentsSQL;
    try
      SegmentsQuery.Open;
    except
      copyToClipboard(SegmentsSQL);
      raise;
    end;
    UFormConfig.AutoFitGridColumns(Grid, SegmentsQuery);
    FSegmentsLoaded := True;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFDBSpace.UsageBarPaint(Sender: TObject);
var
  fillWidth : Integer;
  barColor  : TColor;
  pctText   : String;
begin
  with UsageBar.Canvas do begin
    Brush.Color := RGB(232, 232, 232);
    FillRect(UsageBar.ClientRect);

    if FUsedPercent >= 90 then barColor := RGB(206, 46, 46)
    else if FUsedPercent >= 70 then barColor := RGB(230, 145, 30)
    else barColor := RGB(46, 150, 74);

    fillWidth := Round((UsageBar.Width - 2) * (FUsedPercent / 100));
    if fillWidth > UsageBar.Width - 2 then fillWidth := UsageBar.Width - 2;
    if fillWidth < 0 then fillWidth := 0;

    Brush.Color := barColor;
    FillRect(Rect(1, 1, 1 + fillWidth, UsageBar.Height - 1));

    Pen.Color := RGB(150, 150, 150);
    Brush.Style := bsClear;
    Rectangle(0, 0, UsageBar.Width, UsageBar.Height);

    pctText := FormatFloat('0.0', FUsedPercent) + ' %';
    Font.Color := clBlack;
    Font.Style := [fsBold];
    Brush.Style := bsClear;
    TextOut( (UsageBar.Width - TextWidth(pctText)) div 2, (UsageBar.Height - TextHeight(pctText)) div 2, pctText);
  end;
end;

procedure TFDBSpace.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  isTopSegment : Boolean;
  cellText     : String;
begin
  isTopSegment := (not SegmentsQuery.Eof) and (SegmentsQuery.RecNo <= 3);

  if gdSelected in State then
    Grid.Canvas.Brush.Color := clHighlight
  else if isTopSegment then
    Grid.Canvas.Brush.Color := RGB(255, 228, 200)
  else if Odd(SegmentsQuery.RecNo) then
    Grid.Canvas.Brush.Color := RGB(245, 245, 245)
  else
    Grid.Canvas.Brush.Color := clWindow;

  if gdSelected in State then
    Grid.Canvas.Font.Color := clHighlightText
  else if isTopSegment then
    Grid.Canvas.Font.Color := RGB(140, 40, 0)
  else
    Grid.Canvas.Font.Color := clWindowText;

  Grid.Canvas.FillRect(Rect);

  cellText := Column.Field.DisplayText;

  if Column.FieldName = 'MB' then
    Grid.Canvas.TextRect(Rect, Rect.Right - Grid.Canvas.TextWidth(cellText) - 6, Rect.Top + 2, cellText)
  else
    Grid.Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top + 2, cellText);
end;

end.
