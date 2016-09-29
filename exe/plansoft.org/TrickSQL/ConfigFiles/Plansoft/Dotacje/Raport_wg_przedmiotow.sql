--queryname=Dotacje - Raport zbiorczy
--execute_immediate=no
select  nazwa_grupy "Nazwa grupy", name "Przedmiot", forma "Forma", wydzial_wykladowcy "Wydzia³ wyk³adowcy"
        , wydzial_grupy "Wydzia³ grupy", sum ( wspolczynnik ) "Wspó³czynnik - suma"
from
(       
  select
        case 
         when subjects.name = 'Wychowanie fizyczne' then 'Studium Wychowania Fizycznego'
         when upper(subjects.name) like 'JEZYK%' then 'Studium jêzyków obcych'
         when upper(subjects.name) like 'JÊZYK%' then 'Studium jêzyków obcych'
        else  
          nvl( 
               (select name
                  from org_units
                where unit_type='FACULTY' 
                  and rownum = 1 -- aviod Wydzia³ Techniki Wojskowej --> Instytut Optoelektroniki
                connect by prior parent_id	=	id
                start with id	= l.orguni_id)
             , 'NIEZNANY') 
        end 
        wydzial_wykladowcy
       ,case 
           /*
           when substr(g.ABBREVIATION,1,1)= 'A' then 'Mechatronika'
           when substr(g.ABBREVIATION,1,1)= 'B' then 'Budownictwo'
           when substr(g.ABBREVIATION,1,1)= 'C' then 'Chemia'
           when substr(g.ABBREVIATION,1,1)= 'D' then 'Elektronika  i  telekomunikacja'
           when substr(g.ABBREVIATION,1,1)= 'E' then 'Elektronika  i  telekomunikacja'
           when substr(g.ABBREVIATION,1,1)= 'G' then 'Geodezja i kartografia'
           when substr(g.ABBREVIATION,1,1)= 'I' then 'Informatyka'
           when substr(g.ABBREVIATION,1,1)= 'L' then 'Lotnictwo i kosmonautyka'
           when substr(g.ABBREVIATION,1,1)= 'M' then 'Mechanika i budowa maszyn'
           when substr(g.ABBREVIATION,1,1)= 'N' then 'In¿ynieria materia³owa'
           when substr(g.ABBREVIATION,1,1)= 'S' then 'In¿ynieria bezpieczeñstwa'
           when substr(g.ABBREVIATION,1,1)= 'T' then 'Logistyka'
           when substr(g.ABBREVIATION,1,1)= 'Z' then 'Zarz¹dzanie'
           --
           when substr(g.abbreviation,1,1)= 'A' then 'WMT'
           when substr(g.abbreviation,1,1)= 'B' then 'WIG'
           when substr(g.abbreviation,1,1)= 'C' then 'WTC'
           when substr(g.abbreviation,1,1)= 'D' then 'WEL'
           when substr(g.abbreviation,1,1)= 'E' then 'WEL'
           when substr(g.abbreviation,1,1)= 'G' then 'WIG'
           when substr(g.abbreviation,1,1)= 'I' then 'WCY'
           when substr(g.abbreviation,1,1)= 'L' then 'WMT'
           when substr(g.abbreviation,1,1)= 'M' then 'WME'
           when substr(g.abbreviation,1,1)= 'N' then 'WTC'
           when substr(g.abbreviation,1,1)= 'O' then 'IOPTO'
           when substr(g.abbreviation,1,1)= 'R' then 'WCY'
           when substr(g.abbreviation,1,1)= 'S' then 'WMT'
           when substr(g.abbreviation,1,1)= 'T' then 'WME'
           when substr(g.abbreviation,1,1)= 'Z' then 'WCY'           
           */
           when substr(g.abbreviation,1,1)= 'A' then 'Wydzia³ Mechatroniki'
           when substr(g.abbreviation,1,1)= 'B' then 'Wydzia³ In¿ynierii L¹dowej i Geodezji'
           when substr(g.abbreviation,1,1)= 'C' then 'Wydzia³ Nowych Technologii i Chemii'
           when substr(g.abbreviation,1,1)= 'D' then 'Wydzia³ Elektroniki'
           when substr(g.abbreviation,1,1)= 'E' then 'Wydzia³ Elektroniki'
           when substr(g.abbreviation,1,1)= 'G' then 'Wydzia³ In¿ynierii L¹dowej i Geodezji'
           when substr(g.abbreviation,1,1)= 'I' then 'Wydzia³ Cybernetyki'
           when substr(g.abbreviation,1,1)= 'L' then 'Wydzia³ Mechatroniki'
           when substr(g.abbreviation,1,1)= 'M' then 'Wydzia³ Mechaniczny'
           when substr(g.abbreviation,1,1)= 'N' then 'Wydzia³ Nowych Technologii i Chemii'
           when substr(g.abbreviation,1,1)= 'O' then 'Intytut Optoelektroniki'
           when substr(g.abbreviation,1,1)= 'R' then 'Wydzia³ Cyberentyki'
           when substr(g.abbreviation,1,1)= 'S' then 'Wydzia³ Mechatroniki'
           when substr(g.abbreviation,1,1)= 'T' then 'Wydzia³ Mechaniczny'
           when substr(g.abbreviation,1,1)= 'Z' then 'Wydzia³ Cyberentyki'           
         else 'NIEZNANY'
         end 
         wydzial_grupy
         /*'IOPTO', 'Intytut Optoelektroniki'
           'WCY'  , 'Wydzia³ Cyberentyki'        
           'WEL'  , 'Wydzia³ Elektroniki'
           'WIG'  , 'Wydzia³ In¿ynierii L¹dowej i Geodezji'
           'WME'  , 'Wydzia³ Mechaniczny'
           'WMT'  , 'Wydzia³ Mechatroniki'
           'WTC'  , 'Wydzia³ Nowych Technologii i Chemii'
           */
       , round ( 1 * FILL/100 
                 / nvl( (select decode(count(*),0,null, count(*)) from gro_cla where cla_id = classes.id), 1)
                 / nvl( (select decode(count(*),0,null, count(*)) from lec_cla where cla_id = classes.id), 1)
               , 2)
       * case when forms.name = 'Laboratorium'
           then
               case 
                 when substr(g.abbreviation,1,1)= 'A' then 1.7
                 when substr(g.abbreviation,1,1)= 'B' then 1.5
                 when substr(g.abbreviation,1,1)= 'C' then 1.7
                 when substr(g.abbreviation,1,1)= 'D' then 1.7
                 when substr(g.abbreviation,1,1)= 'E' then 1.5
                 when substr(g.abbreviation,1,1)= 'G' then 1.5
                 when substr(g.abbreviation,1,1)= 'I' then 1.5
                 when substr(g.abbreviation,1,1)= 'L' then 1.7
                 when substr(g.abbreviation,1,1)= 'M' then 1.7
                 when substr(g.abbreviation,1,1)= 'N' then 1.7
                 when substr(g.abbreviation,1,1)= 'O' then 1.5
                 when substr(g.abbreviation,1,1)= 'S' then 1.7
                 when substr(g.abbreviation,1,1)= 'T' then 1.1
                 when substr(g.abbreviation,1,1)= 'Z' then 1.1
                 else -1
               end 
           else 1
         end        
         wspolczynnik
       , classes.id  zajecie_id
       , classes.day zajecie_dzien
       , classes.hour zajecie_godzina
       , CALC_GROUPS  zajecie_grupy
       , subjects.name
       --, CALC_lecturers  zajecie_wykladowcy
       , planner.getsqlvalues('select first_name||'' ''||last_name from lecturers, lec_cla where lec_cla.lec_id = lecturers.id and cla_id = '||classes.id||'order by last_name', 'N',', ') zajecie_wykladowcy
       , g.name nazwa_grupy
       , FILL wypelnienie_bloku
       , forms.name forma
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
     and (
         g.abbreviation like '%S1'
      or g.abbreviation like '%S2'
      or g.abbreviation like '%S4'
         )
     and classes.day between :date_start 
                     and     :date_end   
     and g.attribs_01=nvl(':pwojskowe_cywilne', g.attribs_01)                    
--order by classes.day, classes.hour     
)
where wydzial_wykladowcy = nvl(':pwydzial_wykladowcy',wydzial_wykladowcy) 
group by forma, nazwa_grupy, name, 
         wydzial_wykladowcy, wydzial_grupy
order by forma, nazwa_grupy, name, 
         wydzial_wykladowcy, wydzial_grupy
-- <parameter name="date_start" dataType="date" caption="Data pocz¹tkowa" value="" type="macro"/>
-- <parameter name="date_end"   dataType="date" caption="Data koñcowa"    value="" type="date"/>
-- <parameter name="pwydzial_wykladowcy"  dataType="string" caption="wydzia³ wyk³adowcy"  value="NIEZNANY" type="macro"/>
-- <parameter name="pwojskowe_cywilne"  dataType="string" caption="Grupa (C/W/puste)"  value="W" type="macro"/>