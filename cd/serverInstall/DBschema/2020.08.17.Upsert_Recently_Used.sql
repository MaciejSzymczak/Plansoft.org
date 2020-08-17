connect planner;

create or replace procedure Upsert_Recently_Used (ppla_id varchar2,pres_ids varchar2,pres_type varchar2) is 
  pragma autonomous_transaction;
  vres_id varchar2(500); 
begin 
 for t in 1 .. xxmsz_tools.wordcount(pres_ids, ';') loop 
  vres_id := xxmsz_tools.extractword(t,pres_ids,';'); 
        update recently_used 
           set res_type = pres_type 
             , cnt = cnt + 1 
             , creation_date = sysdate 
         where pla_id = ppla_id 
           and res_id = vres_id; 
        if (sql%rowcount = 0) then 
         insert into recently_used (pla_id, res_id, res_type) values (ppla_id, vres_id, pres_type); 
        end if; 
 end loop; 
 commit;
end; 
/
