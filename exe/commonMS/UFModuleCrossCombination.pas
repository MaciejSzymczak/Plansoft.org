unit UFModuleCrossCombination;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids, dbtables, TeEngine,
  Series, TeeProcs, Chart, StrHlder, ComCtrls, Printers, ADODB;

type
  TFModuleCrossCombination = class(TFormConfig)
    FontDialog: TFontDialog;
    Timer: TTimer;
    Messages: TStrHolder;
    Panel3: TPanel;
    PB: TProgressBar;
    LProgress: TLabel;
    SG2: TStringGrid;
    Panel1: TPanel;
    Label1: TLabel;
    BZoom1: TSpeedButton;
    BZoom2: TSpeedButton;
    BZoom3: TSpeedButton;
    BZoom4: TSpeedButton;
    BFont: TSpeedButton;
    BClose: TSpeedButton;
    BChart1: TSpeedButton;
    BChart2: TSpeedButton;
    BSort1: TSpeedButton;
    BSort2: TSpeedButton;
    BSort3: TSpeedButton;
    BSort4: TSpeedButton;
    BSort5: TSpeedButton;
    BSort6: TSpeedButton;
    BSort7: TSpeedButton;
    BSort8: TSpeedButton;
    BRefresh: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    AggregateFunction: TComboBox;
    MaskFormat: TComboBox;
    ComboRowColumn: TComboBox;
    ComboColColumn: TComboBox;
    ComboMiddleColumn: TComboBox;
    AutoRefresh: TCheckBox;
    DisableRows: TCheckBox;
    DisableCols: TCheckBox;
    Panel2: TPanel;
    SG: TStringGrid;
    Chart: TChart;
    Series1: TBarSeries;
    Splitter1: TSplitter;
    BSave: TSpeedButton;
    Bload: TSpeedButton;
    SD: TSaveDialog;
    OD: TOpenDialog;
    BEksport: TSpeedButton;
    SD2: TSaveDialog;
    SpeedButton1: TSpeedButton;
    PrintDialog: TPrintDialog;
    SpeedButton2: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BZoom1Click(Sender: TObject);
    procedure BZoom2Click(Sender: TObject);
    procedure BZoom3Click(Sender: TObject);
    procedure BZoom4Click(Sender: TObject);
    procedure BFontClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure BChart1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure SGSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure BSort1Click(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure ComboMiddleColumnChange(Sender: TObject);
    procedure ComboRowColumnChange(Sender: TObject);
    procedure ComboColColumnChange(Sender: TObject);
    procedure OnDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure AggregateFunctionChange(Sender: TObject);
    procedure MaskFormatChange(Sender: TObject);
    procedure DisableRowsClick(Sender: TObject);
    procedure DisableColsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure BloadClick(Sender: TObject);
    procedure BEksportClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    HLastSortType,  VLastSortType      : ShortString;
    Query                              : TADOQuery;
    RowColumn, ColColumn, MiddleColumn : String;
    TimerCounter                       : Integer;
    Columns                            : TStrings;
    Fields                             : Array[1..13] Of TComboBox;
    CanRefresh                         : Boolean;
    FileName                           : ShortString;
    Procedure ResetSG;
    Procedure RefreshChart;
    {Procedure SwapRows(i, j : Integer);
    Procedure SwapCols(i, j : Integer);}
    procedure SortRows(Col : Integer; P : TListSortCompare; Kind : Integer);
    procedure SortCols(Row : Integer; P : TListSortCompare; Kind : Integer);

    Function  GetFieldType(S : String) : ShortString;
    Function  GetFieldCaption(S : String) : ShortString;
    Function  GetFieldName(S : String) : ShortString;
    Procedure Sort;
    Procedure SaveToFile(FileName : ShortString);
    Procedure LoadFromFile(FileName : ShortString);
  public
    { Public declarations }
  end;

Type TDoubleContainter = Class (TObject)
                D       : Double;        //double value for Cell
                Counter : Integer;       //counter for cell
                Value   : Double;        //2nd double value for cell
               End;

Type TSortedObject = Class (TObject)
       Str : String;
       Dbl : Double;
       Num : Integer;
     End;

var
  FModuleCrossCombination : TFModuleCrossCombination;
  DoubleContainter        : TDoubleContainter;

Function ShowModal(_Query : TADOQuery; aColumns : TStrings; aFileName : ShortString) : TModalResult;

implementation

{$R *.DFM}

Uses MaxMin, UUtilityParent;

Function ShowModal(_Query : TADOQuery; aColumns : TStrings; aFileName : ShortString) : TModalResult;
Var t : Integer;
Begin
 FModuleCrossCombination := TFModuleCrossCombination.Create(Application);
 With FModuleCrossCombination Do Begin
  Query     := _Query;
  FileName  := aFileName;
  Columns   := aColumns;
  Fields[1] := ComboRowColumn;
  Fields[2] := ComboColColumn;
  Fields[3] := ComboMiddleColumn;

  For t := 0 To Columns.Count - 1 Do Begin
     Fields[1].Items.Add(GetFieldCaption(Columns[t]));
     Fields[2].Items.Add(GetFieldCaption(Columns[t]));
     Fields[3].Items.Add(GetFieldCaption(Columns[t]));
  End;

  AggregateFunction.ItemIndex := 1;
  MaskFormat.ItemIndex := 0;

  Result := ShowModal;
  SaveToFile(FileName);

  Free;
 End;
End;

Function TFModuleCrossCombination.GetFieldCaption(S : String) : ShortString;
Begin
 Try    Result := ExtractWord(1,S,['|']);
 Except Result := 'Error'; End;
End;

Function TFModuleCrossCombination.GetFieldType(S : String) : ShortString;
Begin
 Try    Result := ExtractWord(3,S,['|']);
 Except Result := 'Error'; End;
End;

Function TFModuleCrossCombination.GetFieldName(S : String) : ShortString;
Begin
 Try    Result := ExtractWord(2,S,['|']);
 Except Result := 'Error'; End;
End;

procedure TFModuleCrossCombination.OnDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
Var FieldNumber : Integer;
    FieldType   : ShortString;
    W         : ShortString;
    K         : TColor;
begin
  inherited;
   FieldNumber := (Control As TComboBox).Tag;
   Fields[FieldNumber].Canvas.Brush.Color := clWhite;
   Fields[FieldNumber].Canvas.FillRect(Rect);
   Fields[FieldNumber].Canvas.Font.Color := clBlack;
   Fields[FieldNumber].Canvas.TextOut(Rect.Left+40, Rect.Top, Fields[FieldNumber].Items[Index]);

   FieldType := GetFieldType(Columns[Index]);
   If FieldType = 'ftString'  Then Begin W := Messages.Strings[0]; K := clGreen; End Else
   If FieldType = 'ftInteger' Then Begin W := Messages.Strings[1]; K := clBlack; End Else
   If FieldType = 'ftFloat'   Then Begin W := Messages.Strings[2]; K := clBlue;  End Else
   If FieldType = 'ftDate'    Then Begin W := Messages.Strings[4]; K := clSilver; End Else
   If FieldType = 'ftOther'   Then Begin W := Messages.Strings[3]; K := clRed;  End Else Begin W := FieldType; K := clRed; End;

   Fields[FieldNumber].Canvas.Font.Style := [fsBold, fsItalic];
   Fields[FieldNumber].Canvas.Font.Color := K;
   Fields[FieldNumber].Canvas.TextOut(Rect.Left, Rect.Top, W);
end;

Procedure TFModuleCrossCombination.ResetSG;
// If there are object asocjaced with SG then delete them
Var _Col, _Row         : Integer;

Begin

  If SG.RowCount > 1 Then Begin
    LProgress.Caption := 'Czyszczenie siatki';
    LProgress.Refresh;
    PB.Max := SG.RowCount -1;
    For _Row := 1 To SG.RowCount -1 Do Begin
      PB.Position := _Row;
      PB.Refresh;
      For _Col := 1 To SG.ColCount -1 Do Begin
        SG.Cells[_Col, _Row] := '';
        If Assigned(SG.Objects[_Col,_Row]) Then Begin
          DoubleContainter         := TDoubleContainter(SG.Objects[_Col, _Row]);
          SG.Objects[_Col,_Row] := nil;
          DoubleContainter.Free;
        End;
      End;
    End;
    PB.Position := 0;
    LProgress.Caption := '';
  End;

  SG.RowCount := 1;
  SG.ColCount := 1;
End;

procedure TFModuleCrossCombination.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ResetSG;
end;

procedure TFModuleCrossCombination.BZoom1Click(Sender: TObject);
begin
  inherited;
 SG.DefaultRowHeight := SG.DefaultRowHeight + 2;
end;

procedure TFModuleCrossCombination.BZoom2Click(Sender: TObject);
begin
  inherited;
 SG.DefaultRowHeight := SG.DefaultRowHeight - 2;
end;

procedure TFModuleCrossCombination.BZoom3Click(Sender: TObject);
begin
  inherited;
 SG.DefaultColWidth := SG.DefaultColWidth + 2;
end;

procedure TFModuleCrossCombination.BZoom4Click(Sender: TObject);
begin
  inherited;
 SG.DefaultColWidth := SG.DefaultColWidth - 2;
end;

procedure TFModuleCrossCombination.BFontClick(Sender: TObject);
begin
  inherited;
 FontDialog.Font := SG.Font;
 If FontDialog.Execute Then SG.Font := FontDialog.Font;
end;

procedure TFModuleCrossCombination.BCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

Procedure TFModuleCrossCombination.RefreshChart;
Var PieSeries        : TPieSeries;
    _Col, _Row       : Integer;
Begin
  If Not ((BChart1.Down Or BChart2.Down)) Then Exit;
  PieSeries := TPieSeries.Create(Application);
  PieSeries.Clear;


  Chart.Title.Text.Clear;
  //Chart.Title.Text.Add('Tytu³');

  If BChart2.Down Then Begin
   _Row := SG.Row;
   For _Col := 1 To SG.ColCount -1 Do
     If Assigned(SG.Objects[_Col,_Row]) Then Begin
       DoubleContainter := TDoubleContainter(SG.Objects[_Col,_Row]);
       PieSeries.Add(DoubleContainter.Value , SG.Cells[_Col,0], clYellow);
     End;
  End
  Else Begin
   _Col := SG.Col;
   For _Row := 1 To SG.RowCount -1 Do
     If Assigned(SG.Objects[_Col,_Row]) Then Begin
       DoubleContainter := TDoubleContainter(SG.Objects[_Col,_Row]);
       PieSeries.Add(DoubleContainter.Value , SG.Cells[0,_Row], clYellow);
     End;
  End;

  If Assigned(Chart.Series[0].DataSource) Then Chart.Series[0].DataSource.Free;
  Chart.Series[0].DataSource := PieSeries;

  Chart.Refresh;
End;

procedure TFModuleCrossCombination.BChart1Click(Sender: TObject);
begin
  inherited;
 //Chart.Visible := (BChart1.Down Or BChart2.Down);
 RefreshChart;
end;

procedure TFModuleCrossCombination.TimerTimer(Sender: TObject);
begin
  inherited;
  If Not Self.Active Then Exit;
  If TimerCounter > 0 Then TimerCounter := TimerCounter - 1;
  If TimerCounter = 1 Then Begin
   RefreshChart;
   Sort;
  End;
end;

procedure TFModuleCrossCombination.SGSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  TimerCounter := 4;
end;

procedure TFModuleCrossCombination.FormShow(Sender: TObject);
begin
  inherited;
  TimerCounter  := 0;
  BChart1Click(NIL);
  DisableRowsClick(nil);
  DisableColsClick(nil);
  CanRefresh := True;
  If FileExists(FileName) Then LoadFromFile(FileName);
end;

{Procedure TFModuleCrossCombination.SwapRows(i, j : Integer);
Begin
  //Zamiana dwóch wierszy miejscami - inne sposoby nie skutkowa³y
  //SG.RowCount := SG.RowCount + 1;
  //SG.Rows[SG.RowCount] := SG.Rows[I];
  //SG.Rows[I] := SG.Rows[J];
  //SG.Rows[J] := SG.Rows[SG.RowCount];
  //SG.RowCount := SG.RowCount - 1;


  SG2.Rows[1]:= SG.Rows[I];
  SG.Rows[I] := SG.Rows[J];
  SG.Rows[J] := SG2.Rows[1];

End;
Procedure TFModuleCrossCombination.SwapCols(i, j : Integer);
Begin
  //SG.ColCount := SG.ColCount + 1;
  //SG.Cols[SG.ColCount] := SG.Cols[I];
  //SG.Cols[I] := SG.Cols[J];
  //SG.Cols[J] := SG.Cols[SG.ColCount];
  //SG.ColCount := SG.ColCount - 1;

  SG2.Cols[1] := SG.Cols[I];
  SG.Cols[I] := SG.Cols[J];
  SG.Cols[J] := SG2.Cols[1];
End;
 }

 Function Sgn (X : Extended) : Integer;
 Begin
  If X > 0 Then Result := 1 Else
  If X = 0 Then Result := 0 Else
                Result := -1;
 End;

Function SortStrAsc(Item1, Item2: Pointer): Integer;    Begin Result := AnsiCompareStr( TSortedObject(Item1).Str, TSortedObject(Item2).Str )  End;
Function SortStrDesc(Item1, Item2: Pointer): Integer;   Begin Result := -AnsiCompareStr( TSortedObject(Item1).Str, TSortedObject(Item2).Str ) End;
Function SortFloatAsc(Item1, Item2: Pointer): Integer;  Begin Result := Sgn(TSortedObject(Item1).Dbl - TSortedObject(Item2).Dbl);           End;
Function SortFloatDesc(Item1, Item2: Pointer): Integer; Begin Result := Sgn(-TSortedObject(Item1).Dbl + TSortedObject(Item2).Dbl); End;

Procedure SetPB(v : Integer);
Begin
 With FModuleCrossCombination Do Begin
  If (v mod 10) = 0 Then Begin PB.Position := v; PB.Refresh; End;
 End;
End;

procedure TFModuleCrossCombination.SortRows(Col : Integer; P : TListSortCompare; Kind : Integer);
Var List         : TList;
    SortedObject : TSortedObject;
    t            : Integer;
begin
  inherited;
  //Prevent from multiple calling
  If Kind in [3,4] Then Begin
    If VLastSortType = IntToStr(Kind) Then Exit;
    VLastSortType := IntToStr(Kind);
  End Else Begin
    If VLastSortType = IntToStr(Col) + ';' + IntToStr(Kind) Then Exit;
    VLastSortType := IntToStr(Col) + ';' + IntToStr(Kind);
  End;

  //Prepare data
  List := TList.Create;
  For t := 1 To SG.RowCount-1 Do Begin
   SortedObject     := TSortedObject.Create;
   SortedObject.Str := SG.Cells[Col,t];
   If Assigned(SG.Objects[Col,t]) Then SortedObject.Dbl := TDoubleContainter(SG.Objects[Col,t]).Value
                                  Else SortedObject.Dbl := 0;
   SortedObject.Num := t;
   List.Add(SortedObject);
  End;
   List.Sort(p);

  //Refresh SG
  LProgress.Caption := 'Odœwie¿anie siatki';
  LProgress.Refresh;
  //SG2.RowCount := SG.RowCount;
  PB.Max := SG.RowCount-1;
  For t := 1 To SG.RowCount-1 Do Begin SG2.Rows[t] := SG.Rows[TSortedObject(List.Items[t-1]).Num]; SetPB(t); End;
  For t := 1 To SG.RowCount-1 Do Begin SG.Rows[t] := SG2.Rows[t]; SetPB(t); End;
  LProgress.Caption := '';
  LProgress.Refresh;
  //SG2.RowCount := 0;

  //Release objects
  For t := 0 To List.Count - 1 Do TSortedObject(List.Items[t]).Free;
  List.Free;
  RefreshChart;
end;

procedure TFModuleCrossCombination.SortCols(Row : Integer; P : TListSortCompare; Kind : Integer);
Var List         : TList;
    SortedObject : TSortedObject;
    t            : Integer;

begin
  inherited;
  //Prevent from multiple calling
  If Kind in [3,4] Then Begin
    If HLastSortType = IntToStr(Kind) Then Exit;
    HLastSortType := IntToStr(Kind);
  End Else Begin
    If HLastSortType = IntToStr(Row) + ';' + IntToStr(Kind) Then Exit;
    HLastSortType := IntToStr(Row) + ';' + IntToStr(Kind);
  End;

  //Prepare data
  List := TList.Create;
  For t := 1 To SG.ColCount-1 Do Begin
   SortedObject     := TSortedObject.Create;
   SortedObject.Str := SG.Cells[t, Row];
   If Assigned(SG.Objects[t, Row]) Then SortedObject.Dbl := TDoubleContainter(SG.Objects[t, Row]).Value
                                   Else SortedObject.Dbl := 0;
   SortedObject.Num := t;
   List.Add(SortedObject);
  End;
   List.Sort(p);

  //Refresh SG
  LProgress.Caption := 'Odœwie¿anie siatki';
  LProgress.Refresh;
  //SG2.ColCount := SG.ColCount;
  PB.Max := SG.ColCount-1;
  For t := 1 To SG.ColCount-1 Do Begin SG2.Cols[t] := SG.Cols[TSortedObject(List.Items[t-1]).Num]; SetPB(t); End;
  For t := 1 To SG.ColCount-1 Do Begin SG.Cols[t] := SG2.Cols[t]; SetPB(t); End;
  LProgress.Caption := '';
  LProgress.Refresh;
  //SG2.ColCount := 0;

  //Release objects
  For t := 0 To List.Count - 1 Do TSortedObject(List.Items[t]).Free;
  List.Free;
  RefreshChart;
end;

procedure TFModuleCrossCombination.BSort1Click(Sender: TObject);
begin
 Sort;
end;


procedure TFModuleCrossCombination.BRefreshClick(Sender: TObject);
Function GetCol(ColValue : String) : Integer;
Var t     : Integer;
    found : Boolean;
Begin
 Found := False;
 For t := 1 To SG.ColCount -1 Do Begin
  If SG.Cells[t,0] = ColValue Then Begin
   found := True;
   Break;
  End;
 End;
 If found Then Result := t Else Begin
  SG.ColCount := SG.ColCount + 1;
  SG.Cells[SG.ColCount-1,0] := ColValue;
  Result := SG.ColCount-1;
 End;
End;

Function GetRow(RowValue : String) : Integer;
Var t     : Integer;
    found : Boolean;
Begin
 Found := False;
 For t := 1 To SG.RowCount -1 Do Begin
  If SG.Cells[0,t] = RowValue Then Begin
   found := True;
   Break;
  End;
 End;
 If found Then Result := t Else Begin
  SG.RowCount := SG.RowCount + 1;
  SG.Cells[0,SG.RowCount-1] := RowValue;
  Result := SG.RowCount-1;
 End;
End;

Var RowValue, ColValue : String;
    MiddleValue        : Double;
    _Col, _Row         : Integer;

Const Masks : Array[0..5] Of String = ('###,###,###,##0.00',
                                       '###########0.00',
                                       '###,###,###,##0.00;(###,###,###,##0.00)',
                                       '###########0.00;(###########0.00)',
                                       '0.000E+00',
                                       '000,000,000,000.00');
begin
  inherited;
  If Not CanRefresh Then Exit;
  With CheckValid Do Begin
    Init(Self);
    If (Fields[1].ItemIndex = -1) And (Not DisableRows.Checked) Then addError('WprowadŸ "W wierszach umieszczaj"');
    If (Fields[2].ItemIndex = -1) And (Not DisableCols.Checked)  Then addError('WprowadŸ "W kolumnach umieszczaj"');
    If Fields[3].ItemIndex = -1 Then addError('WprowadŸ "Na przeciêciu umieszczaj"');
    If Not ShowMessage Then Exit;
  End;

  If Not DisableRows.Checked Then RowColumn    := GetFieldName(Columns[Fields[1].ItemIndex]);
  If Not DisableCols.Checked Then ColColumn    := GetFieldName(Columns[Fields[2].ItemIndex]);
  MiddleColumn := GetFieldName(Columns[Fields[3].ItemIndex]);

  ResetSG;

  Query.DisableControls;
  Query.First;
  While Not Query.EOF Do Begin
   If DisableRows.Checked Then RowValue := 'Wy³¹czone' Else RowValue    := NVL(Query.FieldByName(RowColumn).AsString,'-');
   If DisableCols.Checked Then ColValue := 'Wy³¹czone' Else ColValue    := NVL(Query.FieldByName(ColColumn).AsString,'-');
   Try MiddleValue := Query.FieldByName(MiddleColumn).AsFloat; Except MiddleValue := 0; End;

   _Col := GetCol(ColValue);
   _Row := GetRow(RowValue);

   If Assigned(SG.Objects[_Col,_Row]) Then Begin
     DoubleContainter         := TDoubleContainter(SG.Objects[_Col,_Row]);
     DoubleContainter.Counter := DoubleContainter.Counter + 1;
     Case AggregateFunction.ItemIndex Of
      0: {counter} DoubleContainter.D   := 0; {has no meaning}
      1: {sum}     DoubleContainter.D   := DoubleContainter.D + MiddleValue;
      2: {max}     DoubleContainter.D   := MaxFloat([DoubleContainter.D , MiddleValue ]);
      3: {min}     DoubleContainter.D   := MinFloat([DoubleContainter.D , MiddleValue ]);
      4: {avg}     DoubleContainter.D   := DoubleContainter.D + MiddleValue;
     End;
   End Else Begin
     DoubleContainter            := TDoubleContainter.Create;
     DoubleContainter.Counter    := 1;
     DoubleContainter.D          := MiddleValue;
     SG.Rows[_Row].Objects[_Col] := DoubleContainter;
   End;

   Case AggregateFunction.ItemIndex Of
    0: {counter} DoubleContainter.Value := DoubleContainter.Counter;
    1: {sum}     DoubleContainter.Value := DoubleContainter.D;
    2: {max}     DoubleContainter.Value := DoubleContainter.D;
    3: {min}     DoubleContainter.Value := DoubleContainter.D;
    4: {avg}     DoubleContainter.Value := DoubleContainter.D / DoubleContainter.Counter;
   End;

   SG.Cells[_Col, _Row] := FormatFloat(Masks[MaskFormat.ItemIndex],DoubleContainter.Value);

  Query.Next;
  End;
  Query.EnableControls;
  If SG.RowCount > 0 Then SG.FixedRows := 1;
  If SG.ColCount > 0 Then SG.FixedCols := 1;
  HLastSortType := '-';
  VLastSortType := '-';
  Sort;
end;

procedure TFModuleCrossCombination.ComboMiddleColumnChange(
  Sender: TObject);
begin
  inherited;
  If Fields[(Sender As TComboBox).Tag].ItemIndex = -1 Then Exit;
  If (GetFieldType(Columns[Fields[(Sender As TComboBox).Tag].ItemIndex]) <> 'ftInteger') And
     (GetFieldType(Columns[Fields[(Sender As TComboBox).Tag].ItemIndex]) <> 'ftFloat') Then Begin
   SError('W tej wersji modu³u na przeciêciu mo¿e byæ tylko pole typu liczbowego');
   (Sender As TComboBox).ItemIndex := -1;
  End;
  ComboRowColumnChange(sender);
end;

procedure TFModuleCrossCombination.ComboRowColumnChange(Sender: TObject);
begin
  inherited;
  If Assigned(Sender) Then
  If Fields[(Sender As TComboBox).Tag].ItemIndex <> -1 Then
  If (GetFieldType(Columns[Fields[(Sender As TComboBox).Tag].ItemIndex]) = 'ftOther') Then Begin
   SError('W tej wersji modu³u ten typ pola nie jest obs³ugiwany');
   (Sender As TComboBox).ItemIndex := -1;
  End;

  If AutoRefresh.Checked Then
   If ((Fields[1].ItemIndex <> -1) Or (DisableRows.Checked)) And
      ((Fields[2].ItemIndex <> -1) Or (DisableCols.Checked)) And
      (Fields[3].ItemIndex <> -1) Then BRefreshClick(nil);
end;

procedure TFModuleCrossCombination.ComboColColumnChange(Sender: TObject);
begin
  inherited;
  ComboRowColumnChange(sender);
End;


procedure TFModuleCrossCombination.AggregateFunctionChange(
  Sender: TObject);
begin
  inherited;
  ComboRowColumnChange(nil);
end;

procedure TFModuleCrossCombination.MaskFormatChange(Sender: TObject);
begin
  inherited;
  ComboRowColumnChange(nil);
end;

Procedure TFModuleCrossCombination.Sort;
Begin
 If BSort1.Down Then SortRows(SG.Col,SortFloatAsc,1);
 If BSort2.Down Then SortRows(SG.Col,SortFloatDesc,2);
 If BSort5.Down Then SortRows(0,SortStrAsc,3);
 If BSort6.Down Then SortRows(0,SortStrDesc,4);

 If BSort3.Down Then SortCols(SG.Row,SortFloatAsc,1);
 If BSort4.Down Then SortCols(SG.Row,SortFloatDesc,2);
 If BSort7.Down Then SortCols(0,SortStrAsc,3);
 If BSort8.Down Then SortCols(0,SortStrDesc,4);
End;

procedure TFModuleCrossCombination.DisableRowsClick(Sender: TObject);
begin
  inherited;
  ComboRowColumn.Visible := Not DisableRows.Checked;
  ComboRowColumnChange(nil);
end;

procedure TFModuleCrossCombination.DisableColsClick(Sender: TObject);
begin
  inherited;
  ComboColColumn.Visible := Not DisableCols.Checked;
  ComboRowColumnChange(nil);
end;

procedure TFModuleCrossCombination.FormCreate(Sender: TObject);
begin
  CanRefresh := False;
  inherited;
end;

procedure TFModuleCrossCombination.BSaveClick(Sender: TObject);
begin
 If SD.Execute Then SaveToFile(SD.FileName);
end;

procedure TFModuleCrossCombination.BloadClick(Sender: TObject);
begin
 If OD.Execute Then LoadFromFile(OD.FileName);
end;

Procedure TFModuleCrossCombination.SaveToFile(FileName : ShortString);
Var TFile : TextFile;
    TempFilterSettings : TStrings;
Const BoolToChar : Array[False..True] Of ShortString = ('False', 'True');
begin
  inherited;
  If Not BSave.Enabled Then Exit;
  TempFilterSettings := TStringList.Create;
  //13
  TempFilterSettings.Values['ComboRowColumn.ItemIndex']    := IntToStr(ComboRowColumn.ItemIndex);
  TempFilterSettings.Values['ComboColColumn.ItemIndex']    := IntToStr(ComboColColumn.ItemIndex);
  TempFilterSettings.Values['ComboMiddleColumn.ItemIndex'] := IntToStr(ComboMiddleColumn.ItemIndex);
  TempFilterSettings.Values['ComboMiddleColumn.ItemIndex'] := IntToStr(ComboMiddleColumn.ItemIndex);
  TempFilterSettings.Values['AggregateFunction.ItemIndex'] := IntToStr(AggregateFunction.ItemIndex);
  TempFilterSettings.Values['MaskFormat.ItemIndex']        := IntToStr(MaskFormat.ItemIndex);
  TempFilterSettings.Values['DisableRows.Checked']         := BoolToChar[DisableRows.Checked];
  TempFilterSettings.Values['DisableCols.Checked']         := BoolToChar[DisableCols.Checked];
  TempFilterSettings.Values['AutoRefresh.Checked']         := BoolToChar[AutoRefresh.Checked];
  TempFilterSettings.Values['BChart1.Down']                := BoolToChar[BChart1.Down];
  TempFilterSettings.Values['BChart2.Down']                := BoolToChar[BChart2.Down];
  TempFilterSettings.Values['BSort1.Down']                 := BoolToChar[BSort1.Down];
  TempFilterSettings.Values['BSort2.Down']                 := BoolToChar[BSort2.Down];
  TempFilterSettings.Values['BSort5.Down']                 := BoolToChar[BSort5.Down];
  TempFilterSettings.Values['BSort6.Down']                 := BoolToChar[BSort6.Down];
  TempFilterSettings.Values['BSort3.Down']                 := BoolToChar[BSort3.Down];
  TempFilterSettings.Values['BSort4.Down']                 := BoolToChar[BSort4.Down];
  TempFilterSettings.Values['BSort7.Down']                 := BoolToChar[BSort7.Down];
  TempFilterSettings.Values['BSort8.Down']                 := BoolToChar[BSort8.Down];
  TempFilterSettings.Values['BSave.Enabled']               := BoolToChar[BSave.Enabled]; //for standard combinations set to False to prevent window from changes settings

  AssignFile(TFile, FileName);
  ReWrite(TFile);
  WriteLn(TFile, Columns.CommaText);
  WriteLn(TFile, TempFilterSettings.CommaText);
  TempFilterSettings.Free;
  CloseFile(TFile);
end;

Procedure TFModuleCrossCombination.LoadFromFile(FileName : ShortString);
Var TFile : TextFile;
    S     : String;
    TempFilterSettings : TStrings;

begin
  inherited;

  AssignFile(TFile, FileName);
  Reset(TFile);
  ReadLn(TFile, S);
  If Columns.CommaText <> S Then Begin
   Info(Messages.Strings[5]);
   CloseFile(TFile);
   Exit;
  End;
  ReadLn(TFile, S);
  CloseFile(TFile);

  TempFilterSettings := TStringList.Create;
  TempFilterSettings.CommaText := S;

  CanRefresh := False;
  ComboRowColumn.ItemIndex    := StrToInt(TempFilterSettings.Values['ComboRowColumn.ItemIndex']);
  ComboColColumn.ItemIndex    := StrToInt(TempFilterSettings.Values['ComboColColumn.ItemIndex']);
  ComboMiddleColumn.ItemIndex := StrToInt(TempFilterSettings.Values['ComboMiddleColumn.ItemIndex']);
  ComboMiddleColumn.ItemIndex := StrToInt(TempFilterSettings.Values['ComboMiddleColumn.ItemIndex']);
  AggregateFunction.ItemIndex := StrToInt(TempFilterSettings.Values['AggregateFunction.ItemIndex']);
  MaskFormat.ItemIndex        := StrToInt(TempFilterSettings.Values['MaskFormat.ItemIndex']);
  DisableRows.Checked         := TempFilterSettings.Values['DisableRows.Checked'] = 'True';
  DisableCols.Checked         := TempFilterSettings.Values['DisableCols.Checked'] = 'True';
  BChart1.Down                := TempFilterSettings.Values['BChart1.Down'] = 'True';
  BChart2.Down                := TempFilterSettings.Values['BChart2.Down'] = 'True';
  BSort1.Down                 := TempFilterSettings.Values['BSort1.Down'] = 'True';
  BSort2.Down                 := TempFilterSettings.Values['BSort2.Down'] = 'True';
  BSort5.Down                 := TempFilterSettings.Values['BSort5.Down'] = 'True';
  BSort6.Down                 := TempFilterSettings.Values['BSort6.Down'] = 'True';
  BSort3.Down                 := TempFilterSettings.Values['BSort3.Down'] = 'True';
  BSort4.Down                 := TempFilterSettings.Values['BSort4.Down'] = 'True';
  BSort7.Down                 := TempFilterSettings.Values['BSort7.Down'] = 'True';
  BSort8.Down                 := TempFilterSettings.Values['BSort8.Down'] = 'True';
  AutoRefresh.Checked         := TempFilterSettings.Values['AutoRefresh.Checked'] = 'True';
  BSave.Enabled               := TempFilterSettings.Values['BSave.Enabled'] = 'True';



  TempFilterSettings.Free;
  CanRefresh := True;
  If AutoRefresh.Checked Then
   If ((Fields[1].ItemIndex <> -1) Or (DisableRows.Checked)) And
      ((Fields[2].ItemIndex <> -1) Or (DisableCols.Checked)) And
      (Fields[3].ItemIndex <> -1) Then BRefreshClick(nil);
end;

procedure TFModuleCrossCombination.BEksportClick(Sender: TObject);
Var TFile : TextFile;
    t     : Integer;
begin
  inherited;
 If SD2.Execute Then Begin
  AssignFile(TFile, SD2.FileName);
  ReWrite(TFile);
  For t := 0 To SG.RowCount -1 Do Begin
   WriteLn(TFile, SG.Rows[t].CommaText);
  End;
  CloseFile(TFile);
 End;
 Info('Plik zosta³ utworzony');
end;

procedure TFModuleCrossCombination.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
   If Key = 27 Then BCloseClick(nil);
end;

procedure TFModuleCrossCombination.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  if PrintDialog.Execute then Chart.Print;
  //Chart.PrintRect(Rect(0,0,Printer.PageWidth-1,Printer.PageHeight-1));
  //Chart.Print;
end;

procedure TFModuleCrossCombination.SpeedButton2Click(Sender: TObject);
begin
  inherited;
 SaveDialog1.DefaultExt:='bmp';
 SaveDialog1.Filter:='Plik BMP (*.BMP) |*.bmp|Plik WMF (*.WMF) |*.wmf|Plik EMF (*.emf) |*.emf';
 if SaveDialog1.Execute then
  begin
   try Chart.SaveToBitmapFile(SaveDialog1.FileName); except end;
  end;
end;

end.


