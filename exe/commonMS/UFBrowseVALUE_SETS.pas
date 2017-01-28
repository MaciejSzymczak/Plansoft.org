unit UFBrowseVALUE_SETS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, ExtCtrls, StrHlder, Menus, DB, DBTables,
  RxQuery, ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, ToolEdit,
  DBCtrls, Mask, ADODB, ImgList, OleServer, ExcelXP;

type
  TFBrowseVALUE_SETS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    DESCRIPTION: TDBMemo;
    LabelDESCRIPTION: TLabel;
    SET_TYPE: TDBEdit;
    LabelSET_TYPE: TLabel;
    SQL_STATEMENT: TDBMemo;
    LabelSQL_STATEMENT: TLabel;
    CHECK_PROCEDURE: TDBEdit;
    LabelCHECK_PROCEDURE: TLabel;
    MIN_LENGTH: TDBEdit;
    LabelMIN_LENGTH: TLabel;
    MAX_LENGTH: TDBEdit;
    WHO_CREATION_DATE: TDBDateEdit;
    LabelWHO_CREATION_DATE: TLabel;
    WHO_LAST_UPDATE_DATE: TDBDateEdit;
    LabelWHO_LAST_UPDATE_DATE: TLabel;
    WHO_CREATED_BY: TDBEdit;
    LabelWHO_CREATED_BY: TLabel;
    WHO_LAST_UPDATED_BY: TDBEdit;
    LabelWHO_LAST_UPDATED_BY: TLabel;
    WHO_LAST_UPDATE_LOGIN: TDBEdit;
    LabelWHO_LAST_UPDATE_LOGIN: TLabel;
    BCHAR: TBitBtn;
    BNUMBER: TBitBtn;
    BDATE: TBitBtn;
    BLOOKUP: TBitBtn;
    BSQL: TBitBtn;
    SQL_STATEMENT_INFO: TMemo;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    BcheckSyntax: TBitBtn;
    DSDetails: TDataSource;
    TimerDetails: TTimer;
    PanelDetailsBackground: TPanel;
    PanelDetails: TPanel;
    GridDetails: TRxDBGrid;
    Splitter1: TSplitter;
    QueryDetails: TADOQuery;
    procedure BCHARClick(Sender: TObject);
    procedure BNUMBERClick(Sender: TObject);
    procedure BDATEClick(Sender: TObject);
    procedure BLOOKUPClick(Sender: TObject);
    procedure BSQLClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BPodrzedne1Click(Sender: TObject);
    procedure SET_TYPEChange(Sender: TObject);
    procedure BcheckSyntaxClick(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure TimerDetailsTimer(Sender: TObject);
    procedure GridDetailsDblClick(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure BeforeEdit;    override;
    function checkSQL : string;
  end;

var
  FBrowseVALUE_SETS: TFBrowseVALUE_SETS;

implementation

{$R *.dfm}

uses DM, UUtilityParent, AutoCreate;

Const Counter  : Integer = 3;

function TFBrowseVALUE_SETS.checkSQL : string;
begin
  try
   dmodule.singleValue(sql_statement.text);
   result := '';
  except
  on E:exception do result :=  'Polecenie SQL "'+sql_statement.text+ '" zawiera b³êdy.'+cr+' Komuniat o b³êdzie: ' + E.Message;
 End;
end;

Function  TFBrowseVALUE_SETS.CheckRecord : Boolean;
var alert : string;
Begin
  With UUtilityParent.CheckValid Do Begin
    Init(Self);
    RestrictEmpty([NAME]);

    if SET_TYPE.Text = 'SQL' then begin
      if trim(SQL_STATEMENT.Text) = '' then
        addError('WprowadŸ polecenie SQL')
      else begin
        alert := checkSQL;
        If not strIsEmpty (alert) Then addError(alert);
      end;
    end;

    Result := ShowMessage;
  End;

End;

Procedure TFBrowseVALUE_SETS.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('SELECT value_sets_seq.NEXTVAL FROM DUAL');
 //
 Query['WHO_CREATION_DATE']     := DModule.SingleValue('SELECT TRUNC(SYSDATE) FROM DUAL');
 Query['WHO_CREATED_BY']        := UutilityParent.CurrentUserName;
 Query['WHO_LAST_UPDATE_DATE']  := DModule.SingleValue('SELECT TRUNC(SYSDATE) FROM DUAL');
 Query['WHO_LAST_UPDATED_BY']   := UutilityParent.CurrentUserName;
 Query['WHO_LAST_UPDATE_LOGIN'] := DModule.SingleValue('select userenv(''sessionid'') from dual');
End;

procedure TFBrowseVALUE_SETS.BCHARClick(Sender: TObject);
begin
  inherited;
  Query['SET_TYPE'] := 'CHAR';
end;

procedure TFBrowseVALUE_SETS.BNUMBERClick(Sender: TObject);
begin
  inherited;
  Query['SET_TYPE'] := 'NUMBER';

end;

procedure TFBrowseVALUE_SETS.BDATEClick(Sender: TObject);
begin
  inherited;
  Query['SET_TYPE'] := 'DATE';

end;

procedure TFBrowseVALUE_SETS.BLOOKUPClick(Sender: TObject);
begin
  inherited;
  Query['SET_TYPE'] := 'LOOKUP';

end;

procedure TFBrowseVALUE_SETS.BSQLClick(Sender: TObject);
begin
  inherited;
  Query['SET_TYPE'] := 'SQL';

end;

procedure TFBrowseVALUE_SETS.BitBtn1Click(Sender: TObject);
begin
  inherited;
  Query['SET_TYPE'] := 'TIME';
end;

procedure TFBrowseVALUE_SETS.FormCreate(Sender: TObject);
begin
  inherited;
  SetNotUpdatable([NAME], [LabelNAME]);
end;

procedure TFBrowseVALUE_SETS.BeforeEdit;
begin
 inherited;
 Query['WHO_LAST_UPDATE_DATE']  := DModule.SingleValue('SELECT TRUNC(SYSDATE) FROM DUAL');
 Query['WHO_LAST_UPDATED_BY']   := UutilityParent.CurrentUserName;
 Query['WHO_LAST_UPDATE_LOGIN'] := DModule.SingleValue('select userenv(''sessionid'') from dual');
end;

procedure TFBrowseVALUE_SETS.BPodrzedne1Click(Sender: TObject);
begin
 if SET_TYPE.Text = 'LOOKUP' then
   AutoCreate.LOOKUPSShowModalAsBrowser(Query['ID'])
 else
   info ('Wartoœci mo¿na wprowadzaæ tylko dla zestawów wartoœci o typie LOOKUP( lista wartoœci )');
end;

procedure TFBrowseVALUE_SETS.SET_TYPEChange(Sender: TObject);
begin
  SQL_STATEMENT.visible := SET_TYPE.Text =  'SQL';
  BcheckSyntax.visible := SET_TYPE.Text =  'SQL';
  SQL_STATEMENT_INFO.visible := SET_TYPE.Text =  'SQL';
  LabelSQL_STATEMENT.visible := SET_TYPE.Text =  'SQL';
end;

procedure TFBrowseVALUE_SETS.BcheckSyntaxClick(Sender: TObject);
var alert : string;
begin
  alert := checkSQL;
  if strIsEmpty (alert ) then info ('Formu³a nie zawiera b³êdów')
                         else Serror( alert );
end;

procedure TFBrowseVALUE_SETS.QueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
   Counter := 3;
end;

procedure TFBrowseVALUE_SETS.TimerDetailsTimer(Sender: TObject);
Var ID : ShortString;
begin
  inherited;
  If Counter > 0 Then Counter := Counter - 1;
  If Counter = 1 Then Begin
      QueryDetails.Close;
      If Query.IsEmpty Then Begin
        QueryDetails.Parameters.paramByName('VALUE_SET_ID').value := 0;
        PanelDetails.Caption := '';
      End Else Begin
        ID := NVL(Query.FieldByName('ID').AsString,'-1');
        QueryDetails.Parameters.paramByName('VALUE_SET_ID').value := ID;
        PanelDetails.Caption := 'Wartoœci zestawu  '+Query.FieldByName('NAME').AsString;
      End;
      QueryDetails.Open;
  End;
end;

procedure TFBrowseVALUE_SETS.GridDetailsDblClick(Sender: TObject);
begin
  inherited;
 BPodrzedne1Click(nil);
end;

procedure TFBrowseVALUE_SETS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.LOOKUPSShowModalAsBrowser(Query['ID']);
end;

end.
