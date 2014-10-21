-- 插入物资分类的数据

-- 根节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'ASSET_TYPE','物资分类','12',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid is null and c.code='ASSET_TYPE'
  );