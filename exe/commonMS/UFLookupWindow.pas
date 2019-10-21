unit UFLookupWindow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, Db, DBTables, UUtilityParent,ADODB;

type
  TFLookupWindow = class(TFormConfig)
    Panel: TPanel;
    BOK: TBitBtn;
    BCANCEL: TBitBtn;
    DBGrid: TDBGrid;
    TopPanel: TPanel;
    BFILTER: TEdit;
    DataSource: TDataSource;
    BClear: TBitBtn;
    SearchTimer: TTimer;
    BAdvanced: TBitBtn;
    ADOQuery: TADOQuery;
    procedure BRefreshClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure BCANCELClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BClearClick(Sender: TObject);
    procedure SearchTimerTimer(Sender: TObject);
    procedure BFILTERChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BAdvancedClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BFILTERExit(Sender: TObject);
    procedure BFILTERKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    TableName, KeyField, DisplayFields, DisplayCaption, FindField, WhereClause, DefaultMask, ColumnWidths : String;
    MR : TModalResult;
    SearchCounter   : Integer;
    ADOConnection : TADOConnection;
  public
    { Public declarations }
  end;

var
  FLookupWindow: TFLookupWindow;

Function LookupWindow(mulitSelectFlag: boolean; aADOConnection : TADOConnection; aTableName, aKeyField, aDisplayFields, aDisplayCaption, aFindField, aWhereClause, aDefaultMask : String; Var KeyValue : ShortString; aColumnWidths : shortString = '') : TModalResult;

implementation

uses DM;

{$R *.DFM}

Function LookupWindow(mulitSelectFlag: boolean; aADOConnection : TADOConnection; aTableName, aKeyField, aDisplayFields, aDisplayCaption, aFindField, aWhereClause, aDefaultMask : String; Var KeyValue : ShortString; aColumnWidths : shortString = '') : TModalResult;
var t : integer;
Begin
 Application.CreateForm(TFLookupWindow, FLookupWindow);
 With FLookupWindow Do Begin
 ADOConnection := aADOConnection;
 TableName:=aTableName;
 KeyField :=aKeyField ;
 DisplayFields:=aDisplayFields;
 DisplayCaption:=aDisplayCaption;
 FindField:=aFindField;
 DefaultMask:=aDefaultMask;
 ColumnWidths:=aColumnWidths;
 WhereClause := aWhereClause;
  IF KeyField    = '' Then KeyField := 'ID';
  IF FindField   = '' Then FindField := DisplayFields;
  iF WhereClause = '' Then WhereClause := '0=0';
  MR := mrCancel;
  BFILTER.Text := DefaultMask;

  if mulitSelectFlag then begin
    DBGrid.Options := DBGrid.Options + [dgMultiSelect];
    DBGrid.Options := DBGrid.Options + [dgIndicator];
  end else begin
    DBGrid.Options := DBGrid.Options - [dgMultiSelect];
    DBGrid.Options := DBGrid.Options - [dgIndicator];
  end;

  ShowModal;
  Result := MR;

  if DBGrid.SelectedRows.Count = 0
    then KeyValue := ADOQuery.Fields[0].AsString;

  For t := 0 To DBGrid.SelectedRows.Count - 1 Do Begin
    ADOQuery.Bookmark := DBGrid.SelectedRows.Items[t];
     If KeyValue <> '' Then KeyValue :=  KeyValue + ',';
     KeyValue := KeyValue + ADOQuery.Fields[0].AsString;
  End;

  Free;
 End;
End;

procedure TFLookupWindow.BRefreshClick(Sender: TObject);
  Function Percent (S : String ) : String;
  Begin
   Result := S;
   Result := '%'+S+'%';
  End;

Var aFN, aF   : String;
    FieldList : String;
    DBType    : string;
    t         : integer;
begin
  inherited;
  ADOQuery.Connection := ADOConnection;
  If true Then Begin
   aFN := 'UPPER('+FindField+')';
   aF  := 'UPPER('''+Percent(BFILTER.Text)+''')';
  End Else Begin
   aFN := FindField;
   aF  := ''''+Percent(BFILTER.Text)+'''';
  End;

  ADOQuery.SQL.Clear;

  {If Pos(KeyField,DisplayFields) <> 0 Then
   FieldList := DisplayFields
  Else}
   FieldList :=  KeyField+','+DisplayFields;

  DBType := ADOConnection.Provider;

  If copy(DBType,1,8) = 'OraOLEDB' Then ADOQuery.SQL.Add('SELECT '+FieldList+' FROM '+TableName+' WHERE '+aFN+' LIKE '+aF+' AND '+WhereClause+' AND ROWNUM < 5000 ORDER BY '+FindField) ELSE
  If ADOConnection.Provider = 'Access' Then ADOQuery.SQL.Add('SELECT TOP 5000 '+KeyField+','+DisplayFields+' FROM '+TableName+' WHERE '+aFN+' LIKE '+aF+' AND '+WhereClause+' ORDER BY '+FindField) ELSE
  SError('This module suportes only OraOLEDB, Access. This database is:'+DBType);

  ADOQuery.Close;
  Try
  ADOQuery.Open;
  Except
   SError('Error :'+ADOQuery.SQL.Text);
   UUtilityParent.CopyToClipBoard(ADOQuery.SQL.Text);
   Raise;
  End;
  DBGrid.Columns[0].Width := 0;

  for t := 1 to wordCount(DisplayCaption, [',']) do begin
    dbGrid.Columns[t].Width   := strToInt ( nvl( extractWord(t, ColumnWidths, [',']), '500') );
    dbGrid.Columns[t].title.Caption   := extractWord(t, DisplayCaption, [',']);
  end;
  Caption := DisplayCaption;
end;

procedure TFLookupWindow.BOKClick(Sender: TObject);
begin
  MR := mrOK;
  Close;
end;

procedure TFLookupWindow.BCANCELClick(Sender: TObject);
begin
  MR := mrCancel;
  Close;
end;

procedure TFLookupWindow.DBGridDblClick(Sender: TObject);
begin
 BOKClick(nil);
end;

procedure TFLookupWindow.DBGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = 13 Then Begin
    BOKClick(nil);
  End;
end;

procedure TFLookupWindow.BClearClick(Sender: TObject);
begin
  BFilter.Text := '';
  BRefreshClick(nil);
end;

procedure TFLookupWindow.SearchTimerTimer(Sender: TObject);
begin
  If SearchCounter > 0 Then SearchCounter := SearchCounter - 1;
  If SearchCounter = 1 Then BRefreshClick(nil);
end;

procedure TFLookupWindow.BFILTERChange(Sender: TObject);
begin
  inherited;
   SearchCounter := 3;
end;

procedure TFLookupWindow.FormCreate(Sender: TObject);
begin
  inherited;
  SearchCounter := 0;
end;

procedure TFLookupWindow.FormShow(Sender: TObject);
begin
  inherited;
  SearchCounter := 0;
  BRefreshClick(nil);
end;

procedure TFLookupWindow.BAdvancedClick(Sender: TObject);
begin
  inherited;
  Info(ADOQuery.SQL.Text);
  copyToClipboard(ADOQuery.SQL.Text);
end;

procedure TFLookupWindow.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
 if (MR = mrOK) and (isBlank(ADOQuery.Fields[0].AsString)) then CanClose := False;
end;

procedure TFLookupWindow.BFILTERExit(Sender: TObject);
begin
  inherited;
ActiveControl := DBGrid;
end;

procedure TFLookupWindow.BFILTERKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = 40 Then ActiveControl := DBGrid;
end;

end.
