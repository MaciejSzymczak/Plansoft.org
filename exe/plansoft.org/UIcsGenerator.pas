unit UIcsGenerator;

interface

uses
  Forms, CheckLst;

  procedure generateIcsCalendars (self : tform; periodId, periodName, folder, xslt, css, icsSQL, addText : string; GroupsChecked, lecturersChecked, resourcesChecked, DoNotGenerateTableOfCon : boolean; GList, LList, RList: TCheckListBox);

implementation

Uses Windows, Messages,  UFProgramSettings, UUtilityParent,
  SysUtils, Classes, Graphics, Controls,  Dialogs, ADODB, DM, UFSettings
  ,UFormConfig, StdCtrls, Buttons, ExtCtrls, StrHlder, ComCtrls, ufmain, uutilities, UCommon, AutoCreate;


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
          AssignFile(F, folder+'\layout.xslt');
          Rewrite(F);
          WriteLn(f,
             replace(
               replace(xslt
                 ,'%R1.', fprogramsettings.profileObjectNameLs.Text)
               ,'%R2.', fprogramsettings.profileObjectNameGs.Text)
          );
          CloseFile(F);

          assignFile(F, Folder+'\menu.css');
          Rewrite(F);
          WriteLn(f, css);
          CloseFile(F);

          if DoNotGenerateTableOfCon then   AssignFile(F, Folder+'\eraseme.htm')
                                             else   AssignFile(F, Folder+'\index.xml');
          Rewrite(F);
          WriteLn(f, '<?xml version="1.0" encoding="windows-1250"?>');
          WriteLn(f, '<?xml-stylesheet type="text/xsl" href="layout.xslt"?>');
          WriteLn(f, '<xml>');
          WriteLn(f, '<title name="Plansoft.org - '+fprogramSettings.profileObjectNameClassgen.Text+'"></title>');
          WriteLn(f, '<period name="'+XMLescapeChars(periodName)+'"></period>');
          WriteLn(f, '<description text="'+XMLescapeChars(AddText)+'"></description>');
          WriteLn(f, '<data>');
             If GroupsChecked Then Begin
               for t := 0 to GList.Count - 1 do begin
                 if GList.Checked[t] then begin
                   WriteLn(F, '  <gro href="'+XMLescapeChars(StringToValidFileName(GList.Items[t]))+'.ics'+'" text="'+XMLescapeChars(GList.Items[t])+'"/>');
                 end;
               end;
             end;

             If lecturersChecked Then Begin
               for t := 0 to LList.Count - 1 do begin
                 if LList.Checked[t] then begin
                   WriteLn(F, '  <lec href="'+XMLescapeChars(StringToValidFileName(LList.Items[t]))+'.ics'+'" text="'+XMLescapeChars(LList.Items[t])+'"/>');
                 end;
               end;
             end;
              If ResourcesChecked Then Begin
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
              ShowFolder(Folder);
              if defaultBrowserIsChrome then begin
                  info('Zrobione! Otwórz plik index.html za pomoc¹ Internet Explorer lub Firefox lub umieœæ go na serwerze www. Wiêcej na ten temat w podrêczniku u¿ytkownika');
              end;
              uUtilityParent.ExecuteFile(Folder+'\index.xml','','',SW_SHOWMAXIMIZED);
          end;
        end;

        // ------------------------------------------------------
        procedure recreateCalendar( calendarName : string);
        begin
          //setStatus('Tworzenie kalendarza: ' + calendarName);
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
                  AssignFile(outf, Folder+'\' + StringToValidFileName(presourceList.Items[resIndex])+'.ics');
                  Rewrite(outf);
                except
                    on E:exception do begin
                     CopyToClipboard( Folder+'\' + StringToValidFileName(presourceList.Items[resIndex])+'.ics');
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
											  dmodule.openSQL(queryClasses, IcsSQL + ' and c.id in (select cla_id from '+presAlias+'_cla where '+presAlias+'_id = :pres_id) order by day, hour'
											  //dmodule.openSQL(queryClasses, sqlHolder.Lines.Text + ' and c.id in (select cla_id from '+presAlias+'_cla where is_child=''N'' and '+presAlias+'_id = :pres_id) order by day, hour'
												,'pres_id='      + currentResource +
												 ';per_id_from1='+ periodId    +
												 ';per_id_to1='  + periodId    +
												 ';per_id_from2='+ periodId    +
												 ';per_id_to2='  + periodId
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

												 if not gridDefinition.hourNumberToHourFromTo (fieldByName('hour').AsInteger, fieldByName('fill').AsInteger, hh1, mm1, hh2, mm2) then begin
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
            googleExport ( GroupsChecked    , GList , fprogramsettings.profileObjectNameG.Text  , 'GRO', getCode(GViewType), getCode (GD1),  [ getCode (GD2),getCode (GD3),getCode (GD4),getCode (GD5) ], [ getValue(GD2),getValue(GD3),getValue(GD4),getValue(GD5) ] );
            googleExport ( ResourcesChecked , RList , 'Zasób'                                   , 'ROM', getCode(RViewType), getCode (RD1),  [ getCode (RD2),getCode (RD3),getCode (RD4),getCode (RD5) ], [ getValue(RD2),getValue(RD3),getValue(RD4),getValue(RD5) ] );
            googleExport ( LecturersChecked , LList , fprogramsettings.profileObjectNameL.Text  , 'LEC', getCode(LViewType), getCode (LD1),  [ getCode (LD2),getCode (LD3),getCode (LD4),getCode (LD5) ], [ getValue(LD2),getValue(LD3),getValue(LD4),getValue(LD5) ] );
            fmain.wlog('tableOfContens : Start');
            tableOfContens;
            fmain.wlog('tableOfContens : End');
          end;
      end;
      //setStatus('');
      queryClasses.Free;
    end;



end.
