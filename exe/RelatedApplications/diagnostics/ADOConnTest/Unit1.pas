unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB;

type
  TFMain = class(TForm)
    BitBtn1: TBitBtn;
    ADOConnection: TADOConnection;
    p: TEdit;
    ADOQuery: TADOQuery;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

Procedure SError(S : String);
Var H : String;
Begin
 S := S + Char(0);
 H := 'Info';
 MessageBox(0, @S[1], @H[1], MB_OK  + MB_TASKMODAL);
End;

procedure TFMain.BitBtn1Click(Sender: TObject);
begin
   ADOConnection.ConnectionString := p.Text;
                                            //Provider=OraOLEDB.Oracle.1;Password=4154;Persist Security Info=True;User ID=planner;Data Source=planner.wat.edu.pl:1522/planner
   //Try
     ADOConnection.Attributes :=  ADOConnection.Attributes + [xaCommitRetaining];
     ADOConnection.Attributes :=  ADOConnection.Attributes + [xaAbortRetaining];
     ADOConnection.Open;
     ADOConnection.BeginTrans;
     SError('Connection OK!');
     ADOQuery.Connection := ADOConnection;
     ADOQuery.SQL.Clear;
     ADOQuery.SQL.Add('select sysdate from dual');
     ADOQuery.Open;
     SError('Sysdate:' + ADOQuery.Fields[0].AsString);
     ADOConnection.CommitTrans;
     ADOConnection.Attributes :=  ADOConnection.Attributes - [xaCommitRetaining];
     ADOConnection.Attributes :=  ADOConnection.Attributes - [xaAbortRetaining];
     ADOConnection.CommitTrans;
     ADOConnection.close;
     SError('Connection Closed');
   //Except
   // on E:EDatabaseError do SError('Nie powiod³o siê zalogowanie z bazy z powodu nastêpuj¹cego b³êdu:'+E.Message);
   // on E:exception      do SError('Nie powiod³o siê zalogowanie z bazy z powodu nastêpuj¹cego b³êdu:'+E.Message);
   //End;

end;

end.
