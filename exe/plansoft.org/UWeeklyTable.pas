unit UWeeklyTable;

interface

type tcell = class
         cntMode : boolean;
         spannedCell : boolean;
         colspan : integer;
         dataCell: boolean;
         table : array of record
                     s: string;
                     count : real;
                 end;
         procedure addClass(pcntMode : boolean; pdataCell: boolean; pspannedCell : boolean; colspan : integer; s : string; ignoreDuplicates : boolean; count : real);
         function getBody : string;
     end;

type tweeklyTable = class
         cntMode : boolean;
         titleCategory, title, subtitleCategory, subtitle : string;
         table : array of array of tcell;
         rowCount : integer;
         colCount : integer;
         colLabels, rowLabels :
           array of record
             caption : string;
             Used : boolean;
           end;
         rowLabelsOffset : integer;
         colLabelsOffset : integer;
         public
             procedure init (
                 pcntMode : boolean;
                 pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string;
                 pcolLabels    //day of weeks
               , pcolsubLabels //group names
               , prowLabels : array of string );
             procedure addCell (dataCell: boolean; colLabel, colsubLabel, rowLabel, attributes, body : string; colsubLabelMode : boolean; count : real);
             function  getTitle : string;
             function  getBody (forceSpan : boolean) : string;
             procedure cleanUp;
         private
             function simpleGreyCell    (s: string) : tcell;
             function getSpannedCell : tcell;
     end;

type tweeklyTables = class
         cntMode : boolean;
         weeklyTables : array of tweeklyTable;
         function addWeeklyTable (
                 pCntMode : boolean;
                 pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string;
                 pcolLabels    //day of weeks
               , pcolsubLabels //group names
               , prowLabels : array of string ) : tweeklyTable;
         procedure merge (forceSpan : boolean);
         function getBody(forceSpan : boolean) : string;
         procedure cleanUp;
     end;


implementation

uses sysutils;

//------------------------------------------------------------------------------
procedure tweeklyTable.init (pCntMode : boolean; pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string; pcolLabels, pcolsubLabels, prowLabels : array of string);
var cLength : integer;
    rLength : integer;
    r       : integer;
    t       : integer;
    subColLen : integer;
begin
    cntMode          := pCntMode;
    titleCategory    := pTitleCategory;
    title            := pTitle;
    subtitleCategory := pSubtitleCategory;
    subtitle         := pSubtitle;

    subColLen := Length(pcolsubLabels);
    if subColLen = 0 then begin
        cLength := Length(pcolLabels);
        rLength := Length(prowLabels);

        setLength(colLabels, cLength);
        setLength(rowLabels, rLength);

        //1st row contains column labels, 1st col contains row labels, so +1
        rowLabelsOffset := 1;
        colLabelsOffset := 1;
        rowCount := rLength + rowLabelsOffset;
        colCount := cLength + colLabelsOffset;

        setLength(table, rowCount);

        for r := 0 to rowCount-1 do
            setLength(table[r], colCount);

        //add columns
        for t := 0 to cLength-1 do begin
             table[0][t+1]  := simpleGreyCell(pcolLabels[t]);
             colLabels[t].caption:= pcolLabels[t];
             colLabels[t].Used := false;
        end;
        //add rows
        for t := 0 to rLength-1 do begin
             table[t+rowLabelsOffset][0] := simpleGreyCell(prowLabels[t]);
             rowLabels[t].caption  := prowLabels[t];
             rowLabels[t].Used:= false;
        end;
    end else begin //Length(psubcolLabels) > 0
        cLength := Length(pcolLabels) * subColLen;
        rLength := Length(prowLabels);

        setLength(colLabels, cLength);
        setLength(rowLabels, rLength);

        //1st row contains column labels, 2nd row contains column sublabels, 1st col contains row labels, so +1
        rowLabelsOffset := 2;
        colLabelsOffset := 1;

        rowCount := rLength + rowLabelsOffset;
        colCount := cLength + colLabelsOffset;

        setLength(table, rowCount);

        for r := 0 to rowCount-1 do
            setLength(table[r], colCount);

        //add columns
        for t := 0 to cLength-1 do begin
             if t  mod subColLen = 1 then begin
                 table[0][t+1]:= tcell.Create;
                 table[0][t+1].addClass(cntMode, false, false,subColLen,'<td bgcolor="grey" colspan="?"><center>'+pcolLabels[t div subColLen]+'</center></td>', true, 0);
             end else begin
                 //table[0][t+1] := getSpannedCell;
                 table[0][t+1]:= tcell.Create;
                 table[0][t+1].addClass (cntMode, false, true,0,'<td bgcolor="grey"><center>'+pcolLabels[t div subColLen]+'</center></td>', true, 0);
             end;

             table[1][t+1]          := simpleGreyCell(pcolsubLabels[t  mod subColLen]);
             colLabels[t].caption   := pcolLabels[t div subColLen]+'+'+pcolsubLabels[t  mod subColLen];
             colLabels[t].Used := false;
        end;
        // add rows
        for t := 0 to rLength-1 do begin
             table[t+rowLabelsOffset][0] := simpleGreyCell(prowLabels[t]);
             rowLabels[t].caption  := prowLabels[t];
             rowLabels[t].Used:= false;
        end;
    end;
end;

//------------------------------------------------------------------------------
procedure tweeklyTable.addCell (dataCell: boolean; colLabel, colsubLabel, rowLabel, attributes, body : string; colsubLabelMode : boolean; count : real);
var r,c : integer;
    function rowLabelToId ( s : string ) : integer;
    var t : integer;
    begin
        result := -1;
        for t := 0 to length(rowLabels)-1 do
          if rowLabels[t].caption = s then begin
              result := t + rowLabelsOffset;
              rowLabels[t].Used := true;
          end;
    end;
    function colLabelToId ( s : string ) : integer;
    var t : integer;
    begin
        result := -1;
        for t := 0 to length(colLabels)-1 do
          if colLabels[t].caption = s then begin
              result := t + colLabelsOffset;
              colLabels[t].Used := true;
          end;
    end;
begin
  r := rowLabelToId (rowLabel);
  if not colsubLabelMode then
      c := colLabelToId (colLabel)
  else
      c := colLabelToId (colLabel+'+'+colSubLabel);

  if r = -1 then Raise Exception.CreateFmt('weeklyTable.addCell, Row %s does not exist', [rowLabel]);
  if c = -1 then Raise Exception.CreateFmt('weeklyTable.addCell, Column %s does not exist', [colLabel]);

  if not assigned( table[ r ][ c ] ) then table[ r ][ c ] := tcell.Create;

  if pos('width=',attributes)=0 then attributes := attributes + ' width="?"';

  table[ r ][ c ].addClass (cntMode, dataCell, false,0,'<td '+attributes+'>'+body+'</td>', true, count);
end;

//------------------------------------------------------------------------------
function tweeklyTable.getTitle : string;
begin
    result := titleCategory + ':' +title + #13#10 + '<br/>';
    if (subtitleCategory<>'') and (subtitle<>'') then
        result := result + subtitleCategory + ':' +subtitle + #13#10 + '<br/>';
end;

//------------------------------------------------------------------------------
function tweeklyTable.getBody(forceSpan : boolean) : string;
var r,c : integer;
    res : string;
    procedure add ( s : string );
    begin
      if s <> '' then
          res := res + s + #13+#10;
    end;
    //------------
    function colUsed (x : integer) : boolean;
    begin
      result := true;
      if x-colLabelsOffset < 0 then exit;
      result := colLabels[x-colLabelsOffset].used = true;
    end;
    //------------
    function rowUsed (x : integer) : boolean;
    begin
      result := true;
      if x-rowLabelsOffset < 0 then exit;
      result := rowLabels[x-rowLabelsOffset].used = true;
    end;
    //------------
    Var spanDisabled : boolean;
begin
  //res := '<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">'+#13+#10;
  res := '<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse; font-size:20px;">'+#13+#10;

  //just show the table with default span, do not merge not used columns
  if forceSpan then begin
    for c :=0 to Length(colLabels)-1 do
       colLabels[c].Used := true;
    for c :=0 to Length(rowLabels)-1 do
       rowLabels[c].Used := true;
  end;

  //unspan table if there are not used columns to be deleted
  spanDisabled := false;
  for c :=0 to Length(colLabels)-1 do
     if not colLabels[c].Used then
        spanDisabled := true;
  //
  if spanDisabled then begin
    for r :=0 to rowCount-1 do
        for c :=0 to colCount-1 do
              if Assigned(table[r][c]) then begin
                  table[r][c].spannedCell := false;
                  table[r][c].colspan := 0;
              end;
  end;

  //free cells
  for r :=0 to rowCount-1 do begin
    if rowUsed(r) then begin
      add ('<tr>');
      for c :=0 to colCount-1 do
          if colUsed(c) then begin
            if Assigned(table[r][c]) then
                add( table[r][c].getBody )
            else
                add('<td></td>');
          end;
      add ('</tr>');
    end;
  end;
  add ('</table>');
  result := res;
end;

//------------------------------------------------------------------------------
procedure tweeklyTable.cleanUp;
var r,c : integer;
begin
  //free cells
  for r :=0 to rowCount-1 do
    for c :=0 to colCount-1 do
      if assigned(table[r][c]) then begin
        if length(table[r][c].table)>0 then begin
            finalize ( table[r][c].table );
        end;
        table[r][c].Free;
        table[r][c] := nil;
      end;

  for r := 0 to rowCount-1 do
      finalize ( table[r] );

  finalize( colLabels );
  finalize( rowLabels );
  finalize( table );
end;


//------------------------------------------------------------------------------
function tweeklyTable.simpleGreyCell (s: string) : tcell;
var c : tcell;
begin
    c := tcell.create;
    c.addClass(cntMode, false, false,0,'<td bgcolor="grey"><center>'+s+'</center></td>', true, 0);
    result := c;
end;

//------------------------------------------------------------------------------
function tweeklyTable.getSpannedCell : tcell;
var c : tcell;
begin
    c := tcell.create;
    c.addClass(cntMode, false, true, 0,'', true, 0);
    result := c;
end;

//------------------------------------------------------------------------------
procedure tcell.addClass(pcntMode : boolean; pdataCell: boolean; pspannedCell : boolean; colspan : integer; s : string; ignoreDuplicates : boolean; count : real) ;
var t : integer;
begin
    cntMode     := pcntMode;
    dataCell    := pdataCell;
    spannedCell := pspannedCell;

    if ignoreDuplicates then
        for t := 0 to length(table) - 1 do
            if table[ t ].s = s then begin
                table[ t ].count := table[ t ].count + count;
                exit;
            end;
    setLength(table, length(table)+1);
    table[ length(table)-1 ].s := s;
    table[ length(table)-1 ].count := count;
end;

//------------------------------------------------------------------------------
function tcell.getBody : string;
var t   : integer;
    res : string;
    c    : real;
begin
    if spannedCell then begin
      result := '';
      exit;
    end;


    if cntMode then
    if dataCell then begin
       c:=0;
       for t := 0 to length(table) - 1 do
           c := c + table[t].count;
       result :=
            '<td><table border="2" style="border:solid white; border-collapse: collapse; font-size:10px;" width="100%">'+#13+#10+
            '<tr>'+#13#10+
            '<center>'+FloatToStr(c)+'</center>'+
           '</tr>'+#13#10+
            '</table></td>';
        exit;
    end;

    if length(table)=1 then begin
        result := StringReplace(table[0].s, ' width="?"', '',[rfReplaceAll, rfIgnoreCase]);
        result := StringReplace(table[0].s, 'colspan="?"', 'colspan="'+intToStr(colspan)+'"',[rfReplaceAll, rfIgnoreCase])
    end
    else begin
        res := '';
        for t := 0 to length(table) - 1 do
          res := res + StringReplace(table[t].s, ' width="?"', ' width="'+intToStr(100 div length(table))+'%"',[rfReplaceAll, rfIgnoreCase]) + #13#10;

            result :=
                '<td><table border="2" style="border:solid white; border-collapse: collapse; font-size:10px;" width="100%">'+#13+#10+
                //'<td><table border="2" style="border:solid white; border-collapse: collapse" width="100%">'+#13+#10+
                '<tr>'+#13#10+
                res+
               '</tr>'+#13#10+
                '</table></td>';
    end;
end;

function tweeklyTables.addWeeklyTable (
    pCntMode : boolean;
    pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string;
    pcolLabels    //day of weeks
  , pcolsubLabels //group names
  , prowLabels : array of string ) : tweeklyTable;
begin
    CntMode := pCntMode;
    setLength(weeklyTables, length(weeklyTables)+1 );

    weeklyTables[length(weeklyTables)-1] := tweeklyTable.Create;
    weeklyTables[length(weeklyTables)-1].init(
        cntMode,
        pTitleCategory, pTitle, pSubtitleCategory, pSubtitle,
        pcolLabels,    //day of weeks
        pcolsubLabels, //group names
        prowLabels);

    result := weeklyTables[length(weeklyTables)-1];
end;

procedure tweeklyTables.merge (forceSpan : boolean);
var t,t2 : integer;
begin
    for t := length(weeklyTables)-1 downto 0 do
        if assigned(weeklyTables[t]) then
            for t2 := 0 to t-1 do
                if assigned(weeklyTables[t2]) then
                    if weeklyTables[t].getBody(forceSpan) = weeklyTables[t2].getBody(forceSpan) then
                        if weeklyTables[t].titleCategory = weeklyTables[t2].titleCategory then
                            if weeklyTables[t].subtitleCategory = weeklyTables[t2].subtitleCategory then
                            begin
                                if pos(weeklyTables[t2].title, weeklyTables[t].title)=0 then
                                    weeklyTables[t].title := weeklyTables[t].title + ', ' + weeklyTables[t2].title;
                                if pos(weeklyTables[t2].subtitle, weeklyTables[t].subtitle)=0 then
                                    weeklyTables[t].subtitle := weeklyTables[t].subtitle + ', ' + weeklyTables[t2].subtitle;

                                weeklyTables[t2].cleanUp;
                                weeklyTables[t2].free;
                                weeklyTables[t2] := nil;
                            end;
end;

//------------------------------------------------------------------------------
function tweeklyTables.getBody(forceSpan : boolean) : string;
var t : integer;
    res : string;
    function htmlEnvelope ( s : string) : string;
    begin
        result :=
        '<!DOCTYPE html>'+#13#10+
        '<html>'+#13#10+
        '<head>'+#13#10+
        '<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">'+#13#10+
        '<title>Plansoft.org - zajêcia</title>'+#13#10+
        '</head>'+#13#10+
        '<body>'+#13#10+
        s+#13#10+
        '<font style="font-size:10px;">'+'Data aktualizacji: '+DateTimeToStr(Now())+'</font>'+#13#10+
        '<hr/><font style="font-size:10px;">'+'Dokument zosta³ utworzony za pomoc¹ programu <a href="http://www.plansoft.org">Plansoft.org</a></font>'+#13#10+
        '</body></html>';
    end;
begin
    res := '';
    for t := 0 to length(weeklyTables)-1 do begin
        if assigned(weeklyTables[t]) then
            res := res + weeklyTables[t].getTitle + weeklyTables[t].getBody(forceSpan)+'<br/><br/>';
    end;
    result := htmlEnvelope( res );
end;

procedure tweeklyTables.cleanUp;
var t : integer;
begin
    for t := 0 to length(weeklyTables)-1 do begin
      if assigned(weeklyTables[t]) then begin
          weeklyTables[t].cleanUp;
          weeklyTables[t].free;
          weeklyTables[t] := nil;
      end;
    end;
end;

//test code
//var weeklyTables : tweeklyTables;
//    f            : textFile;
//    weeklyTable  : tweeklyTable;
//    t            : integer;
//    t2            : integer;
//    t3            : integer;
//initialization
////for t2 := 0 to 100 do begin
//    weeklyTables := tweeklyTables.Create;
//
//    for t := 1 to 100 do begin
//    weeklyTable :=
//    weeklyTables.addWeeklyTable(
//        '01'
//       ,'Przedmiot','Chemia'+inttostr(t),'Okres','2013.01'
//       ,['Poniedzia³ek','Wtorek','Œroda','Czwartek','Pi¹tek','Sobota','Niedziela','XYZ']
//       ,[]
//       ,['ALABAMA','8-9','9-10','11-12']);
//
//    for t3 := 1 to 1000 do
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="red" border="5" style="border:solid white;"','TEST<br/>test');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST<br/>test');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','','9-10','BGCOLOR="purple" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Œroda' ,'','9-10','BGCOLOR="green" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Œroda' ,'','9-10','BGCOLOR="green" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Œroda' ,'','9-10','BGCOLOR="green" border="5" style="border:solid white;"','TEST<br/>test');
//    weeklyTable.addCell('Wtorek','','9-10','BGCOLOR="black" border="5" style="border:solid white;"','TEST');
//
//    weeklyTable :=
//    weeklyTables.addWeeklyTable(
//        '01'
//       ,'Przedmiot','Chemia'+inttostr(t),'Okres','2013.01'
//       ,['Poniedzia³ek','Wtorek','Œroda','Czwartek','Pi¹tek','Sobota','Niedziela','XYZ']
//       ,['C11','C12','C13','C14']
//       ,['ALABAMA','8-9','9-10','11-12']);
//
//    for t3 := 1 to 1000 do
//    weeklyTable.addCell('Sobota','C11','9-10','BGCOLOR="red" border="5" style="border:solid white;"','TEST<br/>test');
//    weeklyTable.addCell('Sobota','C11','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST<br/>test');
//    weeklyTable.addCell('Sobota','C11','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C11','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C11','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C11','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C12','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C12','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C12','9-10','BGCOLOR="yellow" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Sobota','C12','9-10','BGCOLOR="purple" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Œroda' ,'C12','9-10','BGCOLOR="green" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Œroda' ,'C12','9-10','BGCOLOR="green" border="5" style="border:solid white;"','TEST');
//    weeklyTable.addCell('Œroda' ,'C12','9-10','BGCOLOR="green" border="5" style="border:solid white;"','TEST<br/>test');
//    weeklyTable.addCell('Wtorek','C12','9-10','BGCOLOR="black" border="5" style="border:solid white;"','TEST');
//
//    end;
//
//    weeklyTables.merge;
//    assignFile(f,'c:\sampletable.html');
//    rewrite(f);
//    writeLn(f,  weeklyTables.getBody );
//    closeFile(f);
//
//    weeklyTables.cleanUp;
//    finalize( weeklyTables );
////end;
//
//
end.

