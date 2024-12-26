unit UWeeklyTable;

interface

type tcell = class
         cntMode : boolean;
         hidden : boolean;
         colspan : integer;
         rowSpan : integer;
         dataCell: boolean;
         table : array of record
                     s: string;
                     count : real;
                 end;
         procedure addClass(
             pcntMode : boolean;
             pdataCell: boolean;
             s : string;
             ignoreDuplicates : boolean;
             count : real);
         function getCellBody : string;
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
         supressNAValues : boolean;
         public
             procedure init (
                 pcntMode : boolean;
                 pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string;
                 pcolLabels    //day of weeks
               , pcolsubLabels //group names
               , prowLabels : array of string
               ; psupressNAValues : boolean);
             procedure addCell (
                 dataCell: boolean;
                 colLabel
               , colsubLabel
               , rowLabel
               , attributes
               , body : string;
               colsubLabelMode : boolean;
               count : real);
             function  getTitle : string;
             function  getBody (noHideFlag : boolean) : string;
             procedure cleanUp;
             //procedure supressNAValues;
             procedure doRowSpan;
             procedure doColSpan;
         private
             function simpleGreyCell    (s: string) : tcell;
             function colUsed (x : integer) : boolean;
             function rowUsed (x : integer) : boolean;
     end;

type tweeklyTables = class
         cntMode : boolean;
         weeklyTables : array of tweeklyTable;
         function addWeeklyTable (
                 pCntMode : boolean;
                 pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string;
                 pcolLabels    //day of weeks
               , pcolsubLabels //group names
               , prowLabels : array of string
               ; psupressNAValues : boolean
               ) : tweeklyTable;
         procedure merge (noHideFlag : boolean);
         function getBody(noHideFlag, rowSpanFlag, colSpanFlag : Boolean) : string;
         procedure cleanUp;
     end;


implementation

uses sysutils, ufmain, UUtilityParent;


//------------------------------------------------------------------------------
procedure tweeklyTable.init (pCntMode : boolean; pTitleCategory, pTitle, pSubtitleCategory, pSubtitle : string; pcolLabels, pcolsubLabels, prowLabels : array of string; psupressNAValues : Boolean);
var cLength : integer;
    rLength : integer;
    r       : integer;
    t       : integer;
    subColLen : integer;
begin
    supressNAValues  := psupressNAValues;
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
             //if t  mod subColLen = 1 then begin
             //    table[0][t+1]:= tcell.Create;
             //    table[0][t+1].addClass(cntMode, false, '<td bgcolor="#f2f2f2" rowspan="?" colspan="?"><center>'+pcolLabels[t div subColLen]+'</center></td>', true, 0);
             //end else begin
                 table[0][t+1]:= tcell.Create;
                 table[0][t+1].addClass (cntMode, false, '<td bgcolor="#f2f2f2" style="padding: 5px;" rowspan="?" colspan="?"><center>'+pcolLabels[t div subColLen]+'</center></td>', true, 0);
             //end;

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
    function rowLabelToId ( s, searchIn : string ) : integer;
    var t : integer;
    begin
        result := -1;
        for t := 0 to length(rowLabels)-1 do
          if rowLabels[t].caption = s then begin
              result := t + rowLabelsOffset;
              if supressNAValues and (Pos('*brak*', searchIn)>0) then {do not mark row as used - hide it}
              else rowLabels[t].Used := true;
              break;
          end;
    end;
    function colLabelToId ( s, searchIn  : string ) : integer;
    var t : integer;
    begin
        result := -1;
        for t := 0 to length(colLabels)-1 do
          if colLabels[t].caption = s then begin
              result := t + colLabelsOffset;
              if supressNAValues and (Pos('*brak*', searchIn)>0) then {do not mark col as used - hide it}
              else colLabels[t].Used := true;
              break;
          end;
    end;
begin
  if colsubLabelMode then begin
      r := rowLabelToId (rowLabel, rowLabel+colLabel+colSubLabel);
      c := colLabelToId (colLabel+'+'+colSubLabel, rowLabel+colLabel+colSubLabel);
  end
  else begin
      r := rowLabelToId (rowLabel, rowLabel+colLabel);
      c := colLabelToId (colLabel, rowLabel+colLabel)
  end;

  if r = -1 then Raise Exception.CreateFmt('weeklyTable.addCell, Row %s does not exist', [rowLabel]);
  if c = -1 then Raise Exception.CreateFmt('weeklyTable.addCell, Column %s does not exist', [colLabel]);

  if not assigned( table[ r ][ c ] ) then table[ r ][ c ] := tcell.Create;

  if pos('width=',attributes)=0   then attributes := attributes + ' width="?"';
  if pos('rowspan=',attributes)=0 then attributes := attributes + ' rowspan="?"';
  if pos('colspan=',attributes)=0 then attributes := attributes + ' colspan="?"';

  table[ r ][ c ].addClass (cntMode, dataCell, '<td '+attributes+'>'+body+'</td>', true, count);
end;

//------------------------------------------------------------------------------
function tweeklyTable.getTitle : string;
begin
    result := titleCategory + ':' +title + #13#10 + '<br/>';
    if (subtitleCategory<>'') and (subtitle<>'') then
        result := result + subtitleCategory + ':' +subtitle + #13#10 + '<br/>';
    if result='<nie dotyczy>:'+ #13#10 + '<br/>' then result := '';
end;


//------------------------------------------------------------------------------
{
procedure tweeklyTable.supressNAValues;
var t : integer;
begin
  for t := 0 to Length(colLabels)-1 do begin
   if  Pos('*brak*', colLabels[t].caption)>0 then colLabels[t].used := false;
  End;
  for t := 0 to Length(rowLabels)-1 do begin
   if  Pos('*brak*', rowLabels[t].caption)>0 then rowLabels[t].used := false;
  End;
end;
}

procedure tweeklyTable.doRowSpan;
var r,c,t : integer;
    curr : string;
    compared : string;
begin

 for r := 0 to rowCount -1 do begin
   If not rowUsed(r) then continue;
   for c := 0 to colCount-1 do begin
     If not colUsed(c) then continue;
     if Assigned(table[r][c]) and not table[r][c].hidden and (table[r][c].rowSpan =1) {not spanned} then begin
       // examine all cells below cell
       curr :=     table[r][c].getCellBody;
       for t := r+1 to rowCount -1 do begin
         If not rowUsed(t) then continue; //just ignore not used column and proceed (multi table generation can have lots of rows not applicable)
         if Assigned(table[t][c]) then begin
           compared := table[t][c].getCellBody;
           if  (compared = curr) and not table[t][c].hidden and (table[t][c].rowSpan =1) {not spanned}
              then begin
                inc ( table[r][c].rowSpan );
                table[t][c].hidden := true;
              end
              else break;
         end;
       end;
     end;
   end;
 end;

end;


procedure tweeklyTable.doColSpan;
var r,c,t : integer;
    curr : string;
    compared : string;

    procedure showDebug;
    var r,c : integer;
    begin
     for r := 0 to rowCount -1 do begin
       for c := 0 to colCount-1 do begin
         fmain.wlog(
           inttoStr(r)+':'+inttostr(c)
           );

         fmain.wlog(
           '  rowUsed:'+BoolToStr(rowUsed(r))+':'+ ' colUsed:'+BoolToStr(colUsed(c))
           );

         fmain.wlog(
           '  assigned: '+ BoolToStr(Assigned(table[r][c]))
           );

         if Assigned(table[r][c]) then
         fmain.wlog(
           '  hidden: '+
               iif(Assigned(table[r][c])
                 ,BoolToStr(table[r][c].hidden)
                 ,'N/A')
           );

         if Assigned(table[r][c]) then
         fmain.wlog(
           '  colspan: '+
              iif(Assigned(table[r][c])
                 ,inttoStr(table[r][c].colspan)
                 ,'N/A')
           );


         if Assigned(table[r][c]) then
         fmain.wlog(
           '  BODY:'+
             iif(Assigned(table[r][c])
               ,table[r][c].getCellBody
               ,'')
           );

       end;
     end;
   end;

begin
  // Be cautious with this debug, it may signifcantly slow down application.
  //fmain.wlog('BEFORE');
  //showDebug;

 for r := 0 to rowCount -1 do begin
   If not rowUsed(r) then continue;
   for c := 0 to colCount-1 do begin
     If not colUsed(c) then continue;
     if  Assigned(table[r][c]) and not table[r][c].hidden and (table[r][c].rowSpan =1) {not spanned}  then begin
       // examine all cells to the left of this cell
       curr :=     table[r][c].getCellBody;
       for t := c+1 to colCount-1 do begin
         If not colUsed(t) then continue; //just ignore not used column and proceed (multi table generation can have lots of columns not applicable)
         if Assigned(table[r][t]) then begin
           compared := table[r][t].getCellBody;
           if (curr = compared) and not table[r][t].hidden and (table[r][t].rowSpan =1) {not spanned}
              then begin
                inc ( table[r][c].colSpan );
                table[r][t].hidden := true;
              end
              else break;
         end;
       end;
     end;
   end;
 end;

 // Be cautious with this debug, it may signifcantly slow down application.
 //fmain.wlog('AFTER');
 //showDebug;

end;


//------------
function tweeklyTable.colUsed (x : integer) : boolean;
begin
  result := true;
  if x < colLabelsOffset then exit;
  result := colLabels[x-colLabelsOffset].used = true;
end;

//------------
function tweeklyTable.rowUsed (x : integer) : boolean;
begin
  result := true;
  if x < rowLabelsOffset then exit;
  result := rowLabels[x-rowLabelsOffset].used = true;
end;

//------------------------------------------------------------------------------
function tweeklyTable.getBody(noHideFlag : boolean) : string;
var r,c : integer;
    res : string;
    procedure add ( s : string );
    begin
      if s <> '' then
          res := res + s + #13+#10;
    end;
    //------------
    Var tmp : string;
begin
  //res := '<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">'+#13+#10;
  res := '<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse; font-size:20px;">'+#13+#10;

  //just show the table with default span, do not merge not used columns
  if noHideFlag then begin
    for c :=0 to Length(colLabels)-1 do
       colLabels[c].Used := true;
    for c :=0 to Length(rowLabels)-1 do
       rowLabels[c].Used := true;
  end;

  //free cells
  for r :=0 to rowCount-1 do begin
    if rowUsed(r) then begin
      add ('<tr>');
      for c :=0 to colCount-1 do
          if colUsed(c) then begin
            if Assigned(table[r][c]) then begin
                tmp := StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(
                      table[r][c].getCellBody
                   , '2.PONIEDZIA£EK', 'PONIEDZIA£EK',[rfReplaceAll, rfIgnoreCase])
                   , '3.WTOREK',       'WTOREK',      [rfReplaceAll, rfIgnoreCase])
                   , '4.ŒRODA',        'ŒRODA',       [rfReplaceAll, rfIgnoreCase])
                   , '5.CZWARTEK',     'CZWARTEK',    [rfReplaceAll, rfIgnoreCase])
                   , '6.PI¥TEK',       'PI¥TEK',      [rfReplaceAll, rfIgnoreCase])
                   , '7.SOBOTA',       'SOBOTA',      [rfReplaceAll, rfIgnoreCase])
                   , '1.NIEDZIELA',    'NIEDZIELA',   [rfReplaceAll, rfIgnoreCase])
                   ;
                add( tmp )
            end else
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
    c.addClass(cntMode, false, '<td bgcolor="#f2f2f2" style="padding: 5px;" rowspan="?" colspan="?"><center>'+s+'</center></td>', true, 0);
    result := c;
end;


//------------------------------------------------------------------------------
procedure tcell.addClass(pcntMode : boolean; pdataCell: boolean;  s : string; ignoreDuplicates : boolean; count : real) ;
var t : integer;
begin
    cntMode     := pcntMode;
    dataCell    := pdataCell;
    rowSpan     := 1;
    colSpan     := 1;
    hidden      := false;

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
function tcell.getCellBody : string;
var t   : integer;
    res : string;
    c    : real;
    rowSpanString : string;
    colSpanString : string;
begin
    if hidden then begin
      //table[0].s := 'HIDDEN' + table[0].s;
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
        //result := StringReplace(result, 'colspan="?"', 'colspan="'+intToStr(colspan)+'"',[rfReplaceAll, rfIgnoreCase]);
        if (rowspan>1) then
           result := StringReplace(result, 'rowspan="?"', 'rowspan="'+intToStr(rowspan)+'"',[rfReplaceAll, rfIgnoreCase])
        else
          //remove rowspan
          result := StringReplace(result, 'rowspan="?"', '',[rfReplaceAll, rfIgnoreCase]);
        if (colspan>1) then
           result := StringReplace(result, 'colspan="?"', 'colspan="'+intToStr(colspan)+'"',[rfReplaceAll, rfIgnoreCase])
        else
          //remove colspan
          result := StringReplace(result, 'colspan="?"', '',[rfReplaceAll, rfIgnoreCase]);
    end
    else begin
        res := '';
        for t := 0 to length(table) - 1 do
          res := res + StringReplace(StringReplace(
            StringReplace(table[t].s, ' width="?"', ' width="'+intToStr(100 div length(table))+'%"',[rfReplaceAll, rfIgnoreCase])
            //remove rowspan on TD level, not needed.
            , 'rowspan="?"', '',[rfReplaceAll, rfIgnoreCase])
            , 'colspan="?"', '',[rfReplaceAll, rfIgnoreCase])
            + #13#10;

            if (rowspan>1) then
               rowspanString := ' rowspan="'+intToStr(rowspan)+'" '
            else
              rowspanString := '';

            if (colspan>1) then
               colspanString := ' colspan="'+intToStr(colspan)+'" '
            else
              colspanString := '';


            result :=
                '<td '+rowspanString+colspanString+'><table border="2" style="border:solid white; border-collapse: collapse; font-size:10px;" width="100%">'+#13+#10+
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
  , prowLabels : array of string
  ; psupressNAValues : boolean
  ) : tweeklyTable;
begin
    CntMode := pCntMode;
    setLength(weeklyTables, length(weeklyTables)+1 );

    weeklyTables[length(weeklyTables)-1] := tweeklyTable.Create;
    weeklyTables[length(weeklyTables)-1].init(
        cntMode,
        pTitleCategory, pTitle, pSubtitleCategory, pSubtitle,
        pcolLabels,    //day of weeks
        pcolsubLabels, //group names
        prowLabels, psupressNAValues);

    result := weeklyTables[length(weeklyTables)-1];
end;

procedure tweeklyTables.merge (noHideFlag : boolean);
var t,t2 : integer;
begin
    for t := length(weeklyTables)-1 downto 0 do
        if assigned(weeklyTables[t]) then
            for t2 := 0 to t-1 do
                if assigned(weeklyTables[t2]) then
                    if weeklyTables[t].getBody(noHideFlag) = weeklyTables[t2].getBody(noHideFlag) then
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
function tweeklyTables.getBody(noHideFlag, rowSpanFlag, colSpanFlag : boolean) : string;
var t : integer;
    res : string;
    function htmlEnvelope ( s : string) : string;
    begin
        result :=
        '<!DOCTYPE html>'+#13#10+
        '<html>'+#13#10+
        '<head>'+#13#10+
        '<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">'+#13#10+
        '<title>Plansoft.org - zajêcia</title>'+#13#10+
        '</head>'+#13#10+
        '<body>'+#13#10+
        s+#13#10+
        '<font style="font-size:10px;">'+'Data aktualizacji: '+DateTimeToStr(Now())+'</font>'+#13#10+
        '<hr/><font style="font-size:10px;">'+'Dokument zosta³ utworzony za pomoc¹ programu <a href="http://www.plansoft.org">Plansoft.org</a></font>'+#13#10+
        '</body></html>';
        result := UTF8Encode(result);
    end;
begin
    res := '';
    for t := 0 to length(weeklyTables)-1 do begin
        if assigned(weeklyTables[t]) then begin
            fmain.wlog('dorowspan');
            if rowSpanFlag then weeklyTables[t].dorowspan;
            fmain.wlog('docolspan');
            if colSpanFlag then weeklyTables[t].docolspan;
            res := res + weeklyTables[t].getTitle + weeklyTables[t].getBody(noHideFlag)+'<br/><br/>';
        End;
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

