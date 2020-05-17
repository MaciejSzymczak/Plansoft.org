--queryname=Dotacje - Wojskowa Akademia Techniczna
--execute_immediate=no
select
/*
2016.01
  Usuniecie grup %s5 i %s6
2015.04
  Nowy parametr: nazwa grupy
  Drukowanie raportu dla grup niestacjonarnych  
2015.01.11
  Rozszerzenie filtra dla grup: r�wnie� %S5 i %S6
2013.02.01
  Wyswietlanie "Wsp. kier. studi�w" zamiast wag wyk�adowc�w
2012.02.25
  1/ Zmiana wsp�czynnik�w dla grup ( "wydzia� grupy" a nie "wydzia� wyk�adowcy" )
    C by�o 1.7 jest 1.5
    E by�o 1.5 jest 1.7
    R by�o -1  jest 1.5
  2/ Zmiana kodu WMT na WML
  3/ Dodanie do zestawienia grup doktoranckich ( S3 )
  4/ Wy�wietlanie kod�w jednostek organizacyjnych zamiast nazw - dotyczy wydzia��w grup oraz wydzia��w wyk�adowc�w
       IOE --> Intytut Optoelektroniki
       SJO --> Studium j�zyk�w obcych
       SSW --> Studium Szkolenia Wojskowego
       SWF --> Studium Wychowania Fizycznego
       WCY --> Wydzia� Cyberentyki
       WCY --> Wydzia� Cyberentyki           
       WEL --> Wydzia� Elektroniki
       WIG --> Wydzia� In�ynierii L�dowej i Geodezji
       WIM --> Wydzia� Inzynierii Mechaninej
       WML --> Wydzia� Mechatroniki
       WTC --> Wydzia� Nowych Technologii i Chemii
2019.04.20 Zmiany w sposobie wyznaczania nazwy wydzia�u i wsp�czynnika dla grupy
	Trzeba podzieli� to na dwa kryteria. Dla grup nazywanych wed�ug nowych standard�w, np. WME18TX1S1, do oznaczenia wydzia�u musi bra� trzy pierwsze litery stanowi�ce kod wydzia�u np. WIM=Wydzia� Inzynierri Mechanicznej. 
	Do okre�lenia wsp�czynnika studi�w potrzebna b�dzie sz�sta pozycja, jest to litera kt�ra w �starych� oznaczeniach by�a na pierwszej pozycji. 
	Kryteria dla grup oznaczanych po staremu, bez zmian. Je�eli chodzi o wsp�czynniki:
	F=1,1
	P=1,5
	W=1,5
2020.05.17 WME -> WIM	
*/
 unique
  WYDZIAL_GRUPY      "Wydzia� grupy"
 ,groups_name         "Grupa" 
 ,ZAJECIE_GRUPY      "Grupy"
 ,NAME               "Przedmiot"
 ,WYDZIAL_WYKLADOWCY "Wydzia� wyk�adowcy"
 --,ZAJECIE_ID         "Id zaj�cia"
 --,ZAJECIE_DZIEN      "Zaj�cie - dzie�"
 --,ZAJECIE_GODZINA    "Zaj�cie - godz."
 --,ZAJECIE_WYKLADOWCY "Zaj�cie - wyk�adowcy"
 --,NAZWA_GRUPY        "Nazwa grupy"
 --,WYPELNIENIE_BLOKU  "Wype�nienie bloku"
     ,(select 2*sum(fill/100) 
        from classes
        where day between :date_start and :date_end
          and calc_groups = c.calc_groups
          and sub_id = c.sub_id
          and for_id in (select id from forms where name = 'Wyk�ad')
      ) "Wyk�ady"    
     ,(select 2*sum(fill/100) 
        from classes
        where day between :date_start and :date_end
          and calc_groups = c.calc_groups
          and sub_id = c.sub_id
          and for_id in (select id from forms where name = '�wiczenia')
      ) "�wiczenia"    
     ,(select 2*sum(fill/100) 
        from classes
        where day between :date_start and :date_end
          and calc_groups = c.calc_groups
          and sub_id = c.sub_id
          and for_id in (select id from forms where name = 'Laboratorium')
      ) "Laboratorium"    
     ,(select 2*sum(fill/100) 
        from classes
        where day between :date_start and :date_end
          and calc_groups = c.calc_groups
          and sub_id = c.sub_id
          and for_id in (select id from forms where name in ('Projekt','Seminarium') )
      ) "Projekt, Seminarium"    
 ,waga "Wsp. kier. studi�w"     
 ,liczba_studentow "Liczba student�w"
 ,liczba_grup "Liczba grup"
 ,WC "Wojskowe-Cywilne"
from
(
  select
        case 
         when subjects.name = 'Wychowanie fizyczne' then 'SWF' --'Studium Wychowania Fizycznego'
         when upper(subjects.name) like 'JEZYK%' then 'SJO' --'Studium j�zyk�w obcych'
         when upper(subjects.name) like 'J�ZYK%' then 'SJO' --'Studium j�zyk�w obcych'
         when upper(subjects.name) like 'FIZYKA%' then 'WTC' --'Wydzia� Nowych Technologii i Chemii' --2012.01.18
        else  
          nvl( 
               (select code
                  from org_units
                where unit_type='FACULTY' 
                  and rownum = 1 -- aviod Wydzia� Techniki Wojskowej --> Instytut Optoelektroniki
                connect by prior parent_id	=	id
                start with id	= l.orguni_id)
             , 'NIEZNANY') 
        end 
        wydzial_wykladowcy
       ,case 
         when subjects.name = 'Fizyka' and forms.name = 'Laboratorium' then 1.7
         when subjects.name = 'Wychowanie fizyczne' then 1
         when upper(subjects.name) like 'JEZYK%' then 1
         when upper(subjects.name) like 'J�ZYK%' then 1
        else  
          nvl( 
               (select attribn_01
                  from org_units
                where unit_type='FACULTY' 
                  and rownum = 1 -- aviod Wydzia� Techniki Wojskowej --> Instytut Optoelektroniki
                connect by prior parent_id	=	id
                start with id	= l.orguni_id)
             , 1) 
        end 
        waga_wykladowcy
       ,case 
	       when length(g.name)=10 then substr(g.name,1,3)  -- --WME18TX1S1
           when substr(g.abbreviation,1,1)= 'A' then 'WML' --'Wydzia� Mechatroniki'
           when substr(g.abbreviation,1,1)= 'B' then 'WIG' --'Wydzia� In�ynierii L�dowej i Geodezji'
           when substr(g.abbreviation,1,1)= 'C' then 'WTC' --'Wydzia� Nowych Technologii i Chemii'
           when substr(g.abbreviation,1,1)= 'D' then 'WEL' --'Wydzia� Elektroniki'
           when substr(g.abbreviation,1,1)= 'E' then 'WEL' --'Wydzia� Elektroniki'
           when substr(g.abbreviation,1,1)= 'F' then 'WLO' --'Wydzia� Logistyki'           
           when substr(g.abbreviation,1,1)= 'G' then 'WIG' --'Wydzia� In�ynierii L�dowej i Geodezji'
           when substr(g.abbreviation,1,1)= 'I' then 'WCY' --'Wydzia� Cybernetyki'
           when substr(g.abbreviation,1,1)= 'L' then 'WML' --'Wydzia� Mechatroniki'
           when substr(g.abbreviation,1,1)= 'M' then 'WIM' --'Wydzia� Inzynierri Mechanicznej'
           when substr(g.abbreviation,1,1)= 'N' then 'WTC' --'Wydzia� Nowych Technologii i Chemii'
           when substr(g.abbreviation,1,1)= 'O' then 'IOE' --'Intytut Optoelektroniki'
           when substr(g.abbreviation,1,1)= 'P' then 'WLO' --'Wydzia� Logistyki'           
           when substr(g.abbreviation,1,1)= 'R' then 'WCY' --'Wydzia� Cybernetyki'
           when substr(g.abbreviation,1,1)= 'S' then 'WML' --'Wydzia� Mechatroniki'
           when substr(g.abbreviation,1,1)= 'T' then 'WIM' --'Wydzia� Inzynierri Mechanicznej'
           when substr(g.abbreviation,1,1)= 'W' then 'IOE' --'Instytut Optoelektroniki'
           when substr(g.abbreviation,1,1)= 'Z' then 'WCY' --'Wydzia� Cybernetyki'           
         else 'NIEZNANY'
         end 
         wydzial_grupy
       , 
	   case 
		 when length(g.name)=10 and substr(g.name,6,1)='A' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='B' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='C' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='D' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='E' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='F' then 1.1				 
		 when length(g.name)=10 and substr(g.name,6,1)='G' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='I' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='L' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='M' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='N' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='O' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='P' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='R' then 1.5				 
		 when length(g.name)=10 and substr(g.name,6,1)='S' then 1.7				 
		 when length(g.name)=10 and substr(g.name,6,1)='T' then 1.1				 
		 when length(g.name)=10 and substr(g.name,6,1)='Z' then 1.1				 
		 when length(g.name)=10 and substr(g.name,6,1)='W' then 1.5				 
		 --
		 when substr(g.abbreviation,1,1)= 'A' then 1.7
		 when substr(g.abbreviation,1,1)= 'B' then 1.5
		 when substr(g.abbreviation,1,1)= 'C' then 1.5 --2012.02.20 1.7
		 when substr(g.abbreviation,1,1)= 'D' then 1.7
		 when substr(g.abbreviation,1,1)= 'E' then 1.7 --2012.02.20 1.5
		 when substr(g.abbreviation,1,1)= 'F' then 1.1 --2019.04.20
		 when substr(g.abbreviation,1,1)= 'G' then 1.5
		 when substr(g.abbreviation,1,1)= 'I' then 1.5
		 when substr(g.abbreviation,1,1)= 'L' then 1.7
		 when substr(g.abbreviation,1,1)= 'M' then 1.7
		 when substr(g.abbreviation,1,1)= 'N' then 1.7
		 when substr(g.abbreviation,1,1)= 'O' then 1.5
		 when substr(g.abbreviation,1,1)= 'P' then 1.5 --2019.04.20
		 when substr(g.abbreviation,1,1)= 'R' then 1.5 --2012.02.20 brak poprzedniej warto�ci
		 when substr(g.abbreviation,1,1)= 'S' then 1.7
		 when substr(g.abbreviation,1,1)= 'T' then 1.1
		 when substr(g.abbreviation,1,1)= 'Z' then 1.1
		 when substr(g.abbreviation,1,1)= 'W' then 1.5 --2019.04.20
		 else -1
	   end       
         waga
       , classes.id  zajecie_id
       , classes.day zajecie_dzien
       , classes.hour zajecie_godzina
       , CALC_GROUPS  zajecie_grupy
       , subjects.name
       --, CALC_lecturers  zajecie_wykladowcy
       , planner.getsqlvalues('select first_name||'' ''||last_name from lecturers, lec_cla where lec_cla.lec_id = lecturers.id and cla_id = '||classes.id||'order by last_name', 'N',', ') zajecie_wykladowcy
       , planner.getsqlvalues('select sum(number_of_peoples) from groups, gro_cla where gro_cla.gro_id = groups.id and cla_id = '||classes.id, 'N',', ') liczba_studentow
       --, planner.getsqlvalues('select unique attribs_01 from groups, gro_cla where gro_cla.gro_id = groups.id and cla_id = '||classes.id, 'N',', ') WC
       , g.name nazwa_grupy
       , FILL wypelnienie_bloku
       , sub_id
       , calc_groups
       , g.number_of_peoples
       , g.name groups_name
       , g.attribs_01 wc
       , (select count(1) from gro_cla where cla_id = classes.id) liczba_grup
     from classes
       , gro_cla
       , groups g
       , lec_cla
       , lecturers l
       , forms
       , subjects
      /*
      classes
       -< gro_cla         [cla_id]
           >- groups         [gro_id]
       -< lec_cla         [cla_id]
           >- lecturers         [lec_id]
       >- forms         [for_id]
       >- subjects
      */
   where gro_cla.cla_id(+) = classes.id
     and lec_cla.cla_id(+) = classes.id
     and l.id(+) = lec_cla.lec_id
     and g.id(+) = gro_cla.gro_id
     and forms.id = classes.for_id
     and subjects.id = classes.sub_id
	 --and g.name like ':group_name' 
     --and (
     --    g.abbreviation like '%:s_n1'
     -- or g.abbreviation like '%:s_n2'
     -- or g.abbreviation like '%:s_n3' --2012.02.20 Studia doktoranckie
     -- or g.abbreviation like '%:s_n4'
     --    )
     and classes.day between :date_start 
                     and     :date_end   
     --and g.attribs_01=nvl(':pwojskowe_cywilne', g.attribs_01)   
     --
     --and classes.id in (1889668,1889669,1889670) --@@@
     --and rownum < 10
     --and g.name like 'C0O1S1%'
     --and classes.id = 1924136                 
--order by classes.day, classes.hour     
) c
order by 2,1,3,4,5,6,7
-- <parameter name="date_start" dataType="date" caption="Data pocz�tkowa" value="" type="macro"/>
-- <parameter name="date_end"   dataType="date" caption="Data ko�cowa"    value="" type="date"/>
-- <parameter name="group_name"   dataType="string" caption="Nazwa grupy (%= wszystkie)"    value="" type="string"/>
-- <parameter name="s_n"   dataType="string" caption="Stacjon/Niestacjon(S/N)"    value="" type="string"/>


















============== groups and lecturers examination =========================
select g.id, g.name,
  case 
  when length(g.name)=10 then substr(g.name,1,3)  -- --WME18TX1S1
   when substr(g.abbreviation,1,1)= 'A' then 'WML' --'Wydzia� Mechatroniki'
   when substr(g.abbreviation,1,1)= 'B' then 'WIG' --'Wydzia� In�ynierii L�dowej i Geodezji'
   when substr(g.abbreviation,1,1)= 'C' then 'WTC' --'Wydzia� Nowych Technologii i Chemii'
   when substr(g.abbreviation,1,1)= 'D' then 'WEL' --'Wydzia� Elektroniki'
   when substr(g.abbreviation,1,1)= 'E' then 'WEL' --'Wydzia� Elektroniki'
   when substr(g.abbreviation,1,1)= 'F' then 'WLO' --'Wydzia� Logistyki'           
   when substr(g.abbreviation,1,1)= 'G' then 'WIG' --'Wydzia� In�ynierii L�dowej i Geodezji'
   when substr(g.abbreviation,1,1)= 'I' then 'WCY' --'Wydzia� Cybernetyki'
   when substr(g.abbreviation,1,1)= 'L' then 'WML' --'Wydzia� Mechatroniki'
   when substr(g.abbreviation,1,1)= 'M' then 'WIM' --'Wydzia� Inzynierri Mechanicznej'
   when substr(g.abbreviation,1,1)= 'N' then 'WTC' --'Wydzia� Nowych Technologii i Chemii'
   when substr(g.abbreviation,1,1)= 'O' then 'IOE' --'Intytut Optoelektroniki'
   when substr(g.abbreviation,1,1)= 'P' then 'WLO' --'Wydzia� Logistyki'           
   when substr(g.abbreviation,1,1)= 'R' then 'WCY' --'Wydzia� Cybernetyki'
   when substr(g.abbreviation,1,1)= 'S' then 'WML' --'Wydzia� Mechatroniki'
   when substr(g.abbreviation,1,1)= 'T' then 'WIM' --'Wydzia� Inzynierri Mechanicznej'
   when substr(g.abbreviation,1,1)= 'W' then 'IOE' --'Instytut Optoelektroniki'
   when substr(g.abbreviation,1,1)= 'Z' then 'WCY' --'Wydzia� Cybernetyki'           
  else 'NIEZNANY'
  end 
  wydzial_grupy
, 
  case 
  when length(g.name)=10 and substr(g.name,6,1)='A' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='B' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='C' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='D' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='E' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='F' then 1.1				 
  when length(g.name)=10 and substr(g.name,6,1)='G' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='I' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='L' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='M' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='N' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='O' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='P' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='R' then 1.5				 
  when length(g.name)=10 and substr(g.name,6,1)='S' then 1.7				 
  when length(g.name)=10 and substr(g.name,6,1)='T' then 1.1				 
  when length(g.name)=10 and substr(g.name,6,1)='Z' then 1.1				 
  when length(g.name)=10 and substr(g.name,6,1)='W' then 1.5				 
  --
  when substr(g.abbreviation,1,1)= 'A' then 1.7
  when substr(g.abbreviation,1,1)= 'B' then 1.5
  when substr(g.abbreviation,1,1)= 'C' then 1.5 
  when substr(g.abbreviation,1,1)= 'D' then 1.7
  when substr(g.abbreviation,1,1)= 'E' then 1.7 
  when substr(g.abbreviation,1,1)= 'F' then 1.1 
  when substr(g.abbreviation,1,1)= 'G' then 1.5
  when substr(g.abbreviation,1,1)= 'I' then 1.5
  when substr(g.abbreviation,1,1)= 'L' then 1.7
  when substr(g.abbreviation,1,1)= 'M' then 1.7
  when substr(g.abbreviation,1,1)= 'N' then 1.7
  when substr(g.abbreviation,1,1)= 'O' then 1.5
  when substr(g.abbreviation,1,1)= 'P' then 1.5 
  when substr(g.abbreviation,1,1)= 'R' then 1.5 
  when substr(g.abbreviation,1,1)= 'S' then 1.7
  when substr(g.abbreviation,1,1)= 'T' then 1.1
  when substr(g.abbreviation,1,1)= 'Z' then 1.1
  when substr(g.abbreviation,1,1)= 'W' then 1.5 
  else -1
  end       
  waga
, created_by, to_char(creation_date,'yyyy-mm-dd')
from groups g
order by g.name

select l.id, l.first_name, l.last_name, 
          nvl( 
               (select code
                  from org_units
                where unit_type='FACULTY' 
                  and rownum = 1 -- aviod Wydzia� Techniki Wojskowej --> Instytut Optoelektroniki
                connect by prior parent_id	=	id
                start with id	= l.orguni_id)
             , 'NIEZNANY') 
        wydzial_wykladowcy
       ,  
          nvl( 
               (select attribn_01
                  from org_units
                where unit_type='FACULTY' 
                  and rownum = 1 -- aviod Wydzia� Techniki Wojskowej --> Instytut Optoelektroniki
                connect by prior parent_id	=	id
                start with id	= l.orguni_id)
             , 1) 
        waga_wykladowcy
        , created_by, to_char(creation_date,'yyyy-mm-dd')
        , (select name from org_units where id= orguni_id) jednostka_wyk
from lecturers l
order by 2,3



