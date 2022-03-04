
create or replace package body tt_planner is

   --2022.02.10 2 subjects   

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
 p_per_id number;
 p_lec_id number;
 p_sub_id number;
 p_for_id number;
 p_gro_id number;
 p_rom_id number;
 p_res_id number;
 p_pla_id number;
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
    p_rescat_id number;
  begin
    for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
      l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
      if l_res_id is not null then 
        insert into tt_resource_lists (id, tt_comb_id, res_id) values (tt_seq.nextval, l_tt_comb_id,  l_res_id );
        p_rescat_id := get_rescat_id(l_res_id);
        add_inclusion (p_rescat_id , 'LIST' );
        case 
            when p_rescat_id = g_lecturer then p_lec_id   := l_res_id;
            when p_rescat_id = g_lecturer  then p_lec_id  := l_res_id; 
            when p_rescat_id = g_form      then p_for_id  := l_res_id; 
            when p_rescat_id = g_subject   then p_sub_id  := l_res_id; 
            when p_rescat_id = g_group     then p_gro_id  := l_res_id; 
            when p_rescat_id = g_period    then p_per_id  := l_res_id; 
            when p_rescat_id = g_planner   then p_pla_id  := l_res_id; 
            when p_rescat_id = 1           then p_rom_id  := l_res_id; 
            --g_date_hour
            else p_res_id :=  l_res_id;
        end case;

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
       , per_id         = p_per_id
       , lec_id         = p_lec_id
       , sub_id         = p_sub_id
       , for_id         = p_for_id
       , gro_id         = p_gro_id
       , rom_id         = p_rom_id
       , res_id         = p_res_id
       , pla_id         = p_pla_id
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
function get_filter (p_res_ids varchar2, p_include_all varchar2 default 'N') return varchar2
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
                    'tt_combinations.id in ( select tt_comb_id from tt_resource_lists where res_id = '||l_res_id||' )'||chr(10)||
                     xxmsz_tools.iif(p_include_all='Y', 'or id in ( select tt_comb_id from tt_inclusions where rescat_id = '||get_rescat_id (l_res_id)||' and inclusion_type = ''ALL'')'||chr(10),'')||
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
     l_complete_sql := 'select cla.id, fill/100*grids.duration duration  from classes cla, grids, str_elems where cla.sub_id = str_elems.parent_id(+) and grids.no = cla.hour '; 
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
         l_sub_cond := ' and nvl(str_elems.child_id, sub_id) in (select res_id from tt_resource_lists where tt_comb_id = '||rec.id||')';
         l_pla_cond := ' and cla.owner in  (select p.name from tt_resource_lists tt, planners p where tt.res_id = p.id tt_comb_id = '||rec.id||')';
       else -- ='ALL'
         l_res_cond := ' and r.rescat_id = ' || rec_incl.rescat_id; 
         l_lec_cond := ' '; 
         l_gro_cond := ' '; 
         l_per_cond := ' '; 
         l_for_cond := ' and cla.for_id is not null';
         l_sub_cond := ' and cla.sub_id is not null';
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
     l_complete_sql :=  'select unique id, duration from ('|| l_complete_sql  ||')';
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
        set  avail_curr = avail_orig - round(l_fill_sum,1)
      where rowid = rec.rowid; 
  end loop;
  wlog('recalc_book_combination(-)',null);  
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- this is performance optimized version of procedure recalc_book_combination for combination 122: LEC-GRO-SUB-FOR-PER
-- use this function when
--   combinations were imported from another system
--   do not execute this function too frequent as it may cause locks
procedure recalc_combination122 (pClearMode varchar2 default 'N') is
  pdate_from date;
  pdate_to   date;
begin
    if (pClearMode='Y') then 
     delete from tt_cla where tt_comb_id in (select id from tt_combinations where weight = 122);
    end if;
    for rec in (select unique per_id from tt_combinations where weight = 122) loop
        select date_from, date_to 
          into pdate_from, pdate_to 
          from periods where id = rec.per_id;
        merge into tt_combinations m 
            using (
                select lec_id, gro_id, nvl(str_elems.child_id, sub_id) sub_id, for_id, round(sum(fill/100*g.duration),1) units --/count(unique cla.id)
                 from classes cla
                 , grids g
                 , gro_cla
                 , lec_cla
                 , str_elems --sub_cla
                where g.no = cla.hour
                 and gro_cla.cla_id = cla.id
                 and lec_cla.cla_id = cla.id
                 and cla.sub_id = str_elems.parent_id(+)
                 and lec_id >0
                 and gro_id >0
                 and cla.day between pdate_from and pdate_to
                group by
                 lec_id, gro_id, nvl(str_elems.child_id, sub_id), for_id
            ) c 
            on (m.lec_id = c.lec_id and m.gro_id = c.gro_id and m.sub_id = c.sub_id and m.for_id = c.for_id and m.per_id=rec.per_id and avail_type='L') 
         when matched 
         then update 
         set avail_curr =  avail_orig - c.units;
         commit;
        merge into tt_cla m 
            using (
                select * from (
                    select cla.id cla_id
                         , (select tt.id 
                              from tt_combinations tt
                                 , TT_INCLUSIONS II_LEC
                                 , TT_INCLUSIONS II_GRO
                                 , TT_INCLUSIONS II_SUB
                                 , TT_INCLUSIONS II_FOR
                              where 
                                    II_LEC.tt_comb_id = TT.Id and II_LEC.RESCAT_ID= -4
                                and II_GRO.tt_comb_id = TT.Id and II_GRO.RESCAT_ID= -5
                                and II_SUB.tt_comb_id = TT.Id and II_SUB.RESCAT_ID= -3
                                and II_FOR.tt_comb_id = TT.Id and II_FOR.RESCAT_ID= -2
                                and (lec_cla.lec_id = tt.lec_id  or II_LEC.inclusion_type='ALL') 
                                and (gro_cla.gro_id = tt.gro_id  or II_GRO.inclusion_type='ALL')
                                and (nvl(str_elems.child_id, cla.sub_id) = tt.sub_id      or II_SUB.inclusion_type='ALL')
                                and (cla.for_id = tt.for_id      or II_FOR.inclusion_type='ALL')
                                and tt.per_id=rec.per_id 
                                and avail_type='L' 
                                and rownum=1) tt_comb_id
                         , round(sum(fill/100*g.duration),1) units --/count(unique cla.id)
                     from classes cla
                     , grids g
                     , gro_cla
                     , lec_cla
                     , str_elems --sub_cla
                    where g.no = cla.hour
                     and gro_cla.cla_id = cla.id
                     and lec_cla.cla_id = cla.id
                     and cla.sub_id = str_elems.parent_id(+)
                     and lec_id >0
                     and gro_id >0
                     and cla.day between pdate_from and pdate_to
                    group by
                     cla.id, lec_id, gro_id, nvl(str_elems.child_id, sub_id), for_id
                ) where tt_comb_id is not null
            ) tt
            on (m.cla_id = tt.cla_id and m.tt_comb_id = tt.tt_comb_id) 
          when not matched then insert (id, cla_id, tt_comb_id, units)
          values (
              tt_seq.nextval
              , tt.cla_id
              , tt.tt_comb_id
              , tt.units
          )
         when matched 
         then update 
         set units =  tt.units;
         commit;
    end loop;
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

