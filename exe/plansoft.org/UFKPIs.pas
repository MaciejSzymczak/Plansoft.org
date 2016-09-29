unit UFKPIs;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, OleCtrls, SHDocVw, ExtCtrls, Buttons,
  ComCtrls, UFormConfig, dm;

type
  TFKPIs = class(TForm)
    BClose: TSpeedButton;
    BCreate: TSpeedButton;
    Button1: TButton;
    googleChart: TADOQuery;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    procedure BCreateClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FKPIs: TFKPIs;

implementation

Uses uutilityParent, UFMain;

{$R *.dfm}

procedure TFKPIs.BCreateClick(Sender: TObject);
var tmpFile : textfile;
    kpis    : string;
    sqlstmt : string;
begin
  kpis :=
       map.Lines.Values[Selector1.Text]
      +map.Lines.Values[Selector2.Text]
      +map.Lines.Values[Selector3.Text]
      +map.Lines.Values[Selector4.Text]
      +map.Lines.Values[Selector5.Text]
      +map.Lines.Values[Selector6.Text]
      +map.Lines.Values[Selector7.Text];

  googleChart.SQL.Clear;
  sqlstmt := format('select google_chart.getChart(''%s'', ''%s'', ''%s'', %s, %s, ''%s'', ''%s'' ) from dual',[kpis, TopValues.text, map.Lines.Values[periodType.Text], periodCount.Text, uutilityparent.DateToOracle(asOfDate.DateTime), FMain.getUserOrRoleID, iif(showAll.Checked,'Y','N') ]);
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

procedure TFKPIs.BCloseClick(Sender: TObject);
begin
    Close;
end;


end.
