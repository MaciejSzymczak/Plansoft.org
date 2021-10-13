unit UFPurgeData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB,
  DBTables, Grids, DBGrids, ADODB;

type
  TFPurgeData = class(TFormConfig)
    Pages: TPageControl;
    Main: TTabSheet;
    Preview: TTabSheet;                                                                                                                          
    MainPanel: TPanel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    del_lec_flag: TCheckBox;
    del_gro_flag: TCheckBox;
    del_res_flag: TCheckBox;
    del_sub_flag: TCheckBox;
    del_per_flag: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    date_from: TDateTimePicker;
    Date_to: TDateTimePicker;
    Panel1: TPanel;
    BCancel: TBitBtn;
    BExecute: TBitBtn;
    BPreview: TBitBtn;
    PreviewPanel: TPanel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    Grupy: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    L: TLabel;
    G: TLabel;
    R: TLabel;
    S: TLabel;
    P: TLabel;
    Label9: TLabel;
    C: TLabel;
    DBGrid1: TDBGrid;
    dsl: TDataSource;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dsg: TDataSource;
    dss: TDataSource;
    dsr: TDataSource;
    dsp: TDataSource;
    ql: TADOQuery;
    qg: TADOQuery;
    qr: TADOQuery;
    qs: TADOQuery;
    qp: TADOQuery;
    BSave: TBitBtn;
    SaveDialog: TSaveDialog;
    BExecute2: TBitBtn;
    BitBtn3: TBitBtn;
    Label10: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BExecuteClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BPreviewClick(Sender: TObject);
    procedure PagesChange(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
  private
    gCanCloseQuery : boolean;
    procedure refreshPreview;
  public
    { Public declarations }
  end;

var
  FPurgeData: TFPurgeData;

implementation

{$R *.dfm}

uses uutilityparent, DM, UFMain;

procedure TFPurgeData.FormCreate(Sender: TObject);
begin
  inherited;
  date_from.Date := 0;
  date_to.Date := 0;
end;

procedure TFPurgeData.BCancelClick(Sender: TObject);
begin
 gCanCloseQuery := true;
end;


procedure TFPurgeData.BExecuteClick(Sender: TObject);
var dummy : shortString;
begin
 if not date_from.Checked then date_from.DateTime := 0;

 gCanCloseQuery := false;
 date_from.Time := 0;
 date_to.Time   := 0;

 try
  with dmodule.QWork do begin
    SQL.Clear;
    SQL.Add('begin planner_utils.purge_data (:pdate_from, :pdate_to, :del_lec_flag, :del_gro_flag, :del_rom_flag, :del_sub_flag, :del_per_flag); end;');
    parameters.ParamByName('pdate_from').value   := date_from.datetime;
    parameters.ParamByName('pdate_to').value     := date_to.datetime;
    parameters.ParamByName('del_lec_flag').value := iif( del_lec_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_gro_flag').value := iif( del_gro_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_rom_flag').value := iif( del_res_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_sub_flag').value := iif( del_sub_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_per_flag').value:= iif( del_per_flag.checked , 'Y', 'N');
    execSQL;
  end;
  dummy := dmodule.SingleValue('select planner_utils.get_output_param_num1, planner_utils.get_output_param_num2, planner_utils.get_output_param_num3, planner_utils.get_output_param_num4, planner_utils.get_output_param_num5, planner_utils.get_output_param_num6 from dual');
  info ('Czynnoœæ zosta³a wykonana, usuniêto nastêpuj¹c¹ liczbê danych: ' + cr
      + '   Zajêcia:    ' + dmodule.QWork.Fields[0].AsString + cr
      + '   Wyk³adowcy: ' + dmodule.QWork.Fields[1].AsString + cr
      + '   Grupy:      ' + dmodule.QWork.Fields[2].AsString + cr
      + '   Zasoby:     ' + dmodule.QWork.Fields[3].AsString + cr
      + '   Przedmioty: ' + dmodule.QWork.Fields[4].AsString + cr
      + '   Semetry:    ' + dmodule.QWork.Fields[5].AsString );
  gCanCloseQuery := true;
 except
   on E:exception do Begin
     Dmodule.RollbackTrans;
     info('Czynnoœæ nie powiod³a sie z powodu nastêpuj¹cego b³êdu:' + cr + cr + E.Message);
   end;
 end;
end;

procedure TFPurgeData.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := gCanCloseQuery;
  gCanCloseQuery := true;
end;

procedure TFPurgeData.FormShow(Sender: TObject);
begin
 c.Caption := '-';
 l.Caption := '-';
 g.Caption := '-';
 r.Caption := '-';
 s.Caption := '-';
 p.Caption := '-';

 gCanCloseQuery := true;
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora. Bêdziesz móg³ sprawdziæ jakie dane zostan¹ usuniête, ale przycisk Usuñ bêdzie niedostêpny.');
  BExecute.Enabled := false;
  BExecute2.Enabled := false;
 End;
end;

procedure TFPurgeData.BitBtn2Click(Sender: TObject);
begin
 Pages.ActivePage := main;
end;

procedure TFPurgeData.refreshPreview;
var dummy : shortString;
    session_id : shortString;
begin
 screen.Cursor := crHourGlass;
 if not date_from.Checked then date_from.DateTime := 0;
 if isAdmin then begin
   BExecute.Enabled := true;
   BExecute2.Enabled := true;
 end;
 gCanCloseQuery := false;
 date_from.Time := 0;
 date_to.Time   := 0;

 session_id := dmodule.SingleValue('select planner_utils.get_session_id from dual');
 try
  with dmodule.QWork do begin
    SQL.Clear;
    SQL.Add('begin planner_utils.preview_before_purge_data (:pdate_from, :pdate_to, :del_lec_flag, :del_gro_flag, :del_rom_flag, :del_sub_flag, :del_per_flag, :session_id); end;');
    parameters.ParamByName('pdate_from').value := date_from.datetime;
    parameters.ParamByName('pdate_to').value   := date_to.datetime;
    parameters.ParamByName('del_lec_flag').value := iif( del_lec_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_gro_flag').value := iif( del_gro_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_rom_flag').value := iif( del_res_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_sub_flag').value := iif( del_sub_flag.checked , 'Y', 'N');
    parameters.ParamByName('del_per_flag').value := iif( del_per_flag.checked , 'Y', 'N');
    parameters.ParamByName('session_id').value   := session_id;
    execSQL;
  end;
  dummy := dmodule.SingleValue('select planner_utils.get_output_param_num1, planner_utils.get_output_param_num2, planner_utils.get_output_param_num3, planner_utils.get_output_param_num4, planner_utils.get_output_param_num5, planner_utils.get_output_param_num6 from dual');

  C.Caption := dmodule.QWork.Fields[0].AsString;
  L.Caption := dmodule.QWork.Fields[1].AsString;
  G.Caption := dmodule.QWork.Fields[2].AsString;
  R.Caption := dmodule.QWork.Fields[3].AsString;
  S.Caption := dmodule.QWork.Fields[4].AsString;
  P.Caption := dmodule.QWork.Fields[5].AsString;

  ql.close;
  qg.close;
  qr.close;
  qs.close;
  qp.close;
  ql.SQL.Clear;
  qg.SQL.Clear;
  qr.SQL.Clear;
  qs.SQL.Clear;
  qp.SQL.Clear;
  ql.SQL.Add('select value from tmp_varchar2 where sessionid = planner_utils.get_session_id and param=''LEC'' order by 1');
  qg.SQL.Add('select value from tmp_varchar2 where sessionid = planner_utils.get_session_id and param=''GRO'' order by 1');
  qr.SQL.Add('select value from tmp_varchar2 where sessionid = planner_utils.get_session_id and param=''RES'' order by 1');
  qs.SQL.Add('select value from tmp_varchar2 where sessionid = planner_utils.get_session_id and param=''SUB'' order by 1');
  qp.SQL.Add('select value from tmp_varchar2 where sessionid = planner_utils.get_session_id and param=''PER'' order by 1');
  ql.Open;
  qg.Open;
  qr.Open;
  qs.Open;
  qp.Open;

  dmodule.SQL('begin delete from tmp_varchar2 where sessionid = planner_utils.get_session_id; end;');

  gCanCloseQuery := true;
  screen.Cursor := crDefault;
 except
   on E:exception do Begin
     screen.Cursor := crDefault;
     Dmodule.RollbackTrans;
     info('Czynnoœæ nie powiod³a sie z powodu nastêpuj¹cego b³êdu:' + cr + cr + E.Message);
   end;
 end;
end;

procedure TFPurgeData.BPreviewClick(Sender: TObject);
begin
 Pages.ActivePage := Preview;
 refreshPreview;
end;

procedure TFPurgeData.PagesChange(Sender: TObject);
begin
  if pages.ActivePageIndex = 1 then refreshPreview;
end;

procedure TFPurgeData.BSaveClick(Sender: TObject);
var f : textFile;
  procedure writeData (var q : tadoquery);
  begin
    writeLn(f, '        ------------------------');
    q.First;
    while not q.Eof do begin
      writeLn(f, '        '+q.fields[0].AsString );
      q.Next;
    end;
    writeLn(f, '        ------------------------');
    writeLn(f, '');
  end;
begin
 if saveDialog.Execute then begin
    AssignFile(f, saveDialog.FileName);
    ReWrite(f);
    writeLn(f, 'Plansoft.org - Raport na temat danych do usuniêcia');
    writeLn(f, '==================================================');
    writeLn(f, '    Dane usuwane za okres od '
                 + dateToStr( date_from.DateTime)
                 + ' do ' + dateToStr( date_to.DateTime) );
    writeLn(f, '    Data uruchomienia :' + dateToStr(now) );
    writeLn(f, '    Uruchomi³: ' + nvl( fmain.conrole_value.text, CurrentUserName) );
    writeLn(f, '');
    writeLn(f, 'Dane do usuniêcia');
    writeLn(f, '');
    writeLn(f, '    Wyk³adowcy');
    writeData (ql);
    writeLn(f, '    Grupy');
    writeData (qg);
    writeLn(f, '    Zasoby');
    writeData (qr);
    writeLn(f, '    Przedmioty');
    writeData (qs);
    writeLn(f, '    Semestry');
    writeData (qp);
    writeLn(f, '');
    writeLn(f, 'Podsumowanie - liczba danych do usuniêcia');
    writeLn(f, '    Zajêcia   :' + C.caption);
    writeLn(f, '    Wyk³adowcy:' + L.caption);
    writeLn(f, '    Grupy     :' + G.caption);
    writeLn(f, '    Zasoby    :' + R.caption);
    writeLn(f, '    Przedmioty:' + S.caption);
    writeLn(f, '    Semestry  :' + P.caption);
    CloseFile(f);
    info('Dane zosta³y pomyœlnie zapisane w pliku');
 end;

end;

end.
