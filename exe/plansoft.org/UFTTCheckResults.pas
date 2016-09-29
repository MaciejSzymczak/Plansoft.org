unit UFTTCheckResults;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, DBCtrls, Grids, DBGrids, DB, ADODB, StdCtrls,
  Buttons, ExtCtrls;

type
  TFTTCheckResults = class(TFormConfig)
    Panel1: TPanel;
    Panel2: TPanel;
    ADOQuery: TADOQuery;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    bClose: TBitBtn;
    bProceed: TBitBtn;
    Label1: TLabel;
    bBrowse: TBitBtn;
    procedure ADOQueryAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    numberOfColumns : integer;
    p_res_ids       : string;
  end;

var
  FTTCheckResults: TFTTCheckResults;

implementation

{$R *.dfm}

uses autocreate, DM, UFMain;

procedure TFTTCheckResults.ADOQueryAfterOpen(DataSet: TDataSet);
var t : integer;
begin
  for t := 0 to dbgrid.Columns.Count -1 do begin
    dbgrid.Columns[t].Visible := true;
    if dbgrid.Columns[t].Width > 200 then dbgrid.Columns[t].Width := 200;
    if t > numberOfColumns-1 then
      dbgrid.Columns[t].Visible := false
    else begin
      if adoquery.FieldByName('null_sensor'+inttostr(t+1)).AsString = '-' then dbgrid.Columns[t].Visible := false;
    end;
  end;
end;

procedure TFTTCheckResults.FormShow(Sender: TObject);
var cols : string;
    null_sensors : string;
    t    : integer;
  Function Merge(S1, S2: string; const Sep : String = '') : String;
  Begin
   If S1='' Then Result := S2 Else
    Begin
     If S2='' Then Result := S1
      Else Result := S1 + Sep + S2;
    End;
  End;
//-------------
begin
  with adoquery do begin
    close;
    adoquery.SQL.Clear;
    cols := '';
    null_sensors := '';
    for t := 1 to numberOfColumns do begin
     cols         := merge(cols        , 'res_desc' + inttostr(t)                                    , ',');
     null_sensors := merge(null_sensors, '(max(res_desc'+inttostr(t)+') over (partition by null ) ) null_sensor'+inttostr(t) , ',');
    end;
    adoquery.SQL.add('select '+cols+','+null_sensors+' from tt_check_results_v where found_tt is null');
    open;
  end;
end;

procedure TFTTCheckResults.bBrowseClick(Sender: TObject);
begin
  TT_COMBINATIONSShowModalAsBrowser;
  dmodule.sql('begin tt_planner.verify (:p_pla_id, :p_res_ids, :p_auto_fix ); end;'
             ,'p_pla_id='+fmain.getUserOrRoleId+';p_res_ids='+p_res_ids+';p_auto_fix=N'
             );
  FormShow(self);
  if adoquery.IsEmpty then modalResult := mrOK;
end;

end.
