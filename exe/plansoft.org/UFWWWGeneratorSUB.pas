unit UFWWWGeneratorSUB;

// Periodic HTML schedule ("Grafik okresowy") for a single subject (Przedmiot).
// TFWWWGenerator.calendarToHTML (UFWWWGenerator.pas) hardcodes LEC/GRO/ROM throughout
// its body and is never touched here - this unit is a separate, self-contained twin
// that reuses the same building blocks (thtmlTable, convertGrid, the D1-D5/S1-S5/B1-B5
// cell-content formatting, the ColoringIndex dispatch) so the printed page looks and
// behaves consistently with the LEC/GRO/ROM reports, without risking that working code.
// A subject cell can hold several parallel classes - the multi-class-per-cell rendering
// below is the same nested-mini-table approach calendarToHTML already uses when several
// distinct classes share one slot.

interface

uses SysUtils, Classes;

procedure CalendarToHTMLSubject(
       pPeriodId: String;
       presId : string;
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
       pRepeatMonthNames : boolean;
       pHideEmptyRows    : boolean;
       pHideDows         : string;
       pSpan             : integer;
       pspanEmptyCells   : boolean;
       ptransposition : boolean;
       pVerticalLines : boolean;
       notes_before : boolean;
       notes_after : boolean;
       pdfPrintOut, pdfg, pdfl, pdfo, pdfs : boolean;
       weeklyView : boolean;
       const LegendColorBy : Integer = 0
);

implementation

uses Windows, Graphics, DM, UFMain, UUtilities, UCommon, UUtilityParent, Db;

var MaxLegendPositions : integer = 1000;

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
       procedure init(aCellWIDTH, aCellHeight : string; aspanEmptycellsFlag  : boolean);
       procedure AddRow (attrs : string);
       Procedure NewCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       Procedure NewCellCol1(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       Procedure NewCellCol2(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       Procedure NewHeaderCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       Procedure NewCellWidth(Command, S, Color, Width : String);
       procedure Colspan;
       procedure Rowspan;
       procedure transposite;
       function  Flush : string;
       procedure writeCell (s : string; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
       private
       procedure doSpan ( spanType : integer );
       procedure newCellWithWidth(Command, S, Color, Width : String; const colSpan : integer; const rowSpan : integer; const ignoreFlag : boolean);
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
begin
  if Pos(intToStr(colCount),verticalLines)<>0  then
      s := StringReplace(s, '<TD ', '<TD style=''border-right:solid 2.0pt''', [rfIgnoreCase]);

  inc ( colCount );
  setLength(table[ rowCount-1 ].cells, colCount);
  table[ rowCount-1 ].cells[ colCount-1 ].body := s;
  table[ rowCount-1 ].cells[ colCount-1 ].rowSpan := rowSpan;
  table[ rowCount-1 ].cells[ colCount-1 ].colSpan := colSpan;
  table[ rowCount-1 ].cells[ colCount-1 ].ignoreFlag := ignoreFlag;
end;

function htmlColorValue(Color : String) : String;
begin
  Result := Color;
  if (Length(Result) >= 2) and (Result[1] = '"') and (Result[Length(Result)] = '"') then
    Result := Copy(Result, 2, Length(Result)-2);
end;

procedure thtmlTable.newCellWithWidth(Command, S, Color, Width : String; const colSpan : integer; const rowSpan : integer; const ignoreFlag : boolean);
Begin
  If isBlank(S) Then S := '&nbsp';
  If Color <> '0' Then writeCell ( '<TD ROWSPAN="?" COLSPAN="?" style="height:'+lCellHeight+'px;width:'+Width+'px;background-color:'+htmlColorValue(Color)+'" '+Command+' >'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
                  Else writeCell ( '<TD ROWSPAN="?" COLSPAN="?" style="height:'+lCellHeight+'px;width:'+Width+'px" '+Command+' >'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
End;

procedure thtmlTable.newCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
Begin
  newCellWithWidth(Command, S, Color, lCellWIDTH, colSpan, rowSpan, ignoreFlag);
End;

procedure thtmlTable.newCellCol1(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
Begin
  newCellWithWidth(Command, S, Color, NVL(GetSystemParam('CellWidthDay'),lCellWIDTH), colSpan, rowSpan, ignoreFlag);
End;

procedure thtmlTable.newCellCol2(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
Begin
  newCellWithWidth(Command, S, Color, NVL(GetSystemParam('CellWidthHour'),lCellWIDTH), colSpan, rowSpan, ignoreFlag);
End;

procedure thtmlTable.newHeaderCell(Command, S, Color : String; const colSpan : integer = 1; const rowSpan : integer = 1 ; const ignoreFlag : boolean = false);
Begin
  If isBlank(S) Then S := '&nbsp';
  If Color <> '0' Then writeCell ( '<TD ROWSPAN="?" COLSPAN="?" '+Command+' BGCOLOR='+Color+'>'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
                  Else writeCell ( '<TD ROWSPAN="?" COLSPAN="?" '+Command+' >'+S+'</TD>',colSpan, rowSpan, ignoreFlag)
End;

procedure thtmlTable.newCellWidth(Command, S, Color, Width : String);
Begin
  If isBlank(S) Then S := '&nbsp';
  If Color <> '0' Then writeCell ( '<TD ROWSPAN="?" COLSPAN="?" WIDTH='+WIDTH+' style="background-color:'+htmlColorValue(Color)+'" '+Command+' >'+S+'</TD>')
                  Else writeCell ( '<TD ROWSPAN="?" COLSPAN="?" WIDTH='+WIDTH+' '+Command+' >'+S+'</TD>')
End;

procedure thtmlTable.transposite;
var r,c : integer;
    htmlTable : thtmlTable;
begin
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
       for t := c+1 to high(table[r].cells) do begin
         if (table[r].cells[t].body = table[r].cells[c].body) and not ( table[r].cells[t].ignoreFlag )
            then begin
              inc ( table[r].cells[c].colSpan );
              table[r].cells[t].ignoreFlag := true;
            end
            else break;
       end;
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
     if not table[r].cells[c].ignoreFlag and (( pos('>&nbsp<', table[r].cells[c].body) = 0 ) or spanEmptycellsFlag ) then begin
       for t := r+1 to rowCount -1 do begin
         if c > high ( table[t].cells ) then break;
         if (table[t].cells[c].body = table[r].cells[c].body) and not ( table[t].cells[c].ignoreFlag )
            then begin
              inc ( table[r].cells[c].rowSpan );
              table[t].cells[c].ignoreFlag := true;
            end
            else break;
       end;
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
       s := s + cellBuffer+#13#10;
     end;
   end;
   s := s + '</TR>'+#13#10;
 end;
 result := s;
end;

//--------------------------------------------------------------------------------------

// Converts a text file written using the system's ANSI codepage (windows-1250 on a Polish-locale
// machine) into UTF-8 in place - the HTML declares charset=utf-8, so the bytes on disk must
// actually be UTF-8 or Polish letters render as replacement characters. Matches the identical
// helper already used by TFWWWGenerator.CalendarToHTML in UFWWWGenerator.pas.
procedure ConvertAnsiFileToUtf8(const aFileName : string);
var sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(aFileName);
    sl.Text := UTF8Encode(sl.Text);
    sl.SaveToFile(aFileName);
  finally
    sl.Free;
  end;
end;

procedure CalendarToHTMLSubject(
       pPeriodId: String;
       presId : string;
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
       pRepeatMonthNames : boolean;
       pHideEmptyRows    : boolean;
       pHideDows         : string;
       pSpan             : integer;
       pspanEmptyCells   : boolean;
       ptransposition : boolean;
       pVerticalLines : boolean;
       notes_before : boolean;
       notes_after : boolean;
       pdfPrintOut, pdfg, pdfl, pdfo, pdfs : boolean;
       weeklyView : boolean;
       const LegendColorBy : Integer = 0
    );

    Var F : TextFile;
        Class_ : TClass_;
        sHeader, sFooter : String;
        classList : TClassArray;
        subjectName : string;

    var htmlTable : thtmlTable;
        colCnt, rowCnt : integer;
        xp, yp : integer;
        dummy  : integer;
        TS : TTimeStamp;
        Zajecia : integer;
        tmp : integer;
        showLine : boolean;
        cellCurrent, cellPrior, cells : string;
        uniqueCnt, i : integer;
        notesBeforeText, notesAfterText : string;
        tmpPERName : string;
        addECTSflag : boolean;
        legendRow : integer;
        fuse : integer;

    Var Lgnd : Array Of Record Name, ShortCut : String; Colour : Integer; End;
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
      if not fileexists(exeName) then SError('Ups.. Utworzenie pdf nie powiedzie si' + #281 + ', poniewa' + #380 + ' nie odnaleziono pliku: '+exeName+#13#10);
      fmain.wlog(exeName+' '+parameters);
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

      Procedure AddCell(Command, S, Color : String);
      var width : String;
      Begin
        If isBlank(S) Then S := '&nbsp';
        width := '';
        if  CellWIDTH <> '' then  width := ' WIDTH="'+CellWIDTH+'"' ;
        If Color <> '0' Then Writeln( '<TD HEIGHT="'+CELLHEIGHT+'" '+width+Command+' BGCOLOR="'+Color+'">'+S+'</TD>')
                        Else Writeln( '<TD HEIGHT="'+CELLHEIGHT+'" '+width+Command+' >'+S+'</TD>')
      End;

     Procedure Common (Counter : Integer; CommonAttr : TColors);
     Var t : Integer;
         descCodes  : Array[1..5] Of ShortString;
         Sizes      : Array[1..5] Of ShortString;
         Bolds      : Array[1..5] Of Boolean;
         Colour : Integer;
         S, Token : String;
     Begin
       If Class_.FOR_KIND = 'R' Then Begin
         AddCell('',Copy(Class_.FOR_abbreviation,1,StrToInt(NVL(GetSystemParam('MaxLengthFOR_abbreviation'),'1000'))),'"silver"');
         Exit;
       End;

       If Counter > 0 Then
       Begin
         If ColoringIndex <> 'None' Then Begin
           Colour := 0;
           For t:=0 To Counter-1 Do Begin
             Colour := Colour + CommonAttr[t];
           End;
           Colour := Colour div Counter;
         End;
       End
       Else Colour := clRed;

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

     Var CommonAttr : TColors;

     procedure DrawL;
     var Count,t : Integer;
     begin
       Count := WordCount(Class_.CALC_LEC_IDS, [';']);
       For t := 1 To Count Do CommonAttr[t-1] := dmodule.LecturerGetColour(ExtractWord(t,Class_.CALC_LEC_IDS, [';']));
       Common(Count, CommonAttr);
     end;

     procedure DrawG;
     var Count,t : Integer;
     begin
       Count := WordCount(Class_.CALC_GRO_IDS, [';']);
       For t := 1 To Count Do CommonAttr[t-1] := dmodule.GroupGetColour(ExtractWord(t,Class_.CALC_GRO_IDS, [';']));
       Common(Count, CommonAttr);
     end;

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

     procedure DrawDesc;
     begin
       if ColoringIndex = 'DESC1' then begin if not isBlank(Class_.desc1) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       if ColoringIndex = 'DESC2' then begin if not isBlank(Class_.desc2) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       if ColoringIndex = 'DESC3' then begin if not isBlank(Class_.desc3) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       if ColoringIndex = 'DESC4' then begin if not isBlank(Class_.desc4) then CommonAttr[0] := clRed else CommonAttr[0] := clSilver; end;
       Common(1, CommonAttr);
     end;

     procedure DrawS;
     begin
       CommonAttr[0] := Class_.SUB_COLOUR;
       Common(1, CommonAttr);
     end;

     procedure DrawF;
      begin
       CommonAttr[0] := Class_.FOR_COLOUR;
       Common(1, CommonAttr);
      end;

     procedure DrawOwner;
      begin
       CommonAttr[0] := Class_.OWNER_COLOUR;
       Common(1, CommonAttr);
      end;

     procedure DrawCreatedBy;
      begin
       CommonAttr[0] := Class_.CREATOR_COLOUR;
       Common(1, CommonAttr);
      end;

     procedure DrawClass;
      begin
       CommonAttr[0] := Class_.class_colour;
       Common(1, CommonAttr);
      end;

     procedure DrawEmpty;
      begin
       Common(1, CommonAttr);
      end;

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
      if ColoringIndex = 'DESC1'      then DrawDesc      else
      if ColoringIndex = 'DESC2'      then DrawDesc      else
      if ColoringIndex = 'DESC3'      then DrawDesc      else
      if ColoringIndex = 'DESC4'      then DrawDesc      else
      if ColoringIndex = 'ALL_RES'    then DrawR     else DrawR;
    End;

    //--------------------------------------------------------
    function replacePlaceHolders(s : string) : string;
    begin
     result := SearchAndReplace(s,'_','&nbsp;');
     result := SearchAndReplace(result,'%PERIOD',tmpPERName);
     if (pos('<',result)=0) and (pos('>',result)=0) then
       result := SearchAndReplace(result,#13#10, '<br/>');
    end;

    function getDayName ( i: word) : string;
    begin
      if weeklyView then result := LongDayNames[i]
                    else result := ShortDayNames[i];
    end;

    procedure addMonthsRow (addECTSflag : Boolean);
    Var oldMonthName : ShortString;
        newMonthName : ShortString;
        SPAN : Integer;
        xp2  : Integer;
        dummy2 : integer;
        TS2 : TTimeStamp;
        Zajecia2 : Integer;
    begin
        htmlTable.AddRow('ALIGN="center" VALIGN="middle"');

        htmlTable.newCellWidth('','','"silver"',  NVL(GetSystemParam('CellWidthDay'),'0') );
        htmlTable.newCellWidth('','','"silver"',  NVL(GetSystemParam('CellWidthHour'),'0') );
        oldMonthName := GetLongMonthName(convertGrid.convertSingleObject.ColRowDate[1].Date);
        newMonthName := oldMonthName;
        SPAN := 0;
        For xp2:=0+2 To colCnt-1 Do Begin
          If convertGrid.ColRowToDate(dummy2, TS2,Zajecia2,xp2,0) = ConvHeader Then
            newMonthName := GetLongMonthName(TS2.Date);
          If newMonthName = oldMonthName Then Begin
           SPAN := SPAN + 1;
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

    procedure calculateVerticalLines;
    Var xp2     : Integer;
    Var oldMonthName : ShortString;
        newMonthName : ShortString;
        dummy2 : integer;
        TS2 : TTimeStamp;
        Zajecia2 : integer;
    begin
      htmlTable.verticalLines := ',';
      oldMonthName := GetLongMonthName(convertGrid.convertSingleObject.ColRowDate[1].Date);
      newMonthName := oldMonthName;
      For xp2:=0+2 To colCnt-1 Do Begin
        If convertGrid.ColRowToDate(dummy2, TS2,Zajecia2,xp2,0) = ConvHeader Then
          newMonthName := GetLongMonthName(TS2.Date);
        If newMonthName = oldMonthName Then Begin
         {};
        End Else Begin
         oldMonthName := newMonthName;
         htmlTable.verticalLines := htmlTable.verticalLines + intToStr(xp2-1)+',';
        End;
      End;
    end;

    procedure addLegendRow (addECTSflag : Boolean);
    Begin
      If Lgnd[legendRow].Colour = 0 Then Begin
        htmlTable.newCell(
            'mergeWith="'+Lgnd[legendRow].Name+IntToStr(legendRow)+'"'
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
             'mergeWith="'+Lgnd[legendRow].Name+IntToStr(legendRow)+'"'
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

    // Legend for the subject view: unlike LEC/GRO/ROM (which need the parent/child resource
    // expansion + a junction table to scope classes), a subject scopes classes directly via
    // CLA.SUB_ID, so the "outer" queries below are simpler than TFWWWGenerator's RefreshLegend.
    // Deliberately does not support "group summary" mode (LegendMode bit 8) - that is an
    // uncommon combination and would double the SQL variants below for little benefit.
    function RefreshLegend : integer;
      var periodClause : String;
          weekVisibilityClause : string;
          LegendRowNumber : Integer;
          MaxL : Integer;
          outerScopeClause : string;
    const
      LEGEND_COLOR_SUBJECT  = 0;
      LEGEND_COLOR_GROUP    = 1;
      LEGEND_COLOR_LECTURER = 2;
      LEGEND_COLOR_FORM     = 3;
      LEGEND_COLOR_ROOM     = 4;
    begin
    MaxL := StrToInt(NVL(GetSystemParam('MaxLecturersInLegend'),'1000'));

    if LegendColorBy = LEGEND_COLOR_GROUP then
      outerScopeClause := 'CLA.ID in (select CLA_ID from GRO_CLA where GRO_ID = :SUB_ID and IS_CHILD=''N'') '
    else if LegendColorBy = LEGEND_COLOR_LECTURER then
      outerScopeClause := 'CLA.ID in (select CLA_ID from LEC_CLA where LEC_ID = :SUB_ID and IS_CHILD=''N'') '
    else if LegendColorBy = LEGEND_COLOR_FORM then
      outerScopeClause := 'CLA.FOR_ID    = :SUB_ID '
    else if LegendColorBy = LEGEND_COLOR_ROOM then
      outerScopeClause := 'CLA.ID in (select CLA_ID from ROM_CLA where ROM_ID = :SUB_ID and IS_CHILD=''N'') '
    else
      outerScopeClause := 'CLA.SUB_ID     = :SUB_ID ';

    For LegendRowNumber := 1 To High(Lgnd) Do Begin
     Lgnd[LegendRowNumber].Name     := '';
     Lgnd[LegendRowNumber].ShortCut := '';
     Lgnd[LegendRowNumber].Colour   := 0;
    End;

    setLength(Lgnd, MaxLegendPositions+1);
    LegendRowNumber := 0;
    With DModule Do Begin

     periodClause  := UCommon.getWhereClausefromPeriod('ID = ' + pPeriodId ,'CLA.');
     weekVisibilityClause := UCommon.getWeekVisibilityClause(pPeriodId);

     if LegendColorBy=LEGEND_COLOR_SUBJECT then
        OpenSQL('SELECT DISTINCT SUB.ID, SUB.NAME, SUB.ABBREVIATION, SUB.COLOUR '+
                '  FROM CLASSES CLA, SUBJECTS SUB '+
                ' WHERE CLA.SUB_ID = SUB.ID AND CLA.SUB_ID = '+presId+' '+
                '   AND '+periodClause+weekVisibilityClause+' '+
                'ORDER BY SUB.NAME');

     if LegendColorBy=LEGEND_COLOR_GROUP then
        OpenSQL('SELECT DISTINCT GRO.ID, GRO.NAME, GRO.ABBREVIATION, GRO.COLOUR '+
                '  FROM CLASSES CLA, GROUPS GRO, GRO_CLA GCO '+
                ' WHERE CLA.SUB_ID = '+presId+' '+
                '   AND GCO.CLA_ID = CLA.ID AND GCO.GRO_ID = GRO.ID AND GCO.IS_CHILD = ''N'' '+
                '   AND '+periodClause+weekVisibilityClause+' '+
                'ORDER BY GRO.NAME');

     if LegendColorBy=LEGEND_COLOR_LECTURER then
        OpenSQL('SELECT DISTINCT LEC.ID, '+sql_LECNAME+' LEC_NAME, LEC.ABBREVIATION, LEC.COLOUR '+
                '  FROM CLASSES CLA, LECTURERS LEC, LEC_CLA LCO '+
                ' WHERE CLA.SUB_ID = '+presId+' '+
                '   AND LCO.CLA_ID = CLA.ID AND LCO.LEC_ID = LEC.ID AND LCO.IS_CHILD = ''N'' '+
                '   AND '+periodClause+weekVisibilityClause+' '+
                'ORDER BY LEC_NAME');

     if LegendColorBy=LEGEND_COLOR_FORM then
        OpenSQL('SELECT DISTINCT FORM.ID, FORM.NAME, FORM.ABBREVIATION, FORM.COLOUR '+
                '  FROM CLASSES CLA, FORMS FORM '+
                ' WHERE CLA.SUB_ID = '+presId+' AND FORM.ID = CLA.FOR_ID '+
                '   AND '+periodClause+weekVisibilityClause+' '+
                'ORDER BY FORM.NAME');

     if LegendColorBy=LEGEND_COLOR_ROOM then
        OpenSQL('SELECT DISTINCT ROM.ID, ROM.NAME, ROM.NAME, ROM.COLOUR '+
                '  FROM CLASSES CLA, ROOMS ROM, ROM_CLA RCO '+
                ' WHERE CLA.SUB_ID = '+presId+' '+
                '   AND RCO.CLA_ID = CLA.ID AND RCO.ROM_ID = ROM.ID AND RCO.IS_CHILD = ''N'' '+
                '   AND '+periodClause+weekVisibilityClause+' '+
                'ORDER BY ROM.NAME');

     While Not QWork.Eof Do Begin
      LegendRowNumber := LegendRowNumber + 1;
      if LegendRowNumber > MaxLegendPositions then begin
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

      if (LegendMode and 1 = 0) then begin
         OpenSQL2('SELECT DISTINCT lec.abbreviation, '+sql_LECNAME+' NAME, NULL '+
                  'FROM CLASSES CLA'+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC '+
                  'WHERE LEC_CLA.CLA_ID =  CLA.ID '+
                    'AND LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND CLA.SUB_ID = '+presId+' '+
                    'AND '+outerScopeClause+
                    'AND '+periodClause+weekVisibilityClause+' '+
                  'ORDER BY 1'
                , 'SUB_ID='+QWork.Fields[0].AsString);
      end;

      if (LegendMode and 1 = 1) then begin
         OpenSQL2('SELECT lec.abbreviation, '+sql_LECNAME+' NAME, FORM.abbreviation || '' '' || SUM( GRIDS.DURATION*CLA.FILL/100), FORM.SORT_ORDER_ON_REPORTS '+
                  'FROM CLASSES CLA'+
                  '   , FORMS FORM'+
                  '   , GRIDS '+
                  '   , LEC_CLA'+
                  '   , LECTURERS LEC '+
                  'WHERE LEC_CLA.LEC_ID =  LEC.ID(+) '+
                    'AND LEC_CLA.CLA_ID(+) =  CLA.ID '+
                    'AND CLA.SUB_ID = '+presId+' '+
                    'AND '+outerScopeClause+
                    'AND '+periodClause+weekVisibilityClause+' '+
                    'AND FORM.ID = CLA.FOR_ID '+
                    'and cla.hour = grids.no '+
                    'GROUP BY lec.abbreviation, LEC.TITLE, LEC.FIRST_NAME, LEC.LAST_NAME,FORM.abbreviation,FORM.SORT_ORDER_ON_REPORTS '+
                  'ORDER BY FORM.SORT_ORDER_ON_REPORTS'
                , 'SUB_ID='+QWork.Fields[0].AsString);
      end;

      fuse := 1;
      While Not QWork2.Eof Do Begin

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
     If Not isBlank(Lgnd[LegendRowNumber].Name) Then Lgnd[LegendRowNumber].Name := '<P align=left>'+Lgnd[LegendRowNumber].Name+'</P>';
    End;
    end; //RefreshLegend

//-------------------------------------------------------------------------------------------
begin
 if isBlank(pPeriodId) or isBlank(presId) then begin
   SError('Brak wybranego okresu lub przedmiotu.');
   exit;
 end;

 subjectName := DModule.SingleValue(sql_SUBDESC+presId);
 addECTSflag := (LegendMode and 4 = 4);

 convertGrid.setupGrid (pPeriodId, true, 6, '', colCnt, rowCnt);

 If ShowLegend Then LgndCnt := RefreshLegend;

 AssignFile(F, FileName);
 Rewrite(F);
 Writeln(f, '<!DOCTYPE html>');
 WriteLn(f, '<HTML>');

 WriteLn(f, '<HEAD>');
 WriteLn(f, '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">');
 WriteLn(f, '<TITLE>Plansoft.org - '+ subjectName +'</TITLE>');

 WriteLn(f, ' <style>');
 WriteLn(f, 'table, td, th {');
 WriteLn(f, '  border: 1px solid black;');
 WriteLn(f, '}');

 WriteLn(f, 'table {');
 WriteLn(f, '  width: 100%;');
 WriteLn(f, '  border-collapse: collapse;');
 WriteLn(f, '  padding: 0px;');
 WriteLn(f, '  margin:0 auto;');
 WriteLn(f, '  height: 1px;');
 WriteLn(f, '}');
 WriteLn(f, '</style>');

 WriteLn(f, '</HEAD>');
 WriteLn(f, '<BODY>');

 tmpPERName := DModule.SingleValue(sql_PERDESC+pPeriodId);

 notesBeforeText := '';
 notesAfterText := '';

 if (notes_before or notes_after) then begin
    dmodule.openSQL(
         'select id, per_id, res_id, notes_before, notes_after, internal_notes from timetable_notes where per_id=:per_id and res_id=:res_id' ,
         'per_id='+ pPeriodId+
         ';res_id='+ presId
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

 if weeklyView=false then
   if not pRepeatMonthNames then addMonthsRow(addECTSflag);
 if pVerticalLines then calculateVerticalLines;

 legendRow := 0;

 For yp:=0 To rowCnt-1 Do Begin

  if pHideEmptyRows then begin
    showLine := false;
    For xp:=0 To colCnt-1 Do Begin
      if convertGrid.ColRowToDate(dummy, TS, Zajecia, xp, yp ) = ConvClass then begin
         tmp := DayOfWeek(TimeStampToDateTime(TS));
         if pHideDows[tmp]='-' then showLine := true
         else begin
           classList := FMain.ClassBySubjectCaches.GetClasses(TS, Zajecia, StrToInt(pPeriodId), presId);
           if (Length(classList)>0) then showLine := true;
         end;
      end;
      if Zajecia = 0 then showLine := true;
    end;
  end else showLine := true;

  if pRepeatMonthNames then begin
    if showLine then begin
        if convertGrid.ColRowToDate(dummy, TS,Zajecia,0,yp) = ConvDayOfWeek then begin
          if (TS.Date <> -1) and (DayOfWeek(TimeStampToDateTime(TS)) = 2) then
            addMonthsRow(addECTSflag);
        end;
    end;
  end;

  if showLine then begin
  htmlTable.AddRow('ALIGN="center" VALIGN="middle"');
  For xp:=0 To colCnt-1 Do Begin
   Case convertGrid.ColRowToDate(dummy, TS,Zajecia,xp,yp) Of
    ConvDayOfWeek: begin
                     if pHideEmptyRows
                     then begin
                            If TS.Date<>-1 Then htmlTable.newCellCol1('',getDayName(DayOfWeek(TimeStampToDateTime(TS))),'"silver"')
                                           Else htmlTable.newCellCol1('',''                                            ,'"silver"')
                     end
                     else begin
                            If TS.Date<>-1 Then begin
                              If Zajecia=0
                                Then htmlTable.newCellCol1('',getDayName(DayOfWeek(TimeStampToDateTime(TS))),'"silver"', 1, HOURS_PER_DAY+1, false)
                                else htmlTable.newCellCol1('',getDayName(DayOfWeek(TimeStampToDateTime(TS))),'"silver"', 1, 1, true);
                            end;
                          end;
                   end;
    ConvNumeryZajec: begin
                       If Zajecia<>0 Then htmlTable.newCellCol2('',gridDefinition.getLabel(Zajecia),'"silver"') Else htmlTable.newCell('','&nbsp','0');
                     end;
    convOutOfRange : Begin
                       if weeklyView then htmlTable.writeCell ( '<TD ROWSPAN="?" COLSPAN="?" style="background-color:silver">&nbsp;</TD>')
                       else htmlTable.newCell('background="outofrange.gif"','','"silver"');
                     End;
    ConvHeader     : Begin
                       if weeklyView then htmlTable.writeCell ( '<TD ROWSPAN="?" COLSPAN="?" style="background-color:silver">&nbsp;</TD>')
                       else htmlTable.newCell('',GetDate(TS.Date),'"silver"');
                     End;
    ConvClass:
     Begin
      classList := FMain.ClassBySubjectCaches.GetClasses(TS, Zajecia, StrToInt(pPeriodId), presId);
      if (Length(classList)=0) then
       begin
         htmlTable.newCell('','','0');
       end
       else begin
         if (Length(classList)=1) then begin
           Class_ := classList[0];
           cellCurrent :=
             DrawRect (Class_
               ,D1, D2, D3, D4, D5
               ,S1, S2, S3, S4, S5
               ,B1, B2, B3, B4, B5
               , ColoringIndex
               , iif(weeklyView,'',CellWIDTH)
               );
               cellCurrent := StringReplace(cellCurrent, '<TD ', '<TD ROWSPAN="?" COLSPAN="?"', [rfReplaceAll, rfIgnoreCase]);
               htmlTable.writeCell(cellCurrent);
         end else begin
           cells := '';
           cellPrior := '';
           uniqueCnt := 0;
           for i := 0 to High(classList) do begin
             Class_ := classList[i];
             cellCurrent :=
               DrawRect (Class_
                 ,D1, D2, D3, D4, D5
                 ,S1, S2, S3, S4, S5
                 ,B1, B2, B3, B4, B5
                 , ColoringIndex
                 , iif(weeklyView,'',CellWIDTH)
                 );
               if cellPrior <> cellCurrent then begin
                 cells := cells + '<td_removed>'+cellCurrent+'</td_removed>';
                 uniqueCnt := uniqueCnt + 1;
               end;
             cellPrior := cellCurrent;
           end;

           if (uniqueCnt>1) then begin
             htmlTable.writeCell('<td ROWSPAN="?" COLSPAN="?"><table style="border: 0px; width:100%; height: 100%"><tr>'+cells+'</tr></table></td>');
           end else begin
             cellCurrent := StringReplace(cellCurrent, '<TD ', '<TD ROWSPAN="?" COLSPAN="?"', [rfReplaceAll, rfIgnoreCase]);
             htmlTable.writeCell(cellCurrent);
           end;
         end;
       end;
     End;
    end;
  End;
  if ShowLegend Then Begin
    legendRow := legendRow + 1;
    addLegendRow(addECTSflag);
  End;
  end;
  end;

 if ShowLegend Then
 While legendRow<LgndCnt do begin
      htmlTable.AddRow('ALIGN="center" VALIGN="middle"');
      For xp:=0 To colCnt-1 Do Begin
         htmlTable.newCell('','','"silver"');
      End;
      legendRow := legendRow + 1;
      addLegendRow(addECTSflag);
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
 writeLn(f,'<hr/><FONT style="font-size:10px;">'+'Dokument zosta' + #322 + ' utworzony za pomoc' + #261 + ' programu <a href="http://www.plansoft.org">Plansoft.org</a></FONT>');

 WriteLn(f, '</BODY></HTML>');

 CloseFile(f);
 ConvertAnsiFileToUtf8(fileName);

 if pdfPrintOut then htmlToPdf(fileName, pdfg,pdfl,pdfo,pdfs);
end;

end.
