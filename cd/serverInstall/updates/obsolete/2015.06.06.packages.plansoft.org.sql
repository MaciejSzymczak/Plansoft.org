CREATE OR REPLACE package Xxmsz_Tools as

  -- ***********************************************************************************************************************
  -- * szyfrowanie danych
  -- ***********************************************************************************************************************
  -- SELECT Xxmsz_Tools.encrypt('PASSWORD1') FROM dual;
  -- SELECT Xxmsz_Tools.decrypt(app_password.encrypt('PASSWORD1')) FROM dual;
  -- SELECT Xxmsz_Tools.encrypt('PSW2') FROM dual;
  -- SELECT Xxmsz_Tools.decrypt(app_password.encrypt('PSW2')) FROM dual;

   function encrypt(i_password varchar2) return varchar2;
   function decrypt(i_password varchar2) return varchar2;

  -- ***********************************************************************************************************************
  -- * daty
  -- ***********************************************************************************************************************

  -- Purpose:    Check if a year is a leap year
  -- Author:     Frank Naude, Oracle FAQ
  function isLeapYear(i_year number) return boolean;

  -- zwraca 'Y' gdy okres czasowy (A1,A2) ma czÍúÊ wspÛlnπ z okresem (B1,B2), w przeciwnym razie 'N'
  function has_common_part(
     pa1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pa2 date default to_date('4000-12-31','yyyy-mm-dd') 
   , pb1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pb2 date default to_date('4000-12-31','yyyy-mm-dd')
   ) return varchar2;

/*   
PorÛwnuje okres A1-A2 z okresem B1-B2
                    A1      A2
                    |=========|  
                    |         |
                B1==|=========|==B2               INSIDES                  
                    |  =====  |                   IS_INSIDE
                    |    =====|                   IS_INSIDE_RJUSTIFY
                    |=====    |                   IS_INSIDE_LJUSTIFY
                    |         |
    ========        |         |                   IS_BEFORE_GAP
            ========|         |                   IS_BEFORE_NO_GAP
              ======|===      |                   IS_BEFORE_COMMON_PART
                    |=========|                   THE_SAME   
                    |      ===|======             IS_AFTER_COMMON_PART
                    |         |========           IS_AFTER_NO_GAP
                    |         |       ========    IS_AFTER_GAP
                                                  BAD_PERIOD_A
                                                  BAD_PERIOD_B
*/
  function compare_periods(
     pa1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pa2 date default to_date('4000-12-31','yyyy-mm-dd') 
   , pb1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pb2 date default to_date('4000-12-31','yyyy-mm-dd')
   ) return varchar2;

   
  -- ***********************************************************************************************************************
  -- * systemy liczbowe
  -- ***********************************************************************************************************************
  --
  -- SELECT Xxmsz_Tools.dec2bin(22)      FROM dual;
  -- SELECT Xxmsz_Tools.bin2dec('10110') FROM dual;
  -- SELECT Xxmsz_Tools.dec2oct(44978)   FROM dual;
  -- SELECT Xxmsz_Tools.oct2dec(127662)  FROM dual;
  -- SELECT Xxmsz_Tools.dec2hex(44978)   FROM dual;
  -- SELECT Xxmsz_Tools.hex2dec('AFB2')  FROM dual;
  --
  /* Purpose:    Package with functions to convert numbers between the
                 Decimal, Binary, Octal and Hexidecimal numbering systems.
     Usage:      See sampels at the bottom of this file
     Author:     Frank Naude, 17 February 2003
  */

   function bin2dec (binval in char  ) return number;
   function dec2bin (N      in number) return varchar2;
   function oct2dec (octval in char  ) return number;
   function dec2oct (N      in number) return varchar2;
   function hex2dec (hexval in char  ) return number;
   function dec2hex (N      in number) return varchar2;

  -- ***********************************************************************************************************************
  -- * Operacje na ≥aÒcuchach
  -- ***********************************************************************************************************************

  left   integer := 0;
  right  integer := 1;
  middle integer := 2;

  fopMarkOn  varchar2(50) := '<fo:inline font-size="from-parent(font-size) + 2">';
  fopMarkOff varchar2(50) := '</fo:inline>';

  function Center (S varchar2, LEN number) return varchar2;
  -- otacza takπ samπ liczbπ spacji tekst z przodu i z ty≥u, dlugosc zwracanego lancucha = len
  function trimSpaces ( S varchar2 ) return varchar;
  -- usuwa skrajne spacje oraz usuwa wielokrotne spacje z ciπgu i zastepuje je pojedynczymi
  function makeStr(s varchar2, len number) return varchar2;
  -- zwraca ciag utworzony z wielokrotnego skonkatenowania s o dlugosci len
  function extractWord  (poz number, words varchar, sep varchar := '|') return varchar;
  -- wyodrÍbnia poz-ty podciπg z podciπgÛw rozdzielonych znakiem Sep z ciπgu Words
  --    np. ExtractFileName(2, 'Ala|Ma|Kota','|') -> Ma
  function wordCount(  words varchar2, separator  in     varchar2 := '|') return number;
  -- zlicza liczbÍ podciπgÛw rozdzielonych znakiem Separator w ciπgu Words
  function replaceWord(poz number, replaceWith varchar2, words varchar, sep varchar := '|') return varchar2;
  -- zamienia poz-ty podciπg w ciπgu na ciπg replaceWith  
  function getTokenByName ( tokens varchar2, tokenName varchar2, tokenSeparator varchar2) return varchar2;
  -- wyodrÍdnia z ≥aÒcucha znakÛw w postaci param1=value1;param2=value2,.. odpowiedniπ wartoúÊ
  -- np. select getTokenByName ('param1=value1;param2=value1;param1=value3;param4=value4','param1',';') from dual --> param1=value1
  --     select getTokenByName ('param1=value1;param2=value1;param1=value3;param4=value4','param4',';') from dual --> param4=value4
  --     select getTokenByName ('param1=value1;param2=value1;param1=value3;param1=value4','paramx',';') from dual --> null
  --     select getTokenByName ('param1=value1;param2=value1;param1=value3;param4=value4','param',';') from dual  --> !! param1=value1
  function pushLastWord(pushWord varchar2, words varchar2, sep varchar := '|') return varchar2;
  --k≥adzie s≥owo na koniec
  function popLastWord(words varchar2, sep varchar := '|') return varchar2;
  --zabiera s≥owo z koÒca
  function merge(S1 varchar2, S2 varchar2, SEP varchar2 default null) return varchar2;
  -- ≥πczy ciπgi S1 i S2 za pomocπ separatora SEP
  -- uøyteczna podczas sk≥adania warunkÛw WHERE warunek1 AND warunek2 AND ... oraz podczas dodawania ≥aÒcuchow (NULL || 'any' = NULL ...)
  --    np. Merge('A','B',',', -> 'A,B')
  --        Merge('A','' ,',', -> 'A')
  --       Merge('','B' ,',', -> 'B')
  function wordWrap( wrappedString varchar2, columnWidth number, getTokenNr number default 0, completeWithSpaces varchar2 default 'Y', TokenSeparator varchar2 default '|') return varchar2;
  -- dzieli ciπg S na fragmenty o d≥ugosci columnWidth i zwraca token o numerze getTokenNr ( 0 oznacza, ze zostana zwrocone wszystkie tokeny, rozdzielone znakami |)
  -- jezeli w ciagu wejsciowym sa znaki |, to zostana one potraktowane jako znaki konca wiersza
  function pasteStr( Str varchar2, pastedStr varchar2, fromPos number, toPos number, align number ) return varchar2;
  -- wkleja pastedStr do Str od pozycji fromPos do pozycji toPos align = 1-od prawej 0-od lewej
  function erasePolishChars(S varchar2) return varchar2;
  -- zastepuje polskie znaki ich odpowiednikami bez ogonkow np. ≥Ûøko -> lozko
  -- przyklad uzycia - zamiana ciagow znakow na nazwy kolumn w bazie danych Oracle
  --    select ', '||rpad(replace(replace(replace(replace(replace(substr(xxmsz_tools.erasePolishChars(text),1,30),'(','_'),')','_'),' ','_'),'.',''),'-',''),40) || ' VARCHAR2(500)' x from xxtmp where upper(text) like upper('%') order by num
  procedure addPercent ( V in out varchar2 );
  -- dodaje % na koncu stringa, chyba, ze juz jest % w stringu
  function isSubsetOf (Set1 varchar2, Set2 varchar2) return varchar2;
  -- zwraca TRUE jesli SET1 jest podzbiorem SET2. Elementy sa rozdzdzielone znakiem ;
  --   select substr(xxmsz_tools.issubsetof('third;first','first;second;third'),1,3) from dual -> Y
  --   select substr(xxmsz_tools.issubsetof('fourth;first','first;second;third'),1,3) from dual -> N

  function tolatin2 (tekst in varchar2) return varchar2;
  -- konwertuje ciag na standard Latin2
  function hasPolishSigns(S in out varchar2) return varchar2;
  -- sprawdza, czy string zawiera polskie znaki -> N,Y
  function strToNumber ( str varchar2, valueWhenEmpty varchar2 default '0' ) return number;
  -- konwertuje ciπg do liczby. CzÍúci ca≥kowita i u≥amkowa mogπ byÊ rozdzielone przecinkiem lub kropkπ, separator tysiÍcy nie moøe wystÍpowaÊ
  function isNumber ( str varchar2 ) return varchar2;
  -- sprawdza, czy ciag znakow mozna skonwertwac do liczby. Zwraca wartosci Y/N

   /*****************************************************************************************************************************
   |* Zawijanie wierszy tekstowych
   |*****************************************************************************************************************************
   |  set serveroutput on;
   |  declare
   |    WordWrap xxmsz_tools.tWordWrap;
   |    procedure insertLines ( WordWrap in out xxmsz_tools.tWordWrap ) is
   |      i number;
   |    begin
   |      if WordWrap.errorMessage is not null then xxmsz_tools.dbms_outputPut_line (WordWrap.errorMessage); end if;
   |      for i in 1..xxmsz_tools.wordWrapGetNumberOfLines(WordWrap) loop
   |        xxmsz_tools.dbms_outputPut_line ( xxmsz_tools.wordWrapGetLine(WordWrap,i) );
   |      end loop;
   |    end;
   |  begin
   |    xxmsz_tools.wordWrapInit (WordWrap,'|aaaaaaaaaaaaa|bbbbbbbbbbbbb|ccccccccccccc|');
   |    xxmsz_tools.wordWrapPrepareColumn(WordWrap, 'Przyk≥adowy tekst Przyk≥adowy tekst Przyk≥adowy tekst', 'aaaaaaaaaaaaa', xxmsz_tools.left);
   |    xxmsz_tools.wordWrapPrepareColumn(WordWrap, 'Przyk≥adowy tekst Przyk≥adowy tekst Przyk≥adowy tekst', 'bbbbbbbbbbbbb', xxmsz_tools.right);
   |    xxmsz_tools.wordWrapPrepareColumn(WordWrap, 'Przyk≥adowy tekst Przyk≥adowy tekst Przyk≥adowy tekst', 'ccccccccccccc', xxmsz_tools.middle);
   |    insertLines ( WordWrap );
   |  end;
   |  /
   |
   \*-----------------------------------------------------------------------------------------------------------------------------*/

  type tWordWraplinesPastedStr is  table  of varchar2(5000) index  by  binary_integer;
  type tWordWraplinesFromPos   is  table  of number         index  by  binary_integer;
  type tWordWraplinesToPos     is  table  of number         index  by  binary_integer;
  type tWordWraplinesAlign     is  table  of number         index  by  binary_integer;
  -- zamiast kilku tabel PL/SQL powinna byc jedna z typem rekordowym, ale sk≥adnia jezyka na to nie pozwala ( PLS-00511: rekord nie moøe zawieraÊ tabeli PL/SQL rekordÛw )
  -- PL/SQL nie pozwala predefiniowac typu LongStr = VARCHAR2(5000), szkoda
  type tWordWrap is record (
          defaultStr varchar2(2000)
         ,linesPastedStr tWordWraplinesPastedStr
         ,linesFromPos tWordWraplinesFromPos
         ,linesToPos tWordWraplinesToPos
         ,linesAlign tWordWraplinesAlign
         ,resultLineNum number default -1-- numer zwracanej linii
   ,errorMessage varchar2(1000) default null
   ,tokenSeparator varchar2(1) default '|' --znak przejscia do nastepnej linii
       );

  procedure wordWrapInit (aWordWrap in out nocopy tWordWrap,adefaultStr varchar2, TokenSeparator varchar2 default '|'); -- defaultStr musi zawieraÊ placeholdery
                                                                            -- moze on takøe zawieraÊ inne elementy jak ramki, znaki formatujπce html itp.
  procedure wordWrapPrepareColumn(aWordWrap in out nocopy tWordWrap, pastedStr varchar2, placeHolder varchar2, align number );
  function  wordWrapGetNumberOfLines(aWordWrap in out nocopy tWordWrap) return number; -- zwraca liczbe linii
  function  wordWrapGetLine(aWordWrap in out nocopy tWordWrap,lineNum number) return varchar2; -- zwraca linie o podanym numerze
  
   /*****************************************************************************************************************************
   |* printing tables. this API allows you print tables in easy way 
   |*****************************************************************************************************************************
   |  declare
   |   ptableDef Xxmsz_Tools.tTableDef;
   |  begin
   |   Xxmsz_Tools.addHeader (ptableDef
   |      , 'username|account_status|default_tablespace|temporary_tablespace|created|profile' --column headers. use SQLTrick to get this string in fastest way 
   |      , '0|0|0|0|0|10' -- column widths. you can omit this parameter (= whole table autowidth).  0 means column autowidth.
   |      , 'right|right|right' -- column alligns. you can omit this parameter (= left)
   |   );
   |   for rec in (
   |     select username ||'|'|| account_status ||'|'|| default_tablespace ||'|'|| temporary_tablespace ||'|'|| created ||'|'|| profile data --use SQLTrick to get this string in fastest way
   |                                                                                                                                         --use format (to_char) statemets here  
   |       from dba_users
   |   ) loop
   |    Xxmsz_Tools.addLine   (ptableDef, rec.data);
   |   end loop;
   |   Xxmsz_Tools.showTable (ptableDef);
   |   Xxmsz_Tools.destroy   (ptableDef);  --purges plsql tables
   |  end;
   |  /
   |  
   |  result:
   |   
   |  +-------------------+----------------+------------------+--------------------+--------+----------+
   |  |           USERNAME|  ACCOUNT_STATUS|DEFAULT_TABLESPACE|TEMPORARY_TABLESPACE|CREATED |PROFILE   |
   |  +-------------------+----------------+------------------+--------------------+--------+----------+
   |  |                IZU|            OPEN|              IZUD|TEMP                |06/10/29|DEFAULT   |
   |  |                MON|            OPEN|               MON|TEMP                |06/07/17|DEFAULT   |
   |  |                XDO|            OPEN|              XDOD|TEMP                |06/06/15|DEFAULT   |
   |  |           PERFSTAT|            OPEN|         STATSPACK|TEMP                |07/05/30|DEFAULT   |
   |  |           LOFTWARE|            OPEN|          LOFTWARE|TEMP                |04/04/28|DEFAULT   |
   |  |                PRP|            OPEN|              PRPD|TEMP                |04/01/01|DEFAULT   |
   |  |         AD_MONITOR|EXPIRED ; LOCKED|            SYSTEM|TEMP                |06/06/15|AD_PATCH_M|
   |  |                   |                |                  |                    |        |ONITOR_PRO|
   |  |                   |                |                  |                    |        |FILE      |
   |  +-------------------+----------------+------------------+--------------------+--------+----------+   
   |    
   |  remarks : 
   |     1/ do not use this api to print big tables
   |     2/ you will probably want to change output for yours table. Then make a copy of showTable procedure in you package and modify procedure wout inside it.
   |        in this case remember to replace "Xxmsz_Tools" with your package name in line Xxmsz_Tools.showTable (ptableDef);   
   |
   \*-----------------------------------------------------------------------------------------------------------------------------*/
   
  type tcolumnDef is record (width number                   
                           , allign varchar2(30) --left/right/middle
                           , autowidth char(1) default 'Y' --N = noautowidth
                           ); 
  type tTableRows is  table  of varchar2(5000) index  by  binary_integer;
  type tTableWidths is  table  of tcolumnDef index  by  binary_integer;  
  type tTableDef is record (
          tableWidths      tTableWidths
         ,tableRows        tTableRows
         ,ColumnCount      number
   ,tokenSeparator   varchar2(1)
       );
 procedure addHeader (ptableDef in out nocopy tTableDef, ptableRow varchar2, pcolWidths varchar2 default null, palligns varchar2 default null, ptokenSeparator varchar2 default '|');
 procedure addLine   (ptableDef in out nocopy tTableDef, ptableRow varchar2);
 procedure showTable (ptableDef in out nocopy xxmsz_tools.tTableDef);
 procedure destroy   (ptableDef in out nocopy tTableDef);
 
  -- *********************************************************************************
  -- * Biznesowe operacje na ciπgach
  -- *********************************************************************************
  function amountInWords(aamount number, language_code varchar2 default 'PL', currency_code1 varchar2 default 'z≥', acurrency_code2 varchar2 default 'gr') return varchar2;
  -- zwraca kwote slownie w jezyku okreslonym przez paramert language_code (PL/END)
  function strToDate( p_dat varchar2) return date;
  -- konwertuje string na date, dopasowujac odpowiednia maske formatu
  function peselIsOK ( PESEL  varchar2 ) return  varchar2;
  -- sprawdza PESEL i zwraca Y/N
  function nipIsOk ( NIP  varchar2 ) return  varchar2;
  -- sprawdza NIP i zwraca Y/N
  function regonIsOk ( REGON  varchar2 ) return  varchar2;
  -- sprawdza REGON (9- lub 14-znakowy )i zwraca Y/N
  function emailIsOk ( EMAIL  varchar2 ) return  varchar2;
  -- sprawdza poprawnosc EMAIL i zwraca Y/N
  function ynToBool ( S varchar2, resultIfEmpty boolean default false ) return boolean;
  -- konwertuje wartosc Str na bool
  function ynToYN ( S varchar2, resultIfEmpty varchar2 default 'N' ) return char;
  -- konwertuje wartosc Str na ('N','Y')
  -- np. select xxmsz_tools.ynToYN ('Tak') from dual -> Y
  function boolToYN ( bool boolean, trueValue varchar2 default 'Y', falseValue varchar2 default 'N' ) return varchar2;
  -- konwertuje wartosc bool na Str
  function getIBANcheckDigits (acc varchar2 ) return varchar2;
  -- zwraca cyfry kontrolne CC na konta w formacie IBAN CC88888888aaaabbbbddddeeee
  function formatIBAN ( inS varchar2, numberOfSignsInSection number default 4, formatOnlyWhenDivisible varchar2 default 'N' ) return varchar2;
  -- formatuje rachunek bankowy do postaci iban ( cc88888888aaaabbbbccccdddd -> cc 88888888 aaaa bbbb cccc dddd )
  function formatNIP  ( inS varchar2 ) return varchar2;
  -- formatuje ciπg do postaci 999-999-99-99 jeúli nie zawiera myúlnikÛw w przyciwnym wypadku zwracany jest ciπg oryginalny
  --  select xxmsz_tools.formatNIP('9441733423') from dual --> 944-173-34-23
  --  select xxmsz_tools.formatNIP('944-17-33-423') from dual --> 944-17-33-423
  --  select xxmsz_tools.formatNIP('9-4-4-1-7-3-3-4-2-3') from dual --> 9-4-4-1-7-3-3-4-2-3

  -- *********************************************************************************
  -- * Dziennik zdarzen
  -- *********************************************************************************

  /*
  Aby korzystac z funkcji dziennia zdarzen, nalezy utworzyc nastepujace: tabele i sekwencje.
  Dziennik zdarzen jest wspolny dla wielu aplikacji - uzyj kwalifikatora hierarchicznego dla rozrÛønienia, ktÛre komunikaty dotyczπ ktÛrej aplikacji - zob. pole moduleName

   drop sequence xxmsztools_eventlog_seq;
   drop table xxmsztools_eventlog;

   create sequence xxext.xxmsztools_eventlog_seq;

   create table xxext.xxmsztools_eventlog (
     id number(11)
 ,module_name   varchar2(200)
 ,message       varchar2(200)
 ,message_type  varchar2(10)
 ,created       date default sysdate
   );


   create synonym xxmsztools_eventlog_seq for xxext.xxmsztools_eventlog_seq;

   create synonym xxmsztools_eventlog for xxext.xxmsztools_eventlog;

   CREATE INDEX XXMSZTOOLS_EVENTLOG_I1 ON xxext.XXMSZTOOLS_EVENTLOG (ID);

   CREATE INDEX XXMSZTOOLS_EVENTLOG_I2  ON xxext.XXMSZTOOLS_EVENTLOG (module_name);

  */

  moduleNameForEventLog  varchar2(400);

  procedure setModuleName ( moduleName varchar2 );
  -- ustawia nazwe modu≥u ( zob. opis parametru moduleName w procedurze insertIntoEventLog )
  procedure pushModuleName ( moduleName varchar2 );
  -- dodaje nowy cz≥on do nazwy modu≥u - zwykle wywo≥ywane na poczπtku procedury
  procedure popModuleName;
  -- usuwa cz≥on z nazwy modu≥u - zwykle wywo≥ywane przed wyjsciem z procedury
  procedure insertIntoEventLog ( message varchar2, messageType varchar2 default 'I', moduleName varchar2 default 'XXMSZTOOLS', writeMessage varchar2 default 'Yes', raiseExceptions varchar2 default 'No');
  /* dodaje wiersz do tabeli xxmsztools_eventlog
     message         komunikat do zapisania
     messageType     typ komunikatu : I=Info E=Error W=Warning
     moduleName      hierarchiczne okresenie miejsce wywo≥ania. Cz≥ony rozdzielone kropkπ np Package001.WYDRUK_FAKTURY.FETCH_INVOICES.FETCH_INVOICE
                     jezeli chcesz zapisac nazwe pakietu oraz numer linii, to w module name wpisz : Xxmsz_Tools.extractword( 4, dbms_utility.format_call_stack, CHR(10))
                      stos b≥edÛw: sqlerrm || dbms_utility.format_error_backtrace
     writeMessage    flaga okreslajaca, czy dodac rekord ( moze np. byc sterowana zmienna okreslajaca, czy prowadzic sledzenie )
     raiseExceptions wywolaj wyjatek w razie, gdy nie powiedzie sie wstawienie rekordu do dzienika zdarzen

     JEøELI KORZYSTASZ Z EBS, TO MOøESZ TAKøE UøYÊ NASTEPUJACEJ FUNKCJI:
     procedure fnd_transaction.debug_info(function_name in varchar2,
                       action_name   in varchar2,
                       message_text  in varchar2,
                       s_type        in varchar2 default 'C');
    Ta funkcja lepiej identyfikuje sesje, ale nie pozwala na tworzenie hierarchicznego logu
    select * from fnd_concurrent_debug_info order by time_in_number
    begin fnd_transaction.debug_info('test','test','t est'); end;
  */

 -- workflow version of previous procedure
 -- parameters: MESSAGE
 -- commented due to ensure platform-independent form of this package
 --procedure insertIntoEventLog ( itemtype  in     varchar2, itemkey   in     varchar2, actid     in     number, funcmode  in     varchar2, result    out    varchar2);

  -- do debugowania polecen select
  -- wartosci pobierz za pomoca zapytania select * from xxmsztools_eventlog where module_name like 'insertIntoEventLog%' order by id
  function insertIntoEventLog (pdate date, pvalue varchar) return varchar2;

  -- *********************************************************************************
  -- * Inne operacje
  -- *********************************************************************************
  function startOfTime return date;
  function endOfTime return date;
  
  function replaceXMLchars (buffer in varchar2) return varchar2;
  --zmienia niedozwolone znaki XML na kody
  --wiÍcej na ten temat w Wikipedii i http://www.kurshtml.boo.pl/generatory/unicode.html
  
  function strToAsc ( strString varchar2 ) return varchar2;
  -- konwertuje ciπg znakÛw do ciπgu znakÛw ascii
  -- np. select strToAsc('przyk≥adowy tekst') from dual ->  112,114,122,121,107,179,97,100,111,119,121,32,116,101,107,115,116
  function AscToStr ( ascString varchar2 ) return varchar2;
  -- konwertuje ciπg znakÛw ascii do ciπgu znakÛw
  -- np. select asctostr('112,114,122,121,107,179,97,100,111,119,121,32,116,101,107,115,116') from dual -> przyk≥adowy tekst
  function extractFileName(S  in varchar2)  return varchar2;
  -- wyodrÍbnia ze úcieøki nazwÍ pliku
  --     np. ExtractFileName('c:\Program Files\Joasia.xls') -> Joasia.xls
  function extractPath (S  in varchar2)  return varchar2;
  -- wyodrÍbnia ze úcieøki úcieøkÍ bez nazwy pliku
  --     np. ExtractFileName('c:\Program Files\Joasia.xls') -> c:\Program Files\
  function getBanknotes( wydaj varchar2 ) return varchar2;
  -- zwraca kwote w banknotach i bilonach
  function iif( cond boolean, val1 varchar2, val2 varchar2 ) return varchar2;
  function iif( cond boolean, val1 number, val2 number ) return number;
  function iif( cond boolean, val1 date, val2 date ) return date;
  -- zwraca str1 jesli cond, w przeciwnyym przypadku zwraca str2
  -- funkcja uzyteczna przy formatowaniu warunkowym
  procedure dbms_outputPut_line (
      str         in   varchar2,
      len         in   integer := 254,
      expand_in   in   boolean := true
   );
   -- wykonuje dbms_output.put_line dzielac ciag znakow na podlancuchy o dlugosci len
   -- w razie potrzeby rozszerza bufor za pomoca polecenia dbms_output.enable

  -- extension of nvl
  function extnvl (
   v1 varchar2,v2 varchar2,v3 varchar2 default null,v4 varchar2 default null,v5 varchar2 default null
  ,v6 varchar2 default null,v7 varchar2 default null,v8 varchar2 default null,v9 varchar2 default null,v10 varchar2 default null
  ,v11 varchar2 default null,v12 varchar2 default null,v13 varchar2 default null,v14 varchar2 default null,v15 varchar2 default null
  ,v16 varchar2 default null,v17 varchar2 default null,v18 varchar2 default null,v19 varchar2 default null,v20 varchar2 default null
  ) return varchar2;   
   
  function extnvl (
   v1 number,v2 number,v3 number default null,v4 number default null,v5 number default null
  ,v6 number default null,v7 number default null,v8 number default null,v9 number default null,v10 number default null
  ,v11 number default null,v12 number default null,v13 number default null,v14 number default null,v15 number default null
  ,v16 number default null,v17 number default null,v18 number default null,v19 number default null,v20 number default null
  ) return number;   

    function extnvl (
   v1 date,v2 date,v3 date default null,v4 date default null,v5 date default null
  ,v6 date default null,v7 date default null,v8 date default null,v9 date default null,v10 date default null
  ,v11 date default null,v12 date default null,v13 date default null,v14 date default null,v15 date default null
  ,v16 date default null,v17 date default null,v18 date default null,v19 date default null,v20 date default null
  ) return date;   


  -- *********************************************************************************
  -- * funkcje do przekazywania parametrow pomiedzy sesjami
  -- *********************************************************************************

  -- przykladowe zastosowanie:przekazanie parametru do okna zlecen wspolbieznych
  -- Do okna zlecen wspolbieznych parametrow nie mozna przekazac wprost, ale mozna nadac im wartosci domyslne.
  /*
   przyklad uzycia procedur setParameter, getparameter

   BEGIN
     Xxmsz_Tools.setParameter (Fnd_Profile.value('user_id'), 'PARAM1', 'PARAM1_VALUE');
     Xxmsz_Tools.setParameter (Fnd_Profile.value('user_id'), 'PARAM2', 'PARAM2_VALUE');
     Xxmsz_Tools.setParameter (Fnd_Profile.value('user_id'), 'PARAM2', 'PARAM2_VALUE_NOWA');
   END;

   SELECT Xxmsz_Tools.getParameter (Fnd_Profile.value('user_id'), 'PARAM1') FROM dual
   -- wynik: PARAM1_VALUE

   SELECT Xxmsz_Tools.getParameter (Fnd_Profile.value('user_id'), 'PARAM1') FROM dual
   -- wynik: null

   SELECT Xxmsz_Tools.getParameter (Fnd_Profile.value('user_id'), 'PARAM2') FROM dual
   -- wynik: PARAM2_VALUE_NOWA

   SELECT Xxmsz_Tools.getParameter (Fnd_Profile.value('user_id'), 'PARAM2') FROM dual
   -- wynik: null
   */

  -- procedura skladuje wartosc value parametru o nazwie paramName w kontekscie okreslonego uzytkownika userId
  -- kolejne wywolanie procedury powoduje nadpisanie poprzedniej wartosci
  procedure setParameter ( userId varchar2, paramName varchar2, value varchar2 );
  -- procedura pobiera parametr
  -- kolejne wywolanie funkcji spowoduje zwrocenie wartosci pustej
  function getParameter (userId varchar2, paramName varchar2) return varchar2;


  -- *********************************************************************************
  -- * formatowanie sk≥adni dla SQL
  -- *********************************************************************************
  valueWhenEmpty varchar2(100) := 'NULL';

  function getSQLValues(SQLText varchar2, valueWhenEmpty varchar2 default null,exceptifempty char default 'N', Sep varchar2 default ', ', maxsizeofres number default 30000) return varchar2;
  -- zwraca wynik zapytania z pierwszej kolumny rozdzielony znakami Sep (dla wygody stosuj znak ^ zamiast ')
  --     np. XXMSZ_TOOLS.GetSQLValues ( 'select column_name from sys.all_tab_columns where table_name = ^ALL_OBJECTS^ and owner = ^SYS^ order by column_name' ) -> OWNER|OBJECT_NAME| itd.
  function getSQLValue(SQLText varchar2, valueWhenEmpty varchar2 default null,exceptifempty char default 'Y') return varchar2;
  -- zwraca wartosc zapytania z pierszego wiersza z pierwszej kolumny
  FUNCTION getSQLV(SQLText VARCHAR2, exceptifempty CHAR, Sep VARCHAR2 DEFAULT '|', maxsizeofres NUMBER DEFAULT 30000, singlevaluemode BOOLEAN) RETURN VARCHAR2;

  -- ponizej funkcje przekszta≥ace dane do postaci akceptowanej przez polecenia DML
  function formatDate(Word varchar2, format varchar2 default 'YYYY-MM-DD') return varchar2;
  function formatDateTime(Word varchar2) return varchar2;
  function formatFloat(Word varchar2) return varchar2;
  function formatString(Word varchar2) return varchar2;
  function buildCondition ( FIELDTYPE varchar2, FIELD_NAME varchar2, VALUE1 varchar2, VALUE2 varchar2 default null  ) return varchar2;
  -- Buduje warunek WHERE np.:
  -- xxmsz_tools.buildCondition('NUMBER','NO','1')                      --> NO = 1
  -- xxmsz_tools.buildCondition('VARCHAR2','NO','1')                    --> NO = '1'
  -- xxmsz_tools.buildCondition('VARCHAR2','NO','1%')                   --> NO LIKE '1%'
  -- xxmsz_tools.buildCondition('VARCHAR2','NO','A', 'B')               --> NO BETWEEN 'A' AND 'B'
  -- xxmsz_tools.buildCondition('DATE','NO','2004.12.12', '2004.12.12') --> NO BETWEEN TO_DATE('2004.12.12','yyyy-mm-dd') AND TO_DATE('2004.12.12','yyyy-mm-dd')
  -- xxmsz_tools.buildCondition('DATE','NO', NULL)                      --> NULL ( w szczegÛlnosci funkcja nie zwrÛci NO IS NULL )
  -- daty musza byc przekazane w formacie yyyy-mm-dd

  -- Implemantacja stosu - w trakcie opracowywania
  type tStrStack is record (
   Elements      varchar2(100),
   COUNT         number
  );

  -- Uruchamia dowolne polecenie SQL. W wyzwalaczach nie moøna uøyÊ wprost EXECUTE IMMEDIATE
  procedure executeImmediate (SQL_STATEMENT varchar2);


  -- ***********************************************************************************
  -- * Zastosowanie procedur przedstawionych ponizej:
  -- *  - Zliczanie kwot wg rÛønych stawek podatku vat, walut itd. (zob. wydruk fakury)
  -- *  - Wyznaczanie poczatkowego i koncowego numeru strony ( zob. pakiet wzorcowy plsqlrep)
  -- *
  -- *  przykladowy skrypt:
  -- *  declare
  -- *        SumTotal               xxmsz_tools.TAmounts;
  -- *  begin
  -- *    xxmsz_tools.AmountsInit ( SumTotal          , xxmsz_tools.giAdd );
  -- *    xxmsz_tools.AmountsAdd  ( SumTotal          ,  '7%', 10, 20, 30);
  -- *    xxmsz_tools.AmountsAdd  ( SumTotal          ,  '7%', 10, 20, 30);
  -- *    xxmsz_tools.AmountsAdd  ( SumTotal          ,  '7%', 10, 20, 30);
  -- *    xxmsz_tools.AmountsAdd  ( SumTotal          , '22%', 10, 20, 30);
  -- *    xxmsz_tools.AmountsAdd  ( SumTotal          , '22%', 10, 20, 30);
  -- *    amountsGetExample2      ( SumTotal );
  -- *  end;
  -- *
  -- *  wynik dzialania przykladowego skryptu:
  -- *
  -- *  7%    30  60  90
  -- *  22%   20  40  60
  -- *  ================
  -- *  TOTAL 50 100 150
  -- ***********************************************************************************

  -- poniewaz w PLSQL nie mozna programowac obiektowo, udostepniane sa ponizsze typy i procedury uzywajace tych typow
   giAdd integer := 0; -- gi = group function information
   giMax integer := 1;
   giMin integer := 2;

   type tTAmounts         is  table  of  number        index  by  binary_integer;
   type tTGroupIndicators is  table  of  varchar2(100) index  by  binary_integer;
   type tAmounts is record (
       amounts1        TTAmounts,         -- kolumna 1 do zsumowania np. wartosc netto
       amounts2        TTAmounts,         -- kolumna 2 do zsumowania np. kwota vat
       amounts3        TTAmounts,         -- kolumna 3 do zsumowania np. wartosc brutto
       amounts4        TTAmounts,         -- kolumna 4 do zsumowania np. wartosc brutto bez rabatu
       amounts5        TTAmounts,         -- kolumna 5 do zsumowania np. wartosc netto w przeliczeniu na EUR
       amounts6        TTAmounts,         -- kolumna 6 do zsumowania np. wartosc vat w przeliczeniu na EUR
       amounts7        TTAmounts,         -- kolumna 7 do zsumowania
       amounts8        TTAmounts,         -- kolumna 8 do zsumowania
    groupIndicators TTGroupIndicators, -- wskaznik grupowania, np. stawka vat albo waluta
       COUNT  integer,
    groupOperator integer -- giAdd   (default) : AmountsAdd dodaje wartosci
                          -- giMax             : AmountsAdd oznacza max
        -- giMin             : jw min
     );
   procedure amountsInit (Amounts in out nocopy tAmounts, agroupOperator integer default 0);
   procedure amountsAdd(Amounts in out nocopy tAmounts, aGroupIndicator varchar2, amount1 number, amount2 number default 0, amount3 number default 0, amount4 number default 0, amount5 number default 0, amount6 number default 0, amount7 number default 0, amount8 number default 0);
   -- W PLSQL nie ma typu proceduralnego... skopiuj zatem AmountsGet z dostosuj do wlasnych potrzeb
   procedure amountsGetExample1(Amounts in out nocopy tAmounts);
   -- wyswietla kwoty dla poszczegolnych wskaznikow grupowania, w tym total
   procedure amountsGetExample2(Amounts in out nocopy tAmounts);
   -- wyswietla kwoty dla poszczegolnych wskaznikow grupowania oraz - o ile liczba wskaznikow grupowania >1 , rowniez total
   function amountsGetByIndicator(amounts in out nocopy tAmounts, aGroupIndicator varchar2, amountIndex number) return number;

   /*****************************************************************************************************************************
   |* Konwersje
   \*****************************************************************************************************************************

    /*
    Funkcja konwertuje typ long do typu varchar2
    Uwaga: Jeøeli zmienna typu long jest d≥uøsza niø 4000 znakÛw, to jest obcianana do 4000 znakÛw ( z powodu ograniczeÒ sql )
    Przyk≥adowe zapytanie ( zapewnia wyszykowanie widokÛw wg ich definicji ):

    select xxmsz_tools.long2varchar('select text from all_views where owner = :owner and view_name = :view_name', 'owner',v.owner,'view_name',v.view_name) text
          ,v.view_name, v.text_length, o.status, v.type_text, v.oid_text, v.view_type_owner, v.view_type, superview_name
    from all_views v, all_objects o
    where v.owner = o.owner
    and o.object_type = 'VIEW'
    and v.view_name = o.object_name
    and upper(o.owner) like 'APPS'
    and upper(v.view_name) like  'AP_INVOICES_V'
    and upper(xxmsz_tools.long2varchar('select text from ALL_VIEWS where owner = :owner and view_name = :view_name', 'owner',v.owner,'view_name',v.view_name)) like upper('%%')
    order by  xxmsz_tools.long2varchar('select text from ALL_VIEWS where owner = :owner and view_name = :view_name', 'owner',v.owner,'view_name',v.view_name)
    */
    function long2varchar( p_query  in varchar2,
                               p_name1   in varchar2 default null,
                               p_value1  in varchar2  default null,
                               p_name2   in varchar2 default null,
                               p_value2  in varchar2  default null,
                               p_name3   in varchar2 default null,
                               p_value3  in varchar2  default null,
                               p_name4   in varchar2 default null,
                               p_value4  in varchar2  default null
                              ) return varchar2;

  function getPeriodID(backlogInDays number, periodInterval number, maxBacklog number default -1000, maxBacklogText varchar2 default 'Pozosta≥e', FutureText varchar2  default 'Bieøπce' ) return number;
  -- funkcja zwraca ID okresu, do ktÛrego wpada dzieÒ zaleg≥osci
  -- na przyklad, gdy periodInterval = 5, to w zaleønosci od backlogInDays funkcja przyjmie nastepujace wartosci:
  -- backlogInDays : -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 ...
  -- getPeriodID   : <---- -2 -----> <----- -1 ---> <------- 0 ----------- ... -->
  function getPeriodName(backlogInDays number, periodInterval number, maxBacklog number default -1000, maxBacklogText varchar2 default 'Pozosta≥e', FutureText varchar2  default 'Bieøπce' ) return varchar2;
  -- funkcja zwraca nazwe okresu, do ktÛrego wpada dzieÒ zaleg≥osci
  -- na przyklad, gdy periodInterval = 5, to w zaleønosci od backlogInDays funkcja przyjmie nastepujace wartosci:
  -- backlogInDays : -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 ...
  -- getPeriodID   : <-- 10-6 -----> <---- 5-1 ---> <------- FutureText -- ... -->


  -- ***********************************************************************************************************************
  -- * funkcje przestarzale
  -- ***********************************************************************************************************************

  -- zob. funkcje greatest
  function maximum(
     number1  number   , number2  number   , number3  number default null   , number4  number default null   , number5  number default null
   , number6  number default null   , number7  number default null   , number8  number default null   , number9  number default null   , number10 number default null
   , number11 number default null   , number12 number default null   , number13 number default null   , number14 number default null   , number15 number default null
   , number16 number default null   , number17 number default null   , number18 number default null   , number19 number default null   , number20 number default null
   , number21 number default null   , number22 number default null   , number23 number default null   , number24 number default null   , number25 number default null
   , number26 number default null   , number27 number default null   , number28 number default null   , number29 number default null   , number30 number default null
  ) return number;

  -- zob. funkcje least
  function MINIMUM(
     number1  number   , number2  number   , number3  number default  null   , number4  number default  null   , number5  number default  null
   , number6  number default  null   , number7  number default  null   , number8  number default  null   , number9  number default  null   , number10 number default  null
   , number11 number default  null   , number12 number default  null   , number13 number default  null   , number14 number default  null   , number15 number default  null
   , number16 number default  null   , number17 number default  null   , number18 number default  null   , number19 number default  null   , number20 number default  null
   , number21 number default  null   , number22 number default  null   , number23 number default  null   , number24 number default  null   , number25 number default  null
   , number26 number default  null   , number27 number default  null   , number28 number default  null   , number29 number default  null   , number30 number default  null
  ) return number;

  -- zob. funkcja wordWrap
  function wordWrap( wrappedString varchar2, columnWidth number, getTokenNr number default 0, completeWithSpaces boolean default true, TokenSeparator varchar2 default '|') return varchar2;
  
  -- zob. erasePolishChars
  function withoutPolishSigns (S in varchar2) return varchar2;
  function erasePolishHooks(S varchar2) return varchar2;
  
  function get_primary_key( p_owner varchar2, p_table_name varchar2 ) return varchar2;
  
  -- Zwraca wszystkie przeszukiwalne kolumny podanej tabeli, w ten sposÛb moøna przeszukaÊ zawartosc calej bazy danych np tak 
  --  select * from ( XXX) where upper(cols) like '%ANY TEXT%', gdzie XXX
  --  select 'select '||xxmsz_tools.allTableColumns (table_name)||' vals, '''||table_name||''' tname from '||table_name||' union all '  from all_tables where owner = 'CWDATA'      
  function allTableColumns (pTableName varchar2, pColumNameFilter varchar2 default '%') return varchar2;
  
  
  -- Function allows to delete record from master table even it has child records
  -- BE AWARE ! THIS FUNCTION WORKS FINE UDER CONDITION THERE ARE CONTRAINTS IN DATABASE
  -- example call: 
  --    begin xxmsz_tools.merge_records('CWDATA','CWF_D_SALES_STRUCTURES','116','1002837','ID'); commit; end;  
  --    this will perform      update child_table set <child_table_column> =  1002837 where <child_table_colulm> = 116   for all child records and then
  --                           delete from CWDATA.CWF_D_SALES_STRUCTURES where id = 116  
  procedure merge_records(pOwner  varchar2, pTable_Name varchar2, pOldId varchar2, pNewId varchar2, pkColumn varchar2);
  
  -- silimar to merge_records, updates record from oldId to NewId
  -- begin xxmsz_tools.update_record('CWDATA','CWF_D_CURRENCIES','PLN','XXX','CURRENCY_CODE'); commit; end;   
  procedure update_record(pOwner  varchar2, pTable_Name varchar2, pOldId varchar2, pNewId varchar2, pkColumn varchar2);
  procedure enable_constraints(pOwner varchar2, pTable_Name varchar2, pkColumn varchar2);
  procedure disable_constraints(pOwner varchar2, pTable_Name varchar2, pkColumn varchar2);
  
  
  -- clob faciliates  
  Procedure NewClob  (clobloc       in out nocopy clob, msg_string    in varchar2);
  procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2);
  
  function getAbbreviation ( s varchar2 ) return varchar2;

end;
/

CREATE OR REPLACE package body Xxmsz_Tools as

  -- key must be exactly 8 bytes long
  c_encrypt_key varchar2(8) := 'key45678';

  fopDocumentId          varchar2(100);
  fopCurrentBorderStyle  varchar2(20);
  fopTableBodyFirstEntry boolean;
  --fopFileHandler         utl_file.file_type;
  fopOutputType          varchar2(20); -- file, xxmsztools_eventlog
  fopCharsDelimiter      char;

  c_start_of_time constant date := to_date ('01/01/0001','DD/MM/YYYY');
  c_end_of_time   constant date := to_date ('31/12/4712','DD/MM/YYYY');

 ---------------------------------------------------------------------------------------------------------------------------------------------------------


 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function iif( cond boolean, val1 varchar2, val2 varchar2 ) return varchar2 is
  begin
    if cond then return val1;
    else return val2; end if;
  end;
  function iif( cond boolean, val1 number, val2 number ) return number is
  begin
    if cond then return val1;
    else return val2; end if;
  end;
  function iif( cond boolean, val1 date, val2 date ) return date is
  begin
    if cond then return val1;
    else return val2; end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function center (S varchar2, LEN number) return varchar2 is
    L number;
    SPACES varchar2(500);
  begin
    L := ROUND ( (LEN -  LENGTH(S))  / 2 );
    SPACES := SUBSTR('                                                                                                           ',1,L);
    return SUBSTR( SPACES || S || SPACES, 1, len );
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
   function extractWord  (poz number, words varchar, sep varchar := '|') return varchar is
     word varchar2(5000):='';
     word2 varchar2(5000);
     str2 varchar2(5000):= words || sep;
   begin
     for i in 1..poz loop
      if i = 1 then
       word:=SUBSTR(str2,1,INSTR(str2,sep,poz)-1);
       word2:=str2;
      else
       word2 := SUBSTR(word2,LENGTH(word2)+2-LENGTH(SUBSTR(word2,INSTR(word2,sep,1))));
       word  := SUBSTR(word2,1,INSTR(word2,sep,1)-1);
      end if;
     end loop;
     return Word;
   end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function wordCount(  Words      varchar2,
                       Separator  in     varchar2 := '|') return number is
    N       number(9);
    Counter number(9);
    temp   varchar2(30000);
  begin
   temp := words;
   counter := 0;
   for n in 1..LENGTH(temp) loop
     if SUBSTR(temp,n,1) = separator then
       counter := counter + 1;
     end if;
   end loop;

   return counter+1;
  exception
   when OTHERS then
    return 0;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function replaceWord(poz number, replaceWith varchar2, words varchar, sep varchar := '|') return varchar2 is
    res varchar2(32000) := null;
    numberOfWords number(10);
  begin
    numberOfWords := wordCount(Words, Sep);
    if numberOfWords < poz then
     raise_application_error(-20000,'invalid poz parameter: cant be greather than numerOfWords');
    end if;
   for i in 1..numberOfWords loop
     if i <> poz then  res := merge(res,extractWord(i,Words,sep),sep);
                 else  res := merge(res,replaceWith,sep); end if;
   end loop;
   return res;
  end;

  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getTokenByName ( tokens varchar2, tokenName varchar2, tokenSeparator varchar2) return varchar2 is
   res        varchar2(32000);
   vtokens    varchar2(32000);
   vtokenName  varchar2(32000);
  begin
    -- @ is an identifier of start of token
    -- 'BIK_CREATED_BY_LOGIN=12;CREATED_BY_LOGIN=11' ---> ';@BIK_CREATED_BY_LOGIN=12;@CREATED_BY_LOGIN=11;@'
    vtokens    := replace ( tokenSeparator || tokens || tokenSeparator, tokenSeparator, tokenSeparator||'@' );
    vtokenName := '@'||tokenName; 
    select to_char( substr (vtokens,
                            instr (vtokens, vtokenName),
                              instr (vtokens,
                                     tokenSeparator,
                                     instr (vtokens, vtokenName)
                                    )
                            - instr (vtokens, vtokenName)
                           ))
    into res
    from dual;
    return substr(res,2,65000);
  end;
  
  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function pushLastWord(pushWord varchar2, words varchar2, sep varchar := '|') return varchar2 is --po≥Ûø
  begin
    return Xxmsz_Tools.merge(words, pushWord, sep);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function popLastWord(words varchar2, sep varchar := '|') return varchar2 is --zabierz
    res varchar2(32000) := null;
 numberOfWords number(10);
  begin
    numberOfWords := wordCount(Words, Sep);
 if numberOfWords < 1 then
  RAISE_APPLICATION_ERROR(-20000,'words is empty - cannot pop word');
 end if;
    for i in 1..numberOfWords-1 loop
   res := merge(res,extractWord(i,Words,sep),sep);
 end loop;
 return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function amountInWords(aamount number, language_code varchar2 default 'PL', currency_code1 varchar2 default 'z≥', acurrency_code2 varchar2 default 'gr') return varchar2 is
    Wart    varchar2(2000);
    currency_code2 varchar2(10);
    amount  number := ROUND ( aamount, 2); -- np. 11.115 -> 11.12 ( if you would like to receive 11.11 call trunc(., 2) function before using AmountInWord


      function engAmountInWordsA(amount number, language_code varchar2 default 'PL', currency_code1 varchar2 default 'z≥', currency_code2 varchar2 default 'gr') return varchar2 is
        liczba  number(12,2);
        pom     number;
        sl      varchar(20);
        out     varchar(1000);
        nascie  number;
        tys     number;

        type titem is record (
         SLOWO1 varchar2(20)
        ,SLOWO2 varchar2(20)
        ,SLOWO3 varchar2(20)
        ,WORD1  varchar2(20)
        ,WORD2  varchar2(20)
        ,WORD3  varchar2(20)
        );
        type TT_LICZBY_SLOWA is table of titem index by binary_integer;
        T_LICZBY_SLOWA TT_LICZBY_SLOWA;

      begin
        T_LICZBY_SLOWA (0).SLOWO1 :='zero ';    T_LICZBY_SLOWA (0).SLOWO2 :=' ';                  T_LICZBY_SLOWA (0).SLOWO3 :=' ';             T_LICZBY_SLOWA (0).WORD1 :='zero ';  T_LICZBY_SLOWA (0).WORD2 :='';             T_LICZBY_SLOWA (0).WORD3 :='';
        T_LICZBY_SLOWA (1).SLOWO1 :='jeden ';   T_LICZBY_SLOWA (1).SLOWO2 :='';                   T_LICZBY_SLOWA (1).SLOWO3 :='sto ';          T_LICZBY_SLOWA (1).WORD1 :='one ';   T_LICZBY_SLOWA (1).WORD2 :='';             T_LICZBY_SLOWA (1).WORD3 :='one hundred ';
        T_LICZBY_SLOWA (2).SLOWO1 :='dwa ';     T_LICZBY_SLOWA (2).SLOWO2 :='dwadzieúcia ';       T_LICZBY_SLOWA (2).SLOWO3 :='dwieúcie ';     T_LICZBY_SLOWA (2).WORD1 :='two ';   T_LICZBY_SLOWA (2).WORD2 :='twenty ';      T_LICZBY_SLOWA (2).WORD3 :='two hundred ';
        T_LICZBY_SLOWA (3).SLOWO1 :='trzy ';    T_LICZBY_SLOWA (3).SLOWO2 :='trzydzieúci ';       T_LICZBY_SLOWA (3).SLOWO3 :='trzysta ';      T_LICZBY_SLOWA (3).WORD1 :='three '; T_LICZBY_SLOWA (3).WORD2 :='thirty ';      T_LICZBY_SLOWA (3).WORD3 :='three hundred ';
        T_LICZBY_SLOWA (4).SLOWO1 :='cztery ';  T_LICZBY_SLOWA (4).SLOWO2 :='czterdzieúci ';      T_LICZBY_SLOWA (4).SLOWO3 :='czterysta ';    T_LICZBY_SLOWA (4).WORD1 :='four ';  T_LICZBY_SLOWA (4).WORD2 :='forty ';       T_LICZBY_SLOWA (4).WORD3 :='four hundred ';
        T_LICZBY_SLOWA (5).SLOWO1 :='piÍÊ ';    T_LICZBY_SLOWA (5).SLOWO2 :='piÍÊdziesiπt ';      T_LICZBY_SLOWA (5).SLOWO3 :='piÍÊset ';      T_LICZBY_SLOWA (5).WORD1 :='five ';  T_LICZBY_SLOWA (5).WORD2 :='fifty ';       T_LICZBY_SLOWA (5).WORD3 :='five hundred ';
        T_LICZBY_SLOWA (6).SLOWO1 :='szeúÊ ';   T_LICZBY_SLOWA (6).SLOWO2 :='szeúÊdziesiπt ';     T_LICZBY_SLOWA (6).SLOWO3 :='szeúset ';      T_LICZBY_SLOWA (6).WORD1 :='six ';   T_LICZBY_SLOWA (6).WORD2 :='sixty ';       T_LICZBY_SLOWA (6).WORD3 :='six hundred ';
        T_LICZBY_SLOWA (7).SLOWO1 :='siedem ';  T_LICZBY_SLOWA (7).SLOWO2 :='siedemdziesiπt ';    T_LICZBY_SLOWA (7).SLOWO3 :='siedemset ';    T_LICZBY_SLOWA (7).WORD1 :='seven '; T_LICZBY_SLOWA (7).WORD2 :='seventy ';     T_LICZBY_SLOWA (7).WORD3 :='seven hundred ';
        T_LICZBY_SLOWA (8).SLOWO1 :='osiem ';   T_LICZBY_SLOWA (8).SLOWO2 :='osiemdziesiπt ';     T_LICZBY_SLOWA (8).SLOWO3 :='osiemset ';     T_LICZBY_SLOWA (8).WORD1 :='eight '; T_LICZBY_SLOWA (8).WORD2 :='eighty ';      T_LICZBY_SLOWA (8).WORD3 :='eight hundred ';
        T_LICZBY_SLOWA (9).SLOWO1 :='dziewiÍÊ ';T_LICZBY_SLOWA (9).SLOWO2 :='dziewiÍÊdziesiπt ';  T_LICZBY_SLOWA (9).SLOWO3 :='dziewiÍÊset ';  T_LICZBY_SLOWA (9).WORD1 :='nine ';  T_LICZBY_SLOWA (9).WORD2 :='ninety ';      T_LICZBY_SLOWA (9).WORD3 :='nine hundred ';
        T_LICZBY_SLOWA (10).SLOWO1 :='';        T_LICZBY_SLOWA (10).SLOWO2 :='dziesiÍÊ ';         T_LICZBY_SLOWA (10).SLOWO3 :='';             T_LICZBY_SLOWA (10).WORD1 :='';      T_LICZBY_SLOWA (10).WORD2 :='ten ';        T_LICZBY_SLOWA (10).WORD3 :='';
        T_LICZBY_SLOWA (11).SLOWO1 :='';        T_LICZBY_SLOWA (11).SLOWO2 :='jedenaúcie ';       T_LICZBY_SLOWA (11).SLOWO3 :='';             T_LICZBY_SLOWA (11).WORD1 :='';      T_LICZBY_SLOWA (11).WORD2 :='eleven ';     T_LICZBY_SLOWA (11).WORD3 :='';
        T_LICZBY_SLOWA (12).SLOWO1 :='';        T_LICZBY_SLOWA (12).SLOWO2 :='dwanaúcie ';        T_LICZBY_SLOWA (12).SLOWO3 :='';             T_LICZBY_SLOWA (12).WORD1 :='';      T_LICZBY_SLOWA (12).WORD2 :='twelve ';     T_LICZBY_SLOWA (12).WORD3 :='';
        T_LICZBY_SLOWA (13).SLOWO1 :='';        T_LICZBY_SLOWA (13).SLOWO2 :='trzynaúcie ';       T_LICZBY_SLOWA (13).SLOWO3 :='';             T_LICZBY_SLOWA (13).WORD1 :='';      T_LICZBY_SLOWA (13).WORD2 :='thirteen ';   T_LICZBY_SLOWA (13).WORD3 :='';
        T_LICZBY_SLOWA (14).SLOWO1 :='';        T_LICZBY_SLOWA (14).SLOWO2 :='czternaúcie ';      T_LICZBY_SLOWA (14).SLOWO3 :='';             T_LICZBY_SLOWA (14).WORD1 :='';      T_LICZBY_SLOWA (14).WORD2 :='fourteen ';   T_LICZBY_SLOWA (14).WORD3 :='';
        T_LICZBY_SLOWA (15).SLOWO1 :='';        T_LICZBY_SLOWA (15).SLOWO2 :='piÍtnaúcie ';       T_LICZBY_SLOWA (15).SLOWO3 :='';             T_LICZBY_SLOWA (15).WORD1 :='';      T_LICZBY_SLOWA (15).WORD2 :='fifteen ';    T_LICZBY_SLOWA (15).WORD3 :='';
        T_LICZBY_SLOWA (16).SLOWO1 :='';        T_LICZBY_SLOWA (16).SLOWO2 :='szesnaúcie ';       T_LICZBY_SLOWA (16).SLOWO3 :='';             T_LICZBY_SLOWA (16).WORD1 :='';      T_LICZBY_SLOWA (16).WORD2 :='sixteen ';    T_LICZBY_SLOWA (16).WORD3 :='';
        T_LICZBY_SLOWA (17).SLOWO1 :='';        T_LICZBY_SLOWA (17).SLOWO2 :='siedemnaúcie ';     T_LICZBY_SLOWA (17).SLOWO3 :='';             T_LICZBY_SLOWA (17).WORD1 :='';      T_LICZBY_SLOWA (17).WORD2 :='seventeen ';  T_LICZBY_SLOWA (17).WORD3 :='';
        T_LICZBY_SLOWA (18).SLOWO1 :='';        T_LICZBY_SLOWA (18).SLOWO2 :='osiemnaúcie ';      T_LICZBY_SLOWA (18).SLOWO3 :='';             T_LICZBY_SLOWA (18).WORD1 :='';      T_LICZBY_SLOWA (18).WORD2 :='eighteen ';   T_LICZBY_SLOWA (18).WORD3 :='';
        T_LICZBY_SLOWA (19).SLOWO1 :='';        T_LICZBY_SLOWA (19).SLOWO2 :='dziewiÍtnaúcie ';   T_LICZBY_SLOWA (19).SLOWO3 :='';             T_LICZBY_SLOWA (19).WORD1 :='';      T_LICZBY_SLOWA (19).WORD2 :='nineteen ';   T_LICZBY_SLOWA (19).WORD3 :='';

        /*Generacja s≥ownego zapisu waroúci*/
        nascie := 0;
        tys := 0;
        liczba := amount; --parametr wejsciowy

        if liczba >= 100000000 then
          tys := 1;
          pom := MOD (TRUNC (liczba / 100000000), 10);
          sl :=  T_LICZBY_SLOWA (pom).word3;
          out := CONCAT (out, sl);
          liczba := liczba - pom * 100000000;
        end if;

        if liczba >= 10000000 then
          tys := 1;
          pom := MOD (TRUNC (liczba / 10000000), 10);
          if pom > 1 then
            sl :=  T_LICZBY_SLOWA (pom).word2;
            out := CONCAT (out, sl);
          liczba := liczba - pom * 10000000;
          else
            pom := MOD (TRUNC (liczba / 1000000), 100);
            sl :=  T_LICZBY_SLOWA (pom).word2;
            nascie := 1;
            out := CONCAT (out, sl);
          liczba := liczba - pom * 1000000;
          end if;
        end if;

        if liczba >= 1000000 then
          tys := 1;
          pom := MOD (TRUNC (liczba / 1000000), 10);
          if pom = 1 then
            out := CONCAT (out, 'one million ');
            tys := 0;
          else
            sl :=  T_LICZBY_SLOWA (pom).word1;
            out := CONCAT (out, sl);
          end if;
          liczba := liczba - pom * 1000000;
        end if;

        if tys = 1 then
          out := CONCAT (out, 'millions ');
       tys := 0;
        end if;

        if liczba >= 100000 then
          tys := 1;
          pom := MOD (TRUNC (liczba / 100000), 10);
          sl :=  T_LICZBY_SLOWA (pom).word3;
          out := CONCAT (out, sl);
          liczba := liczba - pom * 100000;
        end if;

        if liczba >= 10000 then
          tys := 1;
          pom := MOD (TRUNC (liczba / 10000), 10);
          if pom > 1 then
              sl :=  T_LICZBY_SLOWA (pom).word2;
              out := CONCAT (out, sl);
            liczba := liczba - pom * 10000;
          else
            pom := MOD (TRUNC (liczba / 1000), 100);
            sl :=  T_LICZBY_SLOWA (pom).word2;
            nascie := 1;
            out := CONCAT (out, sl);
            liczba := liczba - pom * 1000;
          end if;
        end if;

        if liczba >= 1000 then
          tys := 1;
          pom := MOD (TRUNC (liczba / 1000), 10);
          if pom = 1 then
            out := CONCAT (out, 'one thousand ');
            tys := 0;
          else
            sl :=  T_LICZBY_SLOWA (pom).word1;
            out := CONCAT (out, sl);
          end if;
          liczba := liczba - pom * 1000;
        end if;

        if tys = 1 then
          out := CONCAT (out, 'thousands ');
       tys := 0;
        end if;

        if MOD (liczba, 1000) > 0 then
          pom := MOD (TRUNC (liczba / 100), 10);
          sl :=  T_LICZBY_SLOWA (pom).word3;
          out := CONCAT (out, sl);
          pom := MOD (TRUNC (liczba / 10), 10);
          nascie := 0;
          if pom <> 1 then
          sl :=  T_LICZBY_SLOWA (pom).word2;
          else
            nascie := 1;
            pom := MOD (TRUNC (liczba), 100);
            sl :=  T_LICZBY_SLOWA (pom).word2;
          end if;
          out := CONCAT (out, sl);
          if nascie = 0 and TRUNC (MOD (liczba, 10)) != 0 then
            pom := TRUNC (MOD (liczba, 10));
            sl :=  T_LICZBY_SLOWA (pom).word1;
            out := CONCAT (out, sl);
          end if;
        end if;
        out := out || currency_code1 || ' ';

        -- grosze
        out := out || MOD (liczba * 100, 100) || '/100 ';
        return out;
      end;

   --poprzednia wersja funkcji
   --Zalety tej wersji: obsluguje kwoty > 1000000000
   --Wady tej wersji:   nie odmienia wyrazow, tylko pisze w formacie one*two*three
      function engAmountInWordsB(amount number, language_code varchar2 default 'PL', currency_code1 varchar2 default 'z≥', currency_code2 varchar2 default 'gr') return varchar2 is
        value  number;
        value1  number;
        value2  number;
        decimal number;
        i       number;
        S_SAY   varchar2(2000);
        ratunek number;
      begin
        ratunek := 1;
        S_SAY:='';
        i:=10;
        decimal:=NVL(ABS(amount-TRUNC(amount)),0);
        value:=NVL(ABS(amount),0);
        loop
          value1:= TRUNC(value/i,1);
          value2:=(value1 - TRUNC(value1))*10;

          if value1=0 and value2*10=0 then S_SAY:=S_SAY || TO_CHAR(ROUND(decimal,2)*100) || '/100* ' || currency_code1; exit; end if;
          if ratunek = 100            then S_SAY:=S_SAY || TO_CHAR(ROUND(decimal,2)*100) || '0 / 100* ' || currency_code1; exit; end if;--ratunek
          if value2=1 then S_SAY:='one*' || S_SAY; end if;
          if value2=2 then S_SAY:='two*' || S_SAY; end if;
          if value2=3 then S_SAY:='three*' || S_SAY; end if;
          if value2=4 then S_SAY:='four*' || S_SAY; end if;
          if value2=5 then S_SAY:='five*' || S_SAY; end if;
          if value2=6 then S_SAY:='six*' || S_SAY; end if;
          if value2=7 then S_SAY:='seven*' || S_SAY; end if;
          if value2=8 then S_SAY:='eight*' || S_SAY; end if;
          if value2=9 then S_SAY:='nine*' || S_SAY; end if;
          if value2=0 then S_SAY:='zero*' || S_SAY; end if;
          i:=i*10;
          ratunek := ratunek + 1;
        end loop;
      return S_SAY;
      end;

    function slownie( L varchar2 ) return varchar2 is
     V varchar2( 1000 ) := '';
     V1 varchar2( 100 ) := '';

     R varchar2( 1000 );
     AKT varchar2( 3 );
     K integer := 0;
     STOP boolean := false;


            function LICZEBNIK(
                K number,
                L1 varchar2,
                L2 varchar2,
                L5 varchar2 )  return varchar2 is
            begin
                if K = 0 then
             return L5;
                elsif K = 1 then
             return L1;
                else
             if K > 10 and K < 20 then
                 return L5;
             else
                 declare
              CH varchar2( 40 );
              L  number;
                 begin
              CH := TO_CHAR ( K );
              L := TO_NUMBER ( SUBSTR( CH, NVL(LENGTH( CH ), 0) ) );
              if L = 0 or L = 1 then
                   return L5;
              elsif L > 1 and L < 5 then
                   return L2;
              else
                  return L5;
              end if;
                 end;
             end if;
                end if;
            return null; end;



            function SLOWNIE3( L varchar2 ) return varchar2 is
             V varchar2( 1000 ) :='';
             NASCIE varchar2( 1 ) := 'N';
            begin
             if NVL(LENGTH( L ), 0) > 2 then
              if SUBSTR( L, 1, 1 )  = '1' then
               V := 'sto ';
              elsif SUBSTR( L, 1 , 1 ) = '2' then
               V := 'dwieúcie ';
                elsif SUBSTR( L,( 1 ), 1 ) = '3' then
               V := 'trzysta ';
                elsif SUBSTR( L,( 1 ), 1 ) = '4' then
               V := 'czterysta ';
                elsif SUBSTR( L,( 1 ), 1 ) = '5' then
               V := 'piÍÊset ';
                elsif SUBSTR( L,( 1 ), 1 ) = '6' then
               V := 'szeúÊset ';
                elsif SUBSTR( L,( 1 ), 1 ) = '7' then
               V := 'siedemset ';
                elsif SUBSTR( L,( 1 ), 1 ) = '8' then
               V := 'osiemset ';
                elsif SUBSTR( L,( 1 ), 1 ) = '9' then
               V := 'dziewiÍÊset ';
              end if;
             end if;
             if NVL(LENGTH( L ), 0) > 1 then
              if SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '1' then
               NASCIE := 'T';
               if SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '0' then
                V := V || 'dziesiÍÊ ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '1' then
                V := V || 'jedenaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '2' then
                V := V || 'dwanaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '3' then
                V := V || 'trzynaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '4' then
                V := V || 'czternaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '5' then
                V := V || 'piÍtnaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '6' then
                V := V || 'szesnaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '7' then
                V := V || 'siedemnaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '8' then
                V := V || 'osiemnaúcie ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '9' then
                V := V || 'dziewiÍtnaúcie ';
               end if;
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '2' then
               V := V || 'dwadzieúcia ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '3' then
               V := V || 'trzydzieúci ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '4' then
               V := V || 'czterdzieúci ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '5' then
               V := V || 'piÍÊdziesiπt ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '6' then
               V := V || 'szeúÊdziesiπt ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '7' then
               V := V || 'siedemdziesiπt ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '8' then
               V := V || 'osiemdziesiπt ';
              elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) - 1 ), 1 ) = '9' then
               V := V || 'dziewiÍÊdziesiπt ';
              end if;
             end if;
             if NVL(LENGTH( L ), 0) > 0 then
              if NASCIE = 'N' then
               if SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '1' then
                V := V || 'jeden ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '2' then
                V := V || 'dwa ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '3' then
                V := V || 'trzy ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '4' then
                V := V || 'cztery ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '5' then
                V := V || 'piÍÊ ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '6' then
                V := V || 'szeúÊ ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '7' then
                V := V || 'siedem ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '8' then
                V := V || 'osiem ';
               elsif SUBSTR( L, ( NVL(LENGTH( L ), 0) ), 1 ) = '9' then
                V := V || 'dziewiÍÊ ';
               end if;
              end if;
              if NVL(LENGTH( L ), 0) = 1 and SUBSTR ( L, 1, 1 ) = '0' then
               V := 'zero ';
              end if;
             end if;
             return V;
            end;



    begin

     loop
      k := k + 1;
      if k > NVL(LENGTH( L ), 0) then
       exit;
      end if;
      if SUBSTR( L, K, 1 ) <> '0' then
          R := SUBSTR( L, K, NVL(LENGTH( L ), 0) - K + 1 );
          exit;
      end if;
     end loop;
     K := 0;
     loop
      if NVL(LENGTH( R ), 0) > 3 then
       AKT := SUBSTR( R, NVL(LENGTH( R ), 0)- 2 , 3 );
       R := SUBSTR( R, 1, NVL(LENGTH( R ), 0) - 3 );
       V1 := SLOWNIE3( AKT );
       K := K + 1;
      else
       STOP := true;
       AKT := R;
       R := '';
       V1 := SLOWNIE3( AKT );
       K := K + 1;
      end if;
      if NVL(LENGTH( V1 ), 0) > 1 then
       if K = 2 then
        V1 := V1 ||
         LICZEBNIK(
          TO_NUMBER( AKT ),
          'tysiπc ',
          'tysiπce ',
          'tysiÍcy ' );
       elsif K = 3 then
        V1 := V1 ||
         LICZEBNIK(
          TO_NUMBER( AKT ),
          'milion ',
          'miliony ',
          'milionÛw ' );
       elsif K = 4 then
        V1 := V1 ||
         LICZEBNIK(
          TO_NUMBER( AKT ),
          'miliard ',
          'miliardy ',
          'miliardÛw ' );
       elsif K = 5 then
        V1 := V1 ||
         LICZEBNIK(
          TO_NUMBER( AKT ),
          'bilion ',
          'biliony ',
          'bilionÛw ' );
       elsif K = 6 then
        V1 := V1 ||
         LICZEBNIK(
          TO_NUMBER( AKT ),
          'trylion ',
          'tryliony ',
          'trylionÛw ' );
       end if;
       V := V1 || V;
      end if;
      exit when STOP;
     end loop;
     return V;

    end;


  begin
    currency_code2 := acurrency_code2;
    if currency_code1 <> 'z≥' and currency_code2 = 'gr' then
      currency_code2 := null;
    end if;

    if language_code <> 'PL' then
  if amount >= 1000000000 then
    return EngAmountInWordsB(amount, language_code, currency_code1, currency_code2);
  else
     return EngAmountInWordsA(amount, language_code, currency_code1, currency_code2);
  end if;

    end if;

 declare
  MinusHolder varchar2(1);
 begin
   MinusHolder := '';
      if amount < 0 then
    MinusHolder := '-';
   end if;

       Wart := slownie (TRUNC(ABS(amount))) || currency_code1 || ' ';
       -- tutaj dodaj grosze
       if TRUNC( ABS(amount), 2) - TRUNC( ABS(amount), 2)  >= 0 then
           Wart := Wart ||SUBSTR( TO_CHAR( TRUNC( ABS(amount), 2), '99999999999999999999.00' ), -2 ) ||'/100 ' || currency_code2;
       end if;
      return Merge ( MinusHolder, Wart);
 end;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function merge(S1 varchar2, S2 varchar2, SEP varchar2 default null) return varchar2 is
  begin
   if S1 is null then
      return S2;
   else
      if S2 is null then
       return S1;
      else
        return S1 || Sep || S2;
      end if;
   end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure addPercent ( V in out varchar2 ) is
  begin
    if INSTR(V, '%') = 0 or V is null then
      V := MERGE ( V, '%');
    end if;
  end;

  function strToDate
  ( p_dat varchar2 ) return date as
    v_dat varchar2(1000);
    v_buf date := null;

       function conv_date (p_string in varchar2)
       return date
       is
         type fmtArray is table of varchar2(30);
         g_fmts fmtArray := fmtArray (
                                      'YYYY-MM-DD'
                                     ,'YYYYMMDD'
                                     ,'YYYYMMDDHH24MI'
                                     ,'DD-MM-YY'
                                     ,'MON-DD-YY'
                                     ,'DD-MON-YYYY'
                                     ,'YYYY/MM/DD HH24:MI:SS'
                                     ,'D-M-YY'
                                     ,'YY-M-D'
                                     ,'M-D-YYYY'
                                     ,'M-DM-YY'
                                     ,'YY-D-M'
                                     ,'YYYY-D-M'
                                     ,'DDMMYYYY'
                                     ,'DDMMYY'
                                     ,'MMDDYYYY'
                                     ,'MMDDYY'
                                     ,'YYYY-M-D'
                                    );
          RETURN_VALUE date;
       begin
          for i in 1 .. g_fmts.count
          loop
             begin
                return_value := TO_DATE(p_string,g_fmts(i));
                exit;
             exception
                when OTHERS then null;
             end;
          end loop;

          if (return_value is null) then
             raise_application_error(-20000, 'Invalid date format : ' || p_string);
          end if;
          return return_value;
      end;

  begin
    v_dat := UPPER(p_dat);
    if v_dat is not null then
      if INSTR(v_dat,'STY')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'STY')-1)||'01'||SUBSTR(v_dat,INSTR(v_dat,'STY')+3);
      end if;
      if INSTR(v_dat,'LUT')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'LUT')-1)||'02'||SUBSTR(v_dat,INSTR(v_dat,'LUT')+3);
      end if;
      if INSTR(v_dat,'MAR')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'MAR')-1)||'03'||SUBSTR(v_dat,INSTR(v_dat,'MAR')+3);
      end if;
      if INSTR(v_dat,'KWI')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'KWI')-1)||'04'||SUBSTR(v_dat,INSTR(v_dat,'KWI')+3);
      end if;
      if INSTR(v_dat,'MAJ')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'MAJ')-1)||'05'||SUBSTR(v_dat,INSTR(v_dat,'MAJ')+3);
      end if;
      if INSTR(v_dat,'CZE')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'CZE')-1)||'06'||SUBSTR(v_dat,INSTR(v_dat,'CZE')+3);
      end if;
      if INSTR(v_dat,'LIP')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'LIP')-1)||'07'||SUBSTR(v_dat,INSTR(v_dat,'LIP')+3);
      end if;
      if INSTR(v_dat,'SIE')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'SIE')-1)||'08'||SUBSTR(v_dat,INSTR(v_dat,'SIE')+3);
      end if;
      if INSTR(v_dat,'WRZ')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'WRZ')-1)||'09'||SUBSTR(v_dat,INSTR(v_dat,'WRZ')+3);
      end if;
      if INSTR(v_dat,'PA')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'PA')-1)||'10'||SUBSTR(v_dat,INSTR(v_dat,'PA')+3);
      end if;
      if INSTR(v_dat,'LIS')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'LIS')-1)||'11'||SUBSTR(v_dat,INSTR(v_dat,'LIS')+3);
      end if;
      if INSTR(v_dat,'GRU')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'GRU')-1)||'12'||SUBSTR(v_dat,INSTR(v_dat,'GRU')+3);
      end if;
      if INSTR(v_dat,'JAN')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'JAN')-1)||'01'||SUBSTR(v_dat,INSTR(v_dat,'JAN')+3);
      end if;
      if INSTR(v_dat,'FEB')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'FEB')-1)||'02'||SUBSTR(v_dat,INSTR(v_dat,'FEB')+3);
      end if;
      if INSTR(v_dat,'MAR')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'MAR')-1)||'03'||SUBSTR(v_dat,INSTR(v_dat,'MAR')+3);
      end if;
      if INSTR(v_dat,'APR')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'APR')-1)||'04'||SUBSTR(v_dat,INSTR(v_dat,'APR')+3);
      end if;
      if INSTR(v_dat,'MAY')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'MAY')-1)||'05'||SUBSTR(v_dat,INSTR(v_dat,'MAY')+3);
      end if;
      if INSTR(v_dat,'JUN')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'JUN')-1)||'06'||SUBSTR(v_dat,INSTR(v_dat,'JUN')+3);
      end if;
      if INSTR(v_dat,'JUL')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'JUL')-1)||'07'||SUBSTR(v_dat,INSTR(v_dat,'JUL')+3);
      end if;
      if INSTR(v_dat,'AUG')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'AUG')-1)||'08'||SUBSTR(v_dat,INSTR(v_dat,'AUG')+3);
      end if;
      if INSTR(v_dat,'SEP')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'SEP')-1)||'09'||SUBSTR(v_dat,INSTR(v_dat,'SEP')+3);
      end if;
      if INSTR(v_dat,'NOV')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'NOV')-1)||'10'||SUBSTR(v_dat,INSTR(v_dat,'NOV')+3);
      end if;
      if INSTR(v_dat,'OCT')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'OCT')-1)||'11'||SUBSTR(v_dat,INSTR(v_dat,'OCT')+3);
      end if;
      if INSTR(v_dat,'DEC')>0 then
        v_dat := SUBSTR(v_dat,1,INSTR(v_dat,'DEC')-1)||'12'||SUBSTR(v_dat,INSTR(v_dat,'DEC')+3);
      end if;
    end if;
    -- data nie moze zawierac liter i musi zawierac cyfry
    if  NVL(TRANSLATE(v_dat,'0ABCDEFGHIJKLMNOPQRSTUVWXYZ•∆ £—”åèØπÊÍÒÛ≥úüø','0'),'0') = v_dat
    and not NVL(TRANSLATE(v_dat,' 0123456789', ' '),' ') = v_dat
      then

      v_buf := conv_date (v_dat);

    end if;
    return v_buf;
    --if v_buf is not null then
    --  return('D');
    --else
    --  return('V:'||v_dat);
    --end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function isSubsetOf (Set1 varchar2, Set2 varchar2) return varchar2 is
    T integer;
    NOT_FOUND boolean;
    ELEMENT varchar2(100);
 workSet2 varchar2(5000);
  begin
    workSet2 := ';' || set2 || ';';
    NOT_FOUND := false;
    T := 1;
    ELEMENT := EXTRACTWORD(1,SET1,';');
    while (NVL(ELEMENT,'<EMPTY>') <> '<EMPTY>') and (NOT_FOUND = false) loop
      if INSTR(workSet2, ';' || ELEMENT || ';') = 0 then
        NOT_FOUND := true;
      end if;
      T := T + 1;
      ELEMENT := EXTRACTWORD(T,SET1,';');
    end loop;
    if NOT_FOUND then
       return 'N';
    else
       return 'Y';
    end if;
  end;


 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function peselIsOK ( PESEL  varchar2 ) return  varchar2
    is
  type  TPesel  is  table  of  number  index  by  binary_integer;
  CPesel          TPESEL;
  TempPESEL       number;
  L               binary_integer;
  CyfraKontrolna  number;

  begin
  if LENGTH( PESEL ) <> 11 then
    return 'N';
  else
   TempPESEL := TO_NUMBER ( PESEL );
   for L in reverse 1..11 loop
    CPesel(L) := MOD(TempPESEL,10);
    TempPESEL := FLOOR(TempPesel/10);
   end loop;

   CyfraKontrolna := MOD(10 - MOD(
     MOD(CPesel( 1) * 1,10) +
     MOD(CPesel( 2) * 3,10) +
     MOD(CPesel( 3) * 7,10) +
     MOD(CPesel( 4) * 9,10) +
     MOD(CPesel( 5) * 1,10) +
     MOD(CPesel( 6) * 3,10) +
     MOD(CPesel( 7) * 7,10) +
     MOD(CPesel( 8) * 9,10) +
     MOD(CPesel( 9) * 1,10) +
     MOD(CPesel(10) * 3,10),10),10);

   if (CyfraKontrolna = CPesel(11)) then
    return 'Y';
   else
    return 'N';
   end if;

  end if;

  exception
   when OTHERS then
    return 'N';
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function nipIsOk ( NIP  varchar2 ) return  varchar2
    is
   /* ********************************************************************** */
  /* Funkcja sprawdza czy NIP jest dobry                                    */
  /* Zwraca Y/N
  /* ********************************************************************** */
    type  TNip  is  table  of  number  index  by  binary_integer;
    CNIP            TNip;
    TempNIP         number;
    L               binary_integer;
    CyfraKontrolna  number;
   begin
  if LENGTH( NIP ) <> 10 then
    return 'N';
  else
   TempNIP := TO_NUMBER ( NIP );
   if TempNIP = 0 then return 'N'; end if;
   for L in reverse 1..10 loop
    CNIP(L) := MOD(TempNIP,10);
    TempNIP := FLOOR(TempNIP/10);
   end loop;
   CyfraKontrolna :=
     MOD(
     CNIP( 1) * 6 +
     CNIP( 2) * 5 +
     CNIP( 3) * 7 +
     CNIP( 4) * 2 +
     CNIP( 5) * 3 +
     CNIP( 6) * 4 +
     CNIP( 7) * 5 +
     CNIP( 8) * 6 +
     CNIP( 9) * 7,11);
   if (CyfraKontrolna = CNIP(10)) then
     return 'Y';
   else
     return 'N';
   end if;
  end if;
  exception
   when OTHERS then
        return 'N';
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function regonIsOk ( REGON  varchar2 ) return  varchar2
    is
   CyfraKontrolna     number;
      c1                 number;
      c2                 number;
      c3                 number;
      c4                 number;
      c5                 number;
      c6                 number;
      c7                 number;
      c8                 number;
      c9                 number;
     begin
     if LENGTH(regon) <> 9 and  LENGTH(regon) <> 14 then return 'N'; end if;
     if TO_NUMBER(regon) = 0 then return 'N'; end if;

     c1 := TO_NUMBER(SUBSTR(regon,1,1));
     c2 := TO_NUMBER(SUBSTR(regon,2,1));
     c3 := TO_NUMBER(SUBSTR(regon,3,1));
     c4 := TO_NUMBER(SUBSTR(regon,4,1));
     c5 := TO_NUMBER(SUBSTR(regon,5,1));
     c6 := TO_NUMBER(SUBSTR(regon,6,1));
     c7 := TO_NUMBER(SUBSTR(regon,7,1));
     c8 := TO_NUMBER(SUBSTR(regon,8,1));
     c9 := TO_NUMBER(SUBSTR(regon,9,1));

     CyfraKontrolna := MOD(
    (c1 * 8 +
     C2 * 9 +
     C3 * 2 +
     C4 * 3 +
     C5 * 4 +
     C6 * 5 +
     C7 * 6 +
     C8 * 7),11);

     if CyfraKontrolna = c9 then return 'Y';
     else return 'N';
     end if;
  exception
   when OTHERS then
    return 'N';
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function formatDate(Word varchar2, format varchar2 default 'YYYY-MM-DD') return varchar2 is
  -- Nazwa          : FormatDate
  -- Opis           : Funkcja przekaszta≥aca date do postaci akceptowanej przez polecenie DML
  begin
    if LENGTH(Word) <> 0 then
     return 'TO_DATE('''||Word||''','''||format||''')';
    else
     return 'NULL';
    end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function formatDateTime(Word varchar2) return varchar2 is
  -- Nazwa          : FormatDateTime
  -- Opis           : Funkcja przekaszta≥aca siÍ do postaci akceptowanej przez
  begin
    if LENGTH(Word) <> 0 then
     return 'TO_DATE('''||Word||''',''dd.mm.yyyy HH24:MI'')';
    else
     return 'NULL';
    end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function formatFloat(Word varchar2) return varchar2 is
  -- Nazwa          : FormatFloat
  -- Opis           : Funkcja przekaszta≥aca siÍ do postaci akceptowanej przez
  --                  polecenie DML
  begin
    if LENGTH(Word) <> 0 then
     return Word;
    else
     return 'NULL';
    end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function formatString(Word varchar2) return varchar2 is
  -- Nazwa          : FormatString
  -- Opis           : Funkcja przekaszta≥aca siÍ do postaci akceptowanej przez
  --                  polecenie DML
  begin
    return ''''||replace(Word,'''','''''')||'''';
  end;


 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function buildCondition ( FIELDTYPE varchar2, FIELD_NAME varchar2, VALUE1 varchar2, VALUE2 varchar2 default null  ) return varchar2 is
   QUOTED_VALUE1 varchar2(4000);
   QUOTED_VALUE2 varchar2(4000);
  begin
      /*
   sk≥adnia dostepna od wersji 9 bazy danych
   CASE
        WHEN FIELDTYPE = 'VARCHAR2' THEN
         QUOTED_VALUE1 := formatString( VALUE1 );
         QUOTED_VALUE2 := formatString( VALUE2 );
        WHEN FIELDTYPE = 'DATE'     THEN
         QUOTED_VALUE1 := formatDate(VALUE1, 'yyyy-mm-dd');
         QUOTED_VALUE2 := formatDate(VALUE2, 'yyyy-mm-dd');
        ELSE
         QUOTED_VALUE1 := VALUE1;
         QUOTED_VALUE2 := VALUE2;
      END CASE;
      */
   if FIELDTYPE = 'VARCHAR2' then
         QUOTED_VALUE1 := formatString( VALUE1 );
         QUOTED_VALUE2 := formatString( VALUE2 );
      elsif FIELDTYPE = 'DATE'     then
         QUOTED_VALUE1 := formatDate(VALUE1, 'yyyy-mm-dd');
         QUOTED_VALUE2 := formatDate(VALUE2, 'yyyy-mm-dd');
      elsif FIELDTYPE = 'NUMBER'     then
         QUOTED_VALUE1 := replace(VALUE1, ',', '.');
         QUOTED_VALUE2 := replace(VALUE2, ',', '.');
      else
         QUOTED_VALUE1 := VALUE1;
         QUOTED_VALUE2 := VALUE2;
      end if;

   if VALUE1 is null and VALUE2 is null then return null; end if;
   if VALUE2 is null then
    if FIELDTYPE = 'VARCHAR2' and (INSTR(QUOTED_VALUE1, '%') <> 0 or INSTR(QUOTED_VALUE1, '_') <> 0) then
      return FIELD_NAME || ' LIKE ' || QUOTED_VALUE1 ;
    else
      return FIELD_NAME || ' = ' || QUOTED_VALUE1 ;
    end if;
   end if;

   return FIELD_NAME || ' BETWEEN ' || QUOTED_VALUE1 || ' AND ' || QUOTED_VALUE2;
 end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure executeImmediate (SQL_STATEMENT varchar2) is
  pragma autonomous_transaction;
  begin
    EXECUTE immediate SQL_STATEMENT;
    commit;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function toLatin2 (tekst in varchar2) return varchar2 is
    STR_ROB varchar2(1024);
  begin
      str_rob := tekst;
      str_rob := replace(str_rob, '•', CHR(164));
      str_rob := replace(str_rob, 'è', CHR(141));
      str_rob := replace(str_rob, '∆', CHR(143));
      str_rob := replace(str_rob, ' ', CHR(168));
      str_rob := replace(str_rob, '£', CHR(157));
      str_rob := replace(str_rob, '—', CHR(227));
      str_rob := replace(str_rob, '”', CHR(224));
      str_rob := replace(str_rob, 'å', CHR(151));
      str_rob := replace(str_rob, 'Ø', CHR(189));
      str_rob := replace(str_rob, 'π', CHR(165));
      str_rob := replace(str_rob, 'Ê', CHR(134));
      str_rob := replace(str_rob, 'Í', CHR(169));
      str_rob := replace(str_rob, '≥', CHR(136));
      str_rob := replace(str_rob, 'Ò', CHR(228));
      str_rob := replace(str_rob, 'Û', CHR(162));
      str_rob := replace(str_rob, 'ú', CHR(152));
      str_rob := replace(str_rob, 'ü', CHR(171));
      str_rob := replace(str_rob, 'ø', CHR(190));
      return(str_rob);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function hasPolishSigns(S in out varchar2) return varchar2 is
   S2 varchar2(500);
  begin
    S := UPPER(S);
    S2:= S;
    S := replace(S,' ','');
    S := replace(S,'”','');
    S := replace(S,'•','');
    S := replace(S,'å','');
    S := replace(S,'£','');
    S := replace(S,'Ø','');
    S := replace(S,'è','');
    S := replace(S,'∆','');
    S := replace(S,'—','');

    if S <> S2 then return 'Y'; else return 'N'; end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function extractFileName(S  in varchar2)  return varchar2  is
  -- Opis           : Funkcja wyodrÍbnia ze úcieøki nazwÍ pliku
  --                  np. ExtractFileName('c:\Program Files\Joasia.xls') -> Joasia.xls
    POS   number;
  begin
    POS := INSTR(S, '\', -1, 1);
    if POS = 0 then
        POS := INSTR(S, '/', -1, 1);
    end if;
    return SUBSTR(S, POS+1 );
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function extractPath (S  in varchar2)  return varchar2  is
  -- Opis           : Funkcja wyodrÍbnia ze úcieøki úcieøkÍ bez nazwy pliku
  --                  np. ExtractFileName('c:\Program Files\Joasia.xls') -> c:\Program Files\
    POS   number;
  begin
    POS := INSTR(S, '\', -1, 1);
    if POS = 0 then
        POS := INSTR(S, '/', -1, 1);
    end if;
    return SUBSTR(S, 1, POS );
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getBanknotes( Wydaj varchar2 ) return varchar2 is
  -- Opis   : Kwota podana w banknotach i bilonach
  -- Autor : Adam P≥andowski 2001.03.10
   W1000 varchar2(20);
   W200  varchar2(20);
   W100  varchar2(20);
   W50   varchar2(20);
   W20   varchar2(20);
   W10   varchar2(20);
   W5    varchar2(20);
   W2    varchar2(20);
    W1    varchar2(20);
    Wgr   varchar2(20);
   tekst varchar2(250);
   Wynik number(16,2);
  begin
  -- Sprawdü d≥ugoúÊ kwoty dla setek 1000 z≥
  if TRUNC(wydaj)<0 then
  return Tekst||' ???? ';
  else
     if NVL(LENGTH( TRUNC(Wydaj) ), 0)>3 then
      -- Dla 1000
     --  IF Trunc(Wydaj/200)>=5 THEN
         if TRUNC(Wydaj/200)>=5 then
          W200:=TRUNC(Wydaj/200)||'*200';
          Wynik:=Wydaj-TRUNC(Wydaj/200)*200;
      if Wynik>=100 then
       W100:=',100';
     end if;
     if SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=9 then
        W50:=',50';
        W20:=',20,20';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=8 then
        W50:=',50';
        W20:=',20';
        W10:=',10';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=7 then
        W50:=',50';
        W20:=',20';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=6 then
        W50:=',50';
        W10:=',10';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=5 then
        W50:=',50';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=4 then
        W20:=',20,20';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=3 then
        W20:=',20';
        W10:=',10';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=2 then
        W20:=',20';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-2,1)=1 then
        W20:=',10';
      end if;
    if SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=9 then
       W5:=',5';
       W2:=',2,2';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=8 then
        W5:=',5';
       W2:=',2';
       W1:=',1';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=7 then
        W5:=',5';
       W2:=',2';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=6 then
        W5:=',5';
       W1:=',1';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=5 then
        W5:=',5';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=4 then
        W2:=',2,2';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=3 then
        W2:=',2';
       W1:=',1';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=2 then
        W2:=',2';
      elsif SUBSTR(Wynik,INSTR(Wynik,',')-1,1)=1 then
        W1:=',1';
      end if;

    end if;
       --
  -- Sprawdü d≥ugoúÊ kwoty dla setek do 999 z≥
     elsif NVL(LENGTH( TRUNC(Wydaj) ), 0)=3 then
      if TRUNC(Wydaj/100) >=9 then
         W200:='4*200';
         W100:=',100';
         Wynik:=Wydaj-TRUNC(Wydaj/100)*100;
      -- Wartoúci poniøej 100
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 800
     elsif TRUNC(Wydaj/100)=8 then
         W200:='4*200';
      Wynik:=Wydaj-800;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 700
     elsif TRUNC(Wydaj/100)=7 then
         W200:='3*200';
         W100:=',100';
      Wynik:=Wydaj-700;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 600
     elsif TRUNC(Wydaj/100)=6 then
         W200:='3*200';
      Wynik:=Wydaj-600;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 500
     elsif TRUNC(Wydaj/100)=5 then
         W200:='200,200';
         W100:=',100';
      Wynik:=Wydaj-500;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 400
     elsif TRUNC(Wydaj/100)=4 then
         W200:='200,200';
      Wynik:=Wydaj-400;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 300
     elsif TRUNC(Wydaj/100)=3 then
         W200:='200';
         W100:=',100';
      Wynik:=Wydaj-300;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
    -- Wydaj 200
     elsif TRUNC(Wydaj/100)=2 then
         W200:='200';
      Wynik:=Wydaj-200;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
     -- Wydaj 100
     elsif TRUNC(Wydaj/100)=1 then
         W100:='100';
         Wynik:=Wydaj-100;
        if TRUNC(Wynik/50)=1 then
           W50:=',50';
           Wynik:=Wynik-50;
        end if;
        if TRUNC(Wynik/20)=2  then
           W20:=',20,20';
           Wynik:=Wynik-40;
        end if;
        if TRUNC(Wynik/20)=1 then
           W20:=',20';
           Wynik:=Wynik-20;
        end if;
        if TRUNC(Wynik/10)=1 then
           W10:=',10';
        end if;
       end if;
      if SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=9 then
       W5:=',5';
       W2:=',2,2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=8 then
        W5:=',5';
       W2:=',2';
       W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=7 then
        W5:=',5';
       W2:=',2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=6 then
        W5:=',5';
       W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=5 then
        W5:=',5';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=4 then
        W2:=',2,2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=3 then
        W2:=',2';
       W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=2 then
        W2:=',2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=1 then
        W1:=',1';
      end if;
     -- Sprawdü d≥ugoúÊ kwoty dla dziesiπtek
    elsif NVL(LENGTH( TRUNC(Wydaj) ), 0)=2 then
     if SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=9 then
        W50:='50';
        W20:=',20,20';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=8 then
        W50:='50';
        W20:=',20';
        W10:=',10';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=7 then
        W50:='50';
        W20:=',20';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=6 then
        W50:='50';
        W10:=',10';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=5 then
        W50:='50';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=4 then
        W20:='20,20';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=3 then
        W20:='20';
        W10:=',10';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=2 then
        W20:='20';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-2,1)=1 then
        W20:='10';
      end if;
      if SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=9 then
       W5:=',5';
       W2:=',2,2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=8 then
        W5:=',5';
       W2:=',2';
       W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=7 then
        W5:=',5';
       W2:=',2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=6 then
        W5:=',5';
       W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=5 then
        W5:=',5';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=4 then
        W2:=',2,2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=3 then
        W2:=',2';
       W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=2 then
        W2:=',2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=1 then
        W1:=',1';
      end if;
    --Sprawdü z≥otÛwki
    elsif NVL(LENGTH( TRUNC(Wydaj) ), 0)=1 then
    if replace((SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)),',','0')=0 then
      W1:='0';
    else
     if SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=9 then
        W50:='5';
        W20:=',2,2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=8 then
        W5:='5';
        W2:=',2';
        W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=7 then
        W5:='5';
        W2:=',2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=6 then
        W5:='5';
        W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=5 then
        W5:='5';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=4 then
        W2:='2,2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=3 then
        W2:='2';
        W1:=',1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=2 then
        W2:='2';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=1 then
        W1:='1';
      elsif SUBSTR(Wydaj,INSTR(Wydaj,',')-1,1)=',' then
        W1:='0';
      end if;
     end if;
    end if;
   -- Sprawdü doa≥πcz grosze
    if SUBSTR( TO_CHAR( TRUNC( Wydaj, 2), '999999999.00' ), -2 )<>'XX' then
     Wgr:=','||SUBSTR( TO_CHAR( TRUNC( Wydaj, 2), '999999999.00' ), -2 )||'/100';
    end if;
    return Tekst||'('||W1000||W200||W100||W50||W20||W10||W5||W2||W1||' z≥ '||Wgr||' gr'||')';
    end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getsqlv(sqltext varchar2, valuewhenempty varchar2, exceptifempty char, sep varchar2 default '|', maxsizeofres number default 30000, singlevaluemode boolean) return varchar2 is
    select_cursor   number;
    n_buffer        varchar2(2000);
    counter         number;
    result          varchar2(32000);
  begin
    begin
   result:= '';
      select_cursor:=dbms_sql.open_cursor;
      dbms_sql.parse(select_cursor, sqltext, dbms_sql.v7);
      dbms_sql.define_column(select_cursor,1,n_buffer,2000);
      --dbms_sql.bind_variable(select_cursor,':TOKEN_NUMBER_FIELD',n_number_of_policy);
      counter:=dbms_sql.execute(select_cursor);

     loop
        if dbms_sql.fetch_rows(select_cursor)>0 then
          dbms_sql.column_value(select_cursor, 1, n_buffer);
          --dbms_output.put_line ( n_buffer );
    result := merge (result, n_buffer, sep);
    if singlevaluemode then exit; end if;
    if length( result ) > maxsizeofres then exit; end if;
        else
          exit;
        end if;
      end loop;
      dbms_sql.close_cursor(select_cursor);
   if exceptifempty = 'Y' and result is null then raise no_data_found; end if;
   return nvl(result,valuewhenempty);
    exception
      when others then
        if dbms_sql.is_open(select_cursor) then
          dbms_sql.close_cursor(select_cursor);
        end if;
        raise;
    end;
  end;

  /*
  FUNCTION remote_qry(p_sql IN VARCHAR2) RETURN NUMBER IS
    --
    v_cursor_name INTEGER;
    v_cursor_rows INTEGER;
    v_cursor_data NUMBER;
    --
  BEGIN
    --
 v_cursor_name := DBMS_SQL.OPEN_CURSOR@SA;
 --
 DBMS_SQL.PARSE@SA(v_cursor_name, p_sql, DBMS_SQL.native);
 DBMS_SQL.DEFINE_COLUMN@SA(v_cursor_name, 1, v_cursor_data);
 --
 v_cursor_rows := DBMS_SQL.EXECUTE_AND_FETCH@SA(v_cursor_name);
 --
 DBMS_SQL.COLUMN_VALUE@SA(v_cursor_name, 1, v_cursor_data);
 DBMS_SQL.CLOSE_CURSOR@SA(v_cursor_name);
    --
    RETURN v_cursor_data;
    --
  EXCEPTION
    WHEN OTHERS THEN
      log_message(p_src => 'swd_sa_extract.remote_qry'
                 ,p_msg => 'Wywolanie zdalne zakonczone bledem: '||SQLERRM
                 ,p_log => C_LOG_LEVEL_ERROR);
      --
   IF DBMS_SQL.IS_OPEN@SA(v_cursor_name) THEN
        DBMS_SQL.CLOSE_CURSOR@SA(v_cursor_name);
   END IF;
   --
      RAISE;
      --
  END remote_qry;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION remote_dml(p_sql IN VARCHAR2) RETURN NUMBER IS
    --
    v_cursor_name INTEGER;
    v_cursor_rows INTEGER;
    --
  BEGIN
    --
 v_cursor_name := DBMS_SQL.OPEN_CURSOR@SA;
 --
 DBMS_SQL.PARSE@SA(v_cursor_name, p_sql, DBMS_SQL.native);
 --
 v_cursor_rows := DBMS_SQL.EXECUTE@SA(v_cursor_name);
 --
 DBMS_SQL.CLOSE_CURSOR@SA(v_cursor_name);
    --
    RETURN v_cursor_rows;
    --
  EXCEPTION
    WHEN OTHERS THEN
      log_message(p_src => 'swd_sa_extract.remote_dml'
                 ,p_msg => 'Wywolanie zdalne zakonczone bledem: '||SQLERRM
                 ,p_log => C_LOG_LEVEL_ERROR);
      --
   IF DBMS_SQL.IS_OPEN@SA(v_cursor_name) THEN
        DBMS_SQL.CLOSE_CURSOR@SA(v_cursor_name);
   END IF;
   --
      RAISE;
      --
  END remote_dml;
  */
  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION getSQLV(SQLText VARCHAR2, exceptifempty CHAR, Sep VARCHAR2 DEFAULT '|', maxsizeofres NUMBER DEFAULT 30000, singlevaluemode BOOLEAN) RETURN VARCHAR2 IS
    select_cursor   NUMBER;
    n_buffer        VARCHAR2(2000);
    counter         NUMBER;
    result          VARCHAR2(32000);
  BEGIN
    BEGIN
   result:= '';
      select_cursor:=dbms_sql.open_cursor;
      dbms_sql.parse(select_cursor, SQLText, dbms_sql.v7);
      dbms_sql.define_column(select_cursor,1,n_buffer,2000);
      --dbms_sql.bind_variable(select_cursor,':TOKEN_NUMBER_FIELD',n_number_of_policy);
      counter:=dbms_sql.EXECUTE(select_cursor);

     LOOP
        IF DBMS_SQL.FETCH_ROWS(select_cursor)>0 THEN
          DBMS_SQL.COLUMN_VALUE(select_cursor, 1, n_buffer);
          --dbms_output.put_line ( n_buffer );
    result := Merge (result, n_buffer, Sep);
    IF singlevaluemode THEN EXIT; END IF;
    IF LENGTH( result ) > maxsizeofres THEN EXIT; END IF;
        ELSE
          EXIT;
        END IF;
      END LOOP;
      DBMS_SQL.CLOSE_CURSOR(select_cursor);
   IF exceptifempty = 'Y' AND result IS NULL THEN RAISE NO_DATA_FOUND; END IF;
   RETURN NVL(result,valueWhenempty);
    EXCEPTION
      WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(select_cursor) THEN
          DBMS_SQL.CLOSE_CURSOR(select_cursor);
        END IF;
        RAISE;
    END;
  END;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getSQLValues(SQLText varchar2, valueWhenEmpty varchar2 default null,exceptifempty char default 'N', Sep varchar2 default ', ', maxsizeofres number default 30000) return varchar2 is
  begin
   return getSQLV(replace(SQLText,'^',''''), valueWhenEmpty, exceptifempty, Sep, maxsizeofres, false);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getSQLValue(SQLText varchar2, valueWhenEmpty varchar2 default null, exceptifempty char default 'Y') return varchar2 is
  begin
   return getSQLV(replace(SQLText,'^',''''), valueWhenEmpty, exceptifempty, '|', 2000, true);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure wordWrapInit (aWordWrap in out nocopy tWordWrap,adefaultStr varchar2, tokenSeparator varchar2 default '|') is
  begin
   aWordWrap.defaultStr := adefaultStr;
   aWordWrap.linesPastedStr.delete;
   aWordWrap.linesFromPos.delete;
   aWordWrap.linesToPos.delete;
   aWordWrap.linesAlign.delete;
   awordWrap.resultLineNum := -1;
   aWordWrap.errorMessage  := null;
   aWordWrap.tokenSeparator  := tokenSeparator;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure wordWrapPrepareColumn(aWordWrap in out nocopy tWordWrap, pastedStr varchar2, placeHolder varchar2, align number) is
   fromPos number;
   toPos   number;

   tempStr varchar2(2000);
   tempfromPos number;
  begin
   if aWordWrap.errorMessage is not null then return; end if;
   fromPos := INSTR(aWordWrap.defaultStr,placeHolder);
   toPos   := fromPos + LENGTH(placeHolder)-1;
   if fromPos = 0 then
    aWordWrap.errorMessage := 'Error: Placeholder '||NVL(PlaceHolder,'<empty>')|| ' not found in defaultStr';
   return;
   end if;

   tempStr     := PasteStr(aWordWrap.defaultStr,'.',fromPos,toPos,0);
   tempfromPos := INSTR(tempStr,placeHolder);
   if tempfromPos <> 0 then
    aWordWrap.errorMessage := 'Error: Two or more occurences of placeholder '||NVL(PlaceHolder,'<empty>')|| ' in defaultStr';
     return;
   end if;

   -- takie dziwolπgi, bo w plsql nie ma polecenia With
   aWordWrap.linesPastedStr ( aWordWrap.linesPastedStr.COUNT ) := pastedStr;
   aWordWrap.linesfromPos   ( aWordWrap.linesfromPos.COUNT   ) := fromPos;
   aWordWrap.linestoPos     ( aWordWrap.linestoPos.COUNT     ) := toPos;
   aWordWrap.linesalign     ( aWordWrap.linesalign.COUNT     ) := align;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function  wordWrapGetNumberOfLines(aWordWrap in out nocopy tWordWrap) return number is
  i number;
  MAXVALUE number;

      function SingleMax ( N1 number, N2 number) return number is
      begin
     if N1 >= N2 then return N1;
                 else return N2; end if;
      end;

  begin
    if aWordWrap.errorMessage is not null then return -1; end if;
    i := aWordWrap.linesPastedStr.FIRST;
    MAXVALUE := -99999999999999999999999999999999999;
    while i is not null loop
      MAXVALUE := SingleMax ( MAXVALUE, WordCount( WordWrap( aWordWrap.linesPastedStr (I), aWordWrap.linestoPos(I) - aWordWrap.linesFromPos(I) + 1, 0, false, aWordWrap.tokenSeparator),aWordWrap.tokenSeparator) );
      --FUNCTION WordWrap( S VARCHAR2, columnWidth NUMBER, getTokenNr NUMBER DEFAULT 0, completeWithSpaces BOOLEAN DEFAULT TRUE, TokenSeparator VARCHAR2 DEFAULT '|') RETURN VARCHAR2
      i := aWordWrap.linesPastedStr.NEXT(i);
    end loop;
    awordWrap.resultLineNum := MAXVALUE;
    return MAXVALUE;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function  wordWrapGetLine(aWordWrap in out nocopy tWordWrap,lineNum number) return varchar2 is
    returnedStr varchar2(2000);
    i number;
  begin
   if aWordWrap.errorMessage is not null then return aWordWrap.errorMessage; end if;
    if awordWrap.resultLineNum = -1 then -- obiekt nie zosta≥ prawid≥owo zainicjowany
   return 'funkcja wordWrapGetLine - obiekt nie zosta≥ prawid≥owo zainicjowany';
   end if;

   returnedStr := aWordWrap.defaultStr;
   i := aWordWrap.linesPastedStr.FIRST;
   while i is not null loop
   returnedStr:= PasteStr (
                   returnedStr
                  ,WordWrap( aWordWrap.linesPastedStr (i), aWordWrap.linestoPos(i) - aWordWrap.linesFromPos(i) + 1, lineNum, false, aWordWrap.tokenSeparator)
                     ,aWordWrap.linesFromPos(i)
                     ,aWordWrap.linesToPos(i)
                     ,aWordWrap.linesAlign(i) );
      i := aWordWrap.linesPastedStr.NEXT(i);
    end loop;
    return returnedStr;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure amountsInit (amounts in out nocopy tAmounts, agroupOperator integer default 0) is
  begin
   Amounts.COUNT := 0;
   Amounts.groupOperator := agroupOperator;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure amountsAdd(amounts in out nocopy tAmounts, aGroupIndicator varchar2, amount1 number, amount2 number default 0, amount3 number default 0, amount4 number default 0, amount5 number default 0, amount6 number default 0, amount7 number default 0, amount8 number default 0) is
    t      integer;
    c      integer;
    FOUND  boolean;
    groupIndicator  varchar2(100);
  begin
   groupIndicator := aGroupIndicator;
   if groupIndicator <> 'TOTAL' then
     amountsAdd(Amounts, 'TOTAL', amount1, amount2, amount3, amount4, amount5, amount6, amount7, amount8);
   end if;
   FOUND := false;
   if groupIndicator is null then groupIndicator := '-'; end if;
   for c in 1..amounts.COUNT loop
    if amounts.groupIndicators(c) = groupIndicator then FOUND := true; t:= c; exit; end if;
   end loop;

   if FOUND then
    if amounts.groupOperator = 0 then
     amounts.amounts1(t) := amounts.amounts1(t) + NVL(amount1,0);
     amounts.amounts2(t) := amounts.amounts2(t) + NVL(amount2,0);
     amounts.amounts3(t) := amounts.amounts3(t) + NVL(amount3,0);
     amounts.amounts4(t) := amounts.amounts4(t) + NVL(amount4,0);
     amounts.amounts5(t) := amounts.amounts5(t) + NVL(amount5,0);
     amounts.amounts6(t) := amounts.amounts6(t) + NVL(amount6,0);
     amounts.amounts7(t) := amounts.amounts7(t) + NVL(amount7,0);
     amounts.amounts8(t) := amounts.amounts8(t) + NVL(amount8,0);
    elsif amounts.groupOperator = 1 then
     amounts.amounts1(t) := maximum (amounts.amounts1(t) , NVL(amount1,0));
     amounts.amounts2(t) := maximum (amounts.amounts2(t) , NVL(amount2,0));
     amounts.amounts3(t) := maximum (amounts.amounts3(t) , NVL(amount3,0));
     amounts.amounts4(t) := maximum (amounts.amounts4(t) , NVL(amount4,0));
     amounts.amounts5(t) := maximum (amounts.amounts5(t) , NVL(amount5,0));
     amounts.amounts6(t) := maximum (amounts.amounts6(t) , NVL(amount6,0));
     amounts.amounts7(t) := maximum (amounts.amounts7(t) , NVL(amount7,0));
     amounts.amounts8(t) := maximum (amounts.amounts8(t) , NVL(amount8,0));
    elsif amounts.groupOperator = 2 then
     amounts.amounts1(t) := MINIMUM (amounts.amounts1(t) , NVL(amount1,0));
     amounts.amounts2(t) := MINIMUM (amounts.amounts2(t) , NVL(amount2,0));
     amounts.amounts3(t) := MINIMUM (amounts.amounts3(t) , NVL(amount3,0));
     amounts.amounts4(t) := MINIMUM (amounts.amounts4(t) , NVL(amount4,0));
     amounts.amounts5(t) := MINIMUM (amounts.amounts5(t) , NVL(amount5,0));
     amounts.amounts6(t) := MINIMUM (amounts.amounts6(t) , NVL(amount6,0));
     amounts.amounts7(t) := MINIMUM (amounts.amounts7(t) , NVL(amount7,0));
     amounts.amounts8(t) := MINIMUM (amounts.amounts8(t) , NVL(amount8,0));
    end if;
   else
    amounts.COUNT := amounts.COUNT + 1;
    amounts.amounts1(amounts.COUNT)         := NVL(amount1,0);
    amounts.amounts2(amounts.COUNT)         := NVL(amount2,0);
    amounts.amounts3(amounts.COUNT)         := NVL(amount3,0);
    amounts.amounts4(amounts.COUNT)         := NVL(amount4,0);
    amounts.amounts5(amounts.COUNT)         := NVL(amount5,0);
    amounts.amounts6(amounts.COUNT)         := NVL(amount6,0);
    amounts.amounts7(amounts.COUNT)         := NVL(amount7,0);
    amounts.amounts8(amounts.COUNT)         := NVL(amount8,0);
    amounts.groupIndicators(amounts.COUNT) := groupIndicator;
   end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure amountsGetExample1(Amounts in out nocopy TAmounts) is
    t integer;
    procedure wout ( s varchar2 ) is begin dbms_output.put_line ( s ); end;

  begin
   for t in 1..Amounts.COUNT loop
    wout ( Amounts.amounts1(t) || ' ' || Amounts.amounts2(t) || ' ' || Amounts.amounts3(t) || ' ' || Amounts.amounts4(t) || ' ' || Amounts.GroupIndicators(t));
   end loop;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
 procedure amountsGetExample2 (amounts in out nocopy TAmounts) is
     procedure wout ( s varchar2 ) is begin dbms_output.put_line ( s ); end;
 begin
   for L in 2..amounts.COUNT loop -- no 1 is "TOTAL"
     wout ( amounts.groupIndicators(L)
   || ' ' || amounts.amounts1(L)
   || ' ' || amounts.amounts2(L)
   || ' ' || amounts.amounts3(L) );
   end loop;

   if amounts.COUNT-1 > 1 then
     wout  ('========================================');
     wout ( amounts.groupIndicators(1)
   || ' ' || Xxmsz_Tools.AmountsGetByIndicator (amounts, 'TOTAL', 1)
   || ' ' || Xxmsz_Tools.AmountsGetByIndicator (amounts, 'TOTAL', 2)
   || ' ' || Xxmsz_Tools.AmountsGetByIndicator (amounts, 'TOTAL', 3) );
   end if;
 end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function amountsGetByIndicator(Amounts in out nocopy TAmounts, aGroupIndicator varchar2, AmountIndex number) return number is
    t      integer;
    c      integer;
    FOUND  boolean;
    GroupIndicator  varchar2(100);
  begin
   GroupIndicator := aGroupIndicator;
   FOUND := false;
   if GroupIndicator is null then GroupIndicator := '-'; end if;
   for c in 1..Amounts.COUNT loop
    if Amounts.GroupIndicators(c) = GroupIndicator then FOUND := true; t:= c; exit; end if;
   end loop;

   if FOUND then
     if amountIndex = 1 then return amounts.amounts1(t); end if;
     if amountIndex = 2 then return amounts.amounts2(t); end if;
     if amountIndex = 3 then return amounts.amounts3(t); end if;
     if amountIndex = 4 then return amounts.amounts4(t); end if;
     if amountIndex = 5 then return amounts.amounts5(t); end if;
     if amountIndex = 6 then return amounts.amounts6(t); end if;
     if amountIndex = 7 then return amounts.amounts7(t); end if;
     if amountIndex = 8 then return amounts.amounts8(t); end if;
   else
     return 0;
   end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function trimSpaces ( S varchar2 ) return varchar is
    lenBefore number;
    lenAfter  number;
    Res       varchar2(30000);
  begin
  if S is null then
   return null;
  end if;
  if LENGTH ( S ) > 30000 then
    RAISE_APPLICATION_ERROR(-20000,'sorry, string too long');
  end if;
  Res := Trim ( S );
  loop
   lenBefore := LENGTH ( Res );
   Res := replace ( Res, '  ', ' ');
   lenAfter := LENGTH ( Res );
   exit when lenBefore = lenAfter;
  end loop;
  return Res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function withoutPolishSigns (S in varchar2) return varchar2 is
    res varchar2(1024);
  begin
      res := S;
      res := replace(res, '•', 'A');
      res := replace(res, 'è', 'Z');
      res := replace(res, '∆', 'C');
      res := replace(res, ' ', 'E');
      res := replace(res, '£', 'L');
      res := replace(res, '—', 'N');
      res := replace(res, '”', 'O');
      res := replace(res, 'å', 'S');
      res := replace(res, 'Ø', 'Z');
      res := replace(res, 'π', 'a');
      res := replace(res, 'Ê', 'c');
      res := replace(res, 'Í', 'e');
      res := replace(res, '≥', 'l');
      res := replace(res, 'Ò', 'n');
      res := replace(res, 'Û', 'o');
      res := replace(res, 'ú', 's');
      res := replace(res, 'ü', 'z');
      res := replace(res, 'ø', 'z');
      return(res);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function wordWrap( wrappedString varchar2, columnWidth number, getTokenNr number default 0, completeWithSpaces boolean default true, TokenSeparator varchar2 default '|') return varchar2 is
   Rest      varchar2(30000);
   Token     varchar2(1000);
   outString varchar2(30000);
   S         varchar2(30000);
   Sentry    number;
  begin
    Sentry := 0;
    S := replace ( wrappedString, CHR(10), TokenSeparator); -- ch(10) jest zawsze separatorem linii

    if LENGTH ( S ) > 30000 then
      return 'sorry, string too long';
    end if;
   outString := '';
   Rest := S;

   loop
     Sentry := Sentry + 1;
  if INSTR( rest, TokenSeparator ) <> 0                     --   jeøeli znaleziono znak koÒca wiersza
    and INSTR( rest, TokenSeparator )-1 <= columnWidth then -- i jesli pierwszy wiersz bez znaku konca wiersza zmiesci sie w kolumnie, to go wez
       Token := SUBSTR( rest, 1, INSTR( rest, TokenSeparator )-1); -- to wez
       Rest  := SUBSTR( rest,    INSTR( rest, TokenSeparator )+1, 30000);
     else
       Token := SUBSTR( rest, 1, columnWidth); -- w przeciwnym wypadku wez to co zmiesci sie w pierwszej kolumnie
       Rest  := SUBSTR( rest,    columnWidth + 1, 30000);

       -- to jeszcze nie jest ostateczny podzial na token i rest.
    -- moze nastapic odciecie czesci tokena po spacji lub myslniku i doklejenie go z powrotem do rest
       -- dfdgdfgdf dfgdfgd|fgd-- jesli ostatni znak tokena i pierwszy znak reszty sa literami* to jesli w tokenie jest spacja/myslnik, to znajdz piersza od konca i przytnij token
    --    * - dok≥adnie: jest innym znakiem niz spacja, myslnik, kropka, znak konca wiersza
       if SUBSTR( token, LENGTH(token), 1) not in (' ','-','.',TokenSeparator) and SUBSTR(rest, 1, 1) not in ( ' ','-','.',TokenSeparator) then
      if replace(replace( replace(SUBSTR(token,2,30000),' ',''), '-', ''),'.', '')  <> SUBSTR(token,2,30000) then -- jest spacja/myslnik czyli mozna zawijac
        declare
      spacePos1 number;
      spacePos2 number;
      spacePos3 number;
      spacePos  number;
      newToken  varchar2(1000);
      restToken varchar2(1000);
     begin
       spacePos1  := INSTR(token,' ',-1);
       spacePos2  := INSTR(token,'-',-1);
       spacePos3  := INSTR(token,'.',-1);
       spacePos   := Maximum (spacePos1, spacePos2,spacePos3); -- pierwszy od konca myslnik lub spacja
          newToken   := SUBSTR(token, 1, spacePos);
       restToken  := SUBSTR(token, spacePos+1, 30000);
       --dbms_output.put_line('newToken='||newToken);
       --dbms_output.put_line('restToken='||restToken);
       Token := newToken;
       Rest := Merge( restToken, Rest, ''); --doklejenie z powrotem fragmentu tokenu to pozosta≥ej czesci
     end;
      end if;
    end if;

  end if;

  if completeWithSpaces then
       outString := Merge ( outString, SUBSTR(merge(Token, MakeStr(' ',columnWidth)),1,columnWidth), TokenSeparator);
  else
       outString := Merge ( outString, SUBSTR(Token,1,columnWidth), TokenSeparator);
  end if;
     exit when (rest is null) or (Sentry = 1000);
   end loop;
   if Sentry = 1000 then
    return 'Error in WordWrap';
   else
     if getTokenNr = 0 then return outString;
                       else return ExtractWord(getTokenNr, outString, TokenSeparator); end if;
   end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function wordWrap( wrappedString varchar2, columnWidth number, getTokenNr number default 0, completeWithSpaces varchar2 default 'Y', TokenSeparator varchar2 default '|') return varchar2 is   
  begin
    return wordWrap( wrappedString, columnWidth, getTokenNr, completeWithSpaces = 'Y' , TokenSeparator);
  end;
  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function makeStr(s varchar2, len number) return varchar2 is
    res varchar2(30000);
  begin
   if s is null or len < 1 then
     return 'input data error';
   end if;
   res := s;
   loop
     res := merge(res,s);
     exit when LENGTH(res) >= len;
   end loop;
   return SUBSTR(res,1,len);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function pasteStr( Str varchar2, pastedStr varchar2, fromPos number, toPos number, align number ) return varchar2 is
   aPastedStr varchar2(30000);
  begin
   if align = 0 then aPastedStr := rpad(NVL(PastedStr,' '), toPos - fromPos + 1, ' '); end if;
   if align = 1 then aPastedStr := lpad(NVL(PastedStr,' '), toPos - fromPos + 1, ' '); end if;
   if align = 2 then aPastedStr := Center (pastedStr, toPos - fromPos + 1); end if;
   return SUBSTR(str,1,fromPos-1) || aPastedStr || SUBSTR(str,toPos+1, 30000);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function ynToBool ( S varchar2, resultIfEmpty boolean default false ) return boolean is
  begin
   if S is null then return resultIfEmpty; else
     return UPPER(substr(S,1,1)) in ('T','Y');
   end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function ynToYN ( S varchar2, resultIfEmpty varchar2 default 'N' ) return char is
  begin
   if S is null then return resultIfEmpty; else
     if UPPER(substr(S,1,1)) in ('T','Y') then return 'Y'; else return 'N'; end if;
   end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function erasePolishChars(S varchar2) return varchar2 is
   S2 varchar2(3000);
  begin
    S2 := S;
    S2 := replace(S2,' ','E');
    S2 := replace(S2,'”','O');
    S2 := replace(S2,'•','A');
    S2 := replace(S2,'å','S');
    S2 := replace(S2,'£','L');
    S2 := replace(S2,'Ø','Z');
    S2 := replace(S2,'è','Z');
    S2 := replace(S2,'∆','C');
    S2 := replace(S2,'—','N');
    S2 := replace(S2,'Í','e');
    S2 := replace(S2,'Û','o');
    S2 := replace(S2,'π','a');
    S2 := replace(S2,'ú','s');
    S2 := replace(S2,'≥','l');
    S2 := replace(S2,'ø','z');
    S2 := replace(S2,'ü','z');
    S2 := replace(S2,'Ê','c');
    S2 := replace(S2,'Ò','n');

    return S2;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function boolToYN ( bool boolean, trueValue varchar2 default 'Y', falseValue varchar2 default 'N' ) return varchar2 is
  begin
   if bool then return trueValue;
           else return falseValue; end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getIBANcheckDigits (acc varchar2 ) return varchar2 is 
  begin
    return lpad(TO_CHAR (98 - MOD (TO_NUMBER (acc || '2521' || '00'), 97)),2,'0');
  end;
  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function formatIBAN ( inS varchar2, numberOfSignsInSection number default 4, formatOnlyWhenDivisible varchar2 default 'N' ) return varchar2 is
  res varchar2(500);
  n integer;
  S varchar2(500);
      function toIBAN (acc varchar2) return varchar2 is 
      --cc 88888888 aaaa bbbb cccc dddd
      --                               
      --         11 1111 1111 2222 2222
      --12 34567890 1234 5678 9012 3456
      begin
        return substr(acc,1,2) 
         || ' ' || substr(acc,3,4) 
         || ' ' || substr(acc,7,4)
         || ' ' || substr(acc,11,4)
         || ' ' || substr(acc,15,4)
         || ' ' || substr(acc,19,4)
         || ' ' || substr(acc,23,4);
      end;                  
  begin
    s := replace(inS,' ','');    
    if length(s)=26 then
      return toIBAN(inS);
    end if;    
    
    --old version
    if YNToBool ( formatOnlyWhenDivisible ) then
      if LENGTH(s) MOD numberOfSignsInSection <> 0 then return s; end if;
    end if;

    n := 0;
    loop
      exit when NVL(LENGTH(SUBSTR(s,1 + n * numberOfSignsInSection ,numberOfSignsInSection)),0) = 0;
      res := Xxmsz_Tools.merge( res, SUBSTR(s,1 + n * numberOfSignsInSection ,numberOfSignsInSection), ' ');
      n := n + 1;
    end loop;
    return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function formatNIP  ( inS varchar2 ) return varchar2 is
  S varchar2(100);
  begin
    if inS is null then return null; end if;
    s := replace(inS,' ','');
    s := replace(inS,'-','');
    if inS <> s then return inS ;
                else return SUBSTR(s,1,3) || '-' || SUBSTR(s,4,3) || '-' || SUBSTR(s,7,2) || '-' || SUBSTR(s,9,2); end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function strToNumber ( str varchar2, valueWhenEmpty varchar2 default '0' ) return number is
   res number;
  begin
   begin
     res := TO_NUMBER (replace(str,' ','')); -- konwertuj na liczbe
   exception
    when OTHERS then
  begin
       res := TO_NUMBER (replace(replace(str,' ',''),',','.')); -- a jesli sie nie udalo, to zamien ,->. i konweruj na liczbe
  exception
    when OTHERS then
         res := TO_NUMBER (replace(replace(str,' ',''),'.',',')); -- a jesli sie nie udalo, to zamien .->, i konweruj na liczbe
                                                     -- a jesli sie nie udalo, to blad
  end;
   end;
   return nvl(res, valueWhenEmpty);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function isNumber ( str varchar2 ) return varchar2  is
   t number;
  begin
    t := strToNumber (str);
    return 'Y';
  exception
   when others then return 'N';
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure pushModuleName ( moduleName varchar2 ) is
  begin
    moduleNameForEventLog := pushLastWord(moduleName,moduleNameForEventLog, '.');
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure popModuleName is
  begin
    moduleNameForEventLog := popLastWord(moduleNameForEventLog,'.');
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure setModuleName ( moduleName varchar2 ) is
  begin
    moduleNameForEventLog := moduleName;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insertIntoEventLog ( message varchar2, messageType varchar2 default 'I', moduleName varchar2 default 'XXMSZTOOLS', writeMessage varchar2 default 'Yes', raiseExceptions varchar2 default 'No') is
  pragma autonomous_transaction;
  maxLength number := 3900;
  
  cursor cur (pmessage varchar2, pmaxLength number) is 
               select * from  (
                 select substr(pmessage,1 + (rownum-1)*pmaxLength ,pmaxLength) submessage from dual 
                 connect by rownum  < 100 
               )
               where submessage is not null;  
  begin
   if not Xxmsz_Tools.ynToBool ( writeMessage , true) then return; end if;
   begin   
     --dzielenie na substringi o okreúlonej d≥ugoúci
     for rec in cur (message, maxLength)
     loop
       EXECUTE immediate
      'insert into xxmsztools_eventlog (id, module_name, message, message_type) values (xxmsztools_eventlog_seq.nextval, :module_name,:message,:messageType)'
      using  NVL(moduleName,moduleNameForEventLog)
           , rec.submessage
           , messageType;
     end loop;
     commit;
   exception
     when OTHERS then
       EXECUTE immediate
      'insert into xxmsztools_eventlog (id, module_name, message, message_type) values (xxmsztools_eventlog_seq.nextval, :module_name,:message,''E'')'
    using NVL(moduleName,moduleNameForEventLog)
        , replace('Unable to insert message : ' || TO_CHAR (sqlcode) || ' ' || sqlerrm ,'''','''''');
       commit;
       if Xxmsz_Tools.ynToBool ( raiseExceptions, false ) then raise; end if;
   end;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function insertIntoEventLog (pdate date, pvalue varchar) return varchar2 is
  begin
    if pdate = trunc(sysdate) then
      insertIntoEventLog(pvalue, 'I', 'insertIntoEventLog' || to_char(pdate, 'yyyy-mm-dd'));
 else
  raise_application_error(-20000, 'Wy≥πcz debug- funkcja insertIntoEventLog');
 end if;
    return null;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure dbms_outputPut_line (
      str         in   varchar2,
      len         in   integer := 254,
      expand_in   in   boolean := true
   )
   is
      v_len   pls_integer     := LEAST (len, 255);
      v_str   varchar2 (2000);
   begin
      if LENGTH (str) > v_len
      then
         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         dbms_outputPut_line (SUBSTR (str, len   + 1), v_len,expand_in);
      else
         v_str := str;
         DBMS_OUTPUT.put_line (v_str);
      end if;
   exception
      when OTHERS
      then
         if expand_in
         then
            DBMS_OUTPUT.ENABLE (1000000);
            DBMS_OUTPUTput_line (v_str);
         else
            raise;
         end if;
   end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function strToAsc ( strString varchar2 ) return varchar2 is
   res varchar2(30000);
  begin
    res := null;
    for i in 1..LENGTH( strString ) loop
      res :=  Xxmsz_Tools.merge(res, ASCII( SUBSTR(strString,i,1) ),',');
    end loop;
    return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function ascToStr ( ascString varchar2 ) return varchar2 is
   res varchar2(30000);
  begin
    res := null;
    for i in 1..Xxmsz_Tools.wordCount (AscString, ',') loop
      res :=  res || CHR( Xxmsz_Tools.extractWord(i, AscString, ',') );
    end loop;
    return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure setParameter ( userId varchar2, paramName varchar2, value varchar2 ) is
    pragma autonomous_transaction;
  begin
    EXECUTE immediate 'DELETE FROM XXMSZTOOLS_EVENTLOG WHERE module_name = ''parametersBuffer.'||userId||'.'||paramName||'''';
    insertIntoEventLog ( value, 'I', 'parametersBuffer'||'.'||userId||'.'||paramName);
    commit;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getParameter (userId varchar2, paramName varchar2) return varchar2 is
    pragma AUTONOMOUS_TRANSACTION;
    res   varchar2 (100);
  begin
    begin
     res := getSQLValue('SELECT message FROM XXMSZTOOLS_EVENTLOG WHERE module_name = ''parametersBuffer.'||userId||'.'||paramName||'''');
     EXECUTE immediate 'DELETE FROM XXMSZTOOLS_EVENTLOG WHERE module_name = ''parametersBuffer.'||userId||'.'||paramName||'''';
     commit;
    exception
     when NO_DATA_FOUND
     then
       res := null;
    end;
    return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function maximum(
     number1  number   , number2  number   , number3  number default null   , number4  number default null   , number5  number default null
   , number6  number default null   , number7  number default null   , number8  number default null   , number9  number default null   , number10 number default null
   , number11 number default null   , number12 number default null   , number13 number default null   , number14 number default null   , number15 number default null
   , number16 number default null   , number17 number default null   , number18 number default null   , number19 number default null   , number20 number default null
   , number21 number default null   , number22 number default null   , number23 number default null   , number24 number default null   , number25 number default null
   , number26 number default null   , number27 number default null   , number28 number default null   , number29 number default null   , number30 number default null
  ) return number is
    type  tnumbers is  table  of  number  index  by  binary_integer;
 numbers tnumbers;
 res     number;
 i       number;
        function singlemax ( n1 in out number, n2 in out number) return number is
     begin
      n1 := NVL( n1, -99999999999999999999999999999999999);
      n2 := NVL( n2, -99999999999999999999999999999999999);
      if n1 >= n2 then return n1;
                  else return n2; end if;
     end;
  begin
     numbers ( 1) := number1;     numbers ( 2) := number2;     numbers ( 3) := number3;     numbers ( 4) := number4;     numbers ( 5) := number5;
     numbers ( 6) := number6;     numbers ( 7) := number7;     numbers ( 8) := number8;     numbers ( 9) := number9;     numbers (10) := number10;
     numbers (11) := number11;    numbers (12) := number12;    numbers (13) := number13;    numbers (14) := number14;    numbers (15) := number15;
     numbers (16) := number16;    numbers (17) := number17;    numbers (18) := number18;    numbers (19) := number19;    numbers (20) := number20;
     numbers (21) := number21;    numbers (22) := number22;    numbers (23) := number23;    numbers (24) := number24;    numbers (25) := number25;
     numbers (26) := number26;    numbers (27) := number27;    numbers (28) := number28;    numbers (29) := number29;    numbers (30) := number30;

  res := -99999999999999999999999999999999999;
  for i in 1..30 loop
          if numbers (i) is null then exit; end if;
   res := singlemax ( res, numbers (i) );
  end loop;
    return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function MINIMUM(
     number1  number   , number2  number   , number3  number default  null   , number4  number default  null   , number5  number default  null
   , number6  number default  null   , number7  number default  null   , number8  number default  null   , number9  number default  null   , number10 number default  null
   , number11 number default  null   , number12 number default  null   , number13 number default  null   , number14 number default  null   , number15 number default  null
   , number16 number default  null   , number17 number default  null   , number18 number default  null   , number19 number default  null   , number20 number default  null
   , number21 number default  null   , number22 number default  null   , number23 number default  null   , number24 number default  null   , number25 number default  null
   , number26 number default  null   , number27 number default  null   , number28 number default  null   , number29 number default  null   , number30 number default  null
  ) return number is
    type  tnumbers is  table  of  number  index  by  binary_integer;
 numbers tnumbers;
 res     number;
 i       number;

        function singlemin ( n1 in out number, n2 in out number) return number is
     begin
      n1 := NVL( n1, 99999999999999999999999999999999999);
      n2 := NVL( n2, 99999999999999999999999999999999999);
      if n1 <= n2 then return n1;
                  else return n2; end if;
     end;
  begin
     numbers ( 1) := number1;     numbers ( 2) := number2;     numbers ( 3) := number3;     numbers ( 4) := number4;     numbers ( 5) := number5;
     numbers ( 6) := number6;     numbers ( 7) := number7;     numbers ( 8) := number8;     numbers ( 9) := number9;     numbers (10) := number10;
     numbers (11) := number11;    numbers (12) := number12;    numbers (13) := number13;    numbers (14) := number14;    numbers (15) := number15;
     numbers (16) := number16;    numbers (17) := number17;    numbers (18) := number18;    numbers (19) := number19;    numbers (20) := number20;
     numbers (21) := number21;    numbers (22) := number22;    numbers (23) := number23;    numbers (24) := number24;    numbers (25) := number25;
     numbers (26) := number26;    numbers (27) := number27;    numbers (28) := number28;    numbers (29) := number29;    numbers (30) := number30;

  res := 99999999999999999999999999999999999;
  for i in 1..30 loop
          if numbers (i) is null then exit; end if;
   res := singlemin ( res, numbers (i) );
  end loop;
    return res;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function bin2dec (binval in char) return number is
    i                 number;
    digits            number;
    result            number := 0;
    current_digit     char(1);
    current_digit_dec number;
  begin
    digits := LENGTH(binval);
    for i in 1..digits loop
       current_digit := SUBSTR(binval, i, 1);
       current_digit_dec := TO_NUMBER(current_digit);
       result := (result * 2) + current_digit_dec;
    end loop;
    return result;
  end bin2dec;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function dec2bin (N in number) return varchar2 is
    binval varchar2(64);
    N2     number := N;
  begin
    while ( N2 > 0 ) loop
       binval := MOD(N2, 2) || binval;
       N2 := TRUNC( N2 / 2 );
    end loop;
    return binval;
  end dec2bin;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function oct2dec (octval in char) return number is
    i                 number;
    digits            number;
    result            number := 0;
    current_digit     char(1);
    current_digit_dec number;
  begin
    digits := LENGTH(octval);
    for i in 1..digits loop
       current_digit := SUBSTR(octval, i, 1);
       current_digit_dec := TO_NUMBER(current_digit);
       result := (result * 8) + current_digit_dec;
    end loop;
    return result;
  end oct2dec;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function dec2oct (N in number) return varchar2 is
    octval varchar2(64);
    N2     number := N;
  begin
    while ( N2 > 0 ) loop
       octval := MOD(N2, 8) || octval;
       N2 := TRUNC( N2 / 8 );
    end loop;
    return octval;
  end dec2oct;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function hex2dec (hexval in char) return number is
    i                 number;
    digits            number;
    result            number := 0;
    current_digit     char(1);
    current_digit_dec number;
  begin
    digits := LENGTH(hexval);
    for i in 1..digits loop
       current_digit := SUBSTR(hexval, i, 1);
       if current_digit in ('A','B','C','D','E','F') then
          current_digit_dec := ASCII(current_digit) - ASCII('A') + 10;
       else
          current_digit_dec := TO_NUMBER(current_digit);
       end if;
       result := (result * 16) + current_digit_dec;
    end loop;
    return result;
  end hex2dec;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function dec2hex (N in number) return varchar2 is
    hexval varchar2(64);
    N2     number := N;
    digit  number;
    hexdigit  char;
  begin
    while ( N2 > 0 ) loop
       digit := MOD(N2, 16);
       if digit > 9 then
          hexdigit := CHR(ASCII('A') + digit - 10);
       else
          hexdigit := TO_CHAR(digit);
       end if;
       hexval := hexdigit || hexval;
       N2 := TRUNC( N2 / 16 );
    end loop;
    return hexval;
end dec2hex;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function isLeapYear(i_year number) return boolean as
  begin
    -- A year is a leap year if it is evenly divisible by 4
    -- but not if it's evenly divisible by 100
    -- unless it's also evenly divisible by 400
  
     if MOD(i_year, 400) = 0 or ( MOD(i_year, 4) = 0 and MOD(i_year, 100) != 0) then
        return true;
     else
        return false;
     end if;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function has_common_part(
     pa1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pa2 date default to_date('4000-12-31','yyyy-mm-dd') 
   , pb1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pb2 date default to_date('4000-12-31','yyyy-mm-dd')
   ) return varchar2 is
       a1 date;
       a2 date;
       b1 date;
       b2 date;
  begin
    a1 := nvl(pa1, to_date('1000-01-01','yyyy-mm-dd')); 
    a2 := nvl(pa2, to_date('4000-12-31','yyyy-mm-dd')); 
    b1 := nvl(pb1, to_date('1000-01-01','yyyy-mm-dd')); 
    b2 := nvl(pb2, to_date('4000-12-31','yyyy-mm-dd'));     
    --insertintoeventlog('a1='||a1||' a2='|| a2 ||' b1='|| b1 ||' b2='|| b2, 'I', 'has_common_part');
  
    -- Okres czasowy (A1,A2) ma czÍúÊ wspÛlnπ z okresem czasowym (B1,B2), gdy spe≥niony jest nastÍpujπcy warunek logiczny:  
    if  (A1 >= B1 or A2 >= B1) and (A1 <= B2 or A2 <= B2)  then
      return 'Y';
    else
      return 'N';
    end if; 
  end;


 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  /*   
  PorÛwnuje okres A1-A2 z okresem B1-B2
                      A1      A2
                      |=========|  
                      |         |
                  B1==|=========|==B2               INSIDES                  
                      |  =====  |                   IS_INSIDE
                      |    =====|                   IS_INSIDE_RJUSTIFY
                      |=====    |                   IS_INSIDE_LJUSTIFY
                      |         |
      ========        |         |                   IS_BEFORE_GAP
              ========|         |                   IS_BEFORE_NO_GAP
                ======|===      |                   IS_BEFORE_COMMON_PART
                      |=========|                   THE_SAME   
                      |      ===|======             IS_AFTER_COMMON_PART
                      |         |========           IS_AFTER_NO_GAP
                      |         |       ========    IS_AFTER_GAP
                                                    BAD_PERIOD_A
                                                    BAD_PERIOD_B
  */
  function compare_periods(
     pa1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pa2 date default to_date('4000-12-31','yyyy-mm-dd') 
   , pb1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pb2 date default to_date('4000-12-31','yyyy-mm-dd')
   ) return varchar2 is
     a1 date;
     a2 date;
     b1 date;
     b2 date;
  begin
    a1 := nvl(pa1, to_date('1000-01-01','yyyy-mm-dd')); 
    a2 := nvl(pa2, to_date('4000-12-31','yyyy-mm-dd')); 
    b1 := nvl(pb1, to_date('1000-01-01','yyyy-mm-dd')); 
    b2 := nvl(pb2, to_date('4000-12-31','yyyy-mm-dd'));     
    --insertintoeventlog('a1='||a1||' a2='|| a2 ||' b1='|| b1 ||' b2='|| b2, 'I', 'compare_periods');
    
    if a1 > a2             then return 'BAD_PERIOD_A'           ; end if;
    if b1 > b2             then return 'BAD_PERIOD_B'           ; end if;

    if b1 < a1 and b2 > a2 then return 'INSIDES'                ; end if;
    if b1 > a1 and b2 < a2 then return 'IS_INSIDE'              ; end if;

    if b1 > a1 and b2 = a2 then return 'IS_INSIDE_RJUSTIFY'     ; end if;
    if b1 = a1 and b2 < a2 then return 'IS_INSIDE_LJUSTIFY'     ; end if;
    
    if b1 < a1 and b2 < a1 then return 'IS_BEFORE_GAP'          ; end if;
    if b1 < a1 and b2 = a1 then return 'IS_BEFORE_NO_GAP'       ; end if;
    if b1 < a1 and b2 > a1 then return 'IS_BEFORE_COMMON_PART'  ; end if;
    if b1 = a1 and b2 = a2 then return 'THE_SAME'               ; end if;
    if b1 < a2 and b2 > a2 then return 'IS_AFTER_COMMON_PART'   ; end if;
    if b1 = a2 and b2 > a2 then return 'IS_AFTER_NO_GAP'        ; end if;
    if b1 > a2 and b2 > a2 then return 'IS_AFTER_GAP'           ; end if;    
  end;

   

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function encrypt (i_password varchar2) return varchar2 is
    v_encrypted_val varchar2(38);
    v_data          varchar2(38);
  begin
     -- Input data must have a length divisible by eight
     v_data := RPAD(i_password,(TRUNC(LENGTH(i_password)/8)+1)*8,CHR(0));

     DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(
        input_string     => v_data,
        key_string       => c_encrypt_key,
        encrypted_string => v_encrypted_val);
     return v_encrypted_val;
  end encrypt;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function decrypt (i_password varchar2) return varchar2 is
    v_decrypted_val varchar2(38);
  begin
     DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(
        input_string     => i_password,
        key_string       => c_encrypt_key,
        decrypted_string => v_decrypted_val);
     return v_decrypted_val;
  end decrypt;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getPeriodID(backlogInDays number, periodInterval number, maxBacklog number default -1000, maxBacklogText varchar2 default 'Pozosta≥e', FutureText varchar2  default 'Bieøπce' ) return number is
  begin
   if backlogInDays >= 0             then return           0; end if;
   if backlogInDays < maxBacklog then return -9999999999; end if;
   return trunc((backlogInDays+1) /periodInterval)  -1;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getPeriodName(backlogInDays number, periodInterval number, maxBacklog number default -1000, maxBacklogText varchar2 default 'Pozosta≥e', FutureText varchar2  default 'Bieøπce' ) return varchar2 is
    absPeriodID number;
  begin
   if backlogInDays >= 0             then return FutureText; end if;
   if backlogInDays < maxBacklog then return maxBacklogText; end if;
   absPeriodID := abs ( getPeriodID(backlogInDays, periodInterval, maxBacklog, maxBacklogText, FutureText));

   return (absPeriodID * periodInterval) || '-' || (absPeriodID * periodInterval -  periodInterval + 1);
  end;


/*
n>=0 => biezace , 0
n<-1000 => zalegle, -9999

select trunc((-6+1) /5)  -1, abs(trunc((-6+1) /5)  -1)*5 || '-' || (abs(trunc((-6+1) /5)  -1)*5 -4)
  from dual
*/

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function long2varchar( p_query  in varchar2,
                             p_name1   in varchar2 default null,
                             p_value1  in varchar2  default null,
                             p_name2   in varchar2 default null,
                             p_value2  in varchar2  default null,
                             p_name3   in varchar2 default null,
                             p_value3  in varchar2  default null,
                             p_name4   in varchar2 default null,
                             p_value4  in varchar2  default null
                            ) return varchar2
  as
      l_cursor    integer default dbms_sql.open_cursor;
      l_n         number;
      l_long_val  varchar2(250);
      l_long_len  number;
      l_buflen    number := 250;
      l_curpos    number := 0;
      l_out       varchar2(32000) := '';
  begin
      dbms_sql.parse( l_cursor, p_query, dbms_sql.native );
      if p_name1 is not null then  dbms_sql.bind_variable( l_cursor, p_name1, p_value1 );   end if;
      if p_name2 is not null then  dbms_sql.bind_variable( l_cursor, p_name2, p_value2 );   end if;
      if p_name3 is not null then  dbms_sql.bind_variable( l_cursor, p_name3, p_value3 );   end if;
      if p_name4 is not null then  dbms_sql.bind_variable( l_cursor, p_name4, p_value4 );   end if;
      dbms_sql.define_column_long(l_cursor, 1);
      l_n := dbms_sql.execute(l_cursor);
      if (dbms_sql.fetch_rows(l_cursor) > 0)
      then
          loop
              dbms_sql.column_value_long(l_cursor, 1, l_buflen,
                                         l_curpos , l_long_val,
                                         l_long_len );
              l_curpos := l_curpos + l_long_len;
              --dbms_output.put_line( l_long_val );
              if length(l_out || l_long_val) < 4000 then
                l_out := l_out || l_long_val;
              else
                l_out := substr(l_out || l_long_val,1,4000);
                exit;
              end if;
              exit when l_long_len = 0;
        end loop;
     end if;
     --dbms_output.put_line( '====================' );
     --dbms_output.put_line( 'Long was ' || l_curpos || ' bytes in length' );
     dbms_sql.close_cursor(l_cursor);
     return substr(l_out,1,4000);
  exception
     when others then
        if dbms_sql.is_open(l_cursor) then
           dbms_sql.close_cursor(l_cursor);
        end if;
        raise;
  end;
  
   /*
   commented due to ensure platform-independent form of this package
   procedure insertIntoEventLog
    ( itemtype  in     varchar2
    , itemkey   in     varchar2
    , actid     in     number
    , funcmode  in     varchar2
    , result    out    varchar2) is
      messageText varchar2(100);
   begin
     messageText := wf_engine.GetActivityAttrText(itemtype, itemkey, actid, 'MESSAGE');
     xxmsz_tools.insertIntoEventLog( messageText );
     result :=  'COMPLETE:';
  
   exception
     when others then
        wf_core.context('ITEM_TYPE_HERE', 'xxmsz_tools.insertIntoEventLog', itemtype, itemkey, 'sqlerrm=' || sqlerrm);
        raise;
   end;
   */

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure addHeader (ptableDef in out nocopy tTableDef, ptableRow varchar2, pcolWidths varchar2 default null, palligns varchar2 default null, ptokenSeparator varchar2 default '|') is
   colWidth number;
   colAllign varchar2(30);
   
  begin
   ptableDef.tokenSeparator := ptokenSeparator;
   ptableDef.ColumnCount := xxmsz_tools.wordCount(ptableRow, ptableDef.tokenSeparator);
   
   --if pcolWidths is not null then
     for t in 1..ptableDef.ColumnCount loop
       colWidth := nvl( to_number ( xxmsz_tools.extractWord(t, pcolWidths, ptableDef.tokenSeparator) ) , 0 );
       ptableDef.tableWidths (t).width := colWidth;
       if colWidth > 0 then
         ptableDef.tableWidths (t).autowidth := 'N';
       else
         ptableDef.tableWidths (t).autowidth := 'Y';        
       end if;      
     end loop;  
   --end if;
 
   for t in 1..ptableDef.ColumnCount loop
     if ptableDef.tableWidths(t).autowidth = 'Y' then
       ptableDef.tableWidths (t).width := greatest ( ptableDef.tableWidths(t).width , length ( xxmsz_tools.extractWord(t, ptableRow, ptableDef.tokenSeparator) ) );      
     end if;
     ptableDef.tableWidths (t).allign := 'left';
   end loop; 
   
   if palligns is not null then
     for t in 1..ptableDef.ColumnCount loop
       colAllign := xxmsz_tools.extractWord(t, palligns, ptableDef.tokenSeparator);
       if colAllign is not null then
         if lower(colAllign) not in ('left','right','middle') then raise_application_error (-20000, 'invalid value of colAllign'); end if;
         ptableDef.tableWidths (t).allign := colAllign;
       end if;
     end loop;  
   end if;
 
 
   ptableDef.tableRows( ptableDef.tableRows.count ) := ptableRow;
  end;
 
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
   procedure addLine   (pTableDef in out nocopy tTableDef, ptableRow varchar2) is
   begin
    ptableDef.ColumnCount := xxmsz_tools.wordCount(ptableRow, ptableDef.tokenSeparator);
    
    for t in 1..ptableDef.ColumnCount loop
      if ptableDef.tableWidths(t).autowidth = 'Y' then
        ptableDef.tableWidths (t).width := greatest ( ptableDef.tableWidths(t).width , nvl( length ( xxmsz_tools.extractWord(t, ptableRow, ptableDef.tokenSeparator) ), 0) );
      end if;
    end loop; 
    
    ptableDef.tableRows( ptableDef.tableRows.count ) := ptableRow;
   exception
    when no_Data_found then
      raise_application_error(-20000, 'Character | is not allowed as a value');
    when others then
      raise_application_error(-20000, 'AddLine. sqlerrm=' || sqlerrm);      
   end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
   procedure showTable (ptableDef in out nocopy xxmsz_tools.tTableDef) is
      WordWrap xxmsz_tools.tWordWrap;
      TableLine varchar2 (1000);
      tableRow  varchar2 (1000);
      --+----------------------+----------------------+-------------------+---------------+ tableLine
      --|                      |                      |                   |               | tableRow
      allign number;
      procedure wout (m varchar2) is
      begin
        xxmsz_tools.dbms_outputPut_line ( m );
      end;    
      procedure insertLines ( WordWrap in out xxmsz_tools.tWordWrap ) is
        i number;
      begin
        if WordWrap.errorMessage is not null then xxmsz_tools.dbms_outputPut_line (WordWrap.errorMessage); end if;
        for i in 1..xxmsz_tools.wordWrapGetNumberOfLines(WordWrap) loop
          wout ( xxmsz_tools.wordWrapGetLine(WordWrap,i) );
        end loop;
      end;
    begin
      TableLine := null;
      for t in 1..ptableDef.ColumnCount loop
        TableLine := TableLine || '+' || lpad('-', ptableDef.tableWidths (t).width , '-');
      end loop; 
      TableLine := TableLine || '+';
      
      tableRow := null;
      for t in 1..ptableDef.ColumnCount loop
        tableRow := tableRow || '|' || lpad( chr(t+65), ptableDef.tableWidths (t).width , chr(t+65));
      end loop; 
      tableRow := tableRow || '|';    
  
      wout(TableLine);      
      for c in 0..ptableDef.tableRows.count-1 loop
        xxmsz_tools.wordWrapInit (WordWrap,tableRow);
        for t in 1..ptableDef.ColumnCount loop
          select decode ( lower(ptableDef.tableWidths (t).allign), 'right', xxmsz_tools.right, 'left', xxmsz_tools.left, xxmsz_tools.middle) into allign from dual;              
          xxmsz_tools.wordWrapPrepareColumn(WordWrap
             , xxmsz_tools.extractWord(t, ptableDef.tableRows(c), ptableDef.tokenSeparator)
             , lpad( chr(t+65), ptableDef.tableWidths (t).width , chr(t+65)) 
             , allign );
        end loop; 
        insertLines ( WordWrap );
        if c = 0 then wout(TableLine); end if;
      end loop;        
      wout(TableLine);  
    end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
   procedure destroy (ptableDef in out nocopy tTableDef) is
   begin
    ptableDef.tableWidths.delete;
    ptableDef.tableRows.delete;
    ptableDef.ColumnCount := 0;
   end; 
  
   -- by http://oracle.anilpassi.com
   function emailIsOk ( EMAIL  varchar2 ) return  varchar2 is
    l_dot_pos    number;
    l_at_pos     number;
    l_str_length number;
   begin
    l_dot_pos    := instr(email
                         ,'.');
    l_at_pos     := instr(email
                         ,'@');
    l_str_length := length(email);
    if ((l_dot_pos = 0) or (l_at_pos = 0) or (l_dot_pos = l_at_pos + 1) or
       (l_at_pos = 1) or (l_at_pos = l_str_length) or
       (l_dot_pos = l_str_length))
    then
      return 'N';
    end if;
    if instr(substr(email
                   ,l_at_pos)
            ,'.') = 0
    then
      return 'N';
    end if;
    return 'Y';
   end;
   

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function extnvl (
   v1 varchar2,v2 varchar2,v3 varchar2 default null,v4 varchar2 default null,v5 varchar2 default null
  ,v6 varchar2 default null,v7 varchar2 default null,v8 varchar2 default null,v9 varchar2 default null,v10 varchar2 default null
  ,v11 varchar2 default null,v12 varchar2 default null,v13 varchar2 default null,v14 varchar2 default null,v15 varchar2 default null
  ,v16 varchar2 default null,v17 varchar2 default null,v18 varchar2 default null,v19 varchar2 default null,v20 varchar2 default null
  ) return varchar2
  is 
  begin
   return 
     nvl( v1, nvl(v2, nvl(v3, nvl(v4, nvl(v5, nvl(v6, nvl(v7, nvl(v8, nvl(v9, nvl(v10, nvl(v11, nvl(v12, nvl(v13, nvl(v14, nvl(v15, nvl(v16, nvl(v17, nvl(v18, nvl(v19, v20)))))))))))))))))));
  end;    
   
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function extnvl (
   v1 number,v2 number,v3 number default null,v4 number default null,v5 number default null
  ,v6 number default null,v7 number default null,v8 number default null,v9 number default null,v10 number default null
  ,v11 number default null,v12 number default null,v13 number default null,v14 number default null,v15 number default null
  ,v16 number default null,v17 number default null,v18 number default null,v19 number default null,v20 number default null
  ) return number   
  is 
  begin
   return 
     nvl( v1, nvl(v2, nvl(v3, nvl(v4, nvl(v5, nvl(v6, nvl(v7, nvl(v8, nvl(v9, nvl(v10, nvl(v11, nvl(v12, nvl(v13, nvl(v14, nvl(v15, nvl(v16, nvl(v17, nvl(v18, nvl(v19, v20)))))))))))))))))));
  end;    

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function extnvl (
   v1 date,v2 date,v3 date default null,v4 date default null,v5 date default null
  ,v6 date default null,v7 date default null,v8 date default null,v9 date default null,v10 date default null
  ,v11 date default null,v12 date default null,v13 date default null,v14 date default null,v15 date default null
  ,v16 date default null,v17 date default null,v18 date default null,v19 date default null,v20 date default null
  ) return date   
  is 
  begin
   return 
     nvl( v1, nvl(v2, nvl(v3, nvl(v4, nvl(v5, nvl(v6, nvl(v7, nvl(v8, nvl(v9, nvl(v10, nvl(v11, nvl(v12, nvl(v13, nvl(v14, nvl(v15, nvl(v16, nvl(v17, nvl(v18, nvl(v19, v20)))))))))))))))))));
  end;    


 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function startOfTime return date is
  begin
   return c_start_of_time;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function endOfTime return date is
  begin
   return c_end_of_time;
  end;
 
 -------------------------------------------------------------------------
 --zmienia niedozwolone znaki XML na kody
 --wiÍcej na ten temat w Wikipedii i http://www.kurshtml.boo.pl/generatory/unicode.html
 function replaceXMLchars (buffer in varchar2) return varchar2 is
 begin
   return replace(replace(replace(replace(replace(buffer , '&', '&'||'amp;'), '>', '&'||'gt;'), '<', '&'||'lt;'), '''', '&'||'apos;'), '"', '&'||'quot;');
 end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function erasePolishHooks(S varchar2) return varchar2 is
  begin
    return erasePolishChars(s);
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function allTableColumns (pTableName varchar2, pColumNameFilter varchar2 default '%') return varchar2 is
   vOwner     varchar2(255);
   vTableName varchar2(255); 
   res        varchar2(32000);
  begin
    if xxmsz_tools.wordCount(pTableName,'.') = 1 then
      vTableName := pTableName;
      select owner into vOwner from all_tables where table_name = pTableName and rownum = 1;        
    else
      vOwner     := xxmsz_tools.extractWord(1,pTableName,'.');
      vTableName := xxmsz_tools.extractWord(2,pTableName,'.');
    end if;
    
    res := '''|''';
    
    for rec in (select case 
                        when data_type = 'VARCHAR2' then column_name  
                        when data_type = 'NUMBER'   then 'to_char('||column_name||')'
                        when data_type= 'DATE'     then 'to_char('||column_name||')'
                        --when data_type= 'LONG'     then 'to_char('||column_name||')'
                        --when data_type= 'XMLTYPE'  then 'to_char('||column_name||')'
                        when data_type= 'TIMESTAMP(6)'  then 'to_char('||column_name||')'
                        when data_type= 'TIMESTAMP(9)'  then 'to_char('||column_name||')'
                        --when data_type= 'CLOB'  then 'to_char('||column_name||')'
                        when data_type= 'CHAR'  then column_name
                       end column_name 
                 from all_tab_cols 
                where owner = vOwner 
                  and table_name = vTableName
                  and column_name like pColumNameFilter
                  and virtual_column = 'NO'
                order by column_id )
    loop
      res := xxmsz_tools.merge(res, rec.column_name, '||''|''||');
    end loop;            
    return res;
  end;
  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure delete_not_used_records ( pTable_name varchar2 ) is 
  begin
    execute immediate 
     'begin '||
     ' for rec in (select rowid from '||pTable_name||' ) '||
     ' loop '||
     '   begin '||
     '     delete from '||pTable_name||' where rowid = rec.rowid; '||
     '   exception '||
     '    when others then null; '||
     '   end; '|| 
     ' end loop; '||
     'end;';  
  end;
  
  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function get_primary_key( p_owner varchar2, p_table_name varchar2 ) return varchar2 is
    --
    v_pk_name    varchar2(30);
    v_pk_columns varchar2(2000);
    --
  begin
    --
    select constraint_name
      into v_pk_name
      from all_constraints
     where owner = p_owner
       and table_name = p_table_name
       and constraint_type = 'P';
    --
    for c_rec in (select column_name from all_cons_columns where constraint_name = v_pk_name and owner = p_owner and table_name = p_table_name order by position) loop
      v_pk_columns := v_pk_columns||c_rec.column_name||',';
    end loop;
    --
    return trim(',' from v_pk_columns);
    --
  end get_primary_key;


 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_records(pOwner varchar2, pTable_Name varchar2, pOldId varchar2, pNewId varchar2, pkColumn varchar2) is
    cntOldId number;
    cntNewId number;    
  begin
    execute immediate 'select count(*) from '||pOwner||'.'||pTable_Name||' where '||pkColumn||' = :pOldId' into cntOldId using pOldId;
    execute immediate 'select count(*) from '||pOwner||'.'||pTable_Name||' where '||pkColumn||' = :pOldId' into cntNewId using pNewId;
    if cntOldId <> 1 then raise_application_error(-20000, 'Error. '||cntOldId||' old records found'); end if;  
    if cntNewId <> 1 then raise_application_error(-20000, 'Error. '||cntNewId||' new records found for "'||pNewId||'"'); end if;

    for rec in 
    (
      SELECT   U.NAME detail_owner
             , O.NAME detail_table
               , trim ( ';' from
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 4) ) 
                  detail_cols
               , trim ( ';' from 
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 4) ) 
                 master_cols
            FROM   SYS.CDEF$ C, SYS.CON$ CN, SYS.OBJ$ O, SYS.USER$ U,
                   SYS.CON$ RC, SYS.USER$ RU, SYS.OBJ$ RO
            WHERE  C.CON# = CN.CON#
            AND    C.OBJ# = O.OBJ#
            AND    O.OWNER# = U.USER#
            AND    C.RCON# = RC.CON#(+)
            AND    RC.OWNER# = RU.USER#(+)
            AND    C.ROBJ# = RO.OBJ#(+)
            and c.type# = 4 -- = Referential Integrity
            --
            AND  ro.name  = pTable_Name
            and  ru.name  = pOwner --master_owner 
    )
    loop
      if rec.detail_cols like '%;%' then raise_application_error(-20000, 'Error. Multicolumn joins are not supprted yet'); end if;
      if rec.master_cols <> pkColumn then raise_application_error(-20000, 'Error. Bad PK column '||pkColumn||' Should be ' || rec.master_cols ); end if;
      execute immediate 'update '||rec.detail_owner||'.'||rec.detail_table||' set '||rec.detail_cols||' = :pNewId where '||rec.detail_cols||' = :pOldId'
        using pNewId, pOldId;
    end loop;
    execute immediate 'delete from  '||pOwner||'.'||pTable_Name||' where '||pkColumn||' = :pOldId' using pOldId;
  end;
 
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure disable_constraints(pOwner varchar2, pTable_Name varchar2, pkColumn varchar2) is
  begin
    for rec in 
    (
      SELECT   U.NAME detail_owner, O.NAME detail_table
               , trim ( ';' from
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 4) ) 
                  detail_cols
               , trim ( ';' from 
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 4) ) 
                 master_cols
              , cn.name   cname
            FROM   SYS.CDEF$ C, SYS.CON$ CN, SYS.OBJ$ O, SYS.USER$ U,
                   SYS.CON$ RC, SYS.USER$ RU, SYS.OBJ$ RO
            WHERE  C.CON# = CN.CON#
            AND    C.OBJ# = O.OBJ#
            AND    O.OWNER# = U.USER#
            AND    C.RCON# = RC.CON#(+)
            AND    RC.OWNER# = RU.USER#(+)
            AND    C.ROBJ# = RO.OBJ#(+)
            and c.type# = 4 -- = Referential Integrity
            --
            AND  ro.name  = pTable_Name
            and  ru.name  = pOwner --master_owner 
    )
    loop
      if rec.detail_cols like '%;%' then raise_application_error(-20000, 'Error. Multicolumn joins are not supprted yet'); end if;
      if rec.master_cols <> pkColumn then raise_application_error(-20000, 'Error. Bad PK column '||pkColumn||' Should be ' || rec.master_cols ); end if;
      execute immediate 'ALTER TABLE '||rec.detail_owner||'.'||rec.detail_table||' DISABLE CONSTRAINT  '||rec.cname;
    end loop;
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure enable_constraints(pOwner varchar2, pTable_Name varchar2, pkColumn varchar2) is
  begin
    for rec in 
    (
      SELECT   U.NAME detail_owner, O.NAME detail_table
               , trim ( ';' from
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 4) ) 
                  detail_cols
               , trim ( ';' from 
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 4) ) 
                 master_cols
              , cn.name   cname
            FROM   SYS.CDEF$ C, SYS.CON$ CN, SYS.OBJ$ O, SYS.USER$ U,
                   SYS.CON$ RC, SYS.USER$ RU, SYS.OBJ$ RO
            WHERE  C.CON# = CN.CON#
            AND    C.OBJ# = O.OBJ#
            AND    O.OWNER# = U.USER#
            AND    C.RCON# = RC.CON#(+)
            AND    RC.OWNER# = RU.USER#(+)
            AND    C.ROBJ# = RO.OBJ#(+)
            and c.type# = 4 -- = Referential Integrity
            --
            AND  ro.name  = pTable_Name
            and  ru.name  = pOwner --master_owner 
    )
    loop
      execute immediate 'ALTER TABLE '||rec.detail_owner||'.'||rec.detail_table||' ENABLE CONSTRAINT  '||rec.cname;
    end loop;
  end;
 
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_record(pOwner varchar2, pTable_Name varchar2, pOldId varchar2, pNewId varchar2, pkColumn varchar2) is
    cntOldId number;
    cntNewId number;    
  begin
    execute immediate 'select count(*) from '||pOwner||'.'||pTable_Name||' where '||pkColumn||' = :pOldId' into cntOldId using pOldId;
    execute immediate 'select count(*) from '||pOwner||'.'||pTable_Name||' where '||pkColumn||' = :pOldId' into cntNewId using pNewId;
    if cntOldId <> 1 then raise_application_error(-20000, 'Error. '||cntOldId||' old records found'); end if;  
    if cntNewId <> 0 then raise_application_error(-20000, 'Error. '||cntNewId||' new records found'); end if;

    for rec in 
    (
      SELECT   U.NAME detail_owner, O.NAME detail_table
               , trim ( ';' from
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=u.name) and (constraint_name=cn.name) and position = 4) ) 
                  detail_cols
               , trim ( ';' from 
                 (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 1) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 2) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 3) 
               ||';'|| (Select column_name from  sys.ALL_CONS_COLUMNS where (owner=ru.name) and (constraint_name=rc.name) and position = 4) ) 
                 master_cols
              , cn.name   cname
            FROM   SYS.CDEF$ C, SYS.CON$ CN, SYS.OBJ$ O, SYS.USER$ U,
                   SYS.CON$ RC, SYS.USER$ RU, SYS.OBJ$ RO
            WHERE  C.CON# = CN.CON#
            AND    C.OBJ# = O.OBJ#
            AND    O.OWNER# = U.USER#
            AND    C.RCON# = RC.CON#(+)
            AND    RC.OWNER# = RU.USER#(+)
            AND    C.ROBJ# = RO.OBJ#(+)
            and c.type# = 4 -- = Referential Integrity
            --
            AND  ro.name  = pTable_Name
            and  ru.name  = pOwner --master_owner 
    )
    loop
      if rec.detail_cols like '%;%' then raise_application_error(-20000, 'Error. Multicolumn joins are not supprted yet'); end if;
      if rec.master_cols <> pkColumn then raise_application_error(-20000, 'Error. Bad PK column '||pkColumn||' Should be ' || rec.master_cols ); end if;
      execute immediate 'ALTER TABLE '||rec.detail_owner||'.'||rec.detail_table||' DISABLE CONSTRAINT  '||rec.cname;
      execute immediate 'update '||rec.detail_owner||'.'||rec.detail_table||' set '||rec.detail_cols||' = :pNewId where '||rec.detail_cols||' = :pOldId'
        using pNewId, pOldId;
    end loop;

    execute immediate 'update  '||pOwner||'.'||pTable_Name||' set '||pkColumn||' = :pNewId where '||pkColumn||' = :pOldId'  using pNewId, pOldId;
    
    enable_constraints(pOwner , pTable_Name , pkColumn );
  end;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  Procedure NewClob  (clobloc       in out nocopy clob,
                      msg_string    in varchar2) is
   pos integer;
   amt number;
  begin
  -- make clob temporary. this may impact the speed of the UI
  -- such that user has to wait to see the notification.
  -- To improve performance make sure buffer cache is well tuned.
     dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);
     if msg_string is not null then
        pos := 1;
        amt := length(msg_string);
        dbms_lob.write(clobloc,amt,pos,msg_string);
     end if;
  end NewClob;    
    
 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is
   pos integer;
   amt number;
  begin    
     pos :=   dbms_lob.getlength(clob_loc) +1;
     amt := length(msg_string);
     dbms_lob.write(clob_loc,amt,pos,msg_string);    
  end WriteToClob;

 ---------------------------------------------------------------------------------------------------------------------------------------------------------
  function getAbbreviation ( s varchar2 ) return varchar2 is
  begin
    return REPLACE(translate(upper( erasePolishChars(s) ),'AEIOUY ','@@@@@@@@@@@@@@@@@@@@'),'@','');
  end; 
  
  
end;
/

CREATE OR REPLACE package planner_utils is

   /*****************************************************************************************************************************
   |* toolkit
   |*****************************************************************************************************************************
   | Maciej Szymczak
   | 2004.11.21 usuniecie problemu zwiazanego z nie dodawaniem rezerwacji dla sali
   | 2005.04.19 dodanie funkcji get_class_coeffficient
   | 2005.05.15 rozwiazanie problemu zwiazanego z konwersja number -> string (,.)
   | 2007.05.05 zmiany, wersja 3.4
   | 2010.03.14 flexs
   | 2010.11.01 copy_data - bugfix   
   | 2012.03.17 periods.locked_flag   
   | 2012.06.17 update_lgr, copy_data - changes ( user sorting demand)   
   | 2012.06.18 insert_classes - changes ( desc1..desc4)   
   | 2013.03.06 track history - changes  
   | 2013.11.03 bugfixing  
   \*-----------------------------------------------------------------------------------------------------------------------------*/

  exc_API_ver_error    number := -20000; --API version error
  exc_wrong_owner_name number := -20001; --Wrong owner name
  exc_lecgrorom_null   number := -20002; --Class without lecturer and group and resource
   
  classes_selected_count number := -1;

  -- output parameters do not work in BDE: Ora-6502 String buffer is to small; no return value is passed
  -- I use this workaround   
  output_param_char1 varchar2(1000);
  output_param_char2 varchar2(1000);
  output_param_char3 varchar2(1000);
  output_param_num1  number; 
  output_param_num2  number;
  output_param_num3  number;
  output_param_num4  number;
  output_param_num5  number;
  output_param_num6  number;
  output_param_num7  number;
  output_param_num8  number;
  output_param_num9  number;
  output_param_num10 number;

   
  -- parametry diagnostyczne dla procedury
  last_error             varchar2(1000);
  last_cnt               number;
  last_orguni_id         number;
  last_lec_id            number;
  last_for_id            number;

  last_ffid              number;
  last_formula           varchar2(1000);
  last_horus             number;
  last_number_of_peoples number;

  procedure enable_trial;
  procedure disable_trial;

  procedure insert_classes(pday            date
                         ,phour           number
                         ,pfill           number
                         ,psub_id         number
                         ,pfor_id         number
                         ,powner          varchar2 default null
                         ,pcalc_lec_ids   varchar2
                         ,pcalc_gro_ids   varchar2
                         ,pcalc_rom_ids   varchar2
                         ,pcolour         number   default null
                         ,pdesc1          varchar2 default null
                         ,pdesc2          varchar2 default null
                         ,pdesc3          varchar2 default null
                         ,pdesc4          varchar2 default null
                         ,ptt_comb_ids    varchar2 default null
                         ,pcalc_lecturers varchar2 default null
                         ,pcalc_groups    varchar2 default null
                         ,pcalc_rooms     varchar2 default null
                         -- prefreshLGR ustaw na wartosc 'N' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) zawieraja dobre wartosci
                         -- prefreshLGR ustaw na wartosc 'Y' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) nie zawieraja dobrych wartosci
                         --   uwaga: identyfikatory musisz podawac zawsze (pcalc_lec_ids, pcalc_gro_ids, pcalc_rom_ids)
                         ,pcreator          varchar2 default null
                         ,prefreshLGR       varchar2 default 'Y'
                         ,pgrantPermissions varchar2 default 'N'
                          --used by public api. it is assumed external system keeps by himself grants (its grants may differ from grants of planner) and thus "knows" who is allowed to modify database
                         ,pcalc_rescat_ids  varchar2 default null
                        );

  procedure update_lgrs;

  /* procedure deletes the class of given id
     arguments:
       pid            class id (=classes.id) 
     remarks:
       this procedure deletes class from database (grants to lecturer, group, resource, subject and form are not deleted. Creator in table planners is not deleted as well).
       THIS PROCEDURE DOES NOT CHECK WHETHER CURRENT USER HAS PERMISSIONS TO DO IT, IT IS A RESPONSIBILITY OF A SYSTEM WHICH USES THIS API.
         justification: 
           External system functionality can differ from planner desktop functionality.
           For example, planner desktop allows changes to owner only (owner is a planner - employee,internal user ).
           In opossite, external system can allow changes to creator rather than to owner (creator may NOT be a planner, it can be any external user for example a lecturer or a student).
           Usually the scenerio of plannig is:
            1. First, external users plans its classes
            2. Next,  external users are disallowed to change data
            3. Next,  planner (insernal user) reviews plans, assigns rooms were missing and so on.            
           It is important to implement appropriate safety rules on external system side, including period of time when external user are allowed to modifi data.
     results:
         Function returs no result. Any errors are reported by exception
  */        
  procedure delete_class ( pid number ); 

  /*
   funkcja zwraca wartoúÊ wspÛ≥czynnika dla zajÍcia wyliczonego za pomoca odnalezionej formu≥y.
   funkcja zwraca zero, jezeli wystapi b≥πd.
   algotytm wyznaczania formu≥y:
   dla kaødego wyk≥adowcy:
     pobierz formu≥Í na dzieÒ i wylicz wartosc formuly. podstaw liczba studentÛw = liczba wszystkich studentÛw spoúrÛd grup w zajÍciu.
     jeøeli nie znaleziono formu≥y, pobierz formu≥Í dla jednostki nadrzÍdnej. powtÛrz operacje aø do odnalezienia formu≥y lub wystπpienia b≥Ídu.
   jeøeli dla poszczegÛlnych wyk≥adowcÛw wspÛ≥czynniki rÛøniπ siÍ, wÛwczas zg≥oú b≥πd.

   w przypadku b≥Ídu funkcja zwraca wartoúÊ 0. komunikat o b≥Ídzie odczytaj wÛwczas za pomocπ funkcji get_last_error. w celu diagnostyki b≥edu sprawdü zmienne o nazwach zaczynajπcych siÍ od last
  */
  function get_class_coeffficient ( aid number, aform_formula_type varchar2, aday date default sysdate) return number;
  function get_last_error return varchar2;
  function get_class_coeffficient_tester ( aid number, aform_formula_type varchar2, aday date default sysdate) return varchar2;
  
  function get_output_param_char1 return varchar2;
  function get_output_param_char2 return varchar2;
  function get_output_param_char3 return varchar2;
  function get_output_param_num1  return number;
  function get_output_param_num2  return number;
  function get_output_param_num3  return number;
  function get_output_param_num4  return number;
  function get_output_param_num5  return number;
  function get_output_param_num6  return number;
  function get_output_param_num7  return number;
  function get_output_param_num8  return number;
  function get_output_param_num9  return number;
  function get_output_param_num10 return number;

  function get_session_id return number;
    
  
  --
  -- returns error_message (is any) by get_output_param_char1 
  --         copied records         by get_output_param_num1
  --         conflict records       by get_output_param_num2
  procedure copy_data(source_date_from date
                    , source_date_to   date
                    , dest_date_from   date
                    , dest_period_must_be_empty varchar2
                    , own_classes      varchar2
                    , planner_id       number
                    , selected_lec_id  number default -1
                    , selected_gro_id  number default -1
                    , selected_res_id  number default -1
                    );

  --
  -- returns classes_deleted by 
  --         classes_deleted - get_output_param_num1
  --         lec_deleted     - get_output_param_num2
  --         gro_deleted     - get_output_param_num3
  --         rom_deleted     - get_output_param_num4
  --         sub_deleted     - get_output_param_num5
  --         per_deleted     - get_output_param_num6                    
   procedure preview_before_purge_data 
                       (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       ,session_id number
                       );
   procedure purge_data (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       , test_flag varchar2 default 'N');
                       
                       
   procedure merge_RES (save_id number, delete_id number, administrator_merging varchar2);                    
   procedure merge_LEC (save_id number, delete_id number, administrator_merging varchar2);                    
   procedure merge_GRO (save_id number, delete_id number, administrator_merging varchar2);        
   procedure merge_SUB (save_id number, delete_id number, administrator_merging varchar2);        
   procedure merge_FOR (save_id number, delete_id number, administrator_merging varchar2);        
   
   function  insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM') return varchar2;           
   procedure insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM');           

  -- zwraca wolny atrybut albo null
  --   
  function  flexGetFieldName (pmax_flex_num number, pform_name varchar2, pcontext_name varchar2, pfield_type varchar2 default 'S') return varchar2;

  function get_available_lec ( plec_id number ) return number;
  function get_available_gro ( pgro_id number ) return number;
  function get_available_rom ( prom_id number ) return number;

  function get_classes_selected_count return number;
    
  -- since wm_concat does not exist in Oracle10g  
  function get_group_types (pclass_id number) return varchar2;

end planner_utils;
/

CREATE OR REPLACE package body planner_utils is

  deleted_class_id number := null;

  procedure enable_trial is
  begin
    classes_history_pkg.trial_active  := true;
    forms_history_pkg.trial_active    := true;
    subjects_history_pkg.trial_active := true;
    lec_cla_history_pkg.trial_active  := true;
    gro_cla_history_pkg.trial_active  := true;
    classes_history_pkg.trial_active  := true;
    lecturers_history_pkg.trial_active:= true;
    groups_history_pkg.trial_active   := true;
    rooms_history_pkg.trial_active    := true;
  end;
  
  procedure disable_trial is
  begin
    classes_history_pkg.trial_active  := false;
    forms_history_pkg.trial_active    := false;
    subjects_history_pkg.trial_active := false;
    lec_cla_history_pkg.trial_active  := false;
    gro_cla_history_pkg.trial_active  := false;
    classes_history_pkg.trial_active  := false;
    lecturers_history_pkg.trial_active:= false;
    groups_history_pkg.trial_active   := false;
    rooms_history_pkg.trial_active    := false;
  end;

  
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function has_common_part(
     pa1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pa2 date default to_date('4000-12-31','yyyy-mm-dd') 
   , pb1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pb2 date default to_date('4000-12-31','yyyy-mm-dd')
   ) return varchar2 is
       a1 date;
       a2 date;
       b1 date;
       b2 date;
  begin
    a1 := nvl(pa1, to_date('1000-01-01','yyyy-mm-dd')); 
    a2 := nvl(pa2, to_date('4000-12-31','yyyy-mm-dd')); 
    b1 := nvl(pb1, to_date('1000-01-01','yyyy-mm-dd')); 
    b2 := nvl(pb2, to_date('4000-12-31','yyyy-mm-dd'));     
  
    -- Okres czasowy (A1,A2) ma czÍúÊ wspÛlnπ z okresem czasowym (B1,B2), gdy spe≥niony jest nastÍpujπcy warunek logiczny:  
    if  (A1 >= B1 or A2 >= B1) and (A1 <= B2 or A2 <= B2)  then
      return 'Y';
    else
      return 'N';
    end if; 
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure copy_data(source_date_from date
                    , source_date_to   date
                    , dest_date_from   date
                    , dest_period_must_be_empty varchar2
                    , own_classes      varchar2
                    , planner_id       number
                    , selected_lec_id  number default -1
                    , selected_gro_id  number default -1
                    , selected_res_id  number default -1
                    ) is
    current_class classes%rowtype;
    current_lec   lec_cla%rowtype;
    current_gro   gro_cla%rowtype;
    current_rom   rom_cla%rowtype;
    dest_date_to  date;
    offset number;
  begin
    output_param_char1 := '';
    dest_date_to := dest_date_from + to_number(source_date_to - source_date_from);

    if has_common_part(source_date_from,source_date_to,dest_date_from,dest_date_to) = 'Y' then    
      output_param_char1 := 'Okresy ürÛd≥owy i docelowy nie mogπ siÍ pokrywaÊ';
      return;
    end if;   
  
    if dest_period_must_be_empty = 'Y' then
     declare
      c number;
     begin
     select count(*) 
       into c 
       from classes
       where day between dest_date_from and dest_date_to;
     if c > 0 then
       output_param_char1 := 'Nie moøna wykonaÊ czynnoúci, poniewaø w obszarze docelowym sπ juø zaplanowane zajÍcia. Jeøeli mimo to chcesz kontynuowaÊ, zezwÛl na skopiowanie odznaczajπc pole wyboru na formularzu';
       return; 
     end if;
     end;  
    end if;
    
    output_param_num1 := 0; --sucess records
    output_param_num2 := 0; --failed records
    offset := dest_date_from - source_date_from;
    for rec in ( select * 
                   from classes 
                  where day between source_date_from and source_date_to
                    -- permissions
                    and id in 
                      (
                       select cla_id from lec_cla where lec_id in (select lec_id from lec_pla where pla_id =  planner_id and (lec_id = selected_lec_id or selected_lec_id =-1) )
                       union
                       select cla_id from gro_cla where gro_id in (select gro_id from gro_pla where pla_id =  planner_id and (gro_id = selected_gro_id or selected_gro_id =-1))
                       union
                       select cla_id from rom_cla where rom_id in (select rom_id from rom_pla where pla_id =  planner_id and (rom_id = selected_res_id or selected_res_id =-1))
                      )
               )
    loop
    savepoint roll;
    begin
      current_class := rec;
      select cla_seq.nextval into current_class.id from dual;
      current_class.day        := current_class.day + offset;
      current_class.created_by := user;
      if own_classes = 'Y' then 
        current_class.owner      := user;
      end if;  
      insert into classes values current_class;
      
      for rec_lec in ( select * from lec_cla where cla_id = rec.id order by id)
      loop
        current_lec := rec_lec;
        select leccla_seq.nextval into current_lec.id from dual;
        current_lec.cla_id:= current_class.id;
        current_lec.day   := current_class.day;
        insert into lec_cla values current_lec;
      end loop;
      
      for rec_gro in ( select * from gro_cla where cla_id = rec.id order by id)
      loop
        current_gro := rec_gro;
        select grocla_seq.nextval into current_gro.id from dual;
        current_gro.cla_id:= current_class.id;
        current_gro.day   := current_class.day;
        insert into gro_cla values current_gro;
      end loop;

      for rec_rom in ( select * from rom_cla where cla_id = rec.id order by id)
      loop
        current_rom := rec_rom;
        select romcla_seq.nextval into current_rom.id from dual;
        current_rom.cla_id:= current_class.id;
        current_rom.day   := current_class.day;
        insert into rom_cla values current_rom;
      end loop;
    
    output_param_num1 := output_param_num1 + 1;  
    exception
      when others then 
        output_param_num2 := output_param_num2 + 1;
        rollback to savepoint roll;
        -- .. and proceed
    end;
    end loop;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure purge_data (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       , test_flag varchar2 default 'N') is
    classes_deleted number;
    lec_deleted number;
    gro_deleted number; 
    rom_deleted number; 
    sub_deleted number; 
    per_deleted number;                  
  begin
   if del_lec_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique lec_id from
       (
        select lec_id from lec_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
        minus
        select lec_id from lec_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )
       );       
     lec_deleted := sql%rowcount;
     if test_flag = 'N' then
       delete from lec_cla   where lec_id in (select id from tmp_numbers  );
       delete from lec_pla   where lec_id in (select id from tmp_numbers  );
       delete from str_elems where child_id in  (select id from tmp_numbers  );
       delete from str_elems where parent_id in  (select id from tmp_numbers  );
       delete from lecturers where id in (select id from tmp_numbers  );
     end if;
   end if;

   if del_gro_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique gro_id from
       (
        select gro_id from gro_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )       
        minus
        select gro_id from gro_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )
       );       
     gro_deleted := sql%rowcount;
     if test_flag = 'N' then
      delete from gro_cla   where gro_id in (select id from tmp_numbers  );
      delete from gro_pla   where gro_id in (select id from tmp_numbers  );
      delete from str_elems where child_id in  (select id from tmp_numbers  );
      delete from str_elems where parent_id in  (select id from tmp_numbers  );
      delete from groups    where id in (select id from tmp_numbers  );
     end if;
   end if;

   if del_rom_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique rom_id from
       (
        select rom_id from rom_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )       
        minus
        select rom_id from rom_cla where cla_id  not  in ( select id from classes where day between pdate_from and pdate_to )
       );       
     rom_deleted := sql%rowcount;
     if test_flag = 'N' then
      delete from rom_cla   where rom_id in (select id from tmp_numbers  );
      delete from rom_pla   where rom_id in (select id from tmp_numbers  );
      delete from str_elems where child_id in  (select id from tmp_numbers  );
      delete from str_elems where parent_id in  (select id from tmp_numbers  );
      delete from rooms    where id in (select id from tmp_numbers  );
     end if;
   end if;

   if test_flag = 'N' then
     -- lec_cla, gro_cla, rom_cla are not cleared cascadely due defferable relation    
     delete from lec_cla where cla_id in (select id from classes where day between pdate_from and pdate_to);
     delete from gro_cla where cla_id in (select id from classes where day between pdate_from and pdate_to);
     delete from rom_cla where cla_id in (select id from classes where day between pdate_from and pdate_to);
     -- tt_cla is cleared cascadely     
     delete 
       from classes 
      where day between pdate_from and pdate_to;
     classes_deleted := sql%rowcount;
   else
     select count(*) into classes_deleted 
       from classes 
      where day between pdate_from and pdate_to;
   end if;  

   if del_sub_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique sub_id from
       (
        select sub_id from classes where day between pdate_from and pdate_to       
        minus
        select sub_id from classes where day not between pdate_from and pdate_to
       );       
     sub_deleted := sql%rowcount;
     if test_flag = 'N' then
      delete from subjects where id in (select id from tmp_numbers  );
     end if;
   end if;
   
   if del_per_flag = 'Y' then
     if test_flag = 'N' then
       delete from periods where pdate_from <= date_from and pdate_to >= date_to;  
       per_deleted := sql%rowcount;
     else
       select count(*) into per_deleted from periods where pdate_from <= date_from and pdate_to >= date_to;  
     end if;  
   end if;
      
   output_param_num1 := classes_deleted;
   output_param_num2 := lec_deleted;
   output_param_num3 := gro_deleted; 
   output_param_num4 := rom_deleted; 
   output_param_num5 := sub_deleted; 
   output_param_num6 := per_deleted;         
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure preview_before_purge_data 
                       (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       ,session_id number
                       )
  is                     
  begin
    delete from tmp_varchar2 where sessionid = session_id and param='LEC';
    delete from tmp_varchar2 where sessionid = session_id and param='GRO';
    delete from tmp_varchar2 where sessionid = session_id and param='RES';
    delete from tmp_varchar2 where sessionid = session_id and param='SUB';
    delete from tmp_varchar2 where sessionid = session_id and param='PER';
    
    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'LEC',
             substr(first_name || ' ' || last_name,1,240) 
        from lecturers
       where id in 
         (
           select lec_id from lec_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
           minus
           select lec_id from lec_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )       
         );     
     
    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'GRO'
             ,substr(name ,1,240)
        from groups
       where id in 
         (
           select gro_id from gro_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
           minus
           select gro_id from gro_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )       
         );     

    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'RES'
            ,substr(name ,1,240)
        from rooms
       where id in 
         (
           select rom_id from rom_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
           minus
           select rom_id from rom_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )       
         );     
         
    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'SUB'
            ,substr(name ,1,240)
        from subjects
        where id in
         (
          select sub_id from classes where day between pdate_from and pdate_to       
          minus
          select sub_id from classes where day not between pdate_from and pdate_to
         );           
         
    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'PER'
            ,substr(name ,1,240)
        from periods
        where pdate_from <= date_from and pdate_to >= date_to;

    purge_data (pdate_from, pdate_to                       
              , del_lec_flag, del_gro_flag, del_rom_flag, del_sub_flag, del_per_flag
              --, classes_deleted, lec_deleted, gro_deleted, rom_deleted, sub_deleted, per_deleted
              , 'Y' /*test_flag*/  );
  end;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure calculate_lgr(     
     cla_id      number,
     l       out classes.calc_lecturers%type,
     g       out classes.calc_groups%type,
     r       out classes.calc_rooms%type,
     l_id    out classes.calc_lec_ids%type,
     g_id    out classes.calc_gro_ids%type,
     r_id    out classes.calc_rom_ids%type,
     r_resid out classes.calc_rescat_ids%type
   );

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_classes(pday              date
                         ,phour             number
                         ,pfill             number
                         ,psub_id           number
                         ,pfor_id           number
                         ,powner            varchar2 default null
                         ,pcalc_lec_ids     varchar2
                         ,pcalc_gro_ids     varchar2
                         ,pcalc_rom_ids     varchar2
                         ,pcolour           number   default null
                         ,pdesc1            varchar2 default null
                         ,pdesc2            varchar2 default null
                         ,pdesc3            varchar2 default null
                         ,pdesc4            varchar2 default null
                         ,ptt_comb_ids      varchar2 default null
                         ,pcalc_lecturers   varchar2 default null
                         ,pcalc_groups      varchar2 default null
                         ,pcalc_rooms       varchar2 default null
                         ,pcreator          varchar2 default null
                         ,prefreshLGR       varchar2 default 'Y'
                         ,pgrantPermissions varchar2 default 'N'
                         ,pcalc_rescat_ids  varchar2 default null --@@@todo: this parameter should be passed by interace
                        ) is
                        
    vcalc_lecturers  classes.calc_lecturers%type := pcalc_lecturers;
    vcalc_groups     classes.calc_groups%type := pcalc_groups;
    vcalc_rooms      classes.calc_rooms%type := pcalc_rooms;
    vcalc_lec_ids    classes.calc_lec_ids%type := pcalc_lec_ids;
    vcalc_gro_ids    classes.calc_gro_ids%type := pcalc_gro_ids;
    vcalc_rom_ids    classes.calc_rom_ids%type := pcalc_rom_ids;
    vcalc_rescat_ids classes.calc_rescat_ids%type := pcalc_rescat_ids;
    cla_seq_nextval number;
    t               number;
    debug_cnt       number := 0;
    procedure auto_grant_permissions is
    --used by public API
    --adds automatically perrmisions to owner
    --creator can be external user, so permissions to creator are not granted
      ppla_id number;
    begin
      select id into ppla_id from planners where name = powner;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        begin
          insert into lec_pla (id,pla_id,lec_id) values (lecpla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_lec_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        begin
          insert into gro_pla (id,pla_id,gro_id) values (gropla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_gro_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        begin
          insert into rom_pla (id,pla_id,rom_id) values (rompla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_rom_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      begin
        insert into sub_pla (id,pla_id,sub_id) values (subpla_seq.nextval,ppla_id,psub_id);       
      exception
       when dup_val_on_index then null;
      end;
      begin
        insert into for_pla (id,pla_id,for_id) values (forpla_seq.nextval,ppla_id,pfor_id); 
      exception
       when dup_val_on_index then null;
      end;
    end;
    --procedure debug ( m varchar2 ) is begin
    --  insert into xxmsztools_eventlog (id, message) values (xxmsztools_eventlog_seq.nextval, m);
    --  commit;
    --end;
  ----------------------------------------------------------------------------------------  
  begin
    -- prevent from planning in locked periods
    for rec in (
      select * 
        from periods
       where pday between date_from and date_to
         and locked_flag = '+'
         and created_by <> user 
    )
    loop
      raise_application_error(-20000, 'Planowanie zajÍÊ w terminie od '||to_char(rec.date_from,'yyyy-mm-dd')||' do '||to_char(rec.date_to,'yyyy-mm-dd')||' zosta≥o zablokowane przez uøytkownika '||rec.created_by);
    end loop;    
    --
    if pgrantPermissions = 'Y' then auto_grant_permissions; end if;
  
  
    cla_seq_nextval := null;
    if deleted_class_id is not null then
      -- use the same id, thus update will return the same id
      -- rollback could restore the record
      declare
       c number;
      begin
       select count(1) into c from classes where id = deleted_class_id and rownum = 1;
       if c = 0 then 
          cla_seq_nextval := deleted_class_id;
          deleted_class_id := null; 
       end if;
      end;
    end if;
    --
    if cla_seq_nextval is null then 
      select cla_seq.nextval
        into cla_seq_nextval
        from dual;
    end if;    
    
    output_param_num1 := cla_seq_nextval;     
    
    --declare
    --  c number;
    --begin
    --  select count(1) into c from lec_cla where lec_id = 4006793 and day = date'2012-12-24' and hour=2;
      --raise_application_error(-20000, 'trace=' || c );
    --end;
    
    
    declare
      plec_id number;
    begin
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        plec_id := xxmsz_tools.extractword(t,pcalc_lec_ids,';');
        insert into lec_cla (id, lec_id, cla_id, is_child, day, hour) values (leccla_seq.nextval,plec_id,cla_seq_nextval, 'N', pday, phour);      
        /*     
        for rec in (
            select unique child_id--, parent_id, level
              from lec_str_elems
             where str_name_lov='STREAM'
            connect by prior str_name_lov='STREAM' and prior child_id = parent_id  
            start with parent_id= xxmsz_tools.extractword(t,pcalc_lec_ids,';')
        )
        loop
          insert into lec_cla (id, lec_id, cla_id, is_child) values (leccla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y');      
        end loop;
        */
      end loop;
    --exception
    --  when others then
    --    raise_application_error(-20000, 'lec='||plec_id||' day='||to_char(pday,'yyyy-mm-dd')||' hour='||phour);
    end;  
    
    for t in 1 .. xxmsz_tools.wordcount(pcalc_gro_ids, ';') loop
      insert into gro_cla (id, gro_id, cla_id, is_child, day, hour) values (grocla_seq.nextval,xxmsz_tools.extractword(t,pcalc_gro_ids,';'),cla_seq_nextval, 'N', pday, phour);
      /*     
      for rec in (
          select unique child_id --, parent_id, level
            from gro_str_elems
           where str_name_lov='STREAM'
          connect by prior str_name_lov='STREAM' and prior child_id = parent_id  
          start with parent_id= xxmsz_tools.extractword(t,pcalc_gro_ids,';')
       )
      loop
        insert into gro_cla (id, gro_id, cla_id, is_child) values (grocla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y');      
      end loop;
      */
    end loop;

    for t in 1 .. xxmsz_tools.wordcount(pcalc_rom_ids, ';') loop
      insert into rom_cla (id, rom_id, cla_id, is_child, day, hour) values (romcla_seq.nextval,xxmsz_tools.extractword(t,pcalc_rom_ids,';'),cla_seq_nextval,'N', pday, phour);
      /*     
      for rec in (
          select unique child_id --, parent_id, level
            from res_str_elems
           where str_name_lov='STREAM'
          connect by prior str_name_lov='STREAM' and prior child_id = parent_id  
          start with parent_id= xxmsz_tools.extractword(t,pcalc_rom_ids,';')
      )
      loop
        insert into rom_cla (id, rom_id, cla_id, is_child) values (romcla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y');      
      end loop;
      */
    end loop;

    if prefreshLGR = 'Y' then calculate_lgr(cla_seq_nextval, vcalc_lecturers, vcalc_groups, vcalc_rooms, vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, vcalc_rescat_ids); end if;
    insert into classes
                (id             , day  ,hour  ,fill  ,sub_id  ,for_id  ,owner  ,calc_lec_ids , calc_gro_ids , calc_rom_ids , calc_lecturers , calc_groups , calc_rooms , created_by        , colour  , desc1, desc2, desc3, desc4, calc_rescat_ids)
         values (cla_seq_nextval, pday ,phour ,pfill ,psub_id ,pfor_id ,powner ,vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, vcalc_lecturers, vcalc_groups, vcalc_rooms, nvl(pcreator,user), pcolour ,pdesc1,pdesc2,pdesc3,pdesc4, vcalc_rescat_ids);
    
    if ptt_comb_ids is not null then
      declare
       l_tt_comb_ids  varchar2(4000) := replace(ptt_comb_ids,';',',');
       l_comb_id      number; 
      begin
        for t in 1 .. xxmsz_tools.wordcount( l_tt_comb_ids, ',') loop
          l_comb_id := regexp_substr(l_tt_comb_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
          tt_planner.book_combination ( l_comb_id, pfill/100 );
          insert into tt_cla (id, cla_id, tt_comb_id, units) values (tt_seq.nextval, cla_seq_nextval, l_comb_id, pfill/100);
        end loop;  
      end;
    end if;  
    
  end insert_classes;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_lgrs is
    cursor cur is select id from classes;
    l       classes.calc_lecturers%type;
    g       classes.calc_groups%type;
    r       classes.calc_rooms%type;
    l_id    classes.calc_lec_ids%type;
    g_id    classes.calc_gro_ids%type;
    r_id    classes.calc_rom_ids%type;
    r_resid classes.calc_rescat_ids%type;
  begin
    disable_trial;
    for rec in cur loop
     calculate_lgr(rec.id, l, g, r, l_id, g_id, r_id, r_resid);
     update classes
     set    calc_lecturers = l,
            calc_groups    = g,
            calc_rooms     = r,
            calc_lec_ids   = l_id,
            calc_gro_ids   = g_id,
            calc_rom_ids   = r_id,
            calc_rescat_ids= r_resid
     where id = rec.id;
     commit;
    end loop;
    enable_trial;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_lgr (cla_id number) is
    l       classes.calc_lecturers%type;
    g       classes.calc_groups%type;
    r       classes.calc_rooms%type;
    l_id    classes.calc_lec_ids%type;
    g_id    classes.calc_gro_ids%type;
    r_id    classes.calc_rom_ids%type;
    r_resid classes.calc_rescat_ids%type;
  begin
     calculate_lgr(cla_id, l, g, r, l_id, g_id, r_id, r_resid);
     update classes
     set    calc_lecturers = l,
            calc_groups    = g,
            calc_rooms     = r,
            calc_lec_ids   = l_id,
            calc_gro_ids   = g_id,
            calc_rom_ids   = r_id,
            calc_rescat_ids= r_resid
     where id = cla_id;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure calculate_lgr(
     cla_id number,
     l       out classes.calc_lecturers%type,
     g       out classes.calc_groups%type,
     r       out classes.calc_rooms%type,
     l_id    out classes.calc_lec_ids%type,
     g_id    out classes.calc_gro_ids%type,
     r_id    out classes.calc_rom_ids%type,
     r_resid out classes.calc_rescat_ids%type
  ) is
    cursor cur_l(pcla_id number) is
      select lec.abbreviation x
           , lec.id
        from lecturers lec
           , lec_cla
       where lec.id = lec_id 
             -- params
         and cla_id = pcla_id
             -- sort by user creating order  
       order by lec_cla.id; 
    --
    cursor cur_g(pcla_id number) is
      select gro.abbreviation x
           , gro.id
        from groups gro
           , gro_cla
       where gro.id = gro_id
          -- params
         and cla_id = pcla_id
       order by gro_cla.id;
    --
    cursor cur_r(pcla_id number) is
      select rom.name||' '||rom.attribs_01 x
           , rom.id
           , rom.rescat_id 
        from rooms rom
           , rom_cla
       where rom.id = rom_id
          -- params
         and cla_id = pcla_id
       order by rom_cla.id;
    --
  begin
    l    := '';
    l_id := '';
    for rec_l in cur_l(cla_id) loop
     l    := xxmsz_tools.merge(l   , rec_l.x , '; ');
     l_id := xxmsz_tools.merge(l_id, rec_l.id, ';');
    end loop;
    g    := '';
    g_id := '';
    for rec_g in cur_g(cla_id) loop
     g    := xxmsz_tools.merge(g   , rec_g.x , '; ');
     g_id := xxmsz_tools.merge(g_id, rec_g.id, ';');
    end loop;
    r    := '';
    r_id := '';
    for rec_r in cur_r(cla_id) loop
     r       := xxmsz_tools.merge(r      , rec_r.x        , '; ');
     r_id    := xxmsz_tools.merge(r_id   , rec_r.id       , ';' );
     r_resid := xxmsz_tools.merge(r_resid, rec_r.rescat_id, ';' ); 
    end loop;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
    function get_class_coeffficient ( aid number, aform_formula_type varchar2, aday date default sysdate) return number is
      afor_id            number;
      coe                number;
      prior_coe          number;
      anumber_of_peoples number;
      ahours             number;
      acalc_lecturers    classes.calc_lecturers%type;
      acalc_groups       classes.calc_groups%type;

      function get_lec_coefficient (alec_id number) return number is
        aorguni_id number;
        coe        number;
        guard      number := 0;
        ffformula  varchar2(500);
          function get_orguni_formula ( aorguni_id number ) return varchar2 is
            ffid       number;
            ffformula  varchar2(500);
            parent_orguni_id number;
          begin
            begin
              -- wyszukiwanie formuly
              last_orguni_id := aorguni_id;
              select id,formula
                into ffid,ffformula
                  from form_formulas
               where for_id       = afor_id
                 and orguni_id    = aorguni_id
                 and formula_type = aform_formula_type
                 and aday between date_from and nvl(date_to,aday);
               last_ffid := ffid;
               return ffformula;
            exception
             when too_many_rows then
               last_error := '(01)Odnaleziono kilka formu≥ dla podanej formy, jednostki, typu formu≥y, daty)';
               return 0;
             when no_data_found then
               guard := guard + 1;
               if guard > 100 then
                 last_error := '(02)Przekroczono dopuszczalnπ liczbÍ zagnieødøeÒ w strukturze organizacyjnej ( 100 ). Sprawdü, czy struktura organizacyjna nie zawiera cykli';
                 return null;
               else
                 select parent_id
                   into parent_orguni_id
                   from org_units
                  where id = aorguni_id;
                  if parent_orguni_id is null then
                    last_error := '(03)Nie odnaleziono formu≥y dla formy prowadzenia zajÍÊ, zadanego dnia oraz jedn.org (oraz jednostek nadrzÍdnych)';
                    return null;
                  else
                   return  get_orguni_formula ( parent_orguni_id );
                  end if;
               end if;
             when others        then
               last_error := '(04)Wyszukiwanie formu≥y - b≥πd: ' || to_char (sqlcode) || ' ' || sqlerrm;
               return null;
            end;
          end;
      begin
        begin
          select orguni_id
            into aorguni_id
            from lecturers where id = alec_id;
        exception
          when others        then
            last_error := '(05)Nie powiod≥o siÍ wyznaczenie jednostki organizacyjnej dla wyk≥adowcy. B≥πd: ' || to_char (sqlcode) || ' ' || sqlerrm;
            return 0;
        end;

        if aorguni_id is null then
           last_error := '(06)Dla wyk≥adowcy nie okreúlono jednostki organizacyjnej - nie moøna wyznaczyÊ formu≥y';
           return 0;
        end if;

        ffformula := get_orguni_formula ( aorguni_id );
        if ffformula is null then --blad
         return 0;
        end if;

        ffformula := replace (ffformula, 'Zaogrπglij'      , 'Round');
        --ffformula := replace (ffformula, 'Liczba_godz'     , to_char(ahours,'99999.0000') );
        --ffformula := replace (ffformula, 'Liczba_studentÛw', to_char(anumber_of_peoples,'99999.0000'));
        ffformula := replace (ffformula, 'Liczba_godz'     , ' xxmsz_tools.strToNumber(' || to_char(ahours)             ||') ' );
        ffformula := replace (ffformula, 'Liczba_studentÛw', ' xxmsz_tools.strToNumber(' || to_char(anumber_of_peoples) ||') ' );
        -- xxmsz_tools.strtonumber chyba niepotrzebne, przy okazji to przetestowania i ew. do usuniecia

        last_formula := ffformula;

        begin
          return xxmsz_tools.getsqlvalue('SELECT '||ffformula||' FROM DUAL');
        exception
          when others then
            last_error := '(07)B≥πd podczas wyliczania formu≥y "' || FFFORMULA || '" B≥πd: ' || to_char (sqlcode) || ' ' || sqlerrm;
            return 0;
        end;
      end;

    begin
      last_error     := null;
      last_formula   := null;
      last_orguni_id := null;
      last_horus     := null;
      last_number_of_peoples := null;
      last_lec_id    := null;
      last_for_id    := null;

      select for_id, 2 * fill / 100, calc_lecturers, calc_groups
        into afor_id, ahours, acalc_lecturers, acalc_groups
        from classes
        where id = aid;

      if acalc_lecturers is null then
        last_error := '(08)Nie moøna wyznaczyÊ wspÛ≥czynnika, poniewaø nie okreúlono wyk≥adowcy';
        return 0;
      end if;

      if acalc_groups is null then
        last_error := '(09)Nie moøna wyznaczyÊ wspÛ≥czynnika, poniewaø nie okreúlono grup';
        return 0;
      end if;

      select nvl( sum ( number_of_peoples ), 0)
        into anumber_of_peoples
        from groups
        where id in ( select gro_id from gro_cla where cla_id = aid );

      if anumber_of_peoples = 0 then
        last_error := '(10)Nie moøna wyznaczyÊ wspÛ≥czynnika, poniewaø nie okreúlono licznoúci grup';
        return 0;
      end if;

      last_for_id            := afor_id;
      last_horus             := ahours;
      last_number_of_peoples := anumber_of_peoples;

      -- wyznacz wspÛ≥czynnik dla kaødego wyk≥adowcy
      coe := 0;
      for rec_lec in ( select lec_id from lec_cla where cla_id = aid ) loop
        prior_coe   := coe;
        last_lec_id := rec_lec.lec_id;
        coe := get_lec_coefficient (rec_lec.lec_id);
        if coe = 0 then -- blad
          exit;
        end if;
        if prior_coe <> 0 then
          if prior_coe <> coe then
            last_error := '(11)Otrzymano rÛøne wartoúci wspÛ≥czynnika dla wyk≥adowcÛw prowadzπcych zajÍcie (' || prior_coe || ', '||  coe || ')';
            return 0;
          end if;
        end if;
      end loop;

      if last_error is not null then
        last_error := last_error || ' wywo≥anie: GET_CLASS_COEFFFICIENT ( '||aid||','''||aform_formula_type||''',TO_DATE(' || to_char(aday,'YYYY-MM-DD') || ',''YYYY-MM-DD''))';
      end if;

      return coe;
    end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_last_error return varchar2 is
  begin
    return last_error;
  end get_last_error;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_class_coeffficient_tester ( aid number, aform_formula_type varchar2, aday date  default sysdate) return varchar2 is
   coe number;
  begin
    coe  := get_class_coeffficient ( aid, aform_formula_type, aday);
    return ' COE='                   || to_char ( coe )
         ||' LAST_ERROR='            || last_error
         ||' LAST_ORGUNI_ID='        || last_orguni_id
         ||' LAST_LEC_ID='           || last_lec_id
         ||' LAST_FOR_ID='           || last_for_id
         ||' LAST_FFID='             || last_ffid
         ||' LAST_FORMULA='          || last_formula
         ||' LAST_HORUS='            || last_horus
         ||' LAST_NUMBER_OF_PEOPLES='|| last_number_of_peoples;
  end get_class_coeffficient_tester;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_output_param_char1 return varchar2 is begin return output_param_char1; end;
  function get_output_param_char2 return varchar2 is begin return output_param_char2; end;
  function get_output_param_char3 return varchar2 is begin return output_param_char3; end;
  function get_output_param_num1  return number is begin return output_param_num1; end;
  function get_output_param_num2  return number is begin return output_param_num2; end;
  function get_output_param_num3  return number is begin return output_param_num3; end;
  function get_output_param_num4  return number is begin return output_param_num4; end;
  function get_output_param_num5  return number is begin return output_param_num5; end;
  function get_output_param_num6  return number is begin return output_param_num6; end;
  function get_output_param_num7  return number is begin return output_param_num7; end;
  function get_output_param_num8  return number is begin return output_param_num8; end;
  function get_output_param_num9  return number is begin return output_param_num9; end;
  function get_output_param_num10 return number is begin return output_param_num10; end;
    
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_session_id return number is
  begin
   return userenv('sessionid');
  end get_session_id;
    
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_res (save_id number, delete_id number, administrator_merging varchar2) is
   TYPE tcla_id_list IS TABLE OF NUMBER(15);
   cla_id_list tcla_id_list;
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from rom_cla 
            , classes c 
        where c.id = rom_cla.cla_id
          and rom_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'ZasÛb, ktÛry probujesz scaliÊ, zosta≥ uøyty przez innych planistÛw. Jeøeli mimo to chcesz dokonaÊ scalenia, zaznacz pole wyboru "ZezwÛl na scalanie jeøeli istniejπ zajÍcia zaplanowane przez innych planistÛw"');
       end if;  
      end;           
    end if;
    -- delete record which would make conflicts after merging
    delete rom_pla x
     where rom_id = delete_id
       -- such record which would be created after update already exists
       and exists ( select 1 from rom_pla where rom_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    delete rom_cla x
     where rom_id = delete_id
       -- such record which would be created after update already exists
       and exists ( select 1 from rom_cla where rom_id = save_id and day = x.day and hour = x.hour)    
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num2 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;  
    cla_id_list.delete;  
    update str_elems set child_id = save_id where child_id = delete_id;
    update str_elems set parent_id = save_id where parent_id = delete_id;
    update rom_pla set rom_id = save_id where rom_id = delete_id;
    output_param_num3 := sql%rowcount;
    update rom_cla set rom_id = save_id where rom_id = delete_id
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num4 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;    
    delete from rooms where id = delete_id;
    output_param_num5 := sql%rowcount;
  end merge_res;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_lec (save_id number, delete_id number, administrator_merging varchar2) is
   TYPE tcla_id_list IS TABLE OF NUMBER(15);
   cla_id_list tcla_id_list;
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from lec_cla 
            , classes c 
        where c.id = lec_cla.cla_id
          and lec_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Dane o wyk≥adowcy, ktÛre prÛbujesz scaliÊ, zosta≥y uøyte przez innych planistÛw. Jeøeli mimo to chcesz dokonaÊ scalenia, zaznacz pole wyboru "ZezwÛl na scalanie jeøeli istniejπ zajÍcia zaplanowane przez innych planistÛw"');
       end if;  
      end;           
    end if;
    delete lec_pla x
     where lec_id = delete_id
       and exists ( select 1 from lec_pla where lec_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    delete lec_cla x
     where lec_id = delete_id
       and exists ( select 1 from lec_cla where lec_id = save_id and day = x.day and hour = x.hour)    
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num2 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;    
    cla_id_list.delete;  
    update str_elems set child_id = save_id where child_id = delete_id;
    update str_elems set parent_id = save_id where parent_id = delete_id;
    update lec_pla set lec_id = save_id where lec_id = delete_id;
    output_param_num3 := sql%rowcount;
    update lec_cla set lec_id = save_id where lec_id = delete_id
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num4 := sql%rowcount;
    i := cla_id_list.first;  
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;
    delete from lecturers where id = delete_id;
    output_param_num5 := sql%rowcount;
  end merge_lec;                   
    
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_gro (save_id number, delete_id number, administrator_merging varchar2) is
   TYPE tcla_id_list IS TABLE OF NUMBER(15);
   cla_id_list tcla_id_list;
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from gro_cla 
            , classes c 
        where c.id = gro_cla.cla_id
          and gro_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Dane o grupie, ktÛre probujesz scaliÊ, zosta≥y uøyte przez innych planistÛw. Jeøeli mimo to chcesz dokonaÊ scalenia, zaznacz pole wyboru "ZezwÛl na scalanie jeøeli istniejπ zajÍcia zaplanowane przez innych planistÛw"');
       end if;  
      end;           
    end if;
    delete gro_pla x
     where gro_id = delete_id
       and exists ( select 1 from gro_pla where gro_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    delete gro_cla x
     where gro_id = delete_id
       and exists ( select 1 from gro_cla where gro_id = save_id and day = x.day and hour = x.hour)    
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num2 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;    
    cla_id_list.delete;  
    update str_elems set child_id = save_id where child_id = delete_id;
    update str_elems set parent_id = save_id where parent_id = delete_id;
    update gro_pla set gro_id = save_id where gro_id = delete_id;
    output_param_num3 := sql%rowcount;
    update gro_cla set gro_id = save_id where gro_id = delete_id
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num4 := sql%rowcount;
    i := cla_id_list.first;  
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;
    delete from groups where id = delete_id;
    output_param_num5 := sql%rowcount;
  end merge_gro;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_SUB (save_id number, delete_id number, administrator_merging varchar2) is
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from classes c 
        where sub_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Przedmiot, ktÛry probujesz scaliÊ, zosta≥ uøyty przez innych planistÛw. Jeøeli mimo to chcesz dokonaÊ scalenia, zaznacz pole wyboru "ZezwÛl na scalanie jeøeli istniejπ zajÍcia zaplanowane przez innych planistÛw"');
       end if;  
      end;           
    end if;
    delete sub_pla x
     where sub_id = delete_id
       and exists ( select 1 from sub_pla where sub_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    output_param_num2 := 0; 
    update sub_pla set sub_id = save_id where sub_id = delete_id;
    output_param_num3 := sql%rowcount;
    update classes set sub_id = save_id where sub_id = delete_id;
    output_param_num4 := sql%rowcount;
    delete from subjects where id = delete_id;
    output_param_num5 := sql%rowcount;
  end merge_SUB;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_FOR (save_id number, delete_id number, administrator_merging varchar2) is
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from classes c 
        where for_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Przedmiot, ktÛry probujesz scaliÊ, zosta≥ uøyty przez innych planistÛw. Jeøeli mimo to chcesz dokonaÊ scalenia, zaznacz pole wyboru "ZezwÛl na scalanie jeøeli istniejπ zajÍcia zaplanowane przez innych planistÛw"');
       end if;  
      end;           
    end if;
    delete for_pla x
     where for_id = delete_id
       and exists ( select 1 from for_pla where for_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    output_param_num2 := 0; 
    update for_pla set for_id = save_id where for_id = delete_id;
    output_param_num3 := sql%rowcount;
    update form_formulas set for_id = save_id where for_id = delete_id;
    update classes set for_id = save_id where for_id = delete_id;
    output_param_num4 := sql%rowcount;
    delete from forms where id = delete_id;
    output_param_num5 := sql%rowcount;
  end merge_FOR;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM') return varchar2 is
   c number;
  begin
    if pparent_id = pchild_id then return 'ZasÛb nie moøe byÊ sam dla siebie podrzÍdny ani nadrzÍdny'; end if;
    --avoid cycles
    select count(*)
     into c 
     from
     (select parent_id id_list
        from str_elems
        where str_name_lov = pstr_name_lov
        connect by prior parent_id = child_id   
        start with child_id=pparent_id)
    where id_list = pchild_id;
    if c > 0 then return 'Dodanie rekordu spowodowa≥oby zapÍtlenie danych. Elementem nadrzÍdnym nie moøe byÊ element, ktÛry juø jest elementem podrzÍdnym'; end if;
    select count(*)
     into c 
     from
     (select child_id id_list
        from str_elems
        where str_name_lov = pstr_name_lov
        connect by prior child_id = parent_id  
        start with parent_id=pchild_id)
    where id_list = pparent_id;    
    if c > 0 then return 'Dodanie rekordu spowodowa≥oby zapÍtlenie danych. Elementem podrzÍdnym nie moøe byÊ element, ktÛry juø jest elementem nadrzÍdnym'; end if;    
    begin
      insert into str_elems (id, parent_id, child_id, str_name_lov) values (main_seq.nextval, pparent_id, pchild_id,pstr_name_lov);
      return '';
    exception 
      when others then 
        if sqlcode = -1 then return 'Ta kombinacja juø istnieje. Rekord nie zosta≥ dodany ponownie'; else return sqlerrm; end if;
    end;
  end insert_str_elem;           

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM') is
  begin
    output_param_char1 := insert_str_elem (pparent_id, pchild_id, pstr_name_lov);
  end insert_str_elem;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function  flexGetFieldName (pmax_flex_num number, pform_name varchar2, pcontext_name varchar2, pfield_type varchar2 default 'S') return varchar2 is
    res varchar2(100);
  begin
   select min (field_name)
     into res 
     from 
       (
       select lpad(rownum,2,'0') field_name from dual connect by rownum  <= pmax_flex_num
       minus
       select substr(attr_name,-2) from flex_col_usage where form_name = pform_name and context_name = pcontext_name and attr_name like 'ATTRIB'||pfield_type||'%'
       );
   return res;
  end flexGetFieldName;


  
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_available_lec ( plec_id number ) return number is
    vres number;
  begin
    select case when planner_utils.classes_selected_count = 0 then 100
                else round ( ( (planner_utils.classes_selected_count-count(1)) * 100) / planner_utils.classes_selected_count ) end 
      into vres
      from lec_cla 
     where lec_id = plec_id
       and ( day, hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv('sessionid') ); 
    return vres;
  end get_available_lec;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_available_gro ( pgro_id number ) return number is
    vres number;
  begin
    if planner_utils.classes_selected_count = 0 then return 100; end if;
    select case when planner_utils.classes_selected_count = 0 then 100
                else round ( ( (planner_utils.classes_selected_count-count(1)) * 100) / planner_utils.classes_selected_count ) end 
      into vres
      from gro_cla 
     where gro_id = pgro_id
       and ( day, hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv('sessionid') ); 
    return vres;
  end get_available_gro;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_available_rom ( prom_id number ) return number is
    vres number;
  begin
    if planner_utils.classes_selected_count = 0 then return 100; end if;
    select case when planner_utils.classes_selected_count = 0 then 100
                else round ( ( (planner_utils.classes_selected_count-count(1)) * 100) / planner_utils.classes_selected_count ) end 
      into vres
      from rom_cla 
     where rom_id = prom_id
       and ( day, hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv('sessionid') ); 
    return vres;
  end get_available_rom;

  function get_classes_selected_count return number is
  begin
   return planner_utils.classes_selected_count;
  end get_classes_selected_count;
  
 -----------------------------------------------------------------------------------------------------------------------------------------------------
 function get_group_types (pclass_id number) return varchar2 is
   l_res varchar2(500) := '';
 begin
   for rec in (
   select unique substr(meaning,1,50) group_type_dsp
    into l_res
    from groups   g  
    ,    gro_cla  c  
    ,    lookups  l
    where g.id = c.gro_id
     and l.lookup_type = 'GROUP_TYPE' and  l.code  = g.group_type
     and cla_id = pclass_id
   ) loop
    l_res := l_res || rec.group_type_dsp || ' ';
   end loop;  
   return l_res;     
 end get_group_types; 


 -----------------------------------------------------------------------------------------------------------------------------------------------------
 procedure delete_class ( pid number ) is
  l_sum_units number;
 begin 
   --debug('delete_class:'||pid);   
   for rec in (select tt_comb_id from tt_cla where cla_id = pid) loop
     select sum(units) into l_sum_units from tt_cla where cla_id = pid and tt_comb_id = rec.tt_comb_id;
     tt_planner.unbook_combination ( rec.tt_comb_id, l_sum_units );
   end loop;
   delete from classes where id = pid;
   -- lec_cla, gro_cla, rom_cla are not cleared cascadely due defferable relation    
   delete from lec_cla where cla_id = pid;
   delete from gro_cla where cla_id = pid;
   delete from rom_cla where cla_id = pid;
   -- tt_cla is cleared cascadely
   
   -- do not uncomment this line. caching problems during classes are moved on the grid
   deleted_class_id := pid;
 exception
 when others then
   rollback; 
   raise;  
 end delete_class;

end planner_utils;
/

CREATE OR REPLACE package api is

   /*****************************************************************************************************************************
   |* Public api to insert, update and delete classes
   |  Do not change database manually. instead of this, use this package.
   |
   |  Summary
   |    procedure insert_class    - Adds new class.
   |    function  can_insert_class- Checks if new class can be added. Does not add new class. 
   |    procedure delete_class    - Deletes existing class. 
   |    procedure update_class    - Updates class.
   |  
   |    function insert_class     - SQL equivalent for procedure insert_class (you can use this in SQL, no PLSQL is required).
   |    function update_class     - SQL equivalent for procedure update_class.
   |    function delete_class     - SQL equivalent for procedure delete_class.
   |
   |*****************************************************************************************************************************
   | History
   | 2010.06.04 created Maciej Szymczak
   | 2013.02.27 change Maciej Szymczak track history - change in delete_class
   | 2013.11.03 bugfixing  
   \-----------------------------------------------------------------------------------------------------------------------------*/
   
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  /* procedure adds a new class
     arguments:
       papiversion    API version. always set 1. 
       pday           class date
       phour          class hour
       pfill          block utilization ( 1-100 )
       psub_id        class subject (=subjects.id)
       pfor_id        class form (=forms.id)
       plec_ids       class lecturer (=lecturers.id). this parameter is optional. You can pass more values separated by ";", for instance "1;2;3"
       pgro_ids       class group of students (=groups.id). this parameter is optional. You can pass more values separated by ";", for instance "1;2;3"
       prom_ids       class resource (=rooms.id). this parameter is optional. You can pass more values separated by ";", for instance "1;2;3"
       powner         =owner name, max. 30chars. it has to be the name of planner for instance BPLATA.
       pcreator       =creator name, max. 30chars. Any name uniquely indicated who actually created this class.
       out_class_id   id of just created class ( =class.id )
     remarks:
       it is assumed that dictionaries like subjects, forms, lecturers, groups, resources are given in database at the moment when you call this procedure.
       this procedure grant automatically to owner permissions to see class in planner system.
       this procedure adds creator into planners table.       
     results:
         Any errors are reported by exception, examples:
          "ORA-00001: unique constraint (PLANNER.LEC_CLA_U) violated" means that you cannot add this class due to conflict with another one
                                                                      (Zaplanowanie tego zajÍcia spodowa≥oby konflikty z innymi zajÍciami)
                                                                      This is frequently occured error
          "ORA-12899: value too large for column "PLANNER"."PLANNERS"."NAME" (actual: 71, maximum: 30)" - creator or owner name is too long
          "ORA-01722: invalid number" - values in plec_ids, ogro_ids, prom_ids are not separated by ";", but by another char
          "ORA-20002: Class without lecturer and group and resource" - (Wskaø przynajmniej jeden z obiektow: wyk≥adowcÍ, grupÍ lub salÍ)
          internal errors:                                                             
          "ORA-20000: API version error" - API version does not respond to external system version.
          "ORA-20001: Wrong owner name" - owner has to be user of type USER
  */        
  procedure insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
    ,out_class_id out number
   );
    
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  -- Checks whether given class can be added, returns Y(insert is allowed) or exception is raised
  -- Procedure insert_class validates whether it is possible to add class as well. Thus you do not need to use this function.
  -- However, you may use it to inform user whether user action will be performed sucesfully in advance. 
  function can_insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
   ) return varchar2;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  /* procedure deletes the class of given id
     arguments:
       pid            class id (=classes.id) 
     remarks:
       this procedure deletes class from database (grants to lecturer, group, resource, subject and form are not deleted. Creator in table planners is not deleted as well).
       THIS PROCEDURE DOES NOT CHECK WHETHER CURRENT USER HAS PERMISSIONS TO DO IT, IT IS A RESPONSIBILITY OF A SYSTEM WHICH USES THIS API.
         justification: 
           External system functionality can differ from planner desktop functionality.
           For example, planner desktop allows changes to owner only (owner is a planner - employee,internal user ).
           In opossite, external system can allow changes to creator rather than to owner (creator may NOT be a planner, it can be any external user for example a lecturer or a student).
           Usually the scenerio of plannig is:
            1. First, external users plans its classes
            2. Next,  external users are disallowed to change data
            3. Next,  planner (insernal user) reviews plans, assigns rooms were missing and so on.            
           It is important to implement appropriate safety rules on external system side, including period of time when external user are allowed to modifi data.
     results:
         Function returs no result. Any errors are reported by exception
  */        
  procedure delete_class ( pid number ); 

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  /* function adds a new class
      Similar to procedure insert_class with the exceptions:
      - you can call this procedure in select statement ( no pl/sql block is required )
      - this procedure performs commit
      
     sample code shows how to use this function. 
  
      select api.insert_class(
           2
          ,date'2010-06-04'               -- pday    
          ,'1'                            -- phour     number
          ,100                            -- pfill     number
          ,(select max(id) from subjects) -- psub_id   number
          ,(select max(id) from forms)    -- pfor_id   number
          ,(select max(id) from lecturers)
                                          -- pcalc_lec_ids   varchar2
          ,(select max(id) from groups)
                                          -- pcalc_gro_ids   varchar2
          ,(select max(id) from rooms)
                                          -- pcalc_rom_ids   varchar2
          ,'BPLATA'                       -- powner    varchar2
          ,'WYKLADOWCA A'                 -- pcreator  varchar2 
         ) result
      from dual
      
     results:
      function returns id of class
  */       
  function insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2 
   ) return number;
   
  --almost the same as procedure delete_class. it allow you use this procedure directly in SQL ( no PL/SQL block is required ) 
  --this procedure does commit.
  function delete_class ( pid number ) return varchar2;  
  
  --updates class.
  -- you need pass all elements of the class ( NOT only changed elements )
  -- updated class has the same id (in_out_class_id).
  procedure update_class(
    papiversion number
   ,pday       date
   ,phour      number
   ,pfill      number
   ,psub_id    number
   ,pfor_id    number
   ,plec_ids   varchar2
   ,pgro_ids   varchar2
   ,prom_ids   varchar2
   ,powner     varchar2
   ,pcreator   varchar2
   ,in_out_class_id in out number);

  --SQL version equivalent   
  function update_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
    ,pclass_id in number 
   ) return number;   
   
   -- procedure purges database from classes out of periods
   procedure delete_orphaned (p_user varchar2 );
   
   function translate_message (psqlerrm varchar2) return varchar2;

end;
/

CREATE OR REPLACE package body api is

  debug_enabled boolean := to_char(sysdate,'yyyy') in ('2010','2011');

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure debug (m varchar2) is
  begin
    if debug_enabled then
      xxmsz_tools.insertIntoEventLog(m,'I','API');
    end if;
  end debug;
 
 
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function translate_message (psqlerrm varchar2) return varchar2 is
     dsp varchar2(240);
  begin
     select meaning into dsp from lookups where lookup_type = 'DBMESSAGE_TRANSLATION' and instr(psqlerrm, code)<>0;
     return dsp;
  exception
     when no_data_found then 
         return psqlerrm;
  end translate_message;
 
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_class(
    papiversion number
   ,pday       date
   ,phour      number
   ,pfill      number
   ,psub_id    number
   ,pfor_id    number
   ,plec_ids   varchar2
   ,pgro_ids   varchar2
   ,prom_ids   varchar2
   ,powner     varchar2
   ,pcreator   varchar2
   ,out_class_id out number    
  ) is
  begin
    debug ('insert_class:' || 
      papiversion||':'||
      to_char(pday,'yyyy-mm-dd')||':'||
      phour      ||':'||
      pfill      ||':'||
      psub_id    ||':'||
      pfor_id    ||':'||
      plec_ids   ||':'||
      pgro_ids   ||':'||
      prom_ids   ||':'||
      powner     ||':'||
      pcreator );
    if papiversion <> 1 then 
      raise_application_error(planner_utils.exc_API_ver_error, 'API version error');
    end if;
    if plec_ids is null and pgro_ids is null and prom_ids is null then
      raise_application_error(planner_utils.exc_lecgrorom_null, 'Class without lecturer and group and resource');
    end if;  
    --savepoint planner_api;
    --
    begin    
      insert into planners (id, name, type, colour) values ( main_seq.nextval, pcreator, 'EXTERNAL',  dbms_random.value(0,255) + 256*dbms_random.value(0,255) + 256*256*dbms_random.value(0,255)  ); 
    exception
     when dup_val_on_index then null;
    end;
    --
    declare
     ppla_id number;
    begin
     select id into ppla_id from planners where name = powner;
    exception
      when no_data_found then raise_application_error(planner_utils.exc_wrong_owner_name, 'Wrong owner name');
    end;
    --
    planner_utils.insert_classes(
      pday             => pday           
     ,phour            => phour           
     ,pfill            => pfill           
     ,psub_id          => psub_id        
     ,pfor_id          => pfor_id         
     ,pcalc_lec_ids    => plec_ids   
     ,pcalc_gro_ids    => pgro_ids  
     ,pcalc_rom_ids    => prom_ids   
     ,pcalc_lecturers  => null 
     ,pcalc_groups     => null   
     ,pcalc_rooms      => null     
     ,powner           => powner      
     ,pcreator         => pcreator     
     ,prefreshLGR      => 'Y'
     ,pgrantPermissions=> 'Y'
    );
    out_class_id  := planner_utils.output_param_num1; 
  exception
  when others then
    rollback; -- to savepoint planner_api;
    raise;  
  end insert_Class;
  
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function can_insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
   ) return varchar2 is
  pragma autonomous_transaction;
  out_class_id number; 
  begin
    debug('can_insert_class');    
    insert_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,out_class_id
    );
    rollback;
    return 'Y';
  end can_insert_class; 

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2 
   ) return number is
  pragma autonomous_transaction;
  out_class_id number; 
  begin
    insert_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,out_class_id
    );
    commit;
    return out_class_id;
  end insert_class; 


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function delete_class ( pid number ) return varchar2 is
  pragma autonomous_transaction; 
  begin
    delete_class(pid);
    commit;
    return null;
  end delete_class;
  

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_class(
    papiversion number
   ,pday       date
   ,phour      number
   ,pfill      number
   ,psub_id    number
   ,pfor_id    number
   ,plec_ids   varchar2
   ,pgro_ids   varchar2
   ,prom_ids   varchar2
   ,powner     varchar2
   ,pcreator   varchar2
   ,in_out_class_id in out number    
  ) is
  begin
    debug('update_class:'||in_out_class_id);
    delete_class ( in_out_class_id );
    insert_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,in_out_class_id
    );
  exception
  when others then
    rollback; 
    raise;  
  end update_class;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function update_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
    ,pclass_id in number 
   ) return number is
  pragma autonomous_transaction;
  in_out_class_id number;
  begin
    in_out_class_id := pclass_id;
    update_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,in_out_class_id
    );
    commit;
    return in_out_class_id;
  end update_class; 


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure delete_class ( pid number ) is
  begin
    planner_utils.delete_class ( pid );
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure delete_orphaned (p_user varchar2 ) is
  begin
    for rec in (select id from classes where not exists (select 1 from periods where day between date_from and date_to) and owner= p_user) loop
      delete_class ( rec.id );
    end loop;
  end delete_orphaned; 

end;
/

CREATE OR REPLACE package tt_planner is

   /*****************************************************************************************************************************
   |* Public api to create available combinations and check if there available combination exists
   |  Do not change database manually. instead of this, use this package.
   |  TT is a shorcut for time table. 
   |
   |   Data model
   |   
   |      TT_RESCAT_COMBINATIONS  
   |       -< TT_COMBINATIONS                 [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_COMBINATIONS_FK1
   |           -< TT_INCLUSIONS               [TT_COMB_ID]     NULLABLE:N CNAME:TT_INCLUSIONS_FK1
   |           -< TT_RESOURCE_LISTS           [TT_COMB_ID]     NULLABLE:N CNAME:TT_RESOURCE_LISTS_FK1
   |           -< TT_CLA                      [TT_COMB_ID]     NULLABLE:N CNAME:TT_CLA_FK2
   |               >- CLASSES                 [CLA_ID]         NULLABLE:N CNAME:TT_CLA_FK1
   |       -< TT_PLA                          [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_PLA_FK2
   |           >- PLANNERS                    [PLA_ID]         NULLABLE:N CNAME:TT_PLA_FK1
   |       -< TT_RESCAT_COMBINATIONS_DTL      [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_RESCAT_COMBINATIONS_DTL_FK1
   |           >- RESOURCE_CATEGORIES         [RESCAT_ID]      NULLABLE:N CNAME:TT_RESCAT_COMBINATIONS_DTL_FK2
   |      
   |  Summary
   |    function  put_combination - Adds/updates combination and returns combination id
   |    procedure put_combination - Same as function, does not returns combination id (for your convienence) 
   |  
   |    function verify           - Checks whether combination exists, populates result table tt_check_results
   |    procedure verify        - Same as function, does not returns status (for yout convienence)
   |
   |    get_review_sql            - Gets sql to review combinations in user frendly way. sql shows combinations according do passed resources and resource categories only
   |
   |*****************************************************************************************************************************
   | History
   | 2011.08.07 Maciej Szymczak created 
   | 2011.09.01 Maciej Szymczak updates
   | 2011.11.17 Maciej Szymczak updates (bind params)
   | 2011.11.27 Maciej Szymczak updates (performance improvement)
   | 2011.11.29 Maciej Szymczak updates (log improvement)
   | 2012.01.14 Maciej Szymczak disable_res_limitation 
   | 2012.02.18 Maciej Szymczak get_rescat_desc - changes
   | 2012.07.14 Maciej Szymczak function get_res_desc - changes, function get_tt_comb_res_desc - new
   | 2013.11.03 bugfixing  
   \-----------------------------------------------------------------------------------------------------------------------------*/
   
g_form      number := -2;
g_subject   number := -3;
g_lecturer  number := -4;
g_group     number := -5;
g_planner   number := -6;
g_period    number := -7;
g_date_hour number := -8;


----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : put_combination
description      : inserts or updates combination. 
Impact on tables : tt_combinations, tt_inclusions, tt_resource_lists
used by          : TFBrowseTT_COMBINATIONS.AfterPost
parameters       : p_res_ids           - comma separated resource list
                   p_all_rescat_ids    - comma separated resource category list. all resources of this category are always permitted (parameter p_res_ids should not contain resources of this type)
                   p_tt_comb_id        - on insert should be null
                                         on update should be tt_combinations.id
                   p_avail_type        - 'N' for non limit combination (any number of combinations is permitted) , 'L' for limit combination (plan table)
                   p_avail_orig        - when p_avail_type is 'N' then left null
                                         when p_avail_type is 'L' then original numer of classes to plan
                   p_avail_curr        - on insert should be null
                                         ob update this is p_avail_orig - numer of scheduled classes
                   p_enabled           - 'Y' for combination enabled, 'N' for combination disabled ( not active )
                   p_sort_order        - sort order which may be used on form ( for visual effect )
return value     : new tt_class id
*/
function put_combination (
  p_rescat_comb_id  number
 ,p_res_ids         varchar2
 ,p_all_rescat_ids  varchar2 default null
 ,p_tt_comb_id      number   default null
 ,p_avail_type      varchar2  
 ,p_avail_orig      number  
 ,p_avail_curr      number 
 ,p_enabled         char 
 ,p_sort_order      number
) return number;
      
----------------------------------------------------------------------------------------------------------------------------------------------
-- does the same as function put_combination, no result value
procedure put_combination (
  p_rescat_comb_id  number
 ,p_res_ids         varchar2
 ,p_all_rescat_ids  varchar2 default null
 ,p_tt_comb_id      number   default null
 ,p_avail_type      varchar2  
 ,p_avail_orig      number  
 ,p_avail_curr      number 
 ,p_enabled         char 
 ,p_sort_order      number
);

----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : verify
description      : verifies whether combination is valid 
Impact on tables : no impact
used by          : TFmain.insertClasses
                   TFTTCheckResults.fbrowseClick ( after new combination is added)
                   TFBrowseTT_COMBINATIONS.checkRecord ( to check, wheter this combination really must be insert )                    
parameters       : p_pla_id          - planners.id. Only tt_combinations active for this planners are validated ( table TT_PLA )
                   p_res_ids         - comma separated resource list 
                   p_auto_fix        - 'Y' means that missed combination will automatically added to the system configuration. When p_auto_fix=Y then function always returns N
                   p_current_comb_id - eliminates current combination from checking. Parametr used by TFBrowseTT_COMBINATIONS.checkRecord only on update record
                   p_no_subsets      - 'Y' means that subcombinations are not examined. parameter curently not used.
return value     :'N' - there is a problem, not all combinations required were found. Use this sql to see details
                        select * from tt_check_results
                  'Y' - OK      
examples
  declare
   l_res varchar2(100);
  begin
   l_Res := planner_tt.verify ('1000117,4000403,4000401', 'Y');
   --raise_application_error(-20000, 'l_res=' || l_res);
  end;
  select id, found_tt, res_id1, rescat_id1, res_desc1, res_id2, rescat_id2, res_desc2, res_id3, rescat_id3, res_desc3, res_id4, rescat_id4, res_desc4, res_id5, rescat_id5, res_desc5, res_id6, rescat_id6, res_desc6, res_id7, rescat_id7, res_desc7, res_id8, rescat_id8, res_desc8, res_id9, rescat_id9, res_desc9, res_id10, rescat_id10, res_desc10 from tt_check_results
*/
function  verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' ) return varchar2;   
procedure verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' );         
   

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : get_rescat_id, get_res_desc
description      : return resource category id and resource description for given resource id
Impact on tables : no impact
used by          : TFmain.BSelectCombClick
                   UFDetails.BSelectCombClick
                   TFBrowseTT_COMBINATIONS.BeforeEdit
parameters       : p_res_id - resource id lecturer.id or group.id of rooms.id or planners.id or periods.id of forms.id or subjects.id
return value     : get_rescat_id - resource category id ( resource_categories.id)
                   get_res_desc  - name of resource
*/
function get_rescat_id   (p_res_id number) return number;
function get_res_desc    (p_res_id number, p_rescat_id number default null, p_include_res_type varchar2 default 'Y') return varchar2;



-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : get_resource_cat_names
description      : gets names of resource categories selected in combination type (table tt_rescat_combinations)
Impact on tables : no impact
used by          : module DM
                   UFBrowseTT_COMBINATIONS.RESCAT_COMB_IDChange
parameters       : prescat_comb_id - tt_rescat_combinations.id
return value     : names of resource categories selected in combination type 
*/
function get_resource_cat_names ( prescat_comb_id number ) return varchar2;


-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : populate_rescat_comb_dtl
description      : gets names of resource categories selected in combination type (table tt_rescat_combinations)
Impact on tables : tt_rescat_combinations_dtl ( insert / delete ) 
used by          : TFBrowseTT_RESCAT_COMBINATIONS.AfterPost
parameters       : prescat_comb_id - tt_rescat_combinations.id
                   l_rescat_ids    - comma separated list of resource categories ( resource_categories.id )
return value     : - 
*/
procedure populate_rescat_comb_dtl (prescat_comb_id number, l_rescat_ids varchar2);

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : get_filter
description      : gets where clause for statement: select * from tt_combinations where ...
Impact on tables : - 
used by          : TFBrowseTT_COMBINATIONS.CustomConditions
parameters       : p_res_ids - comma separated list od resources
return value     : - 
*/
function get_filter (p_res_ids varchar2) return varchar2;

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : set_res_limitation
description      : gets where clause for statement: select * from <resource table> where ...
                   limits LOV of resources to available resources only
Impact on tables : - 
used by          : TFDetails.setResLimitation
parameters       : p_pla_id    - planners.id. Only tt_combinations active for this planners are validated ( table TT_PLA )
                   p_res_ids   - comma separated list of values selected by user formaly
                   p_rescat_id - LOV resource category id (resource_categories.id)
return value     : no return value. Non available resource list is saved to temporary table tt_ids. 
                   Then, application limits LOV this way: <resource table>.id in (select id from <resource table> minus select  id from tt_ids)
*/
procedure set_res_limitation ( p_pla_id number, p_res_ids  varchar2, p_rescat_id number);
 
----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : book_combination, unbook_combination
description      : book_combination decreates current use combination ( tt_combinations.avail_cur ) 
                   unbook_combination increates current use combination ( tt_combinations.avail_cur )
Impact on tables : tt_cla (select)
used by          : planner_utils.insert_classes
parameters       : p_tt_comb_id - combination to increase/decrease
return value     : comma separated tt_cla.tt_comb_id values
*/
procedure book_combination ( p_tt_comb_id number, punits number );
procedure unbook_combination ( p_tt_comb_id number, punits number  );

----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : recalc_book_combination
description      : complex function, which recalculates utilization of combination
Impact on tables : tt_combinations (update)
used by          : TFBrowseTT_COMBINATIONS.Recalculate_AVAIL_CURR
parameters       : p_tt_comb_id - combination recualculation
return value     : -
*/
procedure recalc_book_combination ( p_tt_comb_id number );    
 
----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : set_res_limitation
description      : gets comma separated tt_cla records for given classed.id. Used by : move, copy and other group functions
                   does not check combinations. just use old ones and thus makes operation faster
Impact on tables : tt_cla (select)
used by          : TFMain.modifyClass
parameters       : p_cla_id - classes.id
return value     : comma separated tt_cla.tt_comb_id values
*/
function get_tt_cla ( p_cla_id number ) return varchar2;





------------------------------------- internal routines ----------------------------------------------------------------------------------------------
/*
function         : bitor
description      : calculates distinct sum of wieghts of resource caterogies
Impact on tables : - 
used by          : tt_planner.verify
parameters       : x1..x30 numbers (this numbers are from domain: 2^0, 2^1, 2^2, 2^3, .. )
return value     : logical OR
*/
function bitor(x1 in number
             , x2 in number default 0
             , x3 in number default 0
             , x4 in number default 0
             , x5 in number default 0
             , x6 in number default 0
             , x7 in number default 0
             , x8 in number default 0
             , x9 in number default 0
             , x10 in number default 0
             , x11 in number default 0
             , x12 in number default 0
             , x13 in number default 0
             , x14 in number default 0
             , x15 in number default 0
             , x16 in number default 0
             , x17 in number default 0
             , x18 in number default 0
             , x19 in number default 0
             , x20 in number default 0
             , x21 in number default 0
             , x22 in number default 0
             , x23 in number default 0
             , x24 in number default 0
             , x25 in number default 0
             , x26 in number default 0
             , x27 in number default 0
             , x28 in number default 0
             , x29 in number default 0
             , x30 in number default 0
             )
  return number deterministic parallel_enable;


---------------------------------- Currently not used routines --------------------------------------------------------------------------------
/*
function         : get_review_sql 
description      : gets sql to review combinations in user frendly way
                   sql shows combinations according do passed resources and resource categories only
                   Currently not used.
Impact on tables : no impact
used by          : TFTTCombinations.BRefreshClick             
parameters       : p_res_ids    - comma separated list of resources
                   p_rescat_ids - comma separated list of resource categories
return value     : sql statement
*/
function get_review_sql (p_res_ids varchar2, p_rescat_ids varchar2) return varchar2;

-- used by get_review_sql
function get_rescat_desc (p_rescat_id number) return varchar2;
function get_tt_comb_res_desc (p_tt_comb_id number, p_rescat_id number default null) return varchar2;

end tt_planner;
/

CREATE OR REPLACE package body tt_planner is

debug_mode boolean;
disable_res_limitation boolean;

--used by functions function execute_immediate
   g_table      dbms_sql.varchar2s;
   g_c          number;
   g_rc         number;
   g_result     varchar2(4000);

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure wlog ( pmessage varchar2, pparameters clob) is
pragma autonomous_transaction;
begin
 if not debug_mode then return; end if;
 insert into tt_log (id, message, parameters) values (tt_seq.nextval, pmessage, pparameters);
 commit;
end wlog;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function bitor(x1 in number
             , x2 in number default 0
             , x3 in number default 0
             , x4 in number default 0
             , x5 in number default 0
             , x6 in number default 0
             , x7 in number default 0
             , x8 in number default 0
             , x9 in number default 0
             , x10 in number default 0
             , x11 in number default 0
             , x12 in number default 0
             , x13 in number default 0
             , x14 in number default 0
             , x15 in number default 0
             , x16 in number default 0
             , x17 in number default 0
             , x18 in number default 0
             , x19 in number default 0
             , x20 in number default 0
             , x21 in number default 0
             , x22 in number default 0
             , x23 in number default 0
             , x24 in number default 0
             , x25 in number default 0
             , x26 in number default 0
             , x27 in number default 0
             , x28 in number default 0
             , x29 in number default 0
             , x30 in number default 0
             )
  return number deterministic parallel_enable
is
    function or2args(x in number, y in number)
      return number deterministic parallel_enable
    is
    begin
      return x + y - bitand(x, y);
    end;
begin
  return or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(x1, x2),x3),x4),x5),x6),x7),x8),x9),x10),x11),x12),x13),x14),x15),x16),x17),x18),x19),x20),x21),x22),x23),x24),x25),x26),x27),x28),x29),x30);
end bitor;


-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_rescat_id (p_res_id number) return number is
  res number;
begin
  select coalesce (
        (select g_form     from forms     where id = p_res_id)
       ,(select g_subject  from subjects  where id = p_res_id)
       ,(select g_lecturer from lecturers where id = p_res_id)
       ,(select g_group    from groups    where id = p_res_id)
       ,(select rescat_id  from rooms     where id = p_res_id)
       ,(select g_planner  from planners  where id = p_res_id)
       ,(select g_period   from periods   where id = p_res_id)
       ) 
  into res
  from dual;
  return res;
end get_rescat_id; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_resource_table_name (p_rescat_id number) return varchar2 is
begin
  case p_rescat_id 
    when g_form     then return 'forms'; 
    when g_subject  then return 'subjects';
    when g_lecturer then return 'lecturers';
    when g_group    then return 'groups';
    when g_planner  then return 'planners';
    when g_period   then return 'periods';
    else return 'rooms';  
  end case;
end get_resource_table_name; 



-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_res_desc (p_res_id number, p_rescat_id number default null, p_include_res_type varchar2 default 'Y') return varchar2 is
  res        varchar2(240);
  res_name   varchar2(240);
  l_rescat_id number := p_rescat_id;
begin
  if p_res_id is null then return null; end if;
  --
  if l_rescat_id is null then
    l_rescat_id :=  get_rescat_id (p_res_id);
  end if;
  --
  select sql_name
    into res_name 
    from resource_categories where id = l_rescat_id;
 
  case l_rescat_id 
    when  g_form     then execute immediate 'select ' || res_name || ' from forms     where id = :id' into res using p_res_id;
    when  g_subject  then execute immediate 'select ' || res_name || ' from subjects  where id = :id' into res using p_res_id;
    when  g_lecturer then execute immediate 'select ' || res_name || ' from lecturers where id = :id' into res using p_res_id;
    when  g_group    then execute immediate 'select ' || res_name || ' from groups    where id = :id' into res using p_res_id;
    when  g_planner  then execute immediate 'select ' || res_name || ' from planners  where id = :id' into res using p_res_id;
    when  g_period   then execute immediate 'select ' || res_name || ' from periods   where id = :id' into res using p_res_id;
    -- rescat_id
    else                  
      select name||' '||substr(attribs_01,1,55)                                   
        into res 
        from rooms   
       where id = p_res_id;                              
  end case;
  if p_include_res_type = 'Y' then return get_rescat_desc (l_rescat_id) || ': ' || res;
                              else return res; end if;
exception
 when others then   
   raise_application_error(-20000, 'get_res_desc. p_res_id=' || p_res_id || ' l_rescat_id=' || l_rescat_id || 'sqlerrm=' || sqlerrm);
end get_res_desc; 


-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_rescat_desc (p_rescat_id number) return varchar2 is
  res varchar2(240);
begin
  select upper(name) 
    into res
    from resource_categories 
   where id = p_rescat_id;
  -- 
  return res;
exception
 when others then   
   raise_application_error(-20000, 'get_rescat_desc. p_rescat_id=' || p_rescat_id);
end get_rescat_desc; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure parse_immediate (p_clobe_proc clob, p_return_value boolean) is
  ------------------------------------------------------------------------------------
  procedure clob_to_table (p_clob in clob, p_table in out nocopy dbms_sql.varchar2s) is
    c_length       constant number := 200; --not 256 : polish chars can be stored on 2 bytes
    v_licznik      binary_integer;
    v_rozmiar      number;
  begin
    v_rozmiar := dbms_lob.getlength(p_clob);
    v_licznik := ceil(v_rozmiar / c_length);
    if v_licznik > 0 then
      p_table.delete;
      for i in 1..v_licznik loop
        if i != v_licznik then
          p_table(i) := dbms_lob.substr(p_clob, c_length, (i - 1) * c_length + 1);
        else
          p_table(i) := dbms_lob.substr(p_clob, v_rozmiar - (i - 1) * c_length, (i - 1) * c_length + 1);
        end if;
      end loop;
    end if;
  end;
  ------------------------------------------------------------------------------------
begin
    g_table.delete;
    clob_to_table(p_clobe_proc, g_table);
    g_c := dbms_sql.open_cursor;
    dbms_sql.parse(g_c, g_table, g_table.first, g_table.last, false, 1);
    if p_return_value then        
      dbms_sql.define_column(g_c,1,g_result,4000);
    end if;
end parse_immediate;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function execute_immediate (p_return_value boolean) return varchar2 is
begin
    g_rc := dbms_sql.execute(g_c);
    
    if p_return_value then        
      if dbms_sql.fetch_rows(g_c) >0 then
        dbms_sql.column_value(g_c, 1, g_result);
      end if;        
    end if;
    
    dbms_sql.close_cursor(g_c);
    return g_result;
end execute_immediate;



-------------------------------------------------------------------------------------------------------------------------------------------------------
function put_combination (
  p_rescat_comb_id  number
 ,p_res_ids         varchar2
 ,p_all_rescat_ids  varchar2 default null
 ,p_tt_comb_id      number   default null
 ,p_avail_type      varchar2  
 ,p_avail_orig      number  
 ,p_avail_curr      number 
 ,p_enabled         char 
 ,p_sort_order      number
) return number is
 l_tt_comb_id      number;
 l_res_ids         varchar2(32000) := replace(p_res_ids,';',',');
 l_all_rescat_ids  varchar2(32000) := replace(p_all_rescat_ids,';',',');
 --
 procedure add_inclusion (p_rescat_id number, p_rescat_incl_type varchar2) is
 begin
   insert into tt_inclusions (id, tt_comb_id, rescat_id, inclusion_type) values (tt_seq.nextval, l_tt_comb_id, p_rescat_id, p_rescat_incl_type);
 exception
  when dup_val_on_index then null; --ignore duplicates
  when others then raise_application_error(-20000, 'p_rescat_id=' || p_rescat_id || ' ' || sqlerrm);
 end;
--------------- 
begin
  -- erase redundand commas, for example: 1,,,2,,,,, --> 1,2
  -- redundant commas are generated by put_combination inside verify
  l_res_ids := trim(',' from l_res_ids);
  --while length( l_res_ids ) <> length ( replace(l_res_ids,',,',',') ) loop
  --  l_res_ids := replace(l_res_ids, ',,',',');
  --end loop;
  --   
  wlog('put_combination(+)', l_res_ids);
  savepoint put_combination;
  if p_tt_comb_id is null then
    select tt_seq.nextval into l_tt_comb_id from dual;
    insert into tt_combinations (id, rescat_comb_id, avail_type, avail_orig, avail_curr, enabled, sort_order) values ( l_tt_comb_id, p_rescat_comb_id, p_avail_type, p_avail_orig, p_avail_curr, p_enabled, p_sort_order );
  else
    delete from tt_inclusions     where tt_comb_id = p_tt_comb_id;
    delete from tt_resource_lists where tt_comb_id = p_tt_comb_id;
    l_tt_comb_id := p_tt_comb_id;
  end if;   
  --
  declare
    l_res_id number;
  begin
    for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
      l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
      if l_res_id is not null then 
        insert into tt_resource_lists (id, tt_comb_id, res_id) values (tt_seq.nextval, l_tt_comb_id,  l_res_id );
        add_inclusion ( get_rescat_id(l_res_id), 'LIST' );
      end if;
    end loop;
  end; 
  --
  declare
    l_rescat_id number;
  begin
    for t in 1 .. xxmsz_tools.wordcount( l_all_rescat_ids, ',') loop
      l_rescat_id := regexp_substr(l_all_rescat_ids, '([0-9]|[-])+', 1, t/*get t-th element*/);  
      if l_rescat_id is not null then 
        add_inclusion ( l_rescat_id, 'ALL' );
      end if;
    end loop;
  end;
  -- 
  update tt_combinations c
     set rescat_comb_id = p_rescat_comb_id
       , weight         = (select sum( (select weight from resource_categories rc where rc.id = ri.rescat_id) ) from tt_inclusions ri where tt_comb_id = c.id)
       , avail_type     = p_avail_type        
       , avail_orig     = p_avail_orig        
       , avail_curr     = p_avail_curr       
       , enabled        = p_enabled          
       , sort_order     = p_sort_order      
   where id = l_tt_comb_id;
  return l_tt_comb_id;
end put_combination; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure put_combination (
  p_rescat_comb_id  number
 ,p_res_ids             varchar2
 ,p_all_rescat_ids      varchar2 default null
 ,p_tt_comb_id          number   default null
 ,p_avail_type          varchar2  
 ,p_avail_orig          number  
 ,p_avail_curr          number 
 ,p_enabled             char 
 ,p_sort_order          number
) is
 l_dummy  number;
begin
 l_dummy := put_combination (
    p_rescat_comb_id
   ,p_res_ids   
   ,p_all_rescat_ids 
   ,p_tt_comb_id
   ,p_avail_type        
   ,p_avail_orig        
   ,p_avail_curr       
   ,p_enabled          
   ,p_sort_order      
   );
end put_combination;


-------------------------------------------------------------------------------------------------------------------------------------------------------
function verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N') return varchar2 
is
  l_res_ids     varchar2(32000) := replace(p_res_ids, ';', ',' );
  l_complete_sql varchar2(32000);
  --
  l_select_cols        varchar2(32000);
  l_select_cols_sel    varchar2(32000);
  l_where_clause       varchar2(32000);
  l_data_select        varchar2(32000);
  l_where_weight       varchar2(4000);
  l_where_cardinality  varchar2(4000);
  l_order_by           varchar2(4000);
  l_no_subsets         varchar2(4000);
  l_elem_count         number;
  --l_rescat_count       number := 0;
  --l_sum_rescat_weight  number := 0;
-------------------------------------------------------
begin
  wlog('verify(+)', 'p_res_ids=' || p_res_ids );
  declare
    l_col_name      varchar2(10);
  begin
    l_elem_count := xxmsz_tools.wordcount( l_res_ids, ','); 
    for t in 1 .. l_elem_count  loop
      l_col_name  := 'res_id'||t;
      -- not already added => add 
      --if bitand(l_sum_rescat_weight, l_rescat_weight) = 0 then
      --  l_sum_rescat_weight := l_sum_rescat_weight + l_rescat_weight; 
      --  l_rescat_count := l_rescat_count + 1;
      --end if;
      l_select_cols        := l_select_cols || l_col_name ||', rescat_id'||t||', res_desc'||t||',';
      l_select_cols_sel    := l_select_cols_sel || l_col_name ||', rescat_id'||t||', decode('||l_col_name||',null,null,res_desc'||t||'),';
      l_where_clause       := l_where_clause || 'and ( ttc.id in ( select tt_comb_id from tt_resource_lists where res_id = res_id'||t||' ) or res_id'||t||' =0 or ttc.id in (select tt_comb_id from tt_inclusions where rescat_id = rescat_id'||t||' and inclusion_type = ''ALL'') ) ';
      l_data_select        := xxmsz_tools.merge( 
                                 l_data_select 
                               , '( select :id'||t||' '||l_col_name||', :rc_id'||t||' rescat_id'||t||', :rc_w'||t||' rescat_weight'||t||', :r_desc'||t||' res_desc'||t||', 1 grouping_res_id'||t||' from dual union all select 0,0,0,''-'',0 from dual)'
                               , ',');
      -- combination (group, subject, form)  has weight 8 + 32 + 64 = 104     and cardinality 3
      -- combination (lecturer, subject)     has weight 16 + 32     = 48      and cardinality 2
      -- combination (group, group, subject) has weight 8 + 8 + 32  = 48 (!!) and cardinality 3
      -- thus thanks cardinality combination (group, group, subject) differs from (lecturer, subject) 
      -- moreover thanks to cardinality we can identity combination (group, group) which has weight 8+8=16 (same as lecturer) but cardinality 2
      l_where_weight       := xxmsz_tools.merge( l_where_weight, 'rescat_weight'||t, '+' ); 
      l_where_cardinality  := xxmsz_tools.merge( l_where_cardinality, 'grouping_res_id'||t, '+' ); 
      l_order_by           := xxmsz_tools.merge( l_order_by, to_char(t*3), ', ' );
      l_no_subsets         := xxmsz_tools.merge( l_no_subsets, 'grouping_res_id'||t||'=1', ' and ');
    end loop;
  end;
  --
  delete from tt_check_results;
  --
  l_complete_sql := 
  'insert into tt_check_results (id, '||l_select_cols||' found_tt, rescat_comb_id)
  select tt_check_results_seq.nextval, '||l_select_cols_sel ||'
         (select ttc.id 
            from tt_combinations ttc, tt_rescat_combinations  ttrc, tt_pla 
            where rownum = 1 and tt_pla.pla_id = :p_pla_id1 and ttrc.id  = ttc.rescat_comb_id and tt_pla.rescat_comb_id = ttrc.id and ttc.enabled = ''Y'' /*and (avail_type=''N'' or (avail_type=''L'' and avail_curr > 0))*/ and ttc.weight=distinct_weight_sum and ttc.id<>:p_current
              '|| l_where_clause ||'
         ) tt_found
         , ( select id from tt_rescat_combinations where combination_number = this_weight and cardinality = this_cardinality )
    from (
         select '||l_select_cols||' tt_planner.bitor('|| replace(l_where_weight,'+',',')  ||') distinct_weight_sum, '|| l_where_weight || ' this_weight,' || l_where_cardinality ||' this_cardinality
           from '|| l_data_select ||'
         where ('|| l_where_weight || ',' || l_where_cardinality ||') in (select combination_number, cardinality from tt_rescat_combinations ttrc, tt_pla where tt_pla.rescat_comb_id = ttrc.id and tt_pla.pla_id = :p_pla_id2) 
             and '|| xxmsz_tools.iif(p_no_subsets='Y', l_no_subsets, '0=0' )  ||'
          order by '||l_order_by||'
         )
  ';  
  
  wlog('l_complete_sql', l_complete_sql);
  
  declare
    l_dummy varchar2(1);
    l_cnt   number;
    l_comb_id number;
    l_res_id        varchar2(100);
    l_rescat_id     number;
    l_rescat_weight number;
  begin
    delete from tt_check_results;
    begin 
      parse_immediate ( l_complete_sql, false);
      for t in 1 .. l_elem_count  loop
        l_res_id    := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
        if l_res_id is null then
          raise_application_error(-20000, 'verify t='||t||' p_res_ids='||p_res_ids);
        end if;
        l_rescat_id := get_rescat_id(l_res_id);
        select weight
          into l_rescat_weight 
          from resource_categories 
         where id = l_rescat_id;
        dbms_sql.bind_variable( g_c, ':id'    ||t , to_number(l_res_id) );
        dbms_sql.bind_variable( g_c, ':rc_id' ||t , l_rescat_id         );
        dbms_sql.bind_variable( g_c, ':rc_w'  ||t , l_rescat_weight     );      
        dbms_sql.bind_variable( g_c, ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
        wlog( ':id'    ||t , l_res_id );
        wlog( ':rc_id' ||t , to_char(l_rescat_id)         );
        wlog( ':rc_w'  ||t , to_char(l_rescat_weight)     );      
        wlog( ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
      end loop;  
      dbms_sql.bind_variable( g_c, ':p_pla_id1'  , p_pla_id );      
      dbms_sql.bind_variable( g_c, ':p_pla_id2'  , p_pla_id );      
      dbms_sql.bind_variable( g_c, ':p_current'  , p_current_comb_id );      
      wlog( ':p_pla_id1'  , to_char(p_pla_id) );      
      wlog( ':p_pla_id2'  , to_char(p_pla_id) );      
      wlog( ':p_current'  , to_char(p_current_comb_id) );            
      l_dummy := execute_immediate ( false);
    exception
      when others then
      raise; 
    end;
    select count(1) into l_cnt from tt_check_results where found_tt is null;
    if l_cnt > 0 then 
      -- at least combination not found
      if p_auto_fix = 'Y' then        
        for rec in (select tt_check_results_rowid, concatenated_res_ids, rescat_comb_id from tt_check_results_v where found_tt is null)
        loop
          l_comb_id := put_combination ( rec.rescat_comb_id, rec.concatenated_res_ids, '', '', 'N', null,null,'Y',null );          
          update tt_check_results set found_tt = l_comb_id where rowid = rec.tt_check_results_rowid ; 
        end loop;
        return 'Y';
      else
        return 'N'; 
      end if;
    else 
      -- no records found
      return 'Y'; 
    end if;
  end;
end verify;


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- p_res_ids   - currently selected resources
-- p_rescat_id - resource to select ( get limitation for this resource type )
procedure set_res_limitation ( p_pla_id number, p_res_ids  varchar2, p_rescat_id number) 
is
  l_res_ids     varchar2(32000) := replace(p_res_ids, ';', ',' );
  l_complete_sql varchar2(32000);
  --
  l_select_cols         varchar2(32000);
  l_where_clause        varchar2(32000);
  l_data_select         varchar2(32000);
  l_where_weight        varchar2(4000);
  l_where_cardinality   varchar2(4000);
  l_order_by            varchar2(4000);
  l_resource_table_name varchar2(30);
  l_elem_count          number;
-------------------------------------------------------
begin
  if disable_res_limitation then return; end if;
  wlog('set_res_limitation(+)', 'p_res_ids=' || p_res_ids ||' p_rescat_id=' || p_rescat_id);
  delete from tt_ids;
  if p_res_ids is null then 
    -- no limitation
    return; 
  end if;
  l_resource_table_name := get_resource_table_name (p_rescat_id);
  declare
    l_col_name      varchar2(10);
  begin
    l_elem_count := xxmsz_tools.wordcount( l_res_ids, ','); 
    for t in 1 .. l_elem_count  loop
      l_col_name  := 'res_id'||t;
      l_select_cols        := l_select_cols || l_col_name ||', rescat_id'||t||',';
      l_where_clause       := l_where_clause || 'and ( ttc.id in ( select tt_comb_id from tt_resource_lists where res_id = res_id'||t||' ) or res_id'||t||' =0 or ttc.id in (select tt_comb_id from tt_inclusions where rescat_id = rescat_id'||t||' and inclusion_type = ''ALL'') ) ';
      l_data_select        := xxmsz_tools.merge( 
                                 l_data_select 
                               , '( select '||':id'||t||' '||l_col_name||', '||':rc_id'||t||' rescat_id'||t||', '||':rc_w'||t||' rescat_weight'||t||', '||':r_desc'||t||' res_desc'||t||', 1 grouping_res_id'||t||' from dual union all select 0,0,0,''-'',0 from dual)'
                               , ',');
      l_where_weight       := xxmsz_tools.merge( l_where_weight, 'rescat_weight'||t, '+' ); 
      l_where_cardinality  := xxmsz_tools.merge( l_where_cardinality, 'grouping_res_id'||t, '+' ); 
      l_order_by           := xxmsz_tools.merge( l_order_by, to_char(t*3), ', ' );
    end loop;
  end;
  -- add x
   l_data_select        := xxmsz_tools.merge( 
                              l_data_select 
                            , '( select :xrc_w rescat_weightx, 1 grouping_res_idx from dual x)'
                            , ',');
  l_where_weight       := xxmsz_tools.merge( l_where_weight, 'rescat_weightx', '+' ); 
  l_where_cardinality  := xxmsz_tools.merge( l_where_cardinality, 'grouping_res_idx', '+' ); 
  l_where_clause       := l_where_clause || 'and ( ttc.id in ( select tt_comb_id from tt_resource_lists where res_id = res_idx ) or res_idx =0 or ttc.id in (select tt_comb_id from tt_inclusions where rescat_id = rescat_idx and inclusion_type = ''ALL'') ) ';
  --
  l_complete_sql :=
 -- there is no condition present in verify : (select count(*) from tt_inclusions where tt_comb_id = ttc.id)='||l_rescat_count
 -- because we allow incomplete combination too (combination is W1,G1,S1, user selected W1, then he should see G1 on list even S has not choosen yet)   
'insert into tt_ids (id, tt_found)
 select res_idx, tt_found from
 (
  select res_idx
        ,(select ttc.id 
            from tt_combinations ttc, tt_rescat_combinations  ttrc, tt_pla
           where rownum = 1 and tt_pla.pla_id = :p_pla_id1 and ttrc.id  = ttc.rescat_comb_id and tt_pla.rescat_comb_id = ttrc.id and ttc.enabled = ''Y'' and (avail_type=''N'' or (avail_type=''L'' and avail_curr > 0)) '|| l_where_clause ||'
         ) tt_found 
    from (
         select '||l_select_cols||' null
           from '|| l_data_select ||'
         where ('|| l_where_weight || ',' || l_where_cardinality ||') in (select combination_number, cardinality from tt_rescat_combinations ttrc, tt_pla where tt_pla.rescat_comb_id = ttrc.id and tt_pla.pla_id = :p_pla_id2) 
         )
        ,'||  '( select x.id res_idx, :xrc_id rescat_idx from '||l_resource_table_name||' x)' || ' 
 )';
  wlog('l_complete_sql', l_complete_sql);
  
  --execute immediate l_complete_sql;
  declare
    l_cursor number := dbms_sql.open_cursor;
    l_ignore number;
    --
    l_res_id              varchar2(100);
    l_rescat_id           number;
    l_rescat_weight       number;
  begin
    dbms_sql.parse( l_cursor,  l_complete_sql, dbms_sql.native );
    for t in 1 .. l_elem_count  loop
      l_res_id    := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
      if l_res_id is null then
        raise_application_error(-20000, 'verify t='||t||' p_res_ids='||p_res_ids);
      end if;
      l_rescat_id := get_rescat_id(l_res_id);
      begin
      select weight
        into l_rescat_weight 
        from resource_categories 
       where id = l_rescat_id;
      exception
       when no_data_found then
         raise_application_error(-20000, 'l_res_id='||l_res_id|| '    l_rescat_id=' || l_rescat_id || ' ' || sqlerrm );
      end; 
      dbms_sql.bind_variable( l_cursor, ':id'    ||t , to_number(l_res_id) );
      dbms_sql.bind_variable( l_cursor, ':rc_id' ||t , l_rescat_id         );
      dbms_sql.bind_variable( l_cursor, ':rc_w'  ||t , l_rescat_weight     );      
      dbms_sql.bind_variable( l_cursor, ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
      wlog( ':id'    ||t , l_res_id );
      wlog( ':rc_id' ||t , to_char(l_rescat_id));
      wlog( ':rc_w'  ||t , to_char(l_rescat_weight));      
      wlog( ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
    end loop;  
    --add x
    select weight
      into l_rescat_weight 
      from resource_categories 
     where id = p_rescat_id;    
    dbms_sql.bind_variable( l_cursor, ':xrc_id' , p_rescat_id );      
    dbms_sql.bind_variable( l_cursor, ':xrc_w'  , l_rescat_weight );      
    --
    dbms_sql.bind_variable( l_cursor, ':p_pla_id1'  , p_pla_id );      
    dbms_sql.bind_variable( l_cursor, ':p_pla_id2'  , p_pla_id );   
    wlog( ':xrc_id' , to_char(p_rescat_id) );      
    wlog( ':xrc_w'  , to_char(l_rescat_weight) );      
    wlog( ':p_pla_id1'  , to_char(p_pla_id) );      
    wlog( ':p_pla_id2'  , to_char(p_pla_id) );   
    wlog('set_res_limitation', 'before execute');   
    l_ignore := dbms_sql.execute( l_cursor );
    wlog('set_res_limitation', 'after execute');
    delete from tt_ids where tt_found is null;  
    wlog('set_res_limitation', 'after delete');
    dbms_sql.close_cursor( l_cursor );
  end;
   
  --return 'select id from '|| l_resource_table_name ||' minus select id from tt_ids';
end set_res_limitation;





-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' ) is
 l_dummy varchar2(1);
begin
 l_dummy :=  verify ( p_pla_id, p_res_ids, p_auto_fix, p_current_comb_id, p_no_subsets  );
end verify; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- get sql to review combinations in user frendly way
-- sql shows combinations according do passed resources and resource categories only  
function get_review_sql (p_res_ids varchar2, p_rescat_ids varchar2) return varchar2
is
  l_res_ids         varchar2(32000) := replace(p_res_ids,';',',');
  l_rescat_ids      varchar2(32000) := replace(p_rescat_ids,';',',');
  l_complete_sql    varchar2(32000);
  l_rescat_include1 varchar2(32000);
  l_rescat_include2 varchar2(32000);
  l_res_include     varchar2(32000);
  l_res_exclude     varchar2(32000);
  l_res_id          number;
  l_rescat_id       number;
begin
  if p_res_ids is null or p_rescat_ids is null then
    raise_application_error(-20000, 'p_res_ids and p_rescat_ids have to be not null' );
  end if;
  -- 
  for t in 1 .. xxmsz_tools.wordcount( l_rescat_ids, ',') loop
    l_rescat_id := regexp_substr(l_rescat_ids, '([0-9]|[-])+', 1, t/*get t-th element*/);  
    l_rescat_include1 := xxmsz_tools.merge ( l_rescat_include1 , 'planner_tt.get_rescat_id(res_id)='||l_rescat_id||chr(10), ' or ');
    l_rescat_include2 := xxmsz_tools.merge ( l_rescat_include2 , 'rescat_id='||l_rescat_id||chr(10), ' or ');
  end loop;
  l_rescat_include1 := 'and ('||l_rescat_include1||')';
  l_rescat_include2 := 'and ('||l_rescat_include2||')';
  
  for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
    l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
    l_res_include := l_res_include ||   
         'and ('||chr(10)||
             'tt_comb_id in ( select tt_comb_id from tt_resource_lists where res_id = '||l_res_id||' )'||chr(10)||
          'or tt_comb_id in ( select tt_comb_id from tt_inclusions where rescat_id = '||get_rescat_id (l_res_id)||' and inclusion_type = ''ALL'')'||chr(10)||
             ')'||chr(10);
    l_res_exclude := l_res_exclude ||   
         'and res_id <> '||l_res_id||chr(10);
  end loop;

  l_complete_sql := 
    -- show from inclusions of type 'LIST'
   'select tt_comb_id, planner_tt.get_res_desc (res_id, planner_tt.get_rescat_id (res_id)) description, res_id, ''RES_ID'' type'||chr(10)||
     'from tt_resource_lists'||chr(10)||
     'where 0=0'||chr(10)||
        -- show these categories only:
       l_rescat_include1||
        -- show combination associated with res_id
       l_res_include||
        -- do not show current object, that would be confused for user
       l_res_exclude||
   'union all'||chr(10)||
    -- show from inclusions of type 'ALL'
   'select tt_comb_id, planner_tt.get_rescat_desc ( rescat_id ) || '' - WSZYSCY'' description, rescat_id, ''RESCAT_ID'' type'||chr(10)||
     'from tt_inclusions'||chr(10)||
     'where inclusion_type= ''ALL'''||chr(10)||
        -- show these categories only:
       l_rescat_include2||
        -- show combination associated with res_id
       l_res_include;
 return l_complete_sql;
end get_review_sql;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_filter (p_res_ids varchar2) return varchar2
is
  l_res_ids    varchar2(32000) := replace(p_res_ids,';',',');
  l_filer      varchar2(32000) := '';
  l_res_id     number;
begin
  -- 
  for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
    l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
    l_filer := xxmsz_tools.merge( 
                 l_filer   
                ,  ' ('||chr(10)||
                    'id in ( select tt_comb_id from tt_resource_lists where res_id = '||l_res_id||' )'||chr(10)||
                 'or id in ( select tt_comb_id from tt_inclusions where rescat_id = '||get_rescat_id (l_res_id)||' and inclusion_type = ''ALL'')'||chr(10)||
                    ')'||chr(10)
                ,' and ');
  end loop;
 return l_filer;
end get_filter;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_resource_cat_names ( prescat_comb_id number ) return varchar2 is 
    res        varchar2(4000);
    l_cat_name varchar2(100);
begin
  for rec in (
    select (select name from resource_categories where id = rescat_id) name
      from tt_rescat_combinations_dtl
      where prescat_comb_id = rescat_comb_id
    order by id  
  ) 
  loop
    res := res || ',' || rec.name;  
  end loop;
  return trim(',' from res);
end get_resource_cat_names;


-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure populate_rescat_comb_dtl (prescat_comb_id number, l_rescat_ids varchar2) is
  l_rescat_id number;
  l_weight number;
begin
 delete from tt_rescat_combinations_dtl where rescat_comb_id = prescat_comb_id;
 for t in 1 .. xxmsz_tools.wordcount( l_rescat_ids, ',') loop
   l_weight := regexp_substr(l_rescat_ids, '([0-9]|[-])+', 1, t/*get t-th element*/);  
   select id
     into l_rescat_id
     from resource_categories 
     where weight = l_weight;
   insert into tt_rescat_combinations_dtl (id, rescat_comb_id, rescat_id) values( tt_seq.nextval, prescat_comb_id, l_rescat_id );
 end loop;  
end populate_rescat_comb_dtl;


-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_tt_cla ( p_cla_id number ) return varchar2 is 
 result varchar2(4000) := '';
begin
 for rec in (select tt_comb_id from tt_cla where cla_id = p_cla_id order by id ) loop
   result := result || ',' || rec.tt_comb_id;
 end loop;
 return trim(',' from result);
end get_tt_cla;

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure book_combination ( p_tt_comb_id number, punits number)  is
begin
 for rec in ( select rowid from tt_combinations where id = p_tt_comb_id for update ) loop
   update tt_combinations 
      set avail_curr = avail_curr - punits
    where rowid = rec.rowid;
 end loop;
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure unbook_combination ( p_tt_comb_id number, punits number  )  is
begin
 for rec in ( select rowid from tt_combinations where id = p_tt_comb_id for update ) loop
   update tt_combinations 
      set avail_curr = avail_curr + punits
    where rowid = rec.rowid;
 end loop;
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- this function calculates current utilization of combination
-- in some sense this function is an inverse of function verify
-- use this function when
--   combination has been changed
--   combination has been added after classes were added to the system
procedure recalc_book_combination ( p_tt_comb_id number )  is
 l_cnt          number := 0;
 l_cla_id       number;
 l_fill         number;
 l_fill_sum     number := 0;
 l_complete_sql varchar2(32000);
 l_lec_cond     varchar2(4000);
 l_gro_cond     varchar2(4000);
 l_per_cond     varchar2(4000);
 l_for_cond     varchar2(4000);
 l_sub_cond     varchar2(4000);
 l_pla_cond     varchar2(4000);
 l_res_cond     varchar2(4000);
 type genericcurtyp is ref cursor;
 cur  genericcurtyp;
begin
  wlog('recalc_book_combination(+)', 'p_tt_comb_id=' || p_tt_comb_id );
  for rec in (
    select id, rowid, weight
      from tt_combinations
     where id = p_tt_comb_id
       -- do not calc booking for combinations without limit
       and avail_type = 'L'
  ) loop
     l_complete_sql := 'select id, fill/100 from classes cla where 0=0 '; 
     for rec_incl in ( select rescat_id
                            , inclusion_type 
                         from tt_inclusions 
                        where tt_comb_id = rec.id ) 
     loop
       if rec_incl.inclusion_type = 'LIST' then 
         l_res_cond := ' and rom_cla.rom_id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_lec_cond := ' and         lec_id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_gro_cond := ' and         gro_id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_per_cond := ' and             id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_for_cond := ' and cla.for_id in (select res_id from tt_resource_lists where tt_comb_id = '||rec.id||')';
         l_sub_cond := ' and cla.sub_id in (select res_id from tt_resource_lists where tt_comb_id = '||rec.id||')';
         l_pla_cond := ' and cla.owner in  (select p.name from tt_resource_lists tt, planners p where tt.res_id = p.id tt_comb_id = '||rec.id||')';
       else -- ='ALL'
         l_res_cond := ' and r.rescat_id = ' || rec_incl.rescat_id; 
         l_lec_cond := ' '; 
         l_gro_cond := ' '; 
         l_per_cond := ' '; 
         l_for_cond := ' and cla.for_id is not null';
         l_sub_cond := ' and cla.for_id is not null';
         l_pla_cond := ' and cla.owner is not null';
       end if;         
       -- 
       case rec_incl.rescat_id
        when g_date_hour then raise_application_error(-20000, 'g_date_hour is currently not used');
        when g_planner   then l_complete_sql := l_complete_sql || l_pla_cond; 
        when g_subject   then l_complete_sql := l_complete_sql || l_sub_cond; 
        when g_form      then l_complete_sql := l_complete_sql || l_for_cond; 
        when g_lecturer  then l_complete_sql := l_complete_sql || 'and exists (select 1 from lec_cla          where cla_id = cla.id '||l_lec_cond||')'; 
        when g_group     then l_complete_sql := l_complete_sql || 'and exists (select 1 from gro_cla          where cla_id = cla.id '||l_gro_cond||')'; 
        when g_period    then l_complete_sql := l_complete_sql || 'and exists (select 1 from periods where cla.day between date_from and date_to '||l_per_cond||')'; 
        else                  l_complete_sql := l_complete_sql || 'and exists (select 1 from rom_cla, rooms r where rom_id = r.id and cla_id = cla.id '||l_res_cond||')'; 
       end case;
     end loop;   
     --
     wlog('l_complete_sql', l_complete_sql);
     --
     delete from tt_cla where tt_comb_id = p_tt_comb_id;
     open cur for l_complete_sql;
     loop
       fetch cur into l_cla_id, l_fill;
       exit when cur%notfound;
       insert into tt_cla (id, cla_id, tt_comb_id, units) values (tt_seq.nextval, l_cla_id, p_tt_comb_id, l_fill);
       l_cnt := l_cnt + 1;
       l_fill_sum := l_fill_sum + l_fill;
     end loop;
     close cur;
     --
     update tt_combinations 
        set  avail_curr = avail_orig - l_fill_sum
      where rowid = rec.rowid; 
  end loop;
  wlog('recalc_book_combination(-)',null);  
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_tt_comb_res_desc (p_tt_comb_id number, p_rescat_id number default null) return varchar2 is
 c number;
 res varchar2(2000);
begin
 select count(1)
   into c 
   from tt_inclusions
   where tt_comb_id = p_tt_comb_id 
     and rescat_id = p_rescat_id
     and INCLUSION_TYPE = 'ALL';
 if c <> 0 then return 'WSZYSCY'; end if;    
 --
 res := null;
 for rec in (
    select tt_planner.get_res_desc ( res_id, p_rescat_id, 'N') res
       from tt_resource_lists  x
       where tt_comb_id = p_tt_comb_id
         and tt_planner.get_rescat_id (res_id) = p_rescat_id
 )
 loop
   if res is null then res := rec.res;
                  else res := res ||', '|| rec.res; end if;
 end loop;
 return res;
end get_tt_comb_res_desc; 


begin
  declare
   l_tmp VARCHAR2(100);
  begin
   select value into l_tmp from system_parameters where name = 'TT_LOG';
   debug_mode := l_tmp = 'Y';
   select value into l_tmp from system_parameters where name = 'TT_DISABLE_RES_LIMITATION';
   disable_res_limitation := l_tmp = 'Y'; 
  end;
end tt_planner;
/

CREATE OR REPLACE package google_orgchart is  
    procedure getOrgChart(
         pinclude_lec char
       , pinclude_sub char
       , pinclude_gro char
       , pinclude_rom char
       , ppla_id      varchar2  
       , pentire_db   varchar2       
       , pstruct_code varchar2   
    );  
end;
/

CREATE OR REPLACE package body google_orgchart is  
    
    --@Author: Maciej Szymczak
    --@Created:2015.04.02
    
    res clob;  
       
    --------------------------------------------------------------  
    procedure getOrgChart(
         pinclude_lec char
       , pinclude_sub char
       , pinclude_gro char
       , pinclude_rom char
       , ppla_id      varchar2  
       , pentire_db   varchar2     
       , pstruct_code varchar2    
    )   is  
     counter number := 0;  

  
            --------------------------------------------------------------  
            procedure NewClob  (clobloc       in out nocopy clob,  
                                msg_string    in varchar2) is  
             pos integer;  
             amt number;  
            begin  
               dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);  
               if msg_string is not null then  
                  pos := 1;  
                  amt := length(msg_string);  
                  dbms_lob.write(clobloc,amt,pos,msg_string);  
               end if;  
            end NewClob;  
  
            --------------------------------------------------------------  
            procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is  
             pos integer;  
             amt number;  
            begin  
               pos :=   dbms_lob.getlength(clob_loc) +1;  
               amt := length(msg_string);  
               dbms_lob.write(clob_loc,amt,pos,msg_string);  
            end WriteToClob;  
  
            --------------------------------------------------------------  
            procedure ChunkClob  ( res clob) is
             i number := 0;
             maxLen number := dbms_lob.getlength(res);
             howManyBytes number;
             chunkSize number := 3000;
            begin
              loop
                howManyBytes := dbms_lob.getlength(res)-i+1;
                if howManyBytes > chunkSize then howManyBytes := chunkSize; end if;
                exit when howManyBytes<=0;
                insert into tmp_chunkedclob (id, value) values (main_seq.nextval, dbms_lob.substr( res, chunkSize, 1+i ) );
                i := i + chunkSize;
              end loop;
            end ChunkClob;   
  
    --------------------------------------------------------------   
    begin --getMap 
    
    
        NewClob(res, '');   
        WriteToClob(res,'
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=windows-1250"/>
    <title>
      Plansoft.org - Struktura organizacyjna
    </title>  
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["orgchart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn("string", "Name");
        data.addColumn("string", "Manager");
        data.addColumn("string", "ToolTip");

        data.addRows([
');
        
        -------------------------------------------------------------- 
        declare
          comma varchar2(1) := '';
        begin
          for rec in (
                select id, name, parent_id from org_units 
                where struct_code like pstruct_code||'%'  order by id      
          ) loop
              declare
                -- top organization has no parent organization
                -- top org is when we are the first time in the loop, which means comma is null
                parentOrg number;
              begin
              if comma is null then
                parentOrg := '';
              else
                parentOrg := rec.parent_id;
              end if;
                  WriteToClob(res,comma||'[{v:"'||rec.id||'", f:'''||rec.name||'<div style="color:red; font-style:italic">Jednostka</div>''}, '''||parentOrg||''', ''Jednostka'']
    ');  
              end;
              comma:=',';
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_lec in ('Y') then
                  for recl in (
                        select id, title, last_name, first_name 
                          from lecturers 
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select lec_id from lec_pla where pla_id = ppla_id)) 
                         order by title, last_name, first_name     
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"LECTURERS'||rec.id||'", f:''Wyk≥adowcy''}, '''||rec.id||''', ''Wyk≥adowcy'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recl.id||'", f:'''||recl.title||' '||recl.last_name||' '||recl.first_name||'<div style="color:red; font-style:italic">Wyk≥adowca</div>''}, ''LECTURERS'||rec.id||''', ''Wyk≥adowca'']
    ');  
                  end loop;
                end if;  
                if pinclude_lec in ('C') then
                  for recl in (
                        select id, title, last_name, first_name from lecturers  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select lec_id from lec_pla where pla_id = ppla_id)) 
                        order by title, last_name, first_name     
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"LECTURERS'||rec.id||'", f:''Wyk≥adowcy');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:red; font-style:italic">'||recl.title||' '||recl.last_name||' '||recl.first_name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Wyk≥adowcy'']
    ');  
                  end if;
                end if;  
              end;
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_sub in ('Y') then
                  for recs in (
                        select id, name from subjects
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select sub_id from sub_pla where pla_id = ppla_id)) 
                          order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"SUBJECTS'||rec.id||'", f:''Przedmioty''}, '''||rec.id||''', ''Przedmioty'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recs.id||'", f:'''||recs.name||'<div style="color:green; font-style:italic">Przedmiot</div>''}, ''SUBJECTS'||rec.id||''', ''Przedmiot'']
    ');  
                  end loop;
                end if;  
                if pinclude_sub in ('C') then
                  for recs in (
                        select id, name from subjects  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select sub_id from sub_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"SUBJECTS'||rec.id||'", f:''Przedmioty');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:green; font-style:italic">'||recs.name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Przedmioty'']
    ');  
                  end if;
                end if;  
              end;
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_gro in ('Y') then
                  for recg in (
                        select id, name from groups  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select gro_id from gro_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"GROUPS'||rec.id||'", f:''Grupy''}, '''||rec.id||''', ''Grupy'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recg.id||'", f:'''||recg.name||'<div style="color:blue; font-style:italic">Grupa</div>''}, ''GROUPS'||rec.id||''', ''Grupa'']
    ');  
                  end loop;
                end if;  
                if pinclude_gro in ('C') then
                  for recg in (
                        select id, name from groups  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select gro_id from gro_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"GROUPS'||rec.id||'", f:''Grupy');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:blue; font-style:italic">'||recg.name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Grupy'']
    ');  
                  end if;
                end if;  
              end;
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_rom in ('Y') then
                  for recr in (
                        select id, name from rooms  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select rom_id from rom_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"ROOMS'||rec.id||'", f:''Zasoby''}, '''||rec.id||''', ''Zasoby'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recr.id||'", f:'''||recr.name||'<div style="color:red; font-style:italic">ZasÛb</div>''}, ''ROOMS'||rec.id||''', ''ZasÛb'']
    ');  
                  end loop;
                end if;  
                if pinclude_rom in ('C') then
                  for recr in (
                        select id, name from rooms  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select rom_id from rom_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"ROOMS'||rec.id||'", f:''Zasoby');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:red; font-style:italic">'||recr.name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Zasoby'']
    ');  
                  end if;
                end if;  
              end;
              
          end loop;
        end;
        -------------------------------------------------------------- 
                
    WriteToClob(res,' 
        ]);       
        var chart = new google.visualization.OrgChart(document.getElementById("chart_div"));
        chart.draw(data, {allowHtml:true,allowCollapse:true});
      }
   </script>
   <style type="text/css">
       .google-visualization-orgchart-node {
           width: 240px;
       }
       .google-visualization-orgchart-node-medium {
           vertical-align: top;
       }
   </style>  
    </head>
  <body>
    <div id="chart_div"></div>
  </body>
</html>');

--declare
-- x clob;
--begin
-- newClob(x,'');
-- writeToClob(x,'Test123456789MaciejSzymczakPolska;');
-- ChunkClob(x);
--end;

    ChunkClob(res);
    --return res;  
    end getOrgChart;  
end;
/

CREATE OR REPLACE package google_map is  
    function getMap(
              ppla_id    varchar2  
            , pentire_db varchar2  
            , pscale     varchar2 --scale is a dummy parameter. scale is adjusted automatically
            , pmapTypeId varchar2
    ) return clob;  
end;
/

CREATE OR REPLACE package body google_map is  
     res clob;  
       
    --------------------------------------------------------------  
    function getMap(
              ppla_id varchar2  
            , pentire_db varchar2  
            , pscale     varchar2
            , pmapTypeId varchar2
    ) return clob is  
     counter number := 0;  
     avg_longitude varchar2(200);
     avg_latitude varchar2(200);
  
            --------------------------------------------------------------  
            procedure NewClob  (clobloc       in out nocopy clob,  
                                msg_string    in varchar2) is  
             pos integer;  
             amt number;  
            begin  
               dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);  
               if msg_string is not null then  
                  pos := 1;  
                  amt := length(msg_string);  
                  dbms_lob.write(clobloc,amt,pos,msg_string);  
               end if;  
            end NewClob;  
  
            --------------------------------------------------------------  
            procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is  
             pos integer;  
             amt number;  
            begin  
               pos :=   dbms_lob.getlength(clob_loc) +1;  
               amt := length(msg_string);  
               dbms_lob.write(clob_loc,amt,pos,msg_string);  
            end WriteToClob;  
  
 
    --------------------------------------------------------------   
    begin --getMap 
    
        select replace(to_char(avg(XXMSZ_TOOLS.strToNumber(longitude))),',','.')
             , replace(to_char(avg(XXMSZ_TOOLS.strToNumber(latitude))),',','.') 
          into avg_longitude, avg_latitude 
          from (
              select name 
                   , xxmsz_tools.extractWord(1,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') longitude 
                   , xxmsz_tools.extractWord(2,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') latitude
                from rooms
               where (pentire_db='Y' and 0=0)
                     or
                     (pentire_db='N' and ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = ppla_id))                        
          )
          where xxmsz_tools.isnumber(longitude)='Y' 
            and xxmsz_tools.isnumber(latitude)='Y'
            and latitude is not null
            and latitude is not null;        
    --raise_application_error(-20000, ppla_id ||' ' ||pentire_db||' '|| avg_longitude ||'     '|| avg_latitude );
    
    
        NewClob(res, '');   
        WriteToClob(res,'
<!DOCTYPE html "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <meta http-equiv="content-type" content="text/html; charset=windows-1250" />
 <title>Plansoft.org- zasoby na mapie</title>
 <style type="text/css">
   .labels {
     color: red;
     background-color: transparent;
     font-family: "Lucida Grande", "Arial", sans-serif;
     font-size: 10px;
     font-weight: bold;
     text-align: left;
     width: 140px;     
     border: 0px solid black;
     white-space: nowrap;
   }
 </style>
 <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
 <script type="text/javascript" src="markerwithlabel.js"></script>
 <script type="text/javascript">
   function initMap() {
     var latLng = new google.maps.LatLng('||avg_longitude||', '||avg_latitude||');

     var map = new google.maps.Map(document.getElementById(''map_canvas''), {
       zoom: '||pscale||',
       center: latLng,
			navigationControl: true,
			panControl: true,
			zoomControl: true,
			streetViewControl: true,
			scaleControl: true,
			rotateControl: true,
			overviewMapControl: true,
			overviewMapControlOptions: {
				opened: true
			},
			navigationControlOptions: {
				style: google.maps.NavigationControlStyle.DEFAULT
			},
			mapTypeControl: true,
			mapTypeControlOptions: {
				style: google.maps.MapTypeControlStyle.DEFAULT
			},
       mapTypeId: '||pmapTypeId||'
     });
     var area = new google.maps.LatLngBounds();
');
        
        -------------------------------------------------------------- 
        declare
          point_num integer := 1;
          n         varchar2(50);
        begin
        for rec in (
              select name,attribs_01,desc1,desc2
                   , longitude
                   , latitude 
                from (
                    select name,attribs_01,desc1,desc2
                         , xxmsz_tools.extractWord(1,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') longitude 
                         , xxmsz_tools.extractWord(2,xxmsz_tools.extractWord(1,GOOGLE_LOCATION,'('),',') latitude
                      from rooms
                     where (pentire_db='Y' and 0=0)
                           or
                           (pentire_db='N' and ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = ppla_id))                        
                )
                where xxmsz_tools.isnumber(longitude)='Y' 
                  and xxmsz_tools.isnumber(latitude)='Y'
                  and latitude is not null
                  and latitude is not null
              order by name        
        ) loop

               n := to_char(point_num);
               WriteToClob(res,'
     var marker'||n||' = new MarkerWithLabel({
       position: new google.maps.LatLng('||rec.longitude||', '||rec.latitude||'),
       draggable: true,
       map: map,
       labelContent: "'||rec.attribs_01  || ' ' || rec.name||'",
       labelAnchor: new google.maps.Point(22, 0),
       labelClass: "labels", // the CSS class for the label
       labelStyle: {opacity: 0.9},
	   icon : ''http://maps.google.com/mapfiles/kml/pal4/icon49.png''
     });
     var iw'||n||' = new google.maps.InfoWindow({
       content: "'||rec.attribs_01||' '||rec.name||'<BR/>'||rec.desc1||'<BR/>'||rec.desc2||'<BR/><BR/>'||'"
     });
     google.maps.event.addListener(marker'||n||', "click", function (e) { iw'||n||'.open(map, marker'||n||'); });
     area.extend(new google.maps.LatLng('||rec.longitude||', '||rec.latitude||'));
');  
        point_num := point_num + 1;

        end loop;
        end;
        -------------------------------------------------------------- 

            
                
    WriteToClob(res,'
 
	//var myrectangle = new google.maps.Rectangle({
	//	strokeColor: ''#ff0000'',
	//	strokeWeight: 3,
	//	strokeOpacity: 0.4,
	//	bounds: area,
	//	map: map,
	//	fillColor: ''#ff0000'',
	//	fillOpacity: 0.1
	//});    
    
   map.fitBounds(area); 
   };
 </script>
</head>
<body onload="initMap()">
 <div id="map_canvas" style="height: 100%; width: 100%"></div>
 <p>Plansoft.org - lokalizacja zasobÛw na mapie</p>
</body>
</html>');

        return res;  
    end getMap;  
end;
/

CREATE OR REPLACE package google_chart is  
    function getChart (  
                      kpis varchar2  
                    , top_values number  
                    , pperiod_type varchar2  
                    , pperiod_count number  
                    , pas_of_date date  
                    , pla_id varchar2  
                    , entire_db varchar2  
                    , row_number_rank varchar2 
                    , pie_or_column varchar2 
                    , graph_width varchar2 
                    , graph_height varchar2  
                    , matrix_or_column varchar2  
                    ) return clob;  
end;
/

CREATE OR REPLACE package body google_chart is  
     res clob;  
  
----------------------------------------------------------------------------------------------------------------- 
--Wyk≥adowcy=L  
     sql_l varchar2(4000) := '
select (select title||'' ''||first_name||'' ''||last_name  from lecturers where id = lec_id) lab, cnt val from
(
select lec_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select lec_id, count(*) cnt
      from classes
         , lec_cla
      where classes.id = lec_cla.cla_id
         and %access_where
         and %time_limitation
   group by lec_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Grupy=G  
     sql_g varchar2(4000) := '
select (select nvl(name,abbreviation) from groups where id = gro_id) lab, cnt val from
(
select gro_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select gro_id, count(*) cnt
      from classes
         , gro_cla
      where classes.id = gro_cla.cla_id
         and %access_where
         and %time_limitation
   group by gro_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Zasoby=R  
     sql_r varchar2(4000) := '
select (select attribs_01||'' ''||name from rooms where id = rom_id) lab, cnt val from
(
select rom_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select rom_id, count(*) cnt
      from classes
         , rom_cla
      where classes.id = rom_cla.cla_id
         and %access_where
         and %time_limitation
   group by rom_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Przedmioty=S  
     sql_s varchar2(4000) := '
select (select name from subjects where id = sub_id) lab, cnt val from
(
select sub_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select sub_id, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by sub_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Formy zajeÊ=F  
     sql_f varchar2(4000) := '
select (select name from forms where id = for_id) lab, cnt val from
(
select for_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select for_id, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by for_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Planiúci=P  
     sql_p varchar2(4000) := '
select created_by, cnt from
(
select created_by
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select created_by, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by created_by
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Przedmioty + formy zajeÊ=M  
     sql_m varchar2(4000) := '
select (select name from subjects where id = sub_id)||'', ''||(select name from forms where id = for_id) lab, cnt from
(
select sub_id,for_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select sub_id,for_id, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by sub_id,for_id
)
) where afunction <= %top_values
';  
  
    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure wlog ( pmessage varchar2, pparameters clob) is 
    pragma autonomous_transaction; 
    begin 
     insert into tt_log (id, message, parameters) values (tt_seq.nextval, pmessage, pparameters);  
     commit; 
    end wlog; 
 
    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure clear_log is 
    pragma autonomous_transaction; 
    begin 
     delete from tt_log where message in ('GOOGLE_CHART:L','GOOGLE_CHART:G','GOOGLE_CHART:R','GOOGLE_CHART:S','GOOGLE_CHART:F','GOOGLE_CHART:M','GOOGLE_CHART:P'); 
     commit; 
    end clear_log; 
     
    --------------------------------------------------------------  
    function getChart (  
                      kpis varchar2  
                    , top_values number  
                    , pperiod_type varchar2  
                    , pperiod_count number  
                    , pas_of_date date  
                    , pla_id varchar2  
                    , entire_db varchar2  
                    , row_number_rank varchar2 
                    , pie_or_column varchar2  
                    , graph_width varchar2 
                    , graph_height varchar2 
                    , matrix_or_column varchar2  
    ) return clob is  
     t   integer;  
     r   integer;  
     counter number := 0;  
     row_nums number := length(kpis);  
  
            --------------------------------------------------------------  
            procedure NewClob  (clobloc       in out nocopy clob,  
                                msg_string    in varchar2) is  
             pos integer;  
             amt number;  
            begin  
               dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);  
               if msg_string is not null then  
                  pos := 1;  
                  amt := length(msg_string);  
                  dbms_lob.write(clobloc,amt,pos,msg_string);  
               end if;  
            end NewClob;  
  
            --------------------------------------------------------------  
            procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is  
             pos integer;  
             amt number;  
            begin  
               pos :=   dbms_lob.getlength(clob_loc) +1;  
               amt := length(msg_string);  
               dbms_lob.write(clob_loc,amt,pos,msg_string);  
            end WriteToClob;  
  
            --------------------------------------------------------------  
            procedure insert_pie_or_column_chart( 
                pie_or_column varchar2 
              , graph_width number 
              , graph_height number  
              , pname varchar2 
              , ptitle varchar2 
              , psql varchar2  
            ) is  
              type genericcurtyp is ref cursor;  
              cur genericcurtyp;  
              lab varchar2(255);  
              val number;  
            begin  
                WriteToClob(res,'
            <script type="text/javascript">
              function drawVisualization1() {
                // Create and populate the data table.
                var data = google.visualization.arrayToDataTable([
                  [''Lab'', ''Liczba'']');  
              open cur for psql;  
              loop  
                 fetch cur  
                  into lab, val;  
                 exit when cur%notfound;  
                WriteToClob(res,'
                  ,['''||lab||''', '||val||']');  
              end loop;  
              close cur;  
                WriteToClob(res,'
                ]);
                new google.visualization.'||pie_or_column||'Chart(document.getElementById(''visualization'||pname||''')).
                    draw(data, {title:"'||ptitle||'", width:'||graph_width||', height:'||graph_height||'});
              }
              google.setOnLoadCallback(drawVisualization1);
            </script>');    
            end insert_pie_or_column_chart;    
               
            --------------------------------------------------------------  
            procedure insert_column_chart( pname varchar2, ptitle varchar2, psql varchar2 ) is  
              type genericcurtyp is ref cursor;  
              cur genericcurtyp;  
              lab varchar2(255);  
              val number;  
            begin  
                WriteToClob(res,'
            <script type="text/javascript">
              function drawVisualization1() {
                // Create and populate the data table.
                var data = google.visualization.arrayToDataTable([[''''');  
              open cur for psql;  
              loop  
                 fetch cur  
                  into lab, val;  
                 exit when cur%notfound;  
                WriteToClob(res,'
                  ,'''||lab||'''');  
              end loop;  
                WriteToClob(res,'],[''''');  
              open cur for psql;  
              loop  
                 fetch cur  
                  into lab, val;  
                 exit when cur%notfound;  
                WriteToClob(res,'
                  ,'||val);  
              end loop;  
              close cur;  
                WriteToClob(res,'
                ]]);
                new google.visualization.ColumnChart(document.getElementById(''visualization'||pname||''')).
                    draw(data, {title:"'||ptitle||'", width:2*600, height:2*400,});
              }
              google.setOnLoadCallback(drawVisualization1);
            </script>');    
            end insert_column_chart;    
 
            --------------------------------------------------------------   
            function get_sql (kpi varchar2, top_values number, pperiod_type varchar2, pperiod_num number, pas_of_date date) return varchar2 is   
                    /*   
                    kpi  
                        Planiúci=P  
                        Wyk≥adowcy=L  
                        Grupy=G  
                        Zasoby=R  
                        Przedmioty=S  
                        Formy zajeÊ=F  
                        Przedmioty + formy zajeÊ=M  
                    */      
                    sqlstmt varchar2(4000);  
  
                    --------------------------------------------------------------   
                    function get_time_limitation(pperiod_type varchar2, pperiod_num number, pas_of_date date) return varchar2 is    
                        l_date_from date;    
                        l_date_to   date;    
                    begin    
                      case when pperiod_type = 'yyyy' then  
                                select trunc(pas_of_date-pperiod_num*365,'yyyy'),trunc(pas_of_date+365-pperiod_num*365,'yyyy')-1  into l_date_from, l_date_to from dual;    
                           when pperiod_type = 'q'    then    
                                select add_months (trunc (pas_of_date, 'q'), 0-pperiod_num*3), add_months (trunc (pas_of_date, 'q'), 3-pperiod_num*3)-1 into l_date_from, l_date_to from dual;  
                           when pperiod_type = 'rm'   then  
                                select add_months (trunc (pas_of_date, 'rm'), 0-pperiod_num*1), add_months (trunc (pas_of_date, 'rm'), 1-pperiod_num*1)-1 into l_date_from, l_date_to from dual;  
                           when pperiod_type = 'w'    then  
                                select trunc (pas_of_date, 'ww')-pperiod_num*7, trunc (pas_of_date, 'ww')+6-pperiod_num*7 into l_date_from, l_date_to from dual;  
                      end case;  
                      return 'classes.day between to_date('''|| to_char(l_date_from,'yyyy-mm-dd') ||''',''yyyy-mm-dd'') and to_date('''|| to_char(l_date_to,'yyyy-mm-dd') ||''',''yyyy-mm-dd'')';  
                    end;  
  
                    --------------------------------------------------------------  
                    function get_where_clause ( table_name  varchar2, user_or_role_id varchar2 ) return varchar2 is  
                     tn     varchar2(50);  
                     result varchar2(500);  
                    begin  
                     tn := Upper(table_Name);  
                     tn := replace(tn,'PLANNER.','');  
                     result := '0=1';  
                     if tn = 'LECTURERS' then result := tn||'.ID IN (SELECT LEC_ID FROM LEC_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'GROUPS'    then result := tn||'.ID IN (SELECT GRO_ID FROM GRO_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'ROOMS'     then result := tn||'.ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'SUBJECTS'  then result := tn||'.ID IN (SELECT SUB_ID FROM SUB_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'FORMS'     then result := tn||'.ID IN (SELECT FOR_ID FROM FOR_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'PERIODS'   then result := '0=0'; end if;  
                     if tn = 'PLANNERS'  then result := '0=0'; end if;  
                     if result = '0=1' then raise_application_error(-20000, 'B≥πd programu - funkcja getWhereClause, wartoúÊ ' || tn); end if;  
                     return result;  
                    end;  
                      
                    function get_access_where return varchar2 is  
                        access_l varchar2(500);  
                        access_g varchar2(500);  
                        access_r varchar2(500);  
                        access_s varchar2(500);  
                        access_f varchar2(500);  
                    begin  
                        access_l := 'classes.id in ((select cla_id from lec_cla where lec_id in (select id from lecturers where '||get_where_clause('LECTURERS', pla_id)||' )) union all select id from classes where calc_lec_ids is null)';  
                        access_g := 'classes.id in ((select cla_id from gro_cla where gro_id in (select id from groups    where '||get_where_clause('GROUPS', pla_id)||' )) union all select id from classes where calc_gro_ids is null)';  
                        access_r := 'classes.id in ((select cla_id from rom_cla where rom_id in (select id from rooms     where '||get_where_clause('ROOMS', pla_id)||' )) union all select id from classes where calc_rom_ids is null)';  
                        access_s := '(classes.sub_id in (select id from subjects  where '||get_where_clause('SUBJECTS', pla_id)||') or classes.sub_id is null)';  
                        access_f := '(classes.for_id in (select id from forms     where '||get_where_clause('FORMS', pla_id)||') or classes.for_id is null )';  
                        return access_l ||' and ' || access_g ||' and ' || access_r ||' and ' || access_s ||' and ' || access_f;  
                    end;  
                      
            begin  
                case   
                    when kpi='L' then sqlstmt := sql_l;  
                    when kpi='G' then sqlstmt := sql_g;  
                    when kpi='R' then sqlstmt := sql_r;  
                    when kpi='S' then sqlstmt := sql_s;  
                    when kpi='F' then sqlstmt := sql_f;  
                    when kpi='M' then sqlstmt := sql_m;  
                    when kpi='P' then sqlstmt := sql_p;  
                end case;  
                  
                sqlstmt := replace(sqlstmt, '%time_limitation', get_time_limitation(pperiod_type,pperiod_num, pas_of_date));  
                sqlstmt := replace(sqlstmt, '%top_values', top_values);  
                sqlstmt := replace(sqlstmt, '%function', row_number_rank);  
                if entire_db='Y' then sqlstmt := replace(sqlstmt, '%access_where'   , '0=0');  
                                 else sqlstmt := replace(sqlstmt, '%access_where'   , get_access_where );  
                end if;                     
                wlog('GOOGLE_CHART:' || kpi,sqlstmt);                  
                return sqlstmt;  
            end get_sql;   
    --------------------------------------------------------------   
    begin --getChart 
        clear_log; 
        NewClob(res, '');   
        WriteToClob(res,     
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=windows-1250"/>
    <title>
      Plansoft.org - wskaüniki efektywnoúci
    </title>
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load(''visualization'', ''1'', {packages: [''corechart'']});
    </script>');    
        
    for r in 1..row_nums loop    
    for t in 1..pperiod_count loop    
        counter := counter + 1;    
        declare   
            chart_title varchar2(500);   
        begin   
            select decode(substr(kpis,r,1),'L','Najaktywniejsi wyk≥adowcy','G','Najaktywniejsze grupy','R','Najw. zuøycie sal','S','Przedmioty','F','Formy zajÍÊ','M','Przedmioty+formy','P','Planiúci','???')||'. Okres: '||   
                   decode(pperiod_type,'yyyy','rok','q','kwarta≥','rm','miesiπc','w','tydzieÒ','???')||' '||   
                   decode(t-1,0,'obecny',1,'poprzedni','-'||to_char(t-1))   
              into chart_title   
              from dual;   
            insert_pie_or_column_chart (  
                pie_or_column 
              , graph_width 
              , graph_height     
              , to_char(counter)  
              , chart_title   
              , get_sql( substr(kpis,r,1), top_values, pperiod_type,t-1, pas_of_date)    
            );    
        end;   
    end loop;    
    end loop;   
        WriteToClob(res,'    
  </head>
  <body style="font-family: Arial;border: 0 none;">
  <table>
  ');  
  
    counter := 0;  
    if matrix_or_column = 'Matrix' then 
        for r in 1..row_nums loop  
            WriteToClob(res,'
            <tr>');  
        for t in 1..pperiod_count loop  
            counter := counter + 1;  
            WriteToClob(res,'
                <td><div id="visualization'||to_char(counter)||'"></div></td>');  
        end loop;  
            WriteToClob(res,'
            </tr>');  
        end loop;  
    else --column 
        WriteToClob(res,'
        <tr><td>');  
        for r in 1..row_nums loop  
        for t in 1..pperiod_count loop  
            counter := counter + 1;  
            WriteToClob(res,'
                <div id="visualization'||to_char(counter)||'"></div>');  
        end loop;  
        end loop;  
        WriteToClob(res,'
        </td></tr>');  
    end if; 
  
WriteToClob(res,'
  </table>
  </body>
</html>');  
  
        return res;  
    end getChart;  
end;
/

