unit UFWWWGenerator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, CheckLst, StrHlder, ComCtrls, ufmain, uutilities, UCommon, db,
  ADODB, inifiles, Menus, ShellApi;

type
  TFWWWGenerator = class(TFormConfig)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GROSettings: TStrHolder;
    LECOrderby: TStrHolder;
    xslt: TMemo;
    TabSheet3: TTabSheet;
    css: TMemo;
    TopPanel: TPanel;
    LprofileObjectNamePeriod: TLabel;
    currentPeriod: TEdit;
    currentPeriod_VALUE: TEdit;
    BitBtnPER: TBitBtn;
    genType: TComboBox;
    PageControl2: TPageControl;
    tsWWW: TTabSheet;
    tsGoogle: TTabSheet;
    Label1: TLabel;
    Folder: TEdit;
    Label7: TLabel;
    AddText: TEdit;
    Label2: TLabel;
    pmiddle: TPanel;
    pright: TPanel;
    pleft: TPanel;
    LList: TCheckListBox;
    Splitter1: TSplitter;
    RList: TCheckListBox;
    GList: TCheckListBox;
    Splitter2: TSplitter;
    pmiddletop: TPanel;
    prighttop: TPanel;
    plefttop: TPanel;
    GL: TLabel;
    GROFilterClick: TSpeedButton;
    Groups: TCheckBox;
    GROfilerSettings_dsp: TEdit;
    Resources: TCheckBox;
    RL: TLabel;
    Lecturers: TCheckBox;
    LL: TLabel;
    lsortBy: TLabel;
    ComboSortOrder: TComboBox;
    gfilter: TLabel;
    DoNotGenerateTableOfCon: TCheckBox;
    sqlHolder: TMemo;
    SaveDialog: TSaveDialog;
    bcreatepopup: TSpeedButton;
    BCreate: TSpeedButton;
    createpopup: TPopupMenu;
    Utwrzrozk1: TMenuItem;
    wrzrozkadyautomatycznieautomatycznetworzenieiodwieanierozkadw1: TMenuItem;
    BClose: TSpeedButton;
    bsettings: TSpeedButton;
    ROMSettings: TStrHolder;
    LECSettings: TStrHolder;
    rfilter: TLabel;
    ROMfilerSettings_dsp: TEdit;
    ROMFilterClick: TSpeedButton;
    lfilter: TLabel;
    LECfilerSettings_dsp: TEdit;
    LECFilterClick: TSpeedButton;
    Gselector: TCheckBox;                                                          
    rselector: TCheckBox;
    lselector: TCheckBox;
    adotest: TADOQuery;
    Panel2: TPanel;
    OpenDialog: TOpenDialog;
    BShowAll: TSpeedButton;
    BOther: TSpeedButton;
    MDefault: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure BitBtnPERClick(Sender: TObject);
    procedure currentPeriodChange(Sender: TObject);
    procedure GroupsClick(Sender: TObject);
    procedure ResourcesClick(Sender: TObject);
    procedure LecturersClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GROFilterClickClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboSortOrderChange(Sender: TObject);
    procedure genTypeChange(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
    procedure bcreatepopupClick(Sender: TObject);
    procedure Utwrzrozk1Click(Sender: TObject);
    procedure wrzrozkadyautomatycznieautomatycznetworzenieiodwieanierozkadw1Click(
      Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure bsettingsClick(Sender: TObject);
    procedure ROMFilterClickClick(Sender: TObject);
    procedure LECFilterClickClick(Sender: TObject);
    procedure GselectorClick(Sender: TObject);
    procedure rselectorclick(Sender: TObject);
    procedure lselectorClick(Sender: TObject);
    procedure BOpenDialogClick(Sender: TObject);
    procedure BOtherClick(Sender: TObject);
    procedure BShowAllClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
  private
    formPrepared : boolean;
    settingsLoaded : boolean;
  public
    defaultFolder : string;
    procedure setStatus(i : shortString);
    Procedure calendarToHTML(
           pPeriodId: String;
           presId : string;
           presType : string;
           D1, D2, D3, D4, D5 : shortString;
           Header, Footer : TStrings;
           ShowLegend : Boolean;
           LegendMode : Integer;
           AddCreationDate : Integer;
           ColoringIndex : shortString;
           CellWIDTH, CELLHEIGHT, CELLSIZE : ShortString;
           S1, S2, S3, S4, S5 : ShortString;
           B1, B2, B3, B4, B5 : Boolean;
           FileName : ShortString;
           pRepeatMonthNames : boolean; //powtarzaj nazwy miesiecy
           pHideEmptyRows    : boolean;  //ukrywaj puste wiersze
           pHideDows         : string;
           pSpan             : integer;  //merge
           pspanEmptyCells   : boolean;
           ptransposition : boolean;
           pVerticalLines : boolean;
           notes_before : boolean;
           notes_after : boolean;
           pdfPrintOut, pdfg, pdfl, pdfo, pdfs : boolean
    );
  end;

var
  FWWWGenerator: TFWWWGenerator;

implementation

uses DM, AutoCreate, UUtilityParent, FileCtrl, UFSettings, uFModuleFilter, uFBrowseGROUPS,
  UFProgramSettings, GoogleCal, UFBrowseROOMS, UFBrowseLECTURERS, UWeeklyTable;


type cclassbuffer =
  class
    bufferIsEmpty : boolean;
    dtstart     : string;
    dtend       : string;
    dtstamp     : string;
    uid         : string;
    description : string;
    location    : string;
    summary     : string;
    color       : string;
    internalid  : string;
    hour        : integer;
    day         : string;
    memory      : array of string;
    memoryCnt   : integer;
    procedure init;
    procedure  setBuffer(
      pdtstart    : string;
      pdtend      : string;
      pdtstamp    : string;
      puid        : string;
      pdescription: string;
      plocation   : string;
      psummary    : string;
      pcolor      : string;
      pinternalid : string;
      phour       : integer;
      pday        : string
    );
    function isContinuation (
      pdtstart    : string;
      pdtend      : string;
      pdtstamp    : string;
      puid        : string;
      pdescription: string;
      plocation   : string;
      psummary    : string;
      pcolor      : string;
      pinternalid : string;
      phour       : integer;
      pday        : string
    ) : boolean;
    function bflush : string;
    function searchMemory (s : string) : boolean;
  end;


procedure cclassbuffer.init;
begin
 bufferIsEmpty := true;
 memoryCnt := 0;
end;

procedure cclassbuffer.setBuffer;
begin
 bufferIsEmpty := false;
 dtstart     :=pdtstart    ;
 dtend       :=pdtend      ;
 dtstamp     :=pdtstamp    ;
 uid         :=puid        ;
 description :=pdescription;
 location    :=plocation   ;
 summary     :=psummary    ;
 color       :=pcolor      ;
 internalid  :=pinternalid ;
 hour        :=phour       ;
 day         :=pday        ;
end;

function cclassbuffer.isContinuation (
  pdtstart    : string;
  pdtend      : string;
  pdtstamp    : string;
  puid        : string;
  pdescription: string;
  plocation   : string;
  psummary    : string;
  pcolor      : string;
  pinternalid : string;
  phour       : integer;
  pday        : string
) : boolean;
begin
 result :=
    (phour       = hour+1       ) and
    (pday        = day          ) and
    (description = pdescription ) and
    (location    = plocation    ) and
    (summary     = psummary     );
end;

function cclassbuffer.searchMemory (s : string) : boolean;
var t : integer;
begin
  result := false;
  for t:=0 to memoryCnt-1 do begin
    if s =  memory[t] then begin
      result := true;
      exit;
    end;
  end;
end;

function cclassbuffer.bflush : string;
begin
  bufferIsEmpty := true;
  result:=
    'BEGIN:VEVENT' +#13#10+
    'DTSTART:'+dtstart +#13#10+ //+'Z' local time, no GMT
    'DTEND:'+dtend +#13#10+ //+'Z'
    'DTSTAMP:'+dtstamp +#13#10+ //+'Z'
    'UID:'+uid +#13#10+
    'CLASS:PUBLIC' +#13#10+
    //'CREATED:'+GetNowGMT(-timeZone) +#13#10+
    'DESCRIPTION:'+description +#13#10+
    //'LAST-MODIFIED:'+GetNowGMT(-timeZone) +#13#10+
    'LOCATION:'+location +#13#10+
    'SEQUENCE:0' +#13#10+
    'STATUS:CONFIRMED' +#13#10+
    'SUMMARY:'+summary +#13#10+
    'TRANSP:OPAQUE' +#13#10+
    //'CATEGORIES:Kategoria czerwona' +#13#10+
    'COLOR:'+color +#13#10+
    'INTERNALID:'+internalid +#13#10+
    'END:VEVENT';

  if searchMemory(internalid) then
    result := ''
  else begin
    SetLength(memory, memoryCnt+1);
    memory[memoryCnt] := internalid;
    memoryCnt := memoryCnt + 1;
  end;
end;

const
MaxLegendPositions  : integer =  1000;

type thtmlTable = class
       table  : array of record
                   attrs : string;
                   cells : array of record
                                      colSpan    : integer;
                                      rowSpan    : integer;
                                      body       : string;
                                      ignoreFlag : boolean;
                                    end
                end;
       lCellWidth       : string;
       lCellHeight      : string;
       rowCount, colCount : integer;
       spanEmptycellsFlag : boolean;
       verticalLines    : string;
       //
       procedure init(aCellWIDTH, aCellHeight : string; aspanEmptycellsFlag  : boolean);
       procedure AddRow (attrs : string);
       Procedure NewCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       Procedure NewCellWidth(Command, S, Color, Width : String);
       Procedure NewHeaderCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       procedure Colspan;
       procedure Rowspan;
       procedure transposite;
       function  Flush : string;
       procedure writeCell (s : string; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       private
       procedure doSpan ( spanType : integer );
     end;

procedure thtmlTable.init(aCellWIDTH, aCellHeight : string; aspanEmptycellsFlag  : boolean);
begin
  spanEmptycellsFlag := aspanEmptycellsFlag;
  lCellWIDTH := aCellWIDTH;
  lCellHeight := aCellHeight;
  rowCount := 0;
  colCount := 0;
end;

procedure thtmlTable.addRow (attrs : string);
begin
  inc ( rowCount );
  colCount := 0;
  setLength(table, rowCount);
  table[ rowCount-1 ].attrs := attrs;
end;

procedure thtmlTable.writeCell (s : string; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
var style : string;
begin
  //add vertical lines
  if Pos(intToStr(colCount),verticalLines)<>0  then
      s := StringReplace(s, '<TD ', '<TD style=''border-right:solid 2.0pt''', [rfIgnoreCase]);

  inc ( colCount );
  setLength(table[ rowCount-1 ].cells, colCount);
  table[ rowCount-1 ].cells[ colCount-1 ].body := s;
  table[ rowCount-1 ].cells[ colCount-1 ].rowSpan := rowSpan;
  table[ rowCount-1 ].cells[ colCount-1 ].colSpan := colSpan;
  table[ rowCount-1 ].cells[ colCount-1 ].ignoreFlag := ignoreFlag;
end;

procedure thtmlTable.newCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
Begin
  If isBlank(S) Then S := '&nbsp';
  If Color <> '0' Then writeCell ( '<TD ROWSPAN="?" COLSPAN="?" HEIGHT="'+lCellHeight+'px" WIDTH="'+lCellWIDTH+'px" '+Command+' BGCOLOR='+Color+'>'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
                  Else writeCell ( '<TD ROWSPAN="?" COLSPAN="?" HEIGHT="'+lCellHeight+'px" WIDTH="'+lCellWIDTH+'px" '+Command+' >'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
End;

procedure thtmlTable.newCellWidth(Command, S, Color, Width : String);
Begin
  If isBlank(S) Then S := '&nbsp';
  If Color <> '0' Then writeCell ( '<TD ROWSPAN="?" COLSPAN="?" WIDTH='+WIDTH+' '+Command+' BGCOLOR='+Color+'>'+S+'</TD>')
                  Else writeCell ( '<TD ROWSPAN="?" COLSPAN="?" WIDTH='+WIDTH+' '+Command+' >'+S+'</TD>')
End;

procedure thtmlTable.newHeaderCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
Begin
  If isBlank(S) Then S := '&nbsp';
  If Color <> '0' Then writeCell ( '<TD ROWSPAN="?" COLSPAN="?" '+Command+' BGCOLOR='+Color+'>'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
                  Else writeCell ( '<TD ROWSPAN="?" COLSPAN="?" '+Command+' >'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
End;

procedure thtmlTable.transposite;
var r,c : integer;
    htmlTable : thtmlTable;
begin
 // reset span
 for r := 0 to rowCount -1 do begin
   for c := 0 to high(table[r].cells)-1 do begin
     table[r].cells[c].colSpan := 1;
     table[r].cells[c].ignoreFlag := false;
   end;
 end;

 htmlTable := thtmlTable.create;
 htmlTable.init (lCellWidth, lCellHeight, self.spanEmptycellsFlag);
 for c := 0 to high(table[0].cells)-1 do begin
   htmlTable.AddRow('ALIGN="center" VALIGN="middle"');
   for r := 0 to rowCount -1 do begin
     htmlTable.writeCell( table[r].cells[c].body );
   end;
 end;

 self.table    := nil;
 Finalize( self.table );

 self.colCount := htmlTable.colCount;
 self.rowCount := htmlTable.rowCount;
 self.table    := htmlTable.table;

 htmlTable.free;
end;

procedure thtmlTable.ColSpan;
var r,c,t : integer;
begin
 for r := 0 to rowCount -1 do begin
   for c := 0 to high(table[r].cells) do begin
     if not table[r].cells[c].ignoreFlag and (( pos('>&nbsp<', table[r].cells[c].body) = 0 ) or spanEmptycellsFlag ) then begin
       // examine all cells below cell
       for t := c+1 to high(table[r].cells) do begin
         if (table[r].cells[t].body = table[r].cells[c].body) and not ( table[r].cells[t].ignoreFlag )
            then begin
              inc ( table[r].cells[c].colSpan );
              table[r].cells[t].ignoreFlag := true;
            end
            else break;
       end;
       //s := s + table[r].cells[c].body;
     end;
   end;
 end;
 doSpan ( 2 );
end;

procedure thtmlTable.RowSpan;
var r,c,t : integer;
begin
 for r := 0 to rowCount -1 do begin
   for c := 0 to high(table[r].cells) do begin
     //info ( table[r].cells[c].body +':'+ inttostr(r) +':'+ inttostr(c) );
     if not table[r].cells[c].ignoreFlag and (( pos('>&nbsp<', table[r].cells[c].body) = 0 ) or spanEmptycellsFlag ) then begin
       // examine all cells below cell
       for t := r+1 to rowCount -1 do begin
         //cell might not exist
         if c > high ( table[t].cells ) then break;
         if (table[t].cells[c].body = table[r].cells[c].body) and not ( table[t].cells[c].ignoreFlag )
            then begin
              inc ( table[r].cells[c].rowSpan );
              table[t].cells[c].ignoreFlag := true;
            end
            else break;
       end;
       //s := s + table[r].cells[c].body;
     end;
   end;
 end;
 doSpan ( 1 );
end;

procedure thtmlTable.doSpan ( spanType : integer );
var r,c  : integer;
    colSpan, rowSpan : integer;
    cellBuffer   : string;
begin
 for r := 0 to rowCount -1 do begin
   for c := 0 to high(table[r].cells) do begin
     if not table[r].cells[c].ignoreFlag then begin
       colSpan := table[r].cells[c].colSpan;
       rowSpan := table[r].cells[c].rowSpan;
       cellBuffer := table[r].cells[c].body;
       if spanType = 1 then begin
         if rowSpan <> 1 then cellBuffer := replace( cellBuffer, 'ROWSPAN="?"', 'ROWSPAN="'+intToStr(rowSpan)+'"')
                         else cellBuffer := replace( cellBuffer, 'ROWSPAN="?"', '');
       end;
       if spanType = 2 then begin
         if colSpan <> 1 then cellBuffer := replace( cellBuffer, 'COLSPAN="?"', 'COLSPAN="'+intToStr(colSpan)+'"')
                         else cellBuffer := replace( cellBuffer, 'COLSPAN="?"', '');
       end;
       table[r].cells[c].body := cellBuffer;
     end;
   end;
 end;
end;

function thtmlTable.Flush : string;
var r,c  : integer;
    s, cellBuffer   : string;
begin
 //there might be not spanned cells passed as entry
 doSpan ( 1 );
 doSpan ( 2 );
 s := '';
 for r := 0 to rowCount -1 do begin
   s := s + '<TR '+table[r].attrs+'>';
   for c := 0 to high(table[r].cells) do begin
     if not table[r].cells[c].ignoreFlag then begin
       cellBuffer := table[r].cells[c].body;
       cellBuffer := replace( cellBuffer, 'ROWSPAN="?"', '');
       cellBuffer := replace( cellBuffer, 'COLSPAN="?"', '');
       s := s + cellBuffer+cr;
     end;
   end;
   s := s + '</TR>'+cr;
 end;
 result := s;
end;

type TclassList =
            Record
              cnt     : integer;
              classes : array of TClass_;
            End;
type tcurrentChartClasses = Class
  data : Array Of  //day
          Array Of //hour
            TclassList;
  firstDay : Integer;
  procedure init(psql, pPerId, pResId, presAlias : string; form : tform);
  function get(ts : TTimeStamp; hour: Integer) : TclassList;
End;


{ tcurrentChartClasses }

function tcurrentChartClasses.get(ts: TTimeStamp;
  hour: Integer): TclassList;
begin
 result := data[TS.Date - FirstDay, hour-1];
end;

procedure tcurrentChartClasses.init(psql, pPerId, pResId, presAlias : string; form : tform);
    Var count : Integer;
        dateFrom, dateTo : String;
        queryClasses : tadoquery;
        ChildsAndParents : string;
        x : integer;
        currentResource : string;
        day, hour, t: integer;
        ci : integer;
        orderby : string;

    Procedure internalInit (count, maxHours : Integer);
    var day, hour : integer;
    Begin
      SetLength(data, count, maxHours);
      For day := 0 To count-1 Do
       For hour := 0 To maxHours-1 Do
         data[day][hour].cnt := 0;
    End;

begin
	queryClasses := tadoquery.Create(form);
  With DModule Do Begin
    Dmodule.SingleValue(CustomdateRange('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+pPerId));
    dateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
    dateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';

    FirstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;
    internalInit (QWork.Fields[2].AsInteger+1, QWork.Fields[4].AsInteger);

	ChildsAndParents := getChildsAndParents (pResId, '', true, false);  //2024.07.25 ignoreExclusiveParent=false (it was: true) 
	for x := 1 To WordCount(ChildsAndParents,[';']) do begin
		currentResource := ExtractWord(x, ChildsAndParents, [';']);

    if (presAlias='LEC') then orderby := 'calc_lecturers';
    if (presAlias='GRO') then orderby := 'calc_groups';
    if (presAlias='ROM') then orderby := 'calc_rooms';
		with queryClasses do begin
			try
        //2020.05.02 Include also parent classes on the printouts (like Inauguracja roku)
				//dmodule.openSQL(queryClasses, psql + ' and c.id in (select cla_id from '+presAlias+'_cla where is_child=''N'' and '+presAlias+'_id = :pres_id) order by '+orderby
				dmodule.openSQL(queryClasses, psql + ' and c.id in (select cla_id from '+presAlias+'_cla where '+presAlias+'_id = :pres_id) order by '+orderby
				,'pres_id='      + currentResource +
        ';per_id_from1='+ pPerId    +
        ';per_id_to1='  + pPerId    +
        ';per_id_from2='+ pPerId    +
        ';per_id_to2='  + pPerId
				);
				open;
				except
				on E:exception do begin
				  CopyToClipboard( queryClasses.SQL.text);
			   	raise;
				end;
			end;

			First;
			while not Eof do begin

      day := DateTimeToTimeStamp(FieldByName('DAY').AsDateTime).Date;
      hour := FieldByName('HOUR').AsInteger;

      t := day-firstDay;

      Data[t][hour-1].cnt := Data[t][hour-1].cnt + 1;
      setLength(Data[t][hour-1].classes, Data[t][hour-1].cnt);
      ci := Data[t][hour-1].cnt - 1;

      with Data[t][hour-1].classes[ci] do begin
        id                 := fieldbyname('id').asinteger;
        day                := datetimetotimestamp(fieldbyname('day').asdatetime);
        hour               := fieldbyname('hour').asinteger;
        fill               := fieldbyname('fill').asinteger;
        sub_id             := fieldbyname('sub_id').asinteger;
        for_id             := fieldbyname('for_id').asinteger;
        for_kind           := fieldbyname('for_kind').asString;
        sub_abbreviation   := fieldbyname('sub_abbreviation').asString;
        sub_name           := fieldbyname('sub_name').asString;
        sub_colour         := fieldbyname('sub_colour').asinteger;
        for_colour         := fieldbyname('for_colour').asinteger;
        owner_colour       := fieldbyname('owner_colour').asinteger;
        creator_colour     := fieldbyname('creator_colour').asinteger;
        class_colour       := fieldbyname('class_colour').asinteger;
        desc1              := fieldbyname('desc1').asString;
        desc2              := fieldbyname('desc2').asString;
        desc3              := fieldbyname('desc3').asString;
        desc4              := fieldbyname('desc4').asString;
        for_abbreviation   := fieldbyname('for_abbreviation').asString;
        for_name           := fieldbyname('for_name').asString;
        calc_lecturers     := fieldbyname('calc_lecturers').asString;
        calc_groups        := fieldbyname('calc_groups').asString;
        calc_rooms         := fieldbyname('calc_rooms').asString;
        calc_lec_ids       := fieldbyname('calc_lec_ids').asString;
        calc_gro_ids       := fieldbyname('calc_gro_ids').asString;
        calc_rom_ids       := fieldbyname('calc_rom_ids').asString;
        calc_rescat_ids    := fieldbyname('calc_rescat_ids').asString;
        created_by         := fieldbyname('created_by').asString;
        owner              := fieldbyname('owner').asString;
      end;

			Next;
			end;
		end;

	End;

  End;
  queryClasses.Free;
end;

{$R *.DFM}

procedure TFWWWGenerator.setStatus(i : shortString);
begin
  Status.Caption := i;
  Status.refresh;
  Application.ProcessMessages;
end;


procedure TFWWWGenerator.BitBtnPERClick(Sender: TObject);
var KeyValue : ShortString;
begin
  inherited;
  KeyValue := currentPeriod.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
   currentPeriod.Text := KeyValue;
  End;
end;

procedure TFWWWGenerator.currentPeriodChange(Sender: TObject);
var periodClauseXXX, periodClauseGRO_CLA, periodClauseLEC_CLA, periodClauseROM_CLA : String;
begin
  if not formPrepared then exit;
  If isBlank(currentPeriod.Text) Then Exit;
  //info(((TControl(Sender).Name) as tedit).text);

   DModule.RefreshLookupEdit(Self, currentPeriod.Name ,'NAME','PERIODS','');

  GList.Items.Clear;
  LList.Items.Clear;
  RList.Items.Clear;

    With DModule Do Begin

     periodClauseXXX  :=UCommon.getWhereClausefromPeriod('ID = ' + NVL(currentPeriod.Text,'-1') ,'XXX.');
     periodClauseGRO_CLA  := replace(periodClauseXXX,'XXX.','GRO_CLA.');
     periodClauseLEC_CLA  := replace(periodClauseXXX,'XXX.','LEC_CLA.');
     periodClauseROM_CLA  := replace(periodClauseXXX,'XXX.','ROM_CLA.');

     //@@@sql_GRONAME vs nvl(GRO.NAME,GRO.abbreviation)
     OpenSQL('SELECT DISTINCT nvl(GROUPS.NAME,GROUPS.abbreviation) GRO_NAME, GROUPS.ID ' +
            'FROM GRO_CLA, GROUPS '+
            'WHERE GRO_ID=GROUPS.ID AND '+periodClauseGRO_CLA+' '+
            'AND GROUPS.ID IN (SELECT GRO_ID FROM GRO_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+') '+
            ' AND (' + nvl(GROSettings.Strings.Values['SQL.Category:DEFAULT'],'0=0') + ') ' +
            'ORDER BY GRO_NAME');
     While Not QWork.Eof Do Begin
      GList.Items.Add(QWork.Fields[0].AsString);
      GList.Checked[GList.Count-1] := true;
      GList.Items.Objects[GList.Count-1] := pointer(QWork.Fields[1].AsInteger);
      QWork.Next;
     End;

     OpenSQL('SELECT DISTINCT '+sql_LECNAME+' LEC_NAME, LEC.ID, TITLE, LAST_NAME, FIRST_NAME ' +
            'FROM LEC_CLA, LECTURERS LEC '+
            'WHERE LEC_ID=LEC.ID AND '+periodClauseLEC_CLA+' '+
            'AND LEC.ID IN (SELECT LEC_ID FROM LEC_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+') '+
            ' AND (' + NVL(LECSettings.Strings.Values['SQL.Category:DEFAULT'],'0=0') + ') ' +
            'ORDER BY ' + LECOrderby.Strings.ValueFromIndex [ ComboSortOrder.ItemIndex ]);

     While Not QWork.Eof Do Begin
      LList.Items.Add(QWork.Fields[0].AsString);
      LList.Checked[LList.Count-1] := true;
      LList.Items.Objects[LList.Count-1] := pointer(QWork.Fields[1].AsInteger);
      QWork.Next;
     End;

     OpenSQL('SELECT DISTINCT '+sql_ResCat0NAME+'  ROM_NAME, ROM.ID ' +
            'FROM ROM_CLA, ROOMS ROM '+
            'WHERE ROM_ID=ROM.ID AND '+periodClauseROM_CLA+' '+
            'AND ROM.ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+') '+
            ' AND (' + NVL(ROMSettings.Strings.Values['SQL.Category:DEFAULT'],'0=0') + ') ' +
            'ORDER BY ROM_NAME');
     While Not QWork.Eof Do Begin
      RList.Items.Add(QWork.Fields[0].AsString);
      RList.Checked[RList.Count-1] := true;
      RList.Items.Objects[RList.Count-1] := pointer(QWork.Fields[1].AsInteger);
      QWork.Next;
     End;
  End;

end;

procedure TFWWWGenerator.GroupsClick(Sender: TObject);
begin
  inherited;
  GList.visible := Groups.Checked;
  Gselector.visible := Groups.Checked;
  GL.visible := Groups.Checked;
  gfilter.visible := Groups.Checked;
  GROfilerSettings_dsp.visible := Groups.Checked;
  GROFilterClick.visible := Groups.Checked;
end;

procedure TFWWWGenerator.ResourcesClick(Sender: TObject);
begin
  inherited;
  RList.visible := Resources.Checked;
  rselector.visible := Resources.Checked;
  RL.visible := Resources.Checked;
  rfilter.visible := Resources.Checked;
  ROMfilerSettings_dsp.visible := Resources.Checked;
  ROMFilterClick.visible := Resources.Checked;
end;

procedure TFWWWGenerator.LecturersClick(Sender: TObject);
begin
  inherited;
  LList.visible := Lecturers.Checked;
  ComboSortOrder.Visible := Lecturers.Checked;
  lsortBy.Visible := Lecturers.Checked;
  Lselector.visible := Lecturers.Checked;
  LL.visible := Lecturers.Checked;
  lfilter.visible := Lecturers.Checked;
  LECfilerSettings_dsp.visible := Lecturers.Checked;
  LECFilterClick.visible := Lecturers.Checked;
end;

procedure TFWWWGenerator.FormShow(Sender: TObject);
 var t : integer;
begin
  inherited;
  genTypeChange (nil);

  with fprogramSettings do begin
   //set by autogenerator
   if defaultFolder <> '' then folder.Text := defaultFolder;

   //empty value for variable
   if folder.Text = '' then folder.Text := uutilityParent.ApplicationDocumentsPath + profileObjectNamePeriods.Text;

   LprofileObjectNamePeriod.Caption := profileObjectNamePeriod.Text;
   //
   Groups.Caption    := profileObjectNameGs.Text + '- utwórz';
   Lecturers.Caption := profileObjectNameLs.Text + '- utwórz';
   //
   GL.Caption := profileObjectNameGs.Text;
   LL.Caption := profileObjectNameLs.Text;
  end;

  GroupsClick   (nil);
  ResourcesClick(nil);
  LecturersClick(nil);

  autocreate.GROUPSCreate;
  autocreate.ROOMSCreate('');
  autocreate.LECTURERSCreate;
  autocreate.ROOMSInit(dmodule.pResCatId0,'','0=0','');

  With LECOrderby do begin
    Strings.CommaText :=
      'Tytu³=TITLE'
   + ',Imiê=FIRST_NAME'
   + ',Nazwisko=LAST_NAME'
   + ',"Tytu³, nazwisko, imiê='+sql_LECNAME+'"';

    for t := 0 to Strings.count -1 do begin
     ComboSortOrder.Items.Add( strings.Names[t] );
    end;
    ComboSortOrder.ItemIndex := 2;
  end;

  //uFModuleFilter.initializeFilerSettings ( GROSettings.strings, 'DEFAULT' ) ;
  //uFModuleFilter.GetSQLAndNotes( GROSettings.Strings, FBrowseGROUPS.AvailColumnsWhereClause.Strings, 'DEFAULT');
  //GROfilerSettings_dsp.Text := GROSettings.Strings.Values['Notes.Category:DEFAULT'];
  formPrepared := true;
  currentPeriodChange(self);


  if FileExists(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.xslt.ini') then
  xslt.Lines.LoadFromFile(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.xslt.ini');

  if FileExists(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.css.ini') then
  xslt.Lines.LoadFromFile(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.css.ini');

  //if FileExists(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.ini') then
  //   UutilityParent.LoadFromIni (UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.ini','main',[xslt, css]);

end;

procedure setAll( L : TCheckListBox; v : boolean);
 var t : integer;
begin
  for t := 0 to L.Count - 1 do
   L.Checked[t] := v;
end;

procedure TFWWWGenerator.GROFilterClickClick(Sender: TObject);
begin
  If UFModuleFilter.ShowModal( GROSettings.Strings, FBrowseGROUPS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
     GROfilerSettings_dsp.Text := GROSettings.Strings.Values['Notes.Category:DEFAULT'];
    currentPeriodChange(self);
  End;
end;

procedure TFWWWGenerator.FormCreate(Sender: TObject);
begin
  inherited;
  defaultFolder := '';
  formPrepared  := false;
  settingsLoaded := false;
end;

procedure TFWWWGenerator.ComboSortOrderChange(Sender: TObject);
begin
  inherited;
  currentPeriodChange(self);
end;

Procedure TFWWWGenerator.CalendarToHTML(
           pPeriodId: String;
           presId : string;
           presType : string;
           D1, D2, D3, D4, D5 : shortString;
           Header, Footer : TStrings;
           ShowLegend : Boolean;
           LegendMode : Integer;
           AddCreationDate : Integer;
           ColoringIndex : shortString;
           CellWIDTH, CELLHEIGHT, CELLSIZE : ShortString;
           S1, S2, S3, S4, S5 : ShortString;
           B1, B2, B3, B4, B5 : Boolean;
           FileName : ShortString;
           pRepeatMonthNames : boolean; //powtarzaj nazwy miesiecy
           pHideEmptyRows    : boolean;  //ukrywaj puste wiersze
           pHideDows         : string;
           pSpan             : integer;  //merge
           pspanEmptyCells   : boolean;
           ptransposition : boolean;
           pVerticalLines : boolean;
           notes_before : boolean;
           notes_after : boolean;
           pdfPrintOut, pdfg, pdfl, pdfo, pdfs : boolean
    );

    Var F : TextFile;
        Status : Integer;
        Class_ : TClass_;
        sHeader, sFooter : String;
        fuse : Integer;
        currentChartClasses : tcurrentChartClasses;
        classList : TclassList;
        ReservationsCache     : tReservationsCache;

    Var Lgnd : Array Of Record Name, ShortCut : String;  Colour : Integer; End;
        LgndCnt : integer;

    //--------------------------------------------------------
    procedure htmlToPdf (fileName : String; pdfg,pdfl,pdfo,pdfs : boolean);
    Var parameters : String;
        exeName : String;
        pdfFileName : String;
    begin
      exeName := ApplicationDir+'\wkhtmltopdf.exe';
      pdfFileName := searchAndreplace(filename,'.htm','.pdf');

      parameters := '"'+filename+'" "'+ pdfFileName +'"';
      if pdfg then parameters := '-g ' + parameters;
      if pdfl then parameters := '-l ' + parameters;
      if pdfo then parameters := '-O Landscape ' + parameters;
      if pdfs then parameters := '-s A3 ' + parameters;
      if not fileexists(exeName) then info('Ups.. Utworzenie pdf nie powiedzie siê, poniewa¿ nie odnaleziono pliku: '+exeName+cr+'Je¿eli posiadasz aktywn¹ umowê serwisow¹ firma Software Factory pomo¿e w rozwi¹zaniu problemu, zadzwoñ pod numer +48 604224658. ');
      {if not fsettings.Debug.Checked then}
      //ShellApi.ShellExecute(Application.MainForm.Handle,'open',PChar(exeName), PChar(parameters),'',SW_HIDE);
      executeFileAndWait(exeName+' '+parameters);
    end;

    //--------------------------------------------------------
    function DrawRect (
      Class_ : TClass_;
      D1, D2, D3, D4, D5 : shortString;
      S1, S2, S3, S4, S5 : ShortString;
      B1, B2, B3, B4, B5 : Boolean;
      ColoringIndex : shortString;
      CellWIDTH : shortString) : string;

      function TextoutResource ( code : shortString) : string;
      begin
       if code = 'ALL_RES' then result := Class_.CALC_ROOMS
                           else result := ucommon.getResourcesByType(code, Class_.CALC_RESCAT_IDS, Class_.CALC_ROOMS );
       result := Copy(result,     1, StrToInt(NVL(GetSystemParam('MaxLengthCALC_ROOMS'),'1000')))
      end;

      procedure writeLn(s : string);
      begin
       result := result + s;
      end;

      //--------------------------------------------------------
      Procedure AddCell(Command, S, Color : String);
      Begin
        If isBlank(S) Then S := '&nbsp';
        If Color <> '0' Then Writeln( '<TD HEIGHT='+CELLHEIGHT+' WIDTH='+CellWIDTH+' '+Command+' BGCOLOR='+Color+'>'+S+'</TD>')
                        Else Writeln( '<TD HEIGHT='+CELLHEIGHT+' WIDTH='+CellWIDTH+' '+Command+' >'+S+'</TD>')
      End;

    //--------------------------------------------------------
     Procedure Common (Counter : Integer; CommonAttr : TColors);
     Var t : Integer;
         descCodes  : Array[1..5] Of ShortString;
         Sizes      : Array[1..5] Of ShortString;
         Bolds      : Array[1..5] Of Boolean;
         Colour : Integer;
         S, Token : String;
     Begin
       // for reservation show always form regardless of view settings
       If Class_.FOR_KIND = 'R' Then Begin
         AddCell('',Copy(Class_.FOR_abbreviation,1,StrToInt(NVL(GetSystemParam('MaxLengthFOR_abbreviation'),'1000'))),'silver');
         Exit;
       End;

       // dla non reservations do:
       If Counter > 0 Then
       Begin
         If ColoringIndex <> 'None' Then Begin
           Colour := 0;
           For t:=0 To Counter-1 Do Begin
             Colour := Colour + CommonAttr[t];
           End;
           Colour := Colour div Counter; //average
         End;
       End
       Else Colour := clRed {ikona alert};

       //Grid.Canvas.Font.Size := -7;
       descCodes[1] := D1;
       descCodes[2] := D2;
       descCodes[3] := D3;
       descCodes[4] := D4;
       descCodes[5] := D5;

       Sizes[1]      := S1;
       Sizes[2]      := S2;
       Sizes[3]      := S3;
       Sizes[4]      := S4;
       Sizes[5]      := S5;

       Bolds[1]      := B1;
       Bolds[2]      := B2;
       Bolds[3]      := B3;
       Bolds[4]      := B4;
       Bolds[5]      := B5;

       S := '';
       If Class_.FILL <> 100 Then S := '<FONT style="font-size:'+Sizes[1]+'px;">'+intToStr(Class_.FILL)+'%'+'</FONT>';
       For t := 1 To 5 Do Begin
         Token := '';
         if  descCodes[t]= 'L'          then Token := Copy(Class_.CALC_LECTURERS,   1, StrToInt(NVL(GetSystemParam('MaxLengthCALC_LECTURERS'),'1000')))    else
         if  descCodes[t]= 'L+'         then Token := fmain.LecToNames (Class_.calc_lec_ids)    else
         if  descCodes[t]= 'G'          then Token := Copy(Class_.CALC_GROUPS,      1, StrToInt(NVL(GetSystemParam('MaxLengthCALC_GROUPS'),'1000')))       else
         if  descCodes[t]= 'S'          then Token := Copy(Class_.SUB_abbreviation, 1, StrToInt(NVL(GetSystemParam('MaxLengthSUB_abbreviation'),'1000')))  else
         if  descCodes[t]= 'F'          then Token := Copy(Class_.FOR_abbreviation, 1, StrToInt(NVL(GetSystemParam('MaxLengthFOR_abbreviation'),'1000')))  else
         if  descCodes[t]= 'SF'         then Token := Copy(Class_.SUB_abbreviation+'('+Class_.FOR_abbreviation+')', 1, StrToInt(NVL(GetSystemParam('MaxLengthSUB_abbreviation'),'1000'))) else
         if  descCodes[t]= 'SF+'        then Token := Class_.SUB_name+'('+Class_.FOR_abbreviation+')' else
         if  descCodes[t]= 'OWNER'      then Token := Copy(Class_.Owner,            1, StrToInt(NVL(GetSystemParam('MaxLengthOwner'),'1000')))             else
         if  descCodes[t]= 'CREATED_BY' then Token := Copy(Class_.Created_by,       1, StrToInt(NVL(GetSystemParam('MaxLengthCreated_by'),'1000')))        else
         if  descCodes[t]= 'NONE'       then {}                                                                                                            else
         if  descCodes[t]= 'DESC1'      then Token := Copy(Class_.desc1,            1, StrToInt(NVL(GetSystemParam('MaxLengthDesc1'),'1000')))             else
         if  descCodes[t]= 'DESC2'      then Token := Copy(Class_.desc2,            1, StrToInt(NVL(GetSystemParam('MaxLengthDesc2'),'1000')))             else
         if  descCodes[t]= 'DESC3'      then Token := Copy(Class_.desc3,            1, StrToInt(NVL(GetSystemParam('MaxLengthDesc3'),'1000')))             else
         if  descCodes[t]= 'DESC4'      then Token := Copy(Class_.desc4,            1, StrToInt(NVL(GetSystemParam('MaxLengthDesc4'),'1000')))             else
         if  descCodes[t]= 'ALL_RES'    then Token := Copy(Class_.CALC_ROOMS,       1, StrToInt(NVL(GetSystemParam('MaxLengthCALC_ROOMS'),'1000')))
         else token := TextOutResource ( descCodes[t] );

         If Not isBlank(Token) Then Begin
           Token := '<FONT style="font-size:'+Sizes[t]+'px;">'+Token+'</FONT>';
           If Bolds[t] Then Token := '<B>'+Token+'</B>';
         End;
         S := Merge(S, Token, '<BR/>');
       End;

       If Class_.FILL <> 100 Then AddCell('BORDERCOLORDARK=red BORDERCOLORLIGHT=RED',S,DelphiColourToHTML(Colour))
                             Else AddCell('',S,DelphiColourToHTML(Colour));

     End;

    //--------------------------------------------------------
     Var CommonAttr : TColors;

    //--------------------------------------------------------
     procedure DrawL;
     var Count,t : Integer;
     begin
       Count := WordCount(Class_.CALC_LEC_IDS, [';']);
       For t := 1 To Count Do CommonAttr[t-1] := dmodule.LecturerGetColour(ExtractWord(t,Class_.CALC_LEC_IDS, [';']));
       Common(Count, CommonAttr);
     end;

    //--------------------------------------------------------
     procedure DrawG;
     var Count,t : Integer;
     begin
       Count := WordCount(Class_.CALC_GRO_IDS, [';']);
       For t := 1 To Count Do CommonAttr[t-1] := dmodule.GroupGetColour(ExtractWord(t,Class_.CALC_GRO_IDS, [';']));
       Common(Count, CommonAttr);
     end;

    //--------------------------------------------------------
     procedure DrawR;
     var Count,t : Integer;
         resourceIdList : string;
     begin
       if ColoringIndex = 'ALL_RES' then resourceIdList := Class_.CALC_ROM_IDS
                                    else resourceIdList := ucommon.getResourcesByType(ColoringIndex, Class_.CALC_RESCAT_IDS, Class_.CALC_ROM_IDS );
       Count := WordCount(resourceIdList, [';']);
       For t := 1 To Count Do CommonAttr[t-1] := dmodule.RoomGetColour(ExtractWord(t,resourceIdList, [';']));
       Common(Count, CommonAttr);
     end;

    //--------------------------------------------------------
     procedure DrawDesc;
     begin
       if ColoringIndex = 'DESC1' then begin if not isBlank(Class_.desc1) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       if ColoringIndex = 'DESC2' then begin if not isBlank(Class_.desc2) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       if ColoringIndex = 'DESC3' then begin if not isBlank(Class_.desc3) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       if ColoringIndex = 'DESC4' then begin if not isBlank(Class_.desc4) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       Common(1, CommonAttr);
     end;

    //--------------------------------------------------------
     procedure DrawS;
     begin
       CommonAttr[0] := Class_.SUB_COLOUR;
       Common(1, CommonAttr);
     end;

    //--------------------------------------------------------
     procedure DrawF;
      begin
       CommonAttr[0] := Class_.FOR_COLOUR;
       Common(1, CommonAttr);
      end;

    //--------------------------------------------------------
     procedure DrawOwner;
      begin
       CommonAttr[0] := Class_.OWNER_COLOUR;
       Common(1, CommonAttr);
      end;

    //--------------------------------------------------------
     procedure DrawCreatedBy;
      begin
       CommonAttr[0] := Class_.CREATOR_COLOUR;
       Common(1, CommonAttr);
      end;

    //--------------------------------------------------------
     procedure DrawClass;
      begin
       CommonAttr[0] := Class_.class_colour;
       Common(1, CommonAttr);
      end;

    //--------------------------------------------------------
     procedure DrawEmpty;
      begin
       Common(1, CommonAttr);
      end;

    // -------- DrawCell ---------------------------------
     Begin
      result := '';
      if ColoringIndex = 'L'          then DrawL         else
      if ColoringIndex = 'G'          then DrawG         else
      if ColoringIndex = 'S'          then DrawS         else
      if ColoringIndex = 'F'          then DrawF         else
      if ColoringIndex = 'OWNER'      then DrawOwner     else
      if ColoringIndex = 'CREATED_BY' then DrawCreatedBy else
      if ColoringIndex = 'CLASS'      then DrawClass     else
      if ColoringIndex = 'NONE'       then DrawEmpty     else
      if ColoringIndex = 'DESC1'      then DrawDesc{red color for description} else
      if ColoringIndex = 'DESC2'      then DrawDesc{red color for description} else
      if ColoringIndex = 'DESC3'      then DrawDesc{red color for description} else
      if ColoringIndex = 'DESC4'      then DrawDesc{red color for description} else
      if ColoringIndex = 'ALL_RES'    then DrawR     else DrawR;
    End;
    // -------- END DrawCell ---------------------------------

    //--------------------------------------------------------
    function RefreshLegend : integer;
      var periodClause : String;
          LegendRowNumber : Integer;
          MaxL : Integer;
          ChildsAndParents : string;
    begin
    ChildsAndParents := '('+replace(getChildsAndParents(presId, '', true, false),';',',')+')';  //2024.07.25 ignoreExclusiveParent=false
    MaxL := StrToInt(NVL(GetSystemParam('MaxLecturersInLegend'),'1000'));

    For LegendRowNumber := 1 To High(Lgnd) Do Begin
     Lgnd[LegendRowNumber].Name     := '';
     Lgnd[LegendRowNumber].ShortCut := '';
     Lgnd[LegendRowNumber].Colour   := 0;
    End;

    setLength(Lgnd, MaxLegendPositions+1);
    LegendRowNumber := 0;
    With DModule Do Begin

     periodClause  :=UCommon.getWhereClausefromPeriod('ID = ' + pPeriodId ,'CLA.');

     if presType='LEC' then
        OpenSQL('SELECT DISTINCT SUB.ID, SUB.NAME, SUB.ABBREVIATION, SUB.COLOUR '+
                '  FROM CLASSES CLA, SUBJECTS SUB, LEC_CLA '+
                ' WHERE CLA_ID = CLA.ID'+
                '   AND LEC_ID in '+ChildsAndParents+
                '   AND LEC_CLA.IS_CHILD = ''N'' '+
                '   AND CLA.SUB_ID = SUB.ID AND SUB.ID<>-1 AND SUB.ID<>-2 '+
                '   AND '+periodClause+' '+
                'ORDER BY SUB.NAME');

      if presType='GRO' then
        OpenSQL('SELECT DISTINCT SUB.ID, SUB.NAME, SUB.ABBREVIATION, SUB.COLOUR '+
                '  FROM CLASSES CLA, SUBJECTS SUB, GRO_CLA '+
                ' WHERE CLA_ID = CLA.ID'+
                '   AND GRO_ID in '+ChildsAndParents+
                '   AND GRO_CLA.IS_CHILD = ''N'' '+
                '   AND CLA.SUB_ID = SUB.ID AND SUB.ID<>-1 AND SUB.ID<>-2 '+
                '   AND '+periodClause+' '+
                'ORDER BY SUB.NAME');

      if presType='ROM' then
        OpenSQL('SELECT DISTINCT SUB.ID, SUB.NAME, SUB.ABBREVIATION, SUB.COLOUR '+
                '  FROM CLASSES CLA, SUBJECTS SUB, ROM_CLA '+
                ' WHERE CLA_ID = CLA.ID'+
                '   AND ROM_ID in '+ChildsAndParents+
                '   AND ROM_CLA.IS_CHILD = ''N'' '+
                '   AND CLA.SUB_ID = SUB.ID AND SUB.ID<>-1 AND SUB.ID<>-2 '+
                '   AND '+periodClause+' '+
                'ORDER BY SUB.NAME');

     While Not QWork.Eof Do Begin
      LegendRowNumber := LegendRowNumber + 1;
      if LegendRowNumber > MaxLegendPositions then begin
       //SError('Wyst¹pi³o zdarzenie "t > MaxLegendPositions"(1). t = '+inttostr(t)+', zg³oœ problem serwisowi');
       MaxLegendPositions := MaxLegendPositions + 100;
       setLength(Lgnd, MaxLegendPositions+1);
      end;
      Lgnd[LegendRowNumber].Name     := QWork.Fields[1].AsString;

      if (D1='SF+') OR (D2='SF+') OR (D3='SF+') OR (D4='SF+') OR (D5='SF+') then
        Lgnd[LegendRowNumber].ShortCut := ''
      else
        Lgnd[LegendRowNumber].ShortCut := QWork.Fields[2].AsString;

      Lgnd[LegendRowNumber].Colour   := QWork.Fields[3].AsInteger;

      LegendRowNumber := LegendRowNumber + 1;
      if LegendRowNumber > MaxLegendPositions then begin
       MaxLegendPositions := MaxLegendPositions + 100;
       setLength(Lgnd, MaxLegendPositions+1);
      end;
      Lgnd[LegendRowNumber].Name     := '';
      Lgnd[LegendRowNumber].ShortCut := '';
      Lgnd[LegendRowNumber].Colour   := 0;

      //no summary mode
      if (LegendMode and 1 = 0) then begin
        if presType='LEC' then
         OpenSQL2('SELECT DISTINCT lec.abbreviation, '+sql_LECNAME+' NAME, NULL '+
                  'FROM CLASSES CLA'+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC'+
                  '   , LEC_CLA LEC_CLA2 '+   //  LEC_CLA2 >- CLA -< LEC_CLA >- LEC
                  'WHERE LEC_CLA2.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA2.LEC_ID in '+ChildsAndParents+
                    'AND CLA.SUB_ID     = :SUB_ID '+
                    'AND '+periodClause+' '+
                  'ORDER BY 1'
                , 'SUB_ID='+QWork.Fields[0].AsString);

        if presType='GRO' then
         OpenSQL2('SELECT DISTINCT lec.abbreviation, '+sql_LECNAME+' NAME, NULL '+
                  'FROM CLASSES CLA'+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC'+
                  '   , GRO_CLA '+   //  GRO_CLA >- CLA -< LEC_CLA >- LEC
                  'WHERE GRO_CLA.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID =  CLA.ID '+
                    'AND GRO_CLA.GRO_ID in '+ChildsAndParents+
                    'AND CLA.SUB_ID     = :SUB_ID '+
                    'AND '+periodClause+' '+
                  'ORDER BY 1'
                , 'SUB_ID='+QWork.Fields[0].AsString);

        if presType='ROM' then
         OpenSQL2('SELECT DISTINCT lec.abbreviation, '+sql_LECNAME+' NAME, NULL '+
                  'FROM CLASSES CLA'+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC'+
                  '   , ROM_CLA '+   //  ROM_CLA >- CLA -< LEC_CLA >- LEC
                  'WHERE ROM_CLA.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID =  CLA.ID '+
                    'AND ROM_CLA.ROM_ID in '+ChildsAndParents+
                    'AND CLA.SUB_ID     = :SUB_ID '+
                    'AND '+periodClause+' '+
                  'ORDER BY 1'
                , 'SUB_ID='+QWork.Fields[0].AsString);
      end;

      //summary mode
      if (LegendMode and 1 = 1) then begin
        if presType='LEC' then
         OpenSQL2('SELECT lec.abbreviation, '+sql_LECNAME+' NAME, FORM.abbreviation || '' '' || SUM(GRIDS.DURATION*CLA.FILL/100), FORM.SORT_ORDER_ON_REPORTS '+
                  'FROM CLASSES CLA'+
                  '   , FORMS FORM'+
                  '   , GRIDS '+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC'+
                  '   , LEC_CLA LEC_CLA2 '+   //  LEC_CLA2 >- CLA -< LEC_CLA >- LEC
                  'WHERE LEC_CLA2.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID(+) =  CLA.ID '+
                    'AND LEC_CLA2.LEC_ID in '+ChildsAndParents+
                    'AND CLA.SUB_ID     = :SUB_ID '+
                    'AND LEC_CLA.IS_CHILD = ''N'' '+
                    'AND '+periodClause+' '+
                    'AND FORM.ID = CLA.FOR_ID '+
                    'and cla.hour = grids.no '+
                    'GROUP BY lec.abbreviation, LEC.TITLE, LEC.FIRST_NAME, LEC.LAST_NAME,FORM.abbreviation,FORM.SORT_ORDER_ON_REPORTS '+
                  'ORDER BY FORM.SORT_ORDER_ON_REPORTS'
                , 'SUB_ID='+QWork.Fields[0].AsString);
        if presType='GRO' then
         OpenSQL2('SELECT lec.abbreviation, '+sql_LECNAME+' NAME, FORM.abbreviation|| '' '' || SUM(GRIDS.DURATION*CLA.FILL/100), FORM.SORT_ORDER_ON_REPORTS '+
                  'FROM CLASSES CLA'+
                  '   , FORMS FORM'+
                  '   , GRIDS '+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC'+
                  '   , GRO_CLA '+   //  GRO_CLA >- CLA -< LEC_CLA >- LEC
                  'WHERE GRO_CLA.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID(+) =  CLA.ID '+
                    'AND GRO_CLA.GRO_ID in '+ChildsAndParents+
                    'AND CLA.SUB_ID     = :SUB_ID '+
                    'AND GRO_CLA.IS_CHILD = ''N'' '+
                    'AND '+periodClause+' '+
                    'AND FORM.ID = CLA.FOR_ID '+
                    'and cla.hour = grids.no '+
                    'GROUP BY lec.abbreviation, LEC.TITLE, LEC.FIRST_NAME, LEC.LAST_NAME,FORM.abbreviation,FORM.SORT_ORDER_ON_REPORTS '+
                  'ORDER BY FORM.SORT_ORDER_ON_REPORTS'
                , 'SUB_ID='+QWork.Fields[0].AsString);
        if presType='ROM' then
         OpenSQL2('SELECT lec.abbreviation, '+sql_LECNAME+' NAME, FORM.abbreviation|| '' '' || SUM(GRIDS.DURATION*CLA.FILL/100), FORM.SORT_ORDER_ON_REPORTS '+
                  'FROM CLASSES CLA'+
                  '   , FORMS FORM'+
                  '   , GRIDS '+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC'+
                  '   , ROM_CLA '+   //  ROM_CLA >- CLA -< LEC_CLA >- LEC
                  'WHERE ROM_CLA.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID(+) =  CLA.ID '+
                    'AND ROM_CLA.ROM_ID in '+ChildsAndParents+
                    'AND CLA.SUB_ID     = :SUB_ID '+
                    'AND ROM_CLA.IS_CHILD = ''N'' '+
                    'AND '+periodClause+' '+
                    'AND FORM.ID = CLA.FOR_ID '+
                    'and cla.hour = grids.no '+
                    'GROUP BY lec.abbreviation, LEC.TITLE, LEC.FIRST_NAME, LEC.LAST_NAME,FORM.abbreviation,FORM.SORT_ORDER_ON_REPORTS '+
                  'ORDER BY FORM.SORT_ORDER_ON_REPORTS'
                , 'SUB_ID='+QWork.Fields[0].AsString);
      end;


      fuse := 1;
      While Not QWork2.Eof Do Begin

        //2023.04.03 Split (rather than aggregate) the list of lecturers in the legend
        if (fuse > 1) then begin
          LegendRowNumber := LegendRowNumber + 1;
          if LegendRowNumber > MaxLegendPositions then begin
           MaxLegendPositions := MaxLegendPositions + 100;
           setLength(Lgnd, MaxLegendPositions+1);
          end;
        end;

        Lgnd[LegendRowNumber].Name     := Merge(Lgnd[LegendRowNumber].Name,QWork2.Fields[1].AsString,'<BR/>');

        if (LegendMode and 2 = 2) then
            Lgnd[LegendRowNumber].shortcut := Merge(Lgnd[LegendRowNumber].shortcut,QWork2.Fields[0].AsString,'<BR/>');

        if (LegendMode and 1 = 1) then
            Lgnd[LegendRowNumber].shortcut := Merge(Lgnd[LegendRowNumber].shortcut,QWork2.Fields[2].AsString,'<BR/>');

        Qwork2.Next;
        fuse := fuse + 1;
        If fuse > MaxL Then Begin Lgnd[LegendRowNumber].Name := Lgnd[LegendRowNumber].Name + ' ...'; Break; End;
      End;

      Qwork.Next;
     End;
    End;

    result := LegendRowNumber;

    For LegendRowNumber := 1 To High(Lgnd) Do Begin
     If Not isBlank(Lgnd[LegendRowNumber].Name) Then Lgnd[LegendRowNumber].Name     := '<P align=left>'+Lgnd[LegendRowNumber].Name+'</P>';
    End;
    end; //RefreshLegend

Var xp, yp          : Integer;
    legendRow       : Integer;
    i               : integer;
    priorDayOfWeek  : integer;
    currentDayOfWeek: integer;
    showLine        : boolean;
    cellPrior       : string;
    uniqueCnt       : integer;
    cellCurrent     : string;
    cells           : string;
    htmlTable       : thtmlTable;
    notesBeforeText : string;
    notesAfterText  : string;
    tmp             : integer;
    dummy          : integer;
    colCnt, rowCnt : integer;
    addECTSflag    : boolean;

    //--------------------------------------------------------
    procedure addMonthsRow (addECTSflag: boolean);
    Var xp     : Integer;
    Var SPAN   : Integer;
        oldMonthName : ShortString;
        newMonthName : ShortString;
        dummy : integer;
    begin
        //Names of months
        htmlTable.AddRow('ALIGN="center" VALIGN="middle"');

        htmlTable.newCellWidth('','','silver',  NVL(GetSystemParam('CellWidthDay'),'0') );
        htmlTable.newCellWidth('','','silver',  NVL(GetSystemParam('CellWidthHour'),'0') );
        //ConvertDateColRow.ColRowToDate(TS,Zajecia,0+2,0);
        oldMonthName := GetLongMonthName(convertGrid.convertSingleObject.ColRowDate[1].Date);
        newMonthName := oldMonthName;
        SPAN := 0;
        For xp:=0+2 To colCnt-1 Do Begin
          If convertGrid.ColRowToDate(dummy, TS,Zajecia,xp,0) = ConvHeader Then
            newMonthName := GetLongMonthName(TS.Date);
          If newMonthName = oldMonthName Then Begin
           SPAN := SPAN + 1;
           // add spaned cell to be compilant with span algorythm
           htmlTable.newHeaderCell('ALIGN="CENTER"',oldMonthName,'0',1,1,true);
          End Else Begin
           htmlTable.newHeaderCell('ALIGN="CENTER"',oldMonthName,'0',SPAN,1,false);
           oldMonthName := newMonthName;
           SPAN := 1;
          End;
        End;
        htmlTable.newHeaderCell('ALIGN="CENTER" COLSPAN="'+IntToStr(SPAN)+'"',oldMonthName,'0');

        if ShowLegend then begin
          htmlTable.newCell('','','0');
          htmlTable.newCellWidth('','','0',NVL(GetSystemParam('CellWidthInLegend'),'100'));
          if (addECTSflag) then begin
            htmlTable.newCell('','Spos.<br/>zal.','0');
            htmlTable.newCell('','ECTS','0');
          end;
        end;
    end;

    //--------------------------------------------------------
    procedure calculateVerticalLines;
    Var xp     : Integer;
    Var oldMonthName : ShortString;
        newMonthName : ShortString;
        dummy : integer;
    begin
      htmlTable.verticalLines := ',';
      oldMonthName := GetLongMonthName(convertGrid.convertSingleObject.ColRowDate[1].Date);
      newMonthName := oldMonthName;
      For xp:=0+2 To colCnt-1 Do Begin
        If convertGrid.ColRowToDate(dummy, TS,Zajecia,xp,0) = ConvHeader Then
          newMonthName := GetLongMonthName(TS.Date);
        If newMonthName = oldMonthName Then Begin
         {};
        End Else Begin
         oldMonthName := newMonthName;
         htmlTable.verticalLines := htmlTable.verticalLines + intToStr(xp-1)+',';
        End;
      End;
    end;

    //--------------------------------------------------------
    procedure addLegendRow (addECTSflag : Boolean);
    Begin

      If Lgnd[legendRow].Colour = 0 Then Begin
		      htmlTable.newCell(
            //mergeWith attribute is to avoid merge for cells inside legend
			      'WIDTH="'+CellWIDTH +'" mergeWith="'+Lgnd[legendRow].Name+'"'
			      ,Lgnd[legendRow].ShortCut
			      ,'0'
		      );
		     htmlTable.newCellWidth(
			      ''
			     ,'<FONT style="font-size:'+IntToStr(StrToInt(CELLSIZE)-2)+'px;">'+NVL(Lgnd[legendRow].Name,'&nbsp')+'</FONT>'
			     ,'0'
			     , NVL(GetSystemParam('CellWidthInLegend'),'100')
		      );
      End
      Else Begin
		      htmlTable.newCell(
            //mergeWith attribute is to avoid merge for cells inside legend
			       'WIDTH="'+CellWIDTH +'" mergeWith="'+Lgnd[legendRow].Name+'"'
			      ,Lgnd[legendRow].ShortCut
			      ,DelphiColourToHTML(Lgnd[legendRow].Colour)
		      );
		      htmlTable.newCellWidth(
			      ''
			     ,'<FONT style="font-size:'+CELLSIZE+'px;"><B>'+NVL(Lgnd[legendRow].Name,'&nbsp')+'</B></FONT>'
			     ,'0'
			     ,NVL(GetSystemParam('CellWidthInLegend'),'100')
		      );
      End;
      if (addECTSflag) then begin
          htmlTable.newCell('','','0');
          htmlTable.newCell('','','0');
      end;

    End;

    var     tmpPERName    : string;
    var     tmpLECName    : string;
    var     tmpGROName    : string;
    var     tmpROMName    : string;

    function replacePlaceHolders(s : string) : string;
    begin
     result := SearchAndReplace(s,'_','&nbsp;');
     result := SearchAndReplace(result,'%PERIOD',tmpPERName);
     result := SearchAndReplace(result,'%LECTURER',tmpLECName);
     result := SearchAndReplace(result,'%GROUP',tmpGROName);
     result := SearchAndReplace(result,'%ROOM',tmpROMName);
     //pure txt text
     if (pos('<',result)=0) and (pos('>',result)=0) then
       result := SearchAndReplace(result,#13#10, '<br/>');
    end;

//-------------------------------------------------------------------------------------------
begin
 addECTSflag := (LegendMode and 4 = 4);
 currentChartClasses := tcurrentChartClasses.create();
 ReservationsCache := tReservationsCache.Create;
 //If Not (fmain.TabViewType.TabIndex in [0,1,2,3]) Then Begin
 //  Info( format('Zaznacz kalendarz %s, %s lub zasobu', [fprogramSettings.profileObjectNameLgen.Text, fprogramSettings.profileObjectNameGgen.Text]) );
 // Exit;
 //End;

 currentChartClasses.init(sqlHolder.Lines.Text, pPeriodId, presId, presType, FWWWGenerator);
 ReservationsCache.ReservationsCacheLoadPeriod(pPeriodId);

 if (presType='LEC') then convertGrid.setupGrid (pPeriodId, true, 0, '', colCnt, rowCnt);
 if (presType='GRO') then convertGrid.setupGrid (pPeriodId, true, 1, '', colCnt, rowCnt);
 if (presType='ROM') then convertGrid.setupGrid (pPeriodId, true, 2, '', colCnt, rowCnt);

 If ShowLegend Then LgndCnt := RefreshLegend;

 AssignFile(F, FileName);
 Rewrite(F);
 Writeln(f, '<!DOCTYPE html>');
 WriteLn(f, '<HTML>');

 WriteLn(f, '<HEAD>');
 WriteLn(f, '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">');
 WriteLn(f, '<TITLE>Plansoft.org - '+ fprogramSettings.profileObjectNameClassgen.Text +'</TITLE>');

WriteLn(f, ' <style>');
WriteLn(f, 'table, td, th {');
WriteLn(f, '  border: 1px solid black;');
WriteLn(f, '}');

WriteLn(f, 'table {');
WriteLn(f, '  width: 100%;');
WriteLn(f, '  border-collapse: collapse;');
WriteLn(f, '  padding: 0px;');
WriteLn(f, '  margin:0 auto;');
//the combination of height: 1px; (parent table) and height: 100% (child table) streaches the child table to entire available area
//see https://limebrains.com/blog/2021-03-02T13:00-heigh-100-inside-table-td/
WriteLn(f, '  height: 1px;');
WriteLn(f, '}');
WriteLn(f, '</style>');

 WriteLn(f, '</HEAD>');
 WriteLn(f, '<BODY>');

 tmpPERName := DModule.SingleValue(sql_PERDESC+pPeriodId);
 if pResType='LEC' then tmpLECName := DModule.SingleValue(sql_LECDESC+presId);
 if pResType='GRO' then tmpGROName := DModule.SingleValue(sql_GRODESC+presId);
 if pResType='ROM' then tmpROMName := DModule.SingleValue(sql_ResCat0DESC+presId);
 setStatus('Tworzenie kalendarza:'+tmpLECName+tmpGROName+tmpROMName);

 notesBeforeText := '';
 notesAfterText := '';


 if (notes_before or notes_after) then begin
   //if not elementEnabled('"Nag³ówki rozk³adów zajêæ"','2015.12.04', true) then begin
   //  info('Nie mo¿esz korzystaæ z funkcji "Nag³ówki rozk³adów zajêæ", skontaktuj siê z dostawc¹ oprogramowania',showOnceaday);
   //  notes_before := false;
   //  notes_after := false;
   //end;
    dmodule.openSQL(
         'select id, per_id, res_id, notes_before, notes_after, internal_notes from timetable_notes where per_id=:per_id and res_id=:res_id' ,
         'per_id='+ pPeriodId+
         ';res_id='+ pResId
         );
    notesBeforeText := replacePlaceHolders( dmodule.QWork.fieldByName('notes_before').AsString);
    notesAfterText :=  replacePlaceHolders( dmodule.QWork.fieldByName('notes_after').AsString)
  End;

 If Assigned(Header) Then sHeader := replacePlaceHolders(Header.Text);
 If Assigned(Footer) Then sFooter := replacePlaceHolders(Footer.Text);

 If Assigned(Header) Then WriteLn(F, sHeader);
 if (notes_before) then WriteLn(F, notesBeforeText);
 if addCreationDate=1 then writeLn(f,'<br/><div style="font-size:10px;">'+'Data aktualizacji: '+DateTimeToStr(Now())+'</div>');

 WriteLn(f, '<table style="font-size:'+CELLSIZE+'px;">');

 htmlTable := thtmlTable.create;
 htmlTable.init (CellWIDTH, CellHeight, pspanEmptyCells);

 if not pRepeatMonthNames then addMonthsRow(addECTSflag);
 if pVerticalLines then calculateVerticalLines;

 legendRow := 0;


 For yp:=0 To rowCnt-1 Do Begin

  //there are no classes in line ? hide this line
  if pHideEmptyRows then begin
    showLine := false;
    For xp:=0 To colCnt-1 Do Begin
      if convertGrid.ColRowToDate(dummy, TS, Zajecia, xp, yp ) = ConvClass then begin
         tmp := DayOfWeek(TimeStampToDateTime(TS));
         //tmp=2(Monday) => pHideDows[2] = '-' => not selected to merge
         if pHideDows[tmp]='-' then showLine := true
         else begin
           classList := currentChartClasses.get(TS, Zajecia);
           if (classList.cnt>0) then showLine := true;
         end;
      end;
      if Zajecia = 0 then showLine := true;
    end;
  end else showLine := true;

  //addMonthHeader
  if pRepeatMonthNames then begin
    if showLine then begin
        if convertGrid.ColRowToDate(dummy, TS,Zajecia,0,yp) = ConvDayOfWeek then begin
          currentDayOfWeek := DayOfWeek(TimeStampToDateTime(TS));
          if priorDayOfWeek <> currentDayOfWeek then begin
            addMonthsRow (addECTSflag);
            priorDayOfWeek := currentDayOfWeek;
          end;
        end;
    end;
  end;

  if showLine then begin
  htmlTable.AddRow('ALIGN="center" VALIGN="middle"'); //style="display:none;"
  //content
  For xp:=0 To colCnt-1 Do Begin
   Case convertGrid.ColRowToDate(dummy, TS,Zajecia,xp,yp) Of
    ConvDayOfWeek: begin
                     // in pHideEmptyRows mode disable rowspan
                     if pHideEmptyRows
                     then begin If TS.Date<>-1 Then htmlTable.newCell('',ShortDayNames[DayOfWeek(TimeStampToDateTime(TS))],'silver'); end
                     else begin
                            If TS.Date<>-1 Then begin
                              If Zajecia=0
                                Then htmlTable.newCell('',ShortDayNames[DayOfWeek(TimeStampToDateTime(TS))],'silver', 1, HOURS_PER_DAY+1, false)
                                // add spaned cells with ignoreflag=true to be compilant with span algorythm
                                else htmlTable.newCell('',ShortDayNames[DayOfWeek(TimeStampToDateTime(TS))],'silver', 1, 1, true);
                            end;
                          end;
                   end;
    ConvNumeryZajec: begin
                       If Zajecia<>0 Then htmlTable.newCell('',opisujKolumneZajec.Str(Zajecia),'silver') Else htmlTable.newCell('','&nbsp','0');
                     end;
    convOutOfRange : Begin
                       htmlTable.newCell('background="outofrange.gif"','','silver');
                     End;
    ConvHeader     : Begin
                      //htmlTable.addCell('',GetDay(TS.Date),'silver');
                      htmlTable.newCell('',GetDate(TS.Date),'silver');
                     End;
    ConvClass:
     Begin
      classList := currentChartClasses.get(TS, Zajecia);
      if (classList.cnt=0) then
       begin
         If ReservationsCache.IsReserved(TS, Zajecia)<>'' Then htmlTable.newCell('background="reservation.gif"','','0') Else htmlTable.newCell('','','0');
       end
       else begin
         if (classList.cnt=1) then begin
           Class_ := classList.classes[0];
           cellCurrent :=
             DrawRect (Class_
               ,D1, D2, D3, D4, D5
               ,S1, S2, S3, S4, S5
               ,B1, B2, B3, B4, B5
               , ColoringIndex
               , CellWIDTH);
               cellCurrent := StringReplace(cellCurrent, '<TD ', '<TD ROWSPAN="?" COLSPAN="?"', [rfReplaceAll, rfIgnoreCase]);
               htmlTable.writeCell(cellCurrent);
         end else begin
           cells := '';
           cellPrior := '';
           uniqueCnt := 0;
           for i := 0 to classList.cnt-1 do begin
             Class_ := classList.classes[i];
             cellCurrent :=
               DrawRect (Class_
                 ,D1, D2, D3, D4, D5
                 ,S1, S2, S3, S4, S5
                 ,B1, B2, B3, B4, B5
                 , ColoringIndex
                 , CellWIDTH);
               if cellPrior <> cellCurrent then begin
                 cells := cells + '<td_removed>'+cellCurrent+'</td_removed>';
                 uniqueCnt := uniqueCnt + 1;
               end;
             cellPrior := cellCurrent;
           end;

           if (uniqueCnt>1) then begin
             htmlTable.writeCell('<td ROWSPAN="?" COLSPAN="?"><table style="border: 0px; width:100%; height: 100%"><tr>'+cells+'</tr></table></td>');
           end else begin
             //uniqueCnt=1
             cellCurrent := StringReplace(cellCurrent, '<TD ', '<TD ROWSPAN="?" COLSPAN="?"', [rfReplaceAll, rfIgnoreCase]);
             htmlTable.writeCell(cellCurrent);
           end;

         end;
       end;

     End;
    end;
  End; //for
  if showLine then
    if ShowLegend Then Begin
      legendRow := legendRow + 1;
      addLegendRow(addECTSflag);
    End;
  //Writeln(f, '</TR>');
  end; // if showLine
  end; //For yp:=0 To RowCount-1 Do

  {add missing legend items here}
  if ShowLegend Then
  While legendRow<LgndCnt do begin
       htmlTable.AddRow('ALIGN="center" VALIGN="middle"'); //style="display:none;"
       For xp:=0 To colCnt-1 Do Begin
          htmlTable.newCell('','','silver');
       End;
       legendRow := legendRow + 1;
       AddLegendRow(addECTSflag);
  end;


 if ptransposition then htmlTable.transposite;
 case pSpan of
  0:begin
      htmlTable.colSpan;
      htmlTable.rowSpan;
    end;
  1:begin
    end;
  2:begin
      htmlTable.colSpan;
    end;
  3:begin
      htmlTable.rowSpan;
    end;
  4:begin
      htmlTable.colSpan;
      htmlTable.rowSpan;
    end;
  5:begin
      htmlTable.rowSpan;
      htmlTable.colSpan;
    end;
  else {}
 end;

 Writeln(f, htmlTable.Flush);
 htmlTable.free;

 WriteLn(f, '</TABLE></FONT>');
 If Assigned(Footer) Then WriteLn(F, sFooter);
 if (notes_after) then WriteLn(F, notesAfterText);
 if addCreationDate=0 then writeLn(f,'<FONT style="font-size:10px;">'+'Data aktualizacji: '+DateTimeToStr(Now())+'</FONT>');
 writeLn(f,'<hr/><FONT style="font-size:10px;">'+'Dokument zosta³ utworzony za pomoc¹ programu <a href="http://www.plansoft.org">Plansoft.org</a></FONT>');

 WriteLn(f, '</BODY></HTML>');

 CloseFile(f);

 if pdfPrintOut then htmlToPdf(fileName, pdfg,pdfl,pdfo,pdfs);
 //UUTilityParent.ExecuteFile('winword.exe','c:\test.htm','',SW_SHOWMAXIMIZED);
 currentChartClasses.free;
 ReservationsCache.Free;
end;

procedure TFWWWGenerator.genTypeChange(Sender: TObject);
begin
  tsWWW.TabVisible := true;
  tsGoogle.TabVisible := false;

  case genType.ItemIndex of
   0: begin
        FWWWGenerator.Caption := 'Tworzenie witryny www';
      end;
   1: begin
        FWWWGenerator.Caption := 'Eksport do iKalendarz';
      end;
  end;

  tabsheet2.TabVisible  := genType.ItemIndex =0;
  tabsheet3.TabVisible  := genType.ItemIndex =0;
end;

procedure TFWWWGenerator.BCreateClick(Sender: TObject);
var ColoringIndex    : shortString;


    procedure generateIcsCalendars;
    var queryClasses : tadoquery;
        outf : textFile;
        Class_ : TClass_;

        // ------------------------------------------------------
       procedure write(m : string);
       begin
          if (trim(m)<>'') then
             WriteLn(outf, UTF8Encode(trim(m)));
        end;

        procedure tableOfContens;
        var t : integer;
            f : textFile;
        begin
          AssignFile(F, Folder.Text+'\layout.xslt');
          Rewrite(F);
          WriteLn(f,
             replace(
               replace(xslt.Lines.Text
                 ,'%R1.', fprogramsettings.profileObjectNameLs.Text)
               ,'%R2.', fprogramsettings.profileObjectNameGs.Text)
          );
          CloseFile(F);

          assignFile(F, Folder.Text+'\menu.css');
          Rewrite(F);
          WriteLn(f, css.Lines.Text);
          CloseFile(F);

          if DoNotGenerateTableOfCon.Checked then   AssignFile(F, Folder.Text+'\eraseme.htm')
                                             else   AssignFile(F, Folder.Text+'\index.xml');
          Rewrite(F);
          WriteLn(f, '<?xml version="1.0" encoding="windows-1250"?>');
          WriteLn(f, '<?xml-stylesheet type="text/xsl" href="layout.xslt"?>');
          WriteLn(f, '<xml>');
          WriteLn(f, '<title name="Plansoft.org - '+fprogramSettings.profileObjectNameClassgen.Text+'"></title>');
          WriteLn(f, '<period name="'+XMLescapeChars(currentPeriod_VALUE.Text)+'"></period>');
          WriteLn(f, '<description text="'+XMLescapeChars(AddText.Text)+'"></description>');
          WriteLn(f, '<data>');
             If Groups.Checked Then Begin
               for t := 0 to GList.Count - 1 do begin
                 if GList.Checked[t] then begin
                   WriteLn(F, '  <gro href="'+XMLescapeChars(StringToValidFileName(GList.Items[t]))+'.ics'+'" text="'+XMLescapeChars(GList.Items[t])+'"/>');
                 end;
               end;
             end;
             If lecturers.Checked Then Begin
               for t := 0 to LList.Count - 1 do begin
                 if LList.Checked[t] then begin
                   WriteLn(F, '  <lec href="'+XMLescapeChars(StringToValidFileName(LList.Items[t]))+'.ics'+'" text="'+XMLescapeChars(LList.Items[t])+'"/>');
                 end;
               end;
             end;
              If Resources.Checked Then Begin
               for t := 0 to RList.Count - 1 do begin
                 if RList.Checked[t] then begin
                   WriteLn(F, '  <res href="'+XMLescapeChars(StringToValidFileName(RList.Items[t]))+'.ics'+'" text="'+XMLescapeChars(RList.Items[t])+'"/>');
                 end;
               end;
              end;
          WriteLn(f, '</data>');
          WriteLn(f, '<who lastupdatetext="Aktualizacja: '+DateTimeToStr(Now())+'"></who>');
          WriteLn(f, '<extraText text="Plik iKalendarza mog¹ byæ otwierane w Microsoft Outlook, Google Kalendarz, Apple iCal oraz Mozilla Calendar"></extraText>');
          WriteLn(f, '<href1 href="https://support.google.com/calendar/answer/37118?hl=pl" text="Kliknij w ten link aby dowiedzieæ siê jak zaimportowaæ rozk³ad zajêæ do Google Kalendarza"  ></href1>');
          WriteLn(f, '<href2 href="http://calendar.zoznam.sk/icalendar/ical-pl.php" text="Kliknij w ten link aby dowiedzieæ siê jeszcze wiêcej na temat iKalendarzy"  ></href2>');


          WriteLn(f, '</xml>');

          flush(f);
          CloseFile(F);
          if not fmain.silentMode then begin
              ShowFolder(Folder.Text);
              if defaultBrowserIsChrome then begin
                  info('Zrobione! Otwórz plik index.html za pomoc¹ Internet Explorer lub Firefox lub umieœæ go na serwerze www. Wiêcej na ten temat w podrêczniku u¿ytkownika');
              end;
              uUtilityParent.ExecuteFile(Folder.Text+'\index.xml','','',SW_SHOWMAXIMIZED);
          end;
        end;

        // ------------------------------------------------------
        procedure recreateCalendar( calendarName : string);
        begin
          setStatus('Tworzenie kalendarza: ' + calendarName);
          write('BEGIN:VCALENDAR');

          write('PRODID:-//Google Inc//Google Calendar 70.9054//EN');
          write('VERSION:2.0');
          write('CALSCALE:GREGORIAN');
          write('METHOD:PUBLISH');
          write('X-WR-CALNAME:'+ calendarName);
          write('X-WR-TIMEZONE:Europe/Warsaw');
          write('X-WR-CALDESC:'+'Kalendarz zosta³ utworzony za pomoc¹ programu www.Plansoft.org\nCalendar has been created by www.Plansoft.org');
          write('BEGIN:VTIMEZONE');
          write('TZID:Europe/Warsaw');
          write('X-LIC-LOCATION:Europe/Warsaw');
          write('BEGIN:DAYLIGHT');
          write('TZOFFSETFROM:+0100');
          write('TZOFFSETTO:+0200');
          write('TZNAME:CEST');
          write('DTSTART:19700329T020000');
          write('RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU');
          write('END:DAYLIGHT');
          write('BEGIN:STANDARD');
          write('TZOFFSETFROM:+0200');
          write('TZOFFSETTO:+0100');
          write('TZNAME:CET');
          write('DTSTART:19701025T030000');
          write('RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU');
          write('END:STANDARD');
          write('END:VTIMEZONE');
        end;

        // ------------------------------------------------------
        function TextoutResource ( code : shortString; plabel : shortString; Class_ : TClass_; presources : string) : string;
        begin
          if plabel <> '' then plabel := plabel + ': ';
          if code = 'ALL_RES' then result := plabel + presources
                              else result := plabel + ucommon.getResourcesByType(code, Class_.CALC_RESCAT_IDS, presources );
        end;
        // ------------------------------------------------------
        function getEventDescription(codes, combovalues : array of shortString; pTS : TTimeStamp; pZajecia: Integer; plecturers, pgroups, presources : string) : string;
        var t : integer;
            Token, s : string;
            Status : Integer;
        begin

         //Remove EOLS from the subject Name
         Class_.SUB_NAME := SearchAndReplace(Class_.SUB_NAME,char(10),'');

         For t := 0 To high(codes) Do Begin
           if  codes[t]= 'L'          then Token := combovalues[t] + ': ' + plecturers        else
           if  codes[t]= 'L+'         then Token := combovalues[t] + ': ' + plecturers        else
           if  codes[t]= 'G'          then Token := combovalues[t] + ': ' + pgroups           else
           if  codes[t]= 'S'          then Token := combovalues[t] + ': ' + Class_.SUB_NAME   else
           if  codes[t]= 'F'          then Token := combovalues[t] + ': ' + Class_.FOR_NAME   else
           if  codes[t]= 'SF'         then Token := combovalues[t] + ': ' + Class_.SUB_NAME+'('+Class_.FOR_NAME+')' else
           if  codes[t]= 'SF+'         then Token := combovalues[t] + ': ' + Class_.SUB_NAME+'('+Class_.FOR_NAME+')' else
           if  codes[t]= 'OWNER'      then Token := combovalues[t] + ': ' + Class_.Owner      else
           if  codes[t]= 'CREATED_BY' then Token := combovalues[t] + ': ' + Class_.Created_by else
           if  codes[t]= 'NONE'       then {}                                else
           if  codes[t]= 'DESC1'      then Token := combovalues[t] + ': ' + Class_.desc1      else
           if  codes[t]= 'DESC2'      then Token := combovalues[t] + ': ' + Class_.desc2      else
           if  codes[t]= 'DESC3'      then Token := combovalues[t] + ': ' + Class_.desc3      else
           if  codes[t]= 'DESC4'      then Token := combovalues[t] + ': ' + Class_.desc4      else
           if  codes[t]= 'ALL_RES'    then Token := combovalues[t] + ': ' + presources
           else token := TextOutResource ( codes[t], combovalues[t], Class_, presources);

           S := Merge(S, Token, '\r\n');
         End;
         result := s;
        end;

        // ------------------------------------------------------
        function getEventTitle(code : shortString; pTS : TTimeStamp; pZajecia: Integer; plecturers, pgroups, presources : string) : string;
        var Token  : string;
            Status : Integer;
        begin
           //Remove EOLS from the subject Name
           Class_.SUB_NAME := SearchAndReplace(Class_.SUB_NAME,char(10),'');

           Token := '';
           if  code= 'L'          then Token := plecturers        else
           if  code= 'L+'          then Token := plecturers        else
           if  code= 'G'          then Token := pgroups           else
           if  code= 'S'          then Token := Class_.SUB_NAME   else
           if  code= 'F'          then Token := Class_.FOR_NAME   else
           if  code= 'SF'         then Token := Class_.SUB_NAME+'('+Class_.FOR_NAME+')' else
           if  code= 'SF+'        then Token := Class_.SUB_NAME+'('+Class_.FOR_NAME+')' else
           if  code= 'OWNER'      then Token := Class_.Owner      else
           if  code= 'CREATED_BY' then Token := Class_.Created_by else
           if  code= 'NONE'       then {}                         else
           if  code= 'DESC1'      then Token := Class_.desc1      else
           if  code= 'DESC2'      then Token := Class_.desc2      else
           if  code= 'DESC3'      then Token := Class_.desc3      else
           if  code= 'DESC4'      then Token := Class_.desc4      else
           if  code= 'ALL_RES'    then Token := presources
           else token := TextOutResource ( code, '' , Class_, presources );

           if isBlank(token) then token := '<Skonfiguruj ustawienia>';

         result := token;
        end;

        // ------------------------------------------------------
        function getEventColor(pcolor : shortString; pTS : TTimeStamp; pZajecia: Integer; lcolor, gcolor, rcolor : integer) : string;
        var Token  : integer;
            Status : Integer;
        begin

           token := 0;
           if  pcolor= 'L'          then Token := lcolor        else
           if  pcolor= 'G'          then Token := gcolor           else
           if  pcolor= 'S'          then Token := class_.sub_colour  else
           if  pcolor= 'F'          then Token := class_.for_colour   else
           if  pcolor= 'OWNER'      then Token := class_.owner_colour      else
           if  pcolor= 'CREATED_BY' then Token := class_.creator_colour else
           if  pcolor= 'NONE'       then {}                         else
           if  pcolor= 'DESC1'      then Token := iif(isBlank(Class_.desc1),clRed,clSilver)      else
           if  pcolor= 'DESC2'      then Token := iif(isBlank(Class_.desc2),clRed,clSilver)      else
           if  pcolor= 'DESC3'      then Token := iif(isBlank(Class_.desc3),clRed,clSilver)      else
           if  pcolor= 'DESC4'      then Token := iif(isBlank(Class_.desc4),clRed,clSilver)      else
           if  pcolor= 'ALL_RES'    then Token := rcolor;

         result := DelphiColourToHTML(token);
        end;

        // ------------------------------------------------------
        procedure GoogleExport ( pExportChecked : boolean;
                                 presourceList : TCheckListBox;
                                 presourceName, presAlias : shortString;
                                 pcolor: shortstring;
                                 pcode: shortstring;
                                 pcodes, pcombovalues : array of shortString);
        var resIndex,x        : integer;
            gcal       : TGCalendar;
            yyyy,mm,dd : integer;
            hh1, mm1, hh2, mm2 : integer;
            day        : ttimestamp;
            plecturers : string;
            pgroups    : string;
            presources : string;
            pGoogleLocations : string;
            debugString : string;
            id, title, description, location, ecolor: string;
            timeZone : integer;
            lcolor, gcolor, rcolor : integer;
            classbuffer : cclassbuffer;
            ChildsAndParents : string;
            currentResource : string;

        begin
          timeZone := 0;
          If pExportChecked Then Begin
            for resIndex := 0 to presourceList.Count - 1 do begin
              if presourceList.Checked[resIndex] then begin

                try
                  AssignFile(outf, Folder.Text+'\' + StringToValidFileName(presourceList.Items[resIndex])+'.ics');
                  Rewrite(outf);
                except
                    on E:exception do begin
                     CopyToClipboard( Folder.Text+'\' + StringToValidFileName(presourceList.Items[resIndex])+'.ics');
                     raise;
                    end;
                end;
                classbuffer := cclassbuffer.create;
                classbuffer.init;
                recreateCalendar( presourceList.Items[resIndex] + ' ' + presourceName );

                ChildsAndParents := getChildsAndParents (inttostr(integer( presourceList.Items.Objects[resIndex])), '', true, true);
                for x := 1 To WordCount(ChildsAndParents,[';']) do begin
                  currentResource := ExtractWord(x, ChildsAndParents, [';']);

											with queryClasses do begin
											  try
                        //2020.05.02 Include also parent classes on the printouts (like Inauguracja roku)
											  dmodule.openSQL(queryClasses, sqlHolder.Lines.Text + ' and c.id in (select cla_id from '+presAlias+'_cla where '+presAlias+'_id = :pres_id) order by day, hour'
											  //dmodule.openSQL(queryClasses, sqlHolder.Lines.Text + ' and c.id in (select cla_id from '+presAlias+'_cla where is_child=''N'' and '+presAlias+'_id = :pres_id) order by day, hour'
												,'pres_id='      + currentResource +
												 ';per_id_from1='+ currentPeriod.text    +
												 ';per_id_to1='  + currentPeriod.text    +
												 ';per_id_from2='+ currentPeriod.text    +
												 ';per_id_to2='  + currentPeriod.text
												 );
											  open;
											  except
												on E:exception do begin
												 CopyToClipboard( queryClasses.SQL.text);
												 raise;
												end;
											  end;

											  First;
											  while not Eof do begin
												//add event

												 yyyy       := fieldByName('day_yyyy').AsInteger;
												 mm         := fieldByName('day_mm').AsInteger;
												 dd         := fieldByName('day_dd').AsInteger;
												 day        := dateTimeToTimeStamp(fieldByName('day').AsDateTime);
												 plecturers := fieldByName('lecturers').AsString;
												 pgroups    := fieldByName('groups').AsString;
												 presources := fieldByName('resources').AsString;
												 lcolor     := fieldByName('lcolor').AsInteger;
												 gcolor     := fieldByName('gcolor').AsInteger;
												 rcolor     := fieldByName('rcolor').AsInteger;
												 pgoogleLocations := fieldByName('google_locations').AsString;
												 id         := fieldByName('Id').AsString;

                         with Class_ do begin
                           id                 := fieldbyname('id').asinteger;
                           day                := datetimetotimestamp(fieldbyname('day').asdatetime);
                           hour               := fieldbyname('hour').asinteger;
                           fill               := fieldbyname('fill').asinteger;
                           sub_id             := fieldbyname('sub_id').asinteger;
                           for_id             := fieldbyname('for_id').asinteger;
                           for_kind           := fieldbyname('for_kind').asString;
                           sub_abbreviation   := fieldbyname('sub_abbreviation').asString;
                           sub_name           := fieldbyname('sub_name').asString;
                           sub_colour         := fieldbyname('sub_colour').asinteger;
                           for_colour         := fieldbyname('for_colour').asinteger;
                           owner_colour       := fieldbyname('owner_colour').asinteger;
                           creator_colour     := fieldbyname('creator_colour').asinteger;
                           class_colour       := fieldbyname('class_colour').asinteger;
                           desc1              := fieldbyname('desc1').asString;
                           desc2              := fieldbyname('desc2').asString;
                           desc3              := fieldbyname('desc3').asString;
                           desc4              := fieldbyname('desc4').asString;
                           for_abbreviation   := fieldbyname('for_abbreviation').asString;
                           for_name           := fieldbyname('for_name').asString;
                           calc_lecturers     := fieldbyname('calc_lecturers').asString;
                           calc_groups        := fieldbyname('calc_groups').asString;
                           calc_rooms         := fieldbyname('calc_rooms').asString;
                           calc_lec_ids       := fieldbyname('calc_lec_ids').asString;
                           calc_gro_ids       := fieldbyname('calc_gro_ids').asString;
                           calc_rom_ids       := fieldbyname('calc_rom_ids').asString;
                           calc_rescat_ids    := fieldbyname('calc_rescat_ids').asString;
                           created_by         := fieldbyname('created_by').asString;
                           owner              := fieldbyname('owner').asString;
                         end;

												 if not opisujKolumneZajec.hourNumberToHourFromTo (fieldByName('hour').AsInteger, fieldByName('fill').AsInteger, hh1, mm1, hh2, mm2) then begin
												   info ( format('Nie mo¿na okreœliæ godziny rozpoczêcia lub zakoñczenia dla zajêcia nr %s.'+cr+'Uzupe³nij kolumny Godz.od, Godz.do', [fieldByName('hour').AsString]));
												   queryClasses.Free;
												   autocreate.GRIDSShowModalAsBrowser;
												   exit;
												 end;

												 ecolor       := getEventColor     (pcolor, day , fieldByName('Hour').AsInteger, lcolor, gcolor, rcolor);
												 title        := getEventTitle      (pcode, day , fieldByName('Hour').AsInteger, plecturers, pgroups, presources);
												 description  := getEventDescription(pcodes
																				   ,pcomboValues
																				   ,day, fieldByName('Hour').AsInteger, plecturers, pgroups, presources);
												 location    := pgoogleLocations;

												 {
												 The algorithm:
													if loop:
													  bufor empty
														  setBuffer
													  bufor not empty
														  isContinuation? => splice classes
														  otherwise flush and setBuffer

													finalization:
														bufor not empty => flush

												 }

												 if classbuffer.bufferIsEmpty then begin
												   classbuffer.setBuffer(
													 FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh1-timeZone)+FormatFloat('00',mm1)+FormatFloat('00',0)
													 ,FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh2-timeZone)+FormatFloat('00',mm2)+FormatFloat('00',0)
													 ,FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh1-timeZone)+FormatFloat('00',mm1)+FormatFloat('00',0)
													 ,fieldByName('id').AsString
													 ,description
													 ,location
													 ,title
													 ,ecolor
													 ,Id
													 ,fieldByName('Hour').AsInteger
													 ,uutilityparent.dateToYYYYMMDD( fieldByName('day').AsDateTime )
												   );
												 end else begin
												   //buffer is not empty
												   if classbuffer.isContinuation(
													 FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh1-timeZone)+FormatFloat('00',mm1)+FormatFloat('00',0)
													 ,FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh2-timeZone)+FormatFloat('00',mm2)+FormatFloat('00',0)
													 ,FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh1-timeZone)+FormatFloat('00',mm1)+FormatFloat('00',0)
													 ,fieldByName('id').AsString
													 ,description
													 ,location
													 ,title
													 ,ecolor
													 ,Id
													 ,fieldByName('Hour').AsInteger
													 ,uutilityparent.dateToYYYYMMDD( fieldByName('day').AsDateTime )
												   )
												   then begin
													 //is continuation : splice classes
													 classbuffer.dtend := FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh2-timeZone)+FormatFloat('00',mm2)+FormatFloat('00',0);
													 classbuffer.uid := classbuffer.uid +'+'+ fieldByName('id').AsString;
													 classbuffer.internalid := classbuffer.internalid +'+'+ Id;
													 //hour also needs to be updated for the sake of splice with 3rd block
													 classbuffer.hour  := fieldByName('Hour').AsInteger;
												   end else begin
													 //is not continuation
                           write ( classbuffer.bflush );
													 classbuffer.setBuffer(
													   FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh1-timeZone)+FormatFloat('00',mm1)+FormatFloat('00',0)
													   ,FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh2-timeZone)+FormatFloat('00',mm2)+FormatFloat('00',0)
													   ,FormatFloat('0000',yyyy)+FormatFloat('00',mm)+FormatFloat('00',dd)+'T'+ FormatFloat('00',hh1-timeZone)+FormatFloat('00',mm1)+FormatFloat('00',0)
													   ,fieldByName('id').AsString
													   ,description
													   ,location
													   ,title
													   ,ecolor
													   ,Id
													   ,fieldByName('Hour').AsInteger
													   ,uutilityparent.dateToYYYYMMDD( fieldByName('day').AsDateTime )
													 );
												   end;
												 end;

												Next;
											  end;
											  if not classbuffer.bufferIsEmpty then
                           write ( classbuffer.bflush );
											end;

                End;

                write ('END:VCALENDAR');
                classbuffer.free;
                flush(outf);
                CloseFile(outf);
              end;
            end;
          end;
        end;

    begin
      queryClasses := tadoquery.Create(self);

      if (getCode (FSettings.GD1)='NONE') or (getCode (FSettings.RD1)='NONE') or (getCode (FSettings.LD1)='NONE') then
          info ('Przed uruchomieniem eksportu danych uruchom Ustawienia i zdefiniuj jakie dane powinny zostaæ wys³ane do iKalendarz')
      else begin
          with FSettings Do begin
            googleExport ( Groups.Checked    , GList , fprogramsettings.profileObjectNameG.Text  , 'GRO', getCode(GViewType), getCode (GD1),  [ getCode (GD2),getCode (GD3),getCode (GD4),getCode (GD5) ], [ getValue(GD2),getValue(GD3),getValue(GD4),getValue(GD5) ] );
            googleExport ( Resources.Checked , RList , 'Zasób'                                   , 'ROM', getCode(RViewType), getCode (RD1),  [ getCode (RD2),getCode (RD3),getCode (RD4),getCode (RD5) ], [ getValue(RD2),getValue(RD3),getValue(RD4),getValue(RD5) ] );
            googleExport ( Lecturers.Checked , LList , fprogramsettings.profileObjectNameL.Text  , 'LEC', getCode(LViewType), getCode (LD1),  [ getCode (LD2),getCode (LD3),getCode (LD4),getCode (LD5) ], [ getValue(LD2),getValue(LD3),getValue(LD4),getValue(LD5) ] );
            fmain.wlog('tableOfContens : Start');
            tableOfContens;
            fmain.wlog('tableOfContens : End');
          end;
      end;
      setStatus('');
      queryClasses.Free;
    end;

    // ------------------------------------------------------
    procedure generateWebPage;
      Var fileExt : string;
          f : textFile;
          t : integer;
    begin
      AssignFile(f, Folder.Text+'\layout.xslt');
      Rewrite(f);
      WriteLn(f,
         replace(
           replace(xslt.Lines.Text
             ,'%R1.', fprogramsettings.profileObjectNameLs.Text)
           ,'%R2.', fprogramsettings.profileObjectNameGs.Text)
      );
      CloseFile(f);

      assignFile(f, Folder.Text+'\menu.css');
      Rewrite(f);
      WriteLn(f, css.Lines.Text);
      CloseFile(f);

      if DoNotGenerateTableOfCon.Checked then   AssignFile(F, Folder.Text+'\eraseme.htm')
                                         else   AssignFile(F, Folder.Text+'\index.xml');
      Rewrite(F);
      WriteLn(f, '<?xml version="1.0" encoding="windows-1250"?>');
      WriteLn(f, '<?xml-stylesheet type="text/xsl" href="layout.xslt"?>');
      WriteLn(f, '<xml>');
      WriteLn(f, '<title name="Plansoft.org - '+fprogramSettings.profileObjectNameClassgen.Text+'"></title>');
      WriteLn(f, '<period name="'+XMLescapeChars(currentPeriod_VALUE.Text)+'"></period>');
      WriteLn(f, '<description text="'+XMLescapeChars(AddText.Text)+'"></description>');
      WriteLn(f, '<data>');
         If Groups.Checked Then Begin
           fileExt := iif(FSettings.GPdfPrintOut.Checked,'.pdf','.htm');
           for t := 0 to GList.Count - 1 do begin
             if GList.Checked[t] then begin
               WriteLn(F, '  <gro href="'+XMLescapeChars(StringToValidFileName(GList.Items[t]))+fileExt+'" text="'+XMLescapeChars(GList.Items[t])+'"/>');
               ColoringIndex := getCode(FSettings.GViewType);
               With FSettings Do CalendarToHTML(
               currentPeriod.Text
               , inttostr(integer(GList.Items.Objects[t]))
               , 'GRO'
               , getCode(GD1)
               , getCode(GD2)
               , getCode(GD3)
               , getCode(GD4)
               , getCode(GD5)
               , GHEADER.Lines
               , GFOOTER.Lines
               , gGShowLegend.Checked
               , iif(glegendAbbr.checked,1,0)*2+iif(glegendSummary.checked,1,0)*1
               , gAddCreationDate.itemindex
               , ColoringIndex
               , GW.Text
               , GH.Text
               , GCELLSIZE.Text
               , GS1.Text
               , GS2.Text
               , GS3.Text
               , GS4.Text
               , GS5.Text
               , GB1.Checked
               , GB2.Checked
               , GB3.Checked
               , GB4.Checked
               , GB5.Checked
               , Folder.Text+'/'+StringToValidFileName(GList.Items[t])+'.htm'
               , GRepeatMonthNames.Checked
               , GHideEmptyRows.Checked
               , GHideDows
               , GcomboSpan.itemIndex
               , gspanEmptyCells.checked
               , gtransposition.Checked
               , gVerticalLines.checked
               , gnotes_before.Checked
               , gnotes_after.Checked
               , gPdfprintOut.checked
               , gpdfg.checked
               , gpdfl.checked
               , gpdfo.checked
               , gpdfs.checked );
             end;
           end;
         end;
         If lecturers.Checked Then Begin
           fileExt := iif(FSettings.LPdfPrintOut.Checked,'.pdf','.htm');
           for t := 0 to LList.Count - 1 do begin
             if LList.Checked[t] then begin
               WriteLn(F, '  <lec href="'+XMLescapeChars(StringToValidFileName(LList.Items[t]))+fileExt+'" text="'+XMLescapeChars(LList.Items[t])+'"/>');
               ColoringIndex := getCode(FSettings.LViewType);
               With FSettings Do CalendarToHTML(currentPeriod.Text, inttostr(integer(LList.Items.Objects[t])), 'LEC', getCode(LD1), getCode(LD2), getCode(LD3), getCode(LD4), getCode(LD5), LHEADER.Lines, LFOOTER.Lines, llShowLegend.Checked, iif(llegendAbbr.checked,1,0)*2+iif(llegendSummary.checked,1,0)*1 , lAddCreationDate.itemindex, ColoringIndex, LW.Text, LH.Text, LCELLSIZE.Text, LS1.Text, LS2.Text, LS3.Text, LS4.Text, LS5.Text, LB1.Checked, LB2.Checked, LB3.Checked, LB4.Checked, LB5.Checked,Folder.Text+'/'+StringToValidFileName(LList.Items[t])+'.htm', LRepeatMonthNames.Checked, LHideEmptyRows.Checked, LHideDows, lcomboSpan.itemIndex, lspanEmptyCells.checked,  ltransposition.Checked, lVerticalLines.checked, lnotes_before.Checked, lnotes_after.Checked, LPdfprintOut.checked, lpdfg.checked, lpdfl.checked, lpdfo.checked, lpdfs.checked);
             end;
           end;
         end;
          If Resources.Checked Then Begin
           fileExt := iif(FSettings.RPdfPrintOut.Checked,'.pdf','.htm');
           for t := 0 to RList.Count - 1 do begin
             if RList.Checked[t] then begin
               WriteLn(F, '  <res href="'+XMLescapeChars(StringToValidFileName(RList.Items[t]))+fileExt+'" text="'+XMLescapeChars(RList.Items[t])+'"/>');
               try
                 ColoringIndex := getCode(FSettings.RViewType);
                 With FSettings Do CalendarToHTML(currentPeriod.Text, inttostr(integer(RList.Items.Objects[t])), 'ROM', getCode(RD1), getCode(RD2), getCode(RD3), getCode(RD4), getCode(RD5), RHEADER.Lines, RFOOTER.Lines, rRShowLegend.Checked, iif(rlegendAbbr.checked,1,0)*2+iif(rlegendSummary.checked,1,0)*1, rAddCreationDate.itemindex, ColoringIndex, RW.Text, RH.Text, RCELLSIZE.Text, RS1.Text, RS2.Text, RS3.Text, RS4.Text, RS5.Text, RB1.Checked, RB2.Checked, RB3.Checked, RB4.Checked, RB5.Checked,Folder.Text+'/'+StringToValidFileName(RList.Items[t])+'.htm' , RRepeatMonthNames.Checked, RHideEmptyRows.Checked, RHideDows, rcomboSpan.itemIndex, rspanEmptyCells.checked,  rtransposition.Checked, rVerticalLines.checked, rnotes_before.Checked, rnotes_after.Checked, rPdfprintOut.checked, rpdfg.checked, rpdfl.checked, rpdfo.checked, rpdfs.checked );
               except
                 on E:EDatabaseError do If Question('Wyst¹pi³ b³¹d bazy danych podczas tworzenia rozk³adu dla zasobu '+Folder.Text+'/'+StringToValidFileName(RList.Items[t])+'.htm'+'. Przeka¿ treœæ tego komunikatu serwisowi technicznemu. Czy chcesz kontynuowaæ proces generowania witryny ?'+CR+E.Message) <> ID_YES Then Raise;
                 on E:exception      do If Question('Wyst¹pi³ b³¹d podczas tworzenia rozk³adu dla zasobu '+Folder.Text+'/'+StringToValidFileName(RList.Items[t])+'.htm'+'. Przeka¿ treœæ tego komunikatu serwisowi technicznemu. Czy chcesz kontynuowaæ proces generowania witryny ?'+CR+E.Message) <> ID_YES Then Raise;
               end;
             end;
           end;
          end;
      WriteLn(f, '</data>');
      WriteLn(f, '<who lastupdatetext="Aktualizacja: '+DateTimeToStr(Now())+'"></who>');
      WriteLn(f, '</xml>');

      CloseFile(F);
      if not fmain.silentMode then begin
          ShowFolder(Folder.Text);
          if defaultBrowserIsChrome then begin
              info('Zrobione! Ju¿ mo¿esz przegl¹daæ rozk³ady. Aby jednak zobaczyæ spis treœci (plik index.xml) poproœ swojego informatyka, aby umieœci³ zawartoœæ tego folderu na serwerze Uczelni.');
          end;
          uUtilityParent.ExecuteFile(Folder.Text+'\index.xml','','',SW_SHOWMAXIMIZED);
      end;
    End;

begin
  if not settingsLoaded then
      with fsettings do begin
          Show;
          BCloseSettingsClick(nil);
          Close;
      end;

  ForceDirectories(Folder.Text);
  case genType.ItemIndex of
   0:generateWebPage;
   1:begin
       fmain.wlog('generateIcsCalendars: Start');
       generateIcsCalendars;
       fmain.wlog('generateIcsCalendars: Stop');
     end;
  end;
end;


procedure TFWWWGenerator.bcreatepopupClick(Sender: TObject);
var point : tpoint;
begin
 Point.x := 0;
 Point.y := (sender as tspeedbutton).Height;
 Point   := (sender as tspeedbutton).ClientToScreen(Point);
 createpopup.Popup(Point.X,Point.Y);
end;

procedure TFWWWGenerator.Utwrzrozk1Click(Sender: TObject);
begin
  bcreateClick(bcreate);
end;

procedure TFWWWGenerator.wrzrozkadyautomatycznieautomatycznetworzenieiodwieanierozkadw1Click(
  Sender: TObject);
var iniFile : TIniFile;
    s : string;
    f : textFile;
begin
  if not saveDialog.Execute then exit;

  iniFile := TIniFile.Create( saveDialog.FileName );
  With iniFile do begin
    WriteString ('initype','initype','wwwgenerator');
    WriteString ('wwwgenerator','PeriodName',currentPeriod_VALUE.Text);
    WriteInteger('wwwgenerator','GenType',genType.ItemIndex);
    WriteString ('wwwgenerator','DefaultFolder',Folder.Text);
    WriteString ('wwwgenerator','AddText',AddText.Text);
    WriteBool   ('wwwgenerator','DoNotGenerateTableOfCon',DoNotGenerateTableOfCon.Checked);
    WriteString ('wwwgenerator','RoleName',fmain.CONROLE_VALUE.text);
    WriteBool   ('wwwgenerator','Groups',Groups.Checked);
    WriteBool   ('wwwgenerator','Resources',Resources.Checked);
    WriteBool   ('wwwgenerator','Lecturers',Lecturers.Checked);
    fsettings.FormShow(nil);
    fsettings.Save( extractFileDir(saveDialog.FileName)+'/settings.ini' );
    WriteString ('wwwgenerator','PrintSettingsFileName',extractFileDir(saveDialog.FileName)+'/settings.ini');
  end;
  iniFile.Free;

  AssignFile(f, extractFileDir(saveDialog.FileName)+'/publikacja.bat' );
  reWrite(f);

  writeLn(f, '"'+ApplicationDir + '\' + 'planowanie.exe" '+userName+' '+uutilityparent.EncryptShortString(1, 'PASSWORD:'+password, 'SoftwareFactory')+' '+DBname+' "inifile='+ saveDialog.FileName +'"');
  closeFile(f);

  s :=
  'Pliki zosta³y pomyœlnie zapisane.'+cr+
  'Teraz lub póŸniej mo¿esz rozpocz¹æ eksport uruchamiaj¹c plik publikacja.bat.'+cr+
  'Spowoduje to automatyczne odœwie¿enie danych, bez potrzeby uruchamiania programu.'+cr+
  'Mo¿esz te¿ zaharmonogramowaæ automatyczne tworzenie rozk³adów za pomoc¹ funkcji Panel sterowania->Zaplanowane zadania';

  info(s);
end;

procedure TFWWWGenerator.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFWWWGenerator.bsettingsClick(Sender: TObject);
var     revertCaption    : shortString;
begin
  With FSettings do begin
    revertCaption := caption;
    BWord.Visible := False;
    BHtml.Visible := False;
    BCloseSettings.Caption   := 'Zamknij';
    caption       := 'Ustawienia eksportu';
    tsAdvanced.TabVisible := genType.ItemIndex =0;
    LCellSizes.Visible    := genType.ItemIndex =0;
    GCellSizes.Visible    := genType.ItemIndex =0;
    RCellSizes.Visible    := genType.ItemIndex =0;
    lheadergroup.Visible  := genType.ItemIndex =0;
    gheadergroup.Visible  := genType.ItemIndex =0;
    rheadergroup.Visible  := genType.ItemIndex =0;
    lfootergroup.Visible  := genType.ItemIndex =0;
    gfootergroup.Visible  := genType.ItemIndex =0;
    rfootergroup.Visible  := genType.ItemIndex =0;
    LLShowLegend.Visible  := genType.ItemIndex =0;
    LAddCreationDate.Visible   := genType.ItemIndex =0;
    LRepeatMonthNames.Visible  := genType.ItemIndex =0;
    LHideEmptyRows.Visible     := genType.ItemIndex =0;
    LHideEmptyRowsB.Visible     := genType.ItemIndex =0;
    GHideEmptyRowsB.Visible     := genType.ItemIndex =0;
    RHideEmptyRowsB.Visible     := genType.ItemIndex =0;
    Ltransposition.Visible       := genType.ItemIndex =0;
    lVerticalLines.visible     := genType.ItemIndex =0;
    lspanEmptyCells.Visible    := genType.ItemIndex =0;
    LcomboSpan.Visible         := genType.ItemIndex =0;
    LcomboSpanlabel.Visible    := genType.ItemIndex =0;
    ggShowLegend.Visible       := genType.ItemIndex =0;
    gAddCreationDate.Visible   := genType.ItemIndex =0;
    gRepeatMonthNames.Visible  := genType.ItemIndex =0;
    gHideEmptyRows.Visible     := genType.ItemIndex =0;
    gtransposition.Visible     := genType.ItemIndex =0;
    gVerticalLines.Visible     := genType.ItemIndex =0;
    gspanEmptyCells.Visible    := genType.ItemIndex =0;
    gcomboSpan.Visible         := genType.ItemIndex =0;
    gcomboSpanlabel.Visible    := genType.ItemIndex =0;
    rrShowLegend.Visible       := genType.ItemIndex =0;
    rAddCreationDate.Visible   := genType.ItemIndex =0;
    rRepeatMonthNames.Visible  := genType.ItemIndex =0;
    rHideEmptyRows.Visible     := genType.ItemIndex =0;
    rtransposition.Visible     := genType.ItemIndex =0;
    rVerticalLines.Visible     := genType.ItemIndex =0;
    rspanEmptyCells.Visible    := genType.ItemIndex =0;
    rcomboSpan.Visible         := genType.ItemIndex =0;
    rcomboSpanlabel.Visible    := genType.ItemIndex =0;
    rcomboSpan.Visible         := genType.ItemIndex =0;
    rcomboSpanlabel.Visible    := genType.ItemIndex =0;
    lhelp.Visible     := genType.ItemIndex =0;
    ghelp.Visible     := genType.ItemIndex =0;
    rhelp.Visible     := genType.ItemIndex =0;
    Lnotes_before.Visible     := genType.ItemIndex =0;
    Lnotes_after.Visible      := genType.ItemIndex =0;
    gnotes_before.Visible     := genType.ItemIndex =0;
    gnotes_after.Visible      := genType.ItemIndex =0;
    rnotes_before.Visible     := genType.ItemIndex =0;
    rnotes_after.Visible      := genType.ItemIndex =0;
    LPdfPrintOut.Visible      := genType.ItemIndex =0;
    gPdfPrintOut.Visible      := genType.ItemIndex =0;
    rPdfPrintOut.Visible      := genType.ItemIndex =0;

    lpdfg.visible      := (genType.ItemIndex =0) and (LPdfPrintOut.Checked);
    lpdfl.visible      := (genType.ItemIndex =0) and (LPdfPrintOut.Checked);
    lpdfo.visible      := (genType.ItemIndex =0) and (LPdfPrintOut.Checked);
    lpdfs.visible      := (genType.ItemIndex =0) and (LPdfPrintOut.Checked);

    gpdfg.visible      := (genType.ItemIndex =0) and (gPdfPrintOut.Checked);
    gpdfl.visible      := (genType.ItemIndex =0) and (gPdfPrintOut.Checked);
    gpdfo.visible      := (genType.ItemIndex =0) and (GPdfPrintOut.Checked);
    gpdfs.visible      := (genType.ItemIndex =0) and (gPdfPrintOut.Checked);

    rpdfg.visible      := (genType.ItemIndex =0) and (rPdfPrintOut.Checked);
    rpdfl.visible      := (genType.ItemIndex =0) and (rPdfPrintOut.Checked);
    rpdfo.visible      := (genType.ItemIndex =0) and (rPdfPrintOut.Checked);
    rpdfs.visible      := (genType.ItemIndex =0) and (rPdfPrintOut.Checked);

    LS1.Visible     := genType.ItemIndex =0;
    LS2.Visible     := genType.ItemIndex =0;
    LS3.Visible     := genType.ItemIndex =0;
    LS4.Visible     := genType.ItemIndex =0;
    LS5.Visible     := genType.ItemIndex =0;
    GS1.Visible     := genType.ItemIndex =0;
    GS2.Visible     := genType.ItemIndex =0;
    GS3.Visible     := genType.ItemIndex =0;
    GS4.Visible     := genType.ItemIndex =0;
    GS5.Visible     := genType.ItemIndex =0;
    RS1.Visible     := genType.ItemIndex =0;
    RS2.Visible     := genType.ItemIndex =0;
    RS3.Visible     := genType.ItemIndex =0;
    RS4.Visible     := genType.ItemIndex =0;
    RS5.Visible     := genType.ItemIndex =0;
    LB1.Visible     := genType.ItemIndex =0;
    LB2.Visible     := genType.ItemIndex =0;
    LB3.Visible     := genType.ItemIndex =0;
    LB4.Visible     := genType.ItemIndex =0;
    LB5.Visible     := genType.ItemIndex =0;
    GB1.Visible     := genType.ItemIndex =0;
    GB2.Visible     := genType.ItemIndex =0;
    GB3.Visible     := genType.ItemIndex =0;
    GB4.Visible     := genType.ItemIndex =0;
    GB5.Visible     := genType.ItemIndex =0;
    RB1.Visible     := genType.ItemIndex =0;
    RB2.Visible     := genType.ItemIndex =0;
    RB3.Visible     := genType.ItemIndex =0;
    RB4.Visible     := genType.ItemIndex =0;
    RB5.Visible     := genType.ItemIndex =0;

    //LViewTypeGroup.Visible     := genType.ItemIndex =0;
    //GViewTypeGroup.Visible     := genType.ItemIndex =0;
    //RViewTypeGroup.Visible     := genType.ItemIndex =0;

    label12.Caption := iif(genType.ItemIndex =0, 'Zawartoœæ             Wielk.  Pogr.','Zawartoœæ');
    label13.Caption := iif(genType.ItemIndex =0, 'Zawartoœæ             Wielk.  Pogr.','Zawartoœæ');
    label14.Caption := iif(genType.ItemIndex =0, 'Zawartoœæ             Wielk.  Pogr.','Zawartoœæ');

    LDescGroup.Left := iif(genType.ItemIndex =0, 1, 290);
    GDescGroup.Left := iif(genType.ItemIndex =0, 1, 290);
    RDescGroup.Left := iif(genType.ItemIndex =0, 1, 290);

    LViewTypeGroup.Left := iif(genType.ItemIndex =0, 1, 290);
    GViewTypeGroup.Left := iif(genType.ItemIndex =0, 1, 290);
    RViewTypeGroup.Left := iif(genType.ItemIndex =0, 1, 290);

    ShowModal;

    BWord.Visible := True;
    BHtml.Visible := True;
    caption       := revertCaption;
    tsAdvanced.TabVisible := true;
    LCellSizes.Visible    := true;
    GCellSizes.Visible    := true;
    RCellSizes.Visible    := true;
    lheadergroup.Visible  := true;
    gheadergroup.Visible  := true;
    rheadergroup.Visible  := true;
    lfootergroup.Visible  := true;
    gfootergroup.Visible  := true;
    rfootergroup.Visible  := true;
    LLShowLegend.Visible  := true;
    LAddCreationDate.Visible   := true;
    LRepeatMonthNames.Visible  := true;
    LHideEmptyRows.Visible     := true;
    Ltransposition.Visible       := true;
    lVerticalLines.Visible     := true;
    lspanEmptyCells.Visible     := true;
    LcomboSpan.Visible         := true;
    ggShowLegend.Visible       := true;
    gAddCreationDate.Visible   := true;
    gRepeatMonthNames.Visible  := true;
    gHideEmptyRows.Visible     := true;
    gtransposition.Visible     := true;
    gVerticalLines.Visible     := true;
    gspanEmptyCells.Visible     := true;
    gcomboSpan.Visible         := true;
    rrShowLegend.Visible       := true;
    rAddCreationDate.Visible   := true;
    rRepeatMonthNames.Visible  := true;
    rHideEmptyRows.Visible     := true;
    rtransposition.Visible     := true;
    rVerticalLines.Visible     := true;
    rspanEmptyCells.Visible     := true;
    rcomboSpan.Visible         := true;
    lhelp.Visible              := true;
    Lnotes_before.Visible      := true;
    Lnotes_after.Visible       := true;
    gnotes_before.Visible      := true;
    gnotes_after.Visible       := true;
    rnotes_before.Visible      := true;
    rnotes_after.Visible       := true;

    ghelp.Visible              := true;
    rhelp.Visible              := true;
  end;
  settingsLoaded := true;
end;

procedure TFWWWGenerator.ROMFilterClickClick(Sender: TObject);
begin
  If UFModuleFilter.ShowModal( ROMSettings.Strings, FBrowseROOMS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
    ROMfilerSettings_dsp.Text := ROMSettings.Strings.Values['Notes.Category:DEFAULT'];
    currentPeriodChange(self);
  End;
end;

procedure TFWWWGenerator.LECFilterClickClick(Sender: TObject);
begin
  If UFModuleFilter.ShowModal( LECSettings.Strings, FBrowseLECTURERS.AvailColumnsWhereClause.Strings, 'DEFAULT') = mrOK Then Begin
    LECfilerSettings_dsp.Text := LECSettings.Strings.Values['Notes.Category:DEFAULT'];
    currentPeriodChange(self);
  End;
end;

procedure TFWWWGenerator.GselectorClick(Sender: TObject);
begin
 if (sender as tcheckbox).checked then setAll(GList, true) else setAll(GList, false);
end;

procedure TFWWWGenerator.rselectorclick(Sender: TObject);
begin
 if (sender as tcheckbox).checked then setAll(RList, true) else setAll(RList, false);
end;

procedure TFWWWGenerator.lselectorClick(Sender: TObject);
begin
 if (sender as tcheckbox).checked then setAll(LList, true) else setAll(LList, false);
end;

procedure TFWWWGenerator.BOpenDialogClick(Sender: TObject);
begin
end;

{
var hours : array of string;
    t     : integer;
    weeklyTables : tweeklyTables;
    weeklyTable  : tweeklyTable;
    f            : textFile;
    old_week_iso : shortstring;
begin
    weeklyTables := tweeklyTables.Create;

    for t := 1 to dm.maxHours do
        if opisujkolumnezajec.no[t]<>'' then begin
            setLength(hours, length(hours)+1);
            hours[length(hours)-1] := opisujkolumnezajec.no[t];
        end;

    old_week_iso := '';
    adotest.Open;
    with dmodule do begin
        adotest.First;
        while not adotest.Eof do begin

          if old_week_iso <> adotest.FieldByName('subject').asstring+'+'+adotest.FieldByName('week_iso').asstring then begin
          old_week_iso := adotest.FieldByName('subject').asstring+'+'+adotest.FieldByName('week_iso').asstring;
          weeklyTable :=
          weeklyTables.addWeeklyTable(
             'Przedmiot',adotest.FieldByName('subject').asstring,'Nr tygodnia',adotest.FieldByName('week_iso').asstring
            ,['PONIEDZIA£EK','WTOREK','ŒRODA','CZWARTEK','PI¥TEK','SOBOTA','NIEDZIELA'] //@@@ONLY SELECTED days!!
            ,[]
            ,hours);
          end;

            weeklyTable.addCell(trim(adotest.FieldByName('day_in_say_pl').asstring),'',adotest.FieldByName('hour_dsp').asstring,'BGCOLOR="red" border="5" style="border:solid white;"',
                adotest.FieldByName('form').asstring+'<br/>'+
                adotest.FieldByName('group_name').asstring+'<br/>'+
                adotest.FieldByName('resource_name').asstring+'<br/>'+
                adotest.FieldByName('lecturer_name').asstring
            );
            //@@@color!

            adotest.Next;
        end;
    end;

    weeklyTables.merge;
    assignFile(f,'c:\sampletable.html');
    rewrite(f);
    writeLn(f,  weeklyTables.getBody );
    closeFile(f);

    weeklyTables.cleanUp;
    finalize( weeklyTables );

end;
}

procedure TFWWWGenerator.BOtherClick(Sender: TObject);
begin
  If OpenDialog.Execute then
   xslt.Lines.LoadFromFile(openDialog.FileName);
end;

procedure TFWWWGenerator.BShowAllClick(Sender: TObject);
begin
  xslt.Lines.Assign(mdefault.Lines);
end;

procedure TFWWWGenerator.SpeedButton1Click(Sender: TObject);
begin
  info('Je¿eli w witrynie chcesz umieœciæ dodatkow¹ informacjê nt. semestru (np. wersja robocza), umieœæ j¹ w tym polu');

end;

procedure TFWWWGenerator.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  //ini file does not support chars longer than 2024 chars
  //UutilityParent.SaveToIni (UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.ini','main',[xslt, css]);
  xslt.Lines.SaveToFile(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.xslt.ini');
  xslt.Lines.SaveToFile(UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FWWWGenerator.css.ini');

end;

procedure TFWWWGenerator.SpeedButton2Click(Sender: TObject);
begin
  ShowFolder(Folder.Text);
end;


end.
