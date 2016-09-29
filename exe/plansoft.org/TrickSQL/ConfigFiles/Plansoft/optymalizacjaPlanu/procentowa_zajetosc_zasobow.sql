--queryname=Procentowa zaj�to�� zasob�w w poszczeg�lnych blokach godzinowych w semestrze
--execute_immediate=no
select rom.ATTRIBS_01 ||' ' || rom.name "Zas�b"
     , cla.hour "Blok godzinowy"
     , count(*) "Liczba zaj��"
     , total_days.n "liczba dni pracuj�cych"
     , round(count(*) * 100 / total_days.n, 2) "wsp�czynnik zaj�to�ci [%]"  
  from classes cla
     , rom_cla rc
     , rooms rom
     , --liczba dni w semestrze
       (select count(unique day) n 
          from classes
          where day between :date_start 
                        and :date_end
       ) total_days
 where rc.cla_id = cla.id
   and rc.rom_id = rom.id
   and cla.day between :date_start 
               and     :date_end
   and rom.name like ':res_name'            
group by rom.ATTRIBS_01, rom.name, cla.hour, total_days.n
order by 1,2,3,4  
-- <parameter name="date_start" dataType="date" caption="Data pocz�tkowa" value="" type="macro"/>
-- <parameter name="date_end"   dataType="date" caption="Data ko�cowa"    value="" type="macro"/>
-- <parameter name="res_name"  dataType="string" caption="Nazwa zasobu (%=wszystkie)"  value="%" type="macro"/>
