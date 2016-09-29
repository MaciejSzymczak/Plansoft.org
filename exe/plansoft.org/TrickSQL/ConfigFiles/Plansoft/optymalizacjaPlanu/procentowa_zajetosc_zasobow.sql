--queryname=Procentowa zajêtoœæ zasobów w poszczególnych blokach godzinowych w semestrze
--execute_immediate=no
select rom.ATTRIBS_01 ||' ' || rom.name "Zasób"
     , cla.hour "Blok godzinowy"
     , count(*) "Liczba zajêæ"
     , total_days.n "liczba dni pracuj¹cych"
     , round(count(*) * 100 / total_days.n, 2) "wspó³czynnik zajêtoœci [%]"  
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
-- <parameter name="date_start" dataType="date" caption="Data pocz¹tkowa" value="" type="macro"/>
-- <parameter name="date_end"   dataType="date" caption="Data koñcowa"    value="" type="macro"/>
-- <parameter name="res_name"  dataType="string" caption="Nazwa zasobu (%=wszystkie)"  value="%" type="macro"/>
