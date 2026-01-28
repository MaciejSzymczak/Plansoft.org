unit UFGraphviz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, Buttons, StdCtrls, ExtCtrls, DB, ADODB;

type
  TFGraphviz = class(TFormConfig)
    topPanel: TPanel;
    BCreate: TSpeedButton;
    BClose: TSpeedButton;
    generateChart: TADOQuery;
    chartHeader: TMemo;
    chartFooter: TMemo;
    pmapTypeId: TComboBox;
    Label3: TLabel;
    Label1: TLabel;
    orientation: TComboBox;
    chartHeaderIneractive: TMemo;
    chartFooterInteractive: TMemo;
    chartHeaderVer2: TMemo;
    chartFooterVer2: TMemo;
    chartHeaderVer3: TMemo;
    chartFooterVer3: TMemo;
    Label2: TLabel;
    ChartMode: TComboBox;
    SQLcurrentGroup: TMemo;
    SQLMain: TMemo;
    procedure BCloseClick(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    pid : string;
    procedure customshowmodal(pId : string);
    procedure generateOrgChart(mode, pId : string; orientation : integer);
  end;

var
  FGraphviz: TFGraphviz;

implementation

uses DM, UUtilityParent, UFMain, UWebServices;

{$R *.dfm}

{ TFGraphviz }

procedure TFGraphviz.generateOrgChart(mode, pId: string; orientation : integer);
var
    tmpFileName : string;
    tmpFile : textfile;
    htmlContent : string;
    DateFrom, DateTo : String;
    pchartHeader : String;
begin
  dmodule.CommitTrans;
  dmodule.resetConnection(generateChart);

  //------------------------------------------------------------------------
  if (mode='all') then
  begin
    dmodule.openSQL(generateChart,
       sqlMain.Lines.Text+' order by parent_dsp, child_dsp');
  end;

  //------------------------------------------------------------------------
  if (mode='currentPeriodOnly') then begin
    Dmodule.SingleValue('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+nvl(fmain.conPeriod.Text,'-1'));
    DateFrom := 'TO_DATE('''+dmodule.QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
    DateTo   := 'TO_DATE('''+dmodule.QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';

    dmodule.openSQL(generateChart,
       sqlMain.Lines.Text+
       ' where parent_id in (select gro_id from gro_cla where day between :dfrom1 and :dto1)'+
       ' or child_id in (select gro_id from gro_cla where day between :dfrom2 and :dto2) order by parent_dsp, child_dsp',
	  	';dfrom1=' +  DateFrom +
	  	';dto1=' +  DateTo +
	  	';dfrom2=' +  DateFrom +
	  	';dto2=' + DateTo
      , false
    );
  end;


  //------------------------------------------------------------------------
  if (mode='currentGroup') then
  begin
    dmodule.sql(
     'begin'+
     ' delete from helper1;'+
     ' insert into helper1 (id) values ('+pId+');'+
     ' for l in 1..30 loop'+
     '   insert into helper1 (id) select child_id from str_elems_v where parent_id in (select id from helper1) minus select id from helper1;'+
     '   insert into helper1 (id) select parent_id from str_elems_v where child_id in (select id from helper1)  minus select id from helper1;'+
     '   insert into helper1 (id) select res_id from exclusions where res_id in (select id from helper1)  minus select id from helper1;'+
     '   insert into helper1 (id) select res_id from exclusions where res_id_excluded in (select id from helper1)  minus select id from helper1;'+
     ' end loop;'+
     ' end;');

    dmodule.openSQL(generateChart, SQLcurrentGroup.Lines.Text );
  end;



  if (ChartMode.ItemIndex =0) then begin
	  htmlContent := '@startuml'+cr+'digraph G {'+cr+'%orientation'+cr;
	  while not generateChart.Eof do begin
		 htmlContent := htmlContent +  '"' + generateChart.Fields[1].AsString + '"->"' + generateChart.Fields[0].AsString + '"'
			 + ' ['
			 + iif(generateChart.Fields[2].AsString='+','penwidth=3','penwidth=1')
			 + ',color="'+delphiColourToHTML(generateChart.Fields[3].AsInteger)+'"'
			 +'];'  + cr;
		 generateChart.Next;
	  end;
	  generateChart.Close;
	  Dmodule.RollbackTrans;

	  tmpFileName := uutilityParent.ApplicationDocumentsPath +'Plansoft.org.groups.html';

	  AssignFile(tmpFile, tmpFileName );
	  rewrite(tmpFile);

	  htmlContent := htmlContent + '}' +cr+ '@enduml';
	  case orientation of
	   0:begin htmlContent := searchAndReplace(htmlContent, '%orientation', 'rankdir=LR;'); end;
	   1:begin htmlContent := searchAndReplace(htmlContent, '%orientation', ''); end;
	  end;

    htmlContent := httpPOST('https://soft.home.pl/tools/plantumlAPI.php','txt='+URLEncode(htmlContent),'Content-Type: application/x-www-form-urlencoded',80);

	  writeln(tmpFile, chartHeaderVer3.text +  htmlContent + chartFooterVer3.text);
	  closeFile(tmpFile);
    Dmodule.RollbackTrans;
  end;


  //static chart  EDITABLE
  if (ChartMode.ItemIndex =1) then begin
	  htmlContent := '';
	  while not generateChart.Eof do begin
		 htmlContent := htmlContent +  '"' + generateChart.Fields[1].AsString + '"->"' + generateChart.Fields[0].AsString + '"'
			 + ' ['
			 + iif(generateChart.Fields[2].AsString='+','penwidth=3','penwidth=1')
			 + ',color="'+delphiColourToHTML(generateChart.Fields[3].AsInteger)+'"'
			 +'];<br/>'  + cr;
		 generateChart.Next;
	  end;
	  generateChart.Close;
	  Dmodule.RollbackTrans;

	  tmpFileName := uutilityParent.ApplicationDocumentsPath +'Plansoft.org.groups.html';

	  AssignFile(tmpFile, tmpFileName );
	  rewrite(tmpFile);

	  pchartHeader := chartHeaderVer2.text;
	  case orientation of
	   0:begin pchartHeader := searchAndReplace(pchartHeader, '%orientation', 'rankdir=LR;'); end;
	   1:begin pchartHeader := searchAndReplace(pchartHeader, '%orientation', ''); end;
	  end;

	  writeln(tmpFile, pchartHeader+  htmlContent + chartFooterVer2.text);
	  closeFile(tmpFile);
    Dmodule.RollbackTrans;
  end;


  //interactive chart
  if (ChartMode.ItemIndex =2) then begin
	  htmlContent := '';
	  while not generateChart.Eof do begin
		 dmodule.SQL2('begin insert into helper2 (desc2) values ('''+     'nodes.push({id: ' + generateChart.FieldByName('parent_id').AsString + ', label: "' + generateChart.FieldByName('parent_dsp').AsString + '"})'     +'''); end;');
		 dmodule.SQL2('begin insert into helper2 (desc2) values ('''+     'nodes.push({id: ' + generateChart.FieldByName('child_id').AsString + ', label: "' + generateChart.FieldByName('child_dsp').AsString + '"})'     +'''); end;');
		 htmlContent := htmlContent +  'edges.push({from:' + generateChart.FieldByName('parent_id').AsString + ', to: ' + generateChart.FieldByName('child_id').AsString + ', length: 1});' + cr;
		 generateChart.Next;
	  end;
	  generateChart.Close;

	  dmodule.openSQL(generateChart,
		   'select unique desc2 from helper2');
	  while not generateChart.Eof do begin
		 htmlContent := htmlContent + generateChart.Fields[0].AsString+ cr;
		 generateChart.Next;
	  end;
	  generateChart.Close;

    tmpFileName := uutilityParent.ApplicationDocumentsPath +'Plansoft.org.groups.html';

    AssignFile(tmpFile, tmpFileName );
    rewrite(tmpFile);

    writeln(tmpFile, chartHeaderIneractive.text+  htmlContent + chartFooterInteractive.text);
    closeFile(tmpFile);
    Dmodule.RollbackTrans;
  end;

  ExecuteFile(tmpFileName,'','',SW_SHOWMAXIMIZED);
end;

procedure TFGraphviz.BCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFGraphviz.customshowmodal(pId: string);
begin
  self.pid := pid;
  showmodal;
end;

procedure TFGraphviz.BCreateClick(Sender: TObject);
begin
 Case pmapTypeId.ItemIndex of
  0: fGraphviz.generateOrgChart('all', 'n/a', orientation.itemindex);
  1: fGraphviz.generateOrgChart('currentPeriodOnly', 'n/a', orientation.itemindex);
  2: fGraphviz.generateOrgChart('currentGroup', pId, orientation.itemindex);
 End;

end;

end.
