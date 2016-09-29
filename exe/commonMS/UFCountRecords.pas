unit UFCountRecords;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DBTables, Db, DBLists;

type
  TFCountRecords = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MTables: TMemo;
    MResults: TMemo;
    Query: TQuery;
    Label1: TLabel;
    AdditionalCondition: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCountRecords: TFCountRecords;

Procedure ShowModal(aDatabaseName : String; Tables : TStrings);

implementation

{$R *.DFM}

Procedure ShowModal(aDatabaseName : String; Tables : TStrings);
Begin
 Application.CreateForm(TFCountRecords, FCountRecords);
 FCountRecords.Query.DatabaseName      := aDatabaseName;
 FCountRecords.MTables.Lines.Assign(Tables);
 FCountRecords.ShowModal;
 FCountRecords.Free;
End;

procedure TFCountRecords.BitBtn1Click(Sender: TObject);
Var t : Integer;
    TableName : ShortString;
begin
 MResults.Clear;

 For T := 0 To MTables.Lines.Count - 1 Do Begin
   TableName := MTables.Lines.Strings[t];
   Query.SQL.Clear;
   Query.SQL.Add('Select count(*) from '+TableName);

   If Trim(AdditionalCondition.Text) <> '' Then  Query.SQL.Add('WHERE '+AdditionalCondition.Text);

   Panel1.Caption := TableName;
   Panel1.Refresh;
  Try
   Query.Open;
   MResults.Lines.Add(TableName+#9+Query.Fields[0].AsString);
  Except
   MResults.Lines.Add(TableName+#9+'unkown');
  End;
 End;
  Panel1.Caption := '';
  Panel1.Refresh;
end;

procedure TFCountRecords.BitBtn2Click(Sender: TObject);
begin
 Close;
end;

end.
