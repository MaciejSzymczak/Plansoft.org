connect sys;

GRANT EXECUTE ON sys.dbms_crypto TO planner;  

connect planner;

create or replace function getSHA1 (myText varchar2) return string is
   lv_hash_value_sh1 RAW(100);
   lv_varchar_key_sh1 varchar2(2000);
BEGIN
   SELECT sys.dbms_crypto.hash(utl_raw.cast_to_raw(myText||'softwarefactory'),  sys.dbms_crypto.hash_sh1) 
     INTO lv_hash_value_sh1 
     FROM dual;
  select   lower (to_char (rawtohex (lv_hash_value_sh1)))
    into   lv_varchar_key_sh1
    from   dual;
    return lv_varchar_key_sh1;
END;
/
