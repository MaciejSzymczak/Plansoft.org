unit UFCopyTimeTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFCopyTimeTable = class(TFormConfig)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn1: TBitBtn;
    ch1: TCheckBox;
    P1: TEdit;
    P1_VALUE: TEdit;
    BitBtnPER: TBitBtn;
    G1: TEdit;
    G1_VALUE: TEdit;
    BitBtnGRO: TBitBtn;
    Label6: TLabel;
    Label3: TLabel;
    P2: TEdit;
    P2_VALUE: TEdit;
    BitBtn2: TBitBtn;
    G2: TEdit;
    G2_VALUE: TEdit;
    BitBtn4: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure P1Change(Sender: TObject);
    procedure P2Change(Sender: TObject);
    procedure G1Change(Sender: TObject);
    procedure G2Change(Sender: TObject);
    procedure BitBtnPERClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtnGROClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCopyTimeTable: TFCopyTimeTable;

implementation

uses DM, AutoCreate, UUtilityParent;

{$R *.DFM}

procedure TFCopyTimeTable.P1Change(Sender: TObject);
begin
  inherited;
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
end;

procedure TFCopyTimeTable.P2Change(Sender: TObject);
begin
  inherited;
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
end;

procedure TFCopyTimeTable.G1Change(Sender: TObject);
begin
  inherited;
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME||''(''||abbreviation||'')''','GROUPS','');
end;

procedure TFCopyTimeTable.G2Change(Sender: TObject);
begin
  inherited;
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME||''(''||abbreviation||'')''','GROUPS','');
end;

procedure TFCopyTimeTable.BitBtnPERClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := P1.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
   P1.Text := KeyValue;
  End;
end;

procedure TFCopyTimeTable.BitBtn2Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := P2.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
   P2.Text := KeyValue;
  End;
end;

procedure TFCopyTimeTable.BitBtnGROClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := G1.Text;
  If GROUPSShowModalAsSelect(KeyValue,'0=0','') = mrOK Then Begin
   G1.Text := KeyValue;
  End;
end;

procedure TFCopyTimeTable.BitBtn4Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := G2.Text;
  If GROUPSShowModalAsSelect(KeyValue,'0=0','') = mrOK Then Begin
   G2.Text := KeyValue;
  End;
end;

procedure TFCopyTimeTable.BitBtn3Click(Sender: TObject);
Var V : ShortString;
begin
  inherited;
  If Empty(P1.Text) Then Begin SError('Sk¹d: Semestr musi zostaæ wybrany');  Exit; End;
  If Empty(P2.Text) Then Begin SError('Dok¹d: Semestr musi zostaæ wybrany'); Exit; End;
  If Empty(G1.Text) Then Begin SError('Sk¹d: Grupa musi zostaæ wybrana');    Exit; End;
  If Empty(G2.Text) Then Begin SError('Dok¹d: Grupa musi zostaæ wybrana');   Exit; End;
  If (P1.Text = P2.Text) And (G1.Text = G2.Text) Then Begin SError('Semestr i grupa w sekcjach Sk¹d i dok¹d nie mog¹ byæ takie same'); Exit; End;

  With DModule Do Begin
    V := SingleValue('SELECT COUNT(1) FROM TIMETABLE WHERE GRO_ID='+G2.Text+' AND PER_ID= '+P2.Text);
    If V <> '0' Then Begin
     If Question('W semestrze '+P2_VALUE.Text+' dla grupy '+G2_VALUE.Text+' okreœlano ju¿ zajêæ:'+V+'. Czy chcesz kontynuowaæ?') = ID_NO Then Exit; 
    End;

    dmodule.ADOConnection.CommitTrans;
    SQL('DELETE FROM TIMETABLE WHERE GRO_ID='+G2.Text+' AND PER_ID= '+P2.Text);
    SQL('INSERT INTO TIMETABLE (ID, GRO_ID, PER_ID, SUB_ID, FOR_ID, LIMIT) SELECT TIMTAB_SEQ.NEXTVAL, '+G2.Text+', '+P2.Text+', SUB_ID, FOR_ID, LIMIT FROM TIMETABLE WHERE PER_ID='+P1.Text+' AND GRO_ID='+G1.Text);
  End;

  dmodule.ADOConnection.CommitTrans;
  Info('Kopiowanie zakoñczy³o siê sukcesem')
end;

procedure TFCopyTimeTable.BitBtn1Click(Sender: TObject);
begin
  inherited;
 Close;
end;

end.
