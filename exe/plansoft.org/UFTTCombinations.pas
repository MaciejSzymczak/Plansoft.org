unit UFTTCombinations;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, DB, ADODB, Grids,
  DBGrids;

type
  TFTTCombinations = class(TFormConfig)
    Panel1: TPanel;
    Panel2: TPanel;
    BClose: TBitBtn;
    BAdd: TBitBtn;
    BEdit: TBitBtn;
    BDelete: TBitBtn;
    chbShowL: TCheckBox;
    chbShowG: TCheckBox;
    chbShowresCat0: TCheckBox;
    chbShowresCat1: TCheckBox;
    chbShowS: TCheckBox;
    chbShowF: TCheckBox;
    ADOQuery: TADOQuery;
    DataSource: TDataSource;
    BRefresh: TBitBtn;
    CONL: TEdit;
    CONL_VALUE: TEdit;
    bSelL: TBitBtn;
    bClearL: TBitBtn;
    conresCat0: TEdit;
    CONresCat0_VALUE: TEdit;
    bSelRes0: TBitBtn;
    bClearRes0: TBitBtn;
    CONG: TEdit;
    CONG_VALUE: TEdit;
    bSelG: TBitBtn;
    bClearG: TBitBtn;
    GroupBox1: TGroupBox;
    DBGrid: TDBGrid;
    Panel3: TPanel;
    find: TEdit;
    conresCat1: TEdit;
    CONresCat1_VALUE: TEdit;
    bSelresCat1: TBitBtn;
    bClearresCat1: TBitBtn;
    CONS: TEdit;
    CONS_VALUE: TEdit;
    bSelS: TBitBtn;
    bClearS: TBitBtn;
    CONF: TEdit;
    CONF_VALUE: TEdit;
    bSelF: TBitBtn;
    bClearF: TBitBtn;
    procedure CONLChange(Sender: TObject);
    procedure CONGChange(Sender: TObject);
    procedure conresCat0Change(Sender: TObject);
    procedure bSelLClick(Sender: TObject);
    procedure bSelGClick(Sender: TObject);
    procedure bSelRes0Click(Sender: TObject);
    procedure bClearLClick(Sender: TObject);
    procedure bClearGClick(Sender: TObject);
    procedure bClearRes0Click(Sender: TObject);
    procedure chbShowLClick(Sender: TObject);
    procedure chbShowGClick(Sender: TObject);
    procedure chbShowresCat0Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure findChange(Sender: TObject);
    procedure bClearresCat1Click(Sender: TObject);
    procedure bClearSClick(Sender: TObject);
    procedure bClearFClick(Sender: TObject);
    procedure bSelresCat1Click(Sender: TObject);
    procedure bSelSClick(Sender: TObject);
    procedure bSelFClick(Sender: TObject);
    procedure conresCat1Change(Sender: TObject);
    procedure CONSChange(Sender: TObject);
    procedure CONFChange(Sender: TObject);
    procedure chbShowresCat1Click(Sender: TObject);
    procedure chbShowSClick(Sender: TObject);
    procedure chbShowFClick(Sender: TObject);
  private
    refreshEnabled : boolean;
  public
    { Public declarations }
  end;

var
  FTTCombinations: TFTTCombinations;

implementation

uses DM, autoCreate, uutilityparent;

{$R *.dfm}

procedure TFTTCombinations.CONLChange(Sender: TObject);
begin
  If Trim(CONL.TEXT) <> '' Then CONL_VALUE.Text := DMOdule.SingleValue(sql_LECDESC+CONL.TEXT)
                           Else CONL_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFTTCombinations.CONGChange(Sender: TObject);
begin
  If Trim(CONG.TEXT) <> '' Then CONG_VALUE.Text := DMOdule.SingleValue(sql_GRODESC+CONG.TEXT)
                           Else CONG_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFTTCombinations.conresCat0Change(Sender: TObject);
begin
  If Trim(conresCat0.TEXT) <> '' Then conresCat0_VALUE.Text := DMOdule.SingleValue(sql_ResCat0DESC+conresCat0.TEXT)
                           Else conresCat0_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFTTCombinations.conresCat1Change(Sender: TObject);
begin
  If Trim(conresCat1.TEXT) <> '' Then conresCat1_VALUE.Text := DMOdule.SingleValue(sql_ResCat1DESC+conresCat1.TEXT)
                                 Else conresCat1_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFTTCombinations.CONSChange(Sender: TObject);
begin
  If Trim(CONS.TEXT) <> '' Then CONS_VALUE.Text := DMOdule.SingleValue(sql_SUBDESC+CONS.TEXT)
                           Else CONS_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFTTCombinations.CONFChange(Sender: TObject);
begin
  If Trim(CONF.TEXT) <> '' Then CONF_VALUE.Text := DMOdule.SingleValue(sql_FORDESC+CONF.TEXT)
                           Else CONF_VALUE.Text := '';
  BRefreshClick(nil);
end;


procedure TFTTCombinations.bSelLClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONL.Text;
  If LECTURERSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
   CONL.Text := KeyValue;
  End;
end;

procedure TFTTCombinations.bSelGClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONG.Text;
  If groupSShowModalAsSelect(KeyValue,'','0=0','') = mrOK Then Begin
   CONG.Text := KeyValue;
  End;
end;

procedure TFTTCombinations.bSelRes0Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := conresCat0.Text;
  If ROOMSShowModalAsSelect(dmodule.presCatId0,'',KeyValue,'0=0','') = mrOK Then Begin
   conresCat0.Text := KeyValue;
  End;
end;

procedure TFTTCombinations.bClearLClick(Sender: TObject);
begin
  CONL.Text := '';
end;

procedure TFTTCombinations.bClearGClick(Sender: TObject);
begin
  CONG.Text := '';
end;

procedure TFTTCombinations.bClearRes0Click(Sender: TObject);
begin
  conresCat0.Text := '';
end;

procedure TFTTCombinations.chbShowLClick(Sender: TObject);
begin
 CONL_VALUE.Visible := chbShowL.Checked;
 bSelL.Visible      := chbShowL.Checked;
 bClearL.Visible    := chbShowL.Checked;
 BRefreshClick(nil);
end;

procedure TFTTCombinations.chbShowGClick(Sender: TObject);
begin
 CONG_VALUE.Visible := chbShowG.Checked;
 bSelG.Visible      := chbShowG.Checked;
 bClearG.Visible    := chbShowG.Checked;
 BRefreshClick(nil);
end;

procedure TFTTCombinations.chbShowresCat0Click(Sender: TObject);
begin
 conresCat0_VALUE.Visible    := chbShowresCat0.Checked;
 bSelRes0.Visible      := chbShowresCat0.Checked;
 bClearRes0.Visible    := chbShowresCat0.Checked;
 BRefreshClick(nil);
end;

procedure TFTTCombinations.chbShowresCat1Click(Sender: TObject);
begin
 conresCat1_VALUE.Visible := chbShowresCat1.Checked;
 bSelresCat1.Visible      := chbShowresCat1.Checked;
 bClearresCat1.Visible    := chbShowresCat1.Checked;
 BRefreshClick(nil);
end;

procedure TFTTCombinations.chbShowSClick(Sender: TObject);
begin
 CONS_VALUE.Visible := chbShowS.Checked;
 bSelS.Visible      := chbShowS.Checked;
 bClearS.Visible    := chbShowS.Checked;
 BRefreshClick(nil);
end;

procedure TFTTCombinations.chbShowFClick(Sender: TObject);
begin
 CONF_VALUE.Visible := chbShowF.Checked;
 bSelF.Visible      := chbShowF.Checked;
 bClearF.Visible    := chbShowF.Checked;
 BRefreshClick(nil);
end;

procedure TFTTCombinations.FormShow(Sender: TObject);
begin
  chbShowResCat0.Caption := dmodule.pResCatName0;
  chbShowResCat1.Caption := dmodule.pResCatName1;
  //
  refreshEnabled := false;
  chbShowLClick (nil);
  chbShowGClick (nil);
  chbShowresCat0Click (nil);
  chbShowresCat1Click (nil);
  chbShowSClick (nil);
  chbShowFClick (nil);
  refreshEnabled := true;
end;

procedure TFTTCombinations.BRefreshClick(Sender: TObject);
var currentSQL : string;
    resIds     : string;
    resCatIds  : string;
begin
  DBGrid.Visible := false;
  if not refreshEnabled then exit;
  resCatIds := concatElements ( [iif(chbShowL.checked,'-4','')
                                ,iif(chbShowG.checked,'-5','')
                                ,iif(chbShowresCat0.checked,dmodule.presCatId0,'')
                                ,iif(chbShowresCat1.checked,dmodule.presCatId1,'')
                                ,iif(chbShowS.checked,'-3','')
                                ,iif(chbShowF.checked,'-2','')
                                ]
                                , ',');
  resIds     := concatElements ( [iif(chbShowL.checked,CONL.Text,'')
                                ,iif(chbShowG.checked,CONG.Text,'')
                                ,iif(chbShowresCat0.checked,conresCat0.Text,'')
                                ,iif(chbShowresCat1.checked,conresCat1.Text,'')
                                ,iif(chbShowS.checked,CONS.Text,'')
                                ,iif(chbShowF.checked,CONF.Text,'')
                                ]
                                , ',');
  if (resCatIds='') or (resIds='') then exit;
  currentSQL :=
    dmodule.SingleValue('select tt_planner.get_review_sql (:p_res_ids, :p_resCat_ids) from dual'
                       ,'p_res_ids='+resIds+';p_resCat_ids='+resCatIds
                        );

  with adoQuery do begin
   close;
   sql.clear;
   copytoclipboard ( 'select * from (' + currentSQL + ') where description like ''' + find.Text + '%'' order by description' );
   sql.Add('select * from (' + currentSQL + ') where upper(description) like upper(''' + find.Text + '%'') order by description');
   open;
   dbgrid.Columns[0].Width := 0;
   dbgrid.Columns[1].Width := 800;
   dbgrid.Columns[2].Width := 0;
   dbgrid.Columns[3].Width := 0;
  end;
  DBGrid.Visible := true;
end;

procedure TFTTCombinations.bClearresCat1Click(Sender: TObject);
begin
  conresCat1.Text := '';
end;

procedure TFTTCombinations.bClearSClick(Sender: TObject);
begin
  CONS.Text := '';
end;

procedure TFTTCombinations.bClearFClick(Sender: TObject);
begin
  CONF.Text := '';
end;

procedure TFTTCombinations.findChange(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFTTCombinations.bSelresCat1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := conresCat1.Text;
  If ROOMSShowModalAsSelect(dmodule.presCatId1,'',KeyValue,'0=0','') = mrOK Then Begin
   conresCat1.Text := KeyValue;
  End;
end;

procedure TFTTCombinations.bSelSClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONS.Text;
  If SubjectsShowModalAsSelect(KeyValue,'') = mrOK Then Begin
   CONS.Text := KeyValue;
  End;
end;

procedure TFTTCombinations.bSelFClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := CONF.Text;
  If FormsShowModalAsSelect(KeyValue,'') = mrOK Then Begin
   CONF.Text := KeyValue;
  End;
end;


end.
