-- $Id$

create sequence scs_object_id_seq start with 50000;

create or replace package scs
as

  -- Notice, this is also hard-coded in scs-test-create!
  ScsDbExn constant integer := -20000;

  function new_obj_id (
    obj_id in integer default null
  ) return integer;

  function swap_p (
    p in char
  ) return char;
end scs;
/
show errors

create or replace package body scs
as
  function new_obj_id (
    obj_id in integer default null
  ) return integer
  is
    v_obj_id integer;
  begin
    if obj_id is null then
      select scs_object_id_seq.nextval
        into v_obj_id
        from dual;
    else
      v_obj_id := scs.new_obj_id.obj_id;
    end if;
    return v_obj_id;
  end new_obj_id;

  function swap_p (
    p in char
  ) return char
  is
  begin
    if swap_p.p = 't' then
      return 'f';
    elsif swap_p.p = 'f' then
      return 't';
    else
      raise_application_error(ScsDbExn, 'scs.swap_p. Can''t swap ' || swap_p.p || '.');
    end if;
  end swap_p;

end scs;
/
show errors

------------------------------------
-- LOAD THE ENTIRE SCS DATA MODEL --
------------------------------------

@scs-test-create.sql;
@scs-math-create.sql;
@scs-random-create.sql;
@scs-logs-create.sql;
@scs-locales-create.sql;
@scs-enumerations-create.sql;
@scs-parties-create.sql;
@scs-roles-create.sql;
@scs-persons-create.sql;
@scs-users-create.sql;
@scs-groups-create.sql;
@scs-dict-create.sql;

select table_name from user_tables; -- debugging information
set serveroutput on; -- used by test files

