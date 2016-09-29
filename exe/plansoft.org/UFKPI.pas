unit UFKPI;

{
-- work summary
-- done
--     separate application
--     ready for use engine that generates chart by SQL
--     ready for use sql returning top 10
--     fine gui
--         Planiúci / Wyk≥adowcy / Zasoby / Grupy / Przedmioty / Formy + Ile ( 3 / 5 / 10 / 20 )
-- to do
--     --complete get_sql
			 ?grid.duration
--   test: current month - empty chart ??
--   merge
--   easy / advanced
--     installation package
--          test: logon as another user than PLANNER
     lower empty spaces between charts
         wykresy w kolumnach i w wierszach
         wykresy w jednej kolumnie
     zrob zestawienia dla WATu
     ?automatyczna aktualizacja - update.exe wyjmij do menu i skasuj z aplikacji
}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, DB, ADODB, ComCtrls;

type
  TFKPI = class(TFormConfig)
    googleChart: TADOQuery;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    periodType: TComboBox;
    periodCount: TEdit;
    GroupBox1: TGroupBox;
    Selector1: TComboBox;
    Selector2: TComboBox;
    Selector3: TComboBox;
    Selector4: TComboBox;
    Selector5: TComboBox;
    Selector6: TComboBox;
    Selector7: TComboBox;
    TopValues: TEdit;
    map: TMemo;
    asOfDate: TDateTimePicker;
    showAll: TCheckBox;
    topPanel: TPanel;
    BCreate: TSpeedButton;
    BClose: TSpeedButton;
    adv: TCheckBox;
    rank_rownum: TComboBox;
    pie_or_column: TComboBox;
    Label3: TLabel;
    graph_width: TEdit;
    graph_height: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    matrix_or_column: TComboBox;
    procedure BCreateClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure advClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Selector1Change(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FKPI: TFKPI;

implementation

{$R *.dfm}

Uses uutilityParent, UFMain, dm;



procedure TFKPI.BCreateClick(Sender: TObject);
var tmpFile : textfile;
    kpis    : string;
    sqlstmt : string;
begin
  if not elementEnabled('"Wskaüniki efektywnoúci"','2013.08.19', false) then exit;

  kpis :=
       map.Lines.Values[Selector1.Text]
      +map.Lines.Values[Selector2.Text]
      +map.Lines.Values[Selector3.Text]
      +map.Lines.Values[Selector4.Text]
      +map.Lines.Values[Selector5.Text]
      +map.Lines.Values[Selector6.Text]
      +map.Lines.Values[Selector7.Text];



  googleChart.SQL.Clear;
  sqlstmt := format('select google_chart.getChart(''%s'', ''%s'', ''%s'', %s, %s, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'' ) from dual',
                 [kpis
                , TopValues.text
                , map.Lines.Values[periodType.Text]
                , periodCount.Text
                , uutilityparent.DateToOracle(asOfDate.DateTime)
                , FMain.getUserOrRoleID
                , iif(showAll.Checked,'Y','N')
                , iif(rank_rownum.ItemIndex=0,'row_number','rank')
                , iif(pie_or_column.itemIndex=0,'Pie','Column')
                , graph_width.Text
                , graph_height.text
                , iif(matrix_or_column.itemIndex=0,'Matrix','Column')
                ]);
  googleChart.SQL.Add( sqlstmt );
  try
  googleChart.Open;
  except
   on e:exception do begin
       copyToClipboard( sqlstmt );
       raise;
   end;
  end;
  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'tmpgooglechart.html');
  rewrite(tmpFile);
  writeln(tmpFile, googleChart.Fields[0].AsString);
  closeFile(tmpFile);

  ExecuteFile(uutilityParent.ApplicationDocumentsPath +'tmpgooglechart.html','','',SW_SHOWMAXIMIZED);
end;

procedure TFKPI.BCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TFKPI.advClick(Sender: TObject);
begin
 if adv.Checked then self.width := 536 else self.width := 216;
end;

procedure TFKPI.FormShow(Sender: TObject);
begin
  asOfDate.DateTime := now;
  advClick(nil);
  Selector1Change(nil);
end;

procedure TFKPI.Selector1Change(Sender: TObject);
begin
  inherited;
  selector2.Visible := selector1.ItemIndex<>0;
  selector3.Visible := selector2.ItemIndex<>0;
  selector4.Visible := selector3.ItemIndex<>0;
  selector5.Visible := selector4.ItemIndex<>0;
  selector6.Visible := selector5.ItemIndex<>0;
  selector7.Visible := selector6.ItemIndex<>0;
end;

end.
