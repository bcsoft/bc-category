-- 插入测试数据

-- 根节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'TPL','模板','11',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid is null and c.code='TPL'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'ZC','资产','12',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid is null and c.code='ZC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'BGYP','办公用品','13',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid is null and c.code='BGYP'
  );


-- 模板 子节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'JJHT','经济合同','11-01',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='JJHT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'LDHT','劳动合同','11-02',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='LDHT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'ARRANGE','编排','11-03',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='ARRANGE'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'CARTAX','车船税','11-04',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='CARTAX'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'PMC','配件','11-05',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='PMC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'REPORT','统计报表','11-06',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='REPORT'
  );


-- 模板/经济合同 子节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'HT','合同','11-01-01',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='HT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'SFTZ','收费通知','11-01-02',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='SFTZ'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'BCXY','补充协议','11-01-03',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='BCXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'TBXY','替班协议','11-01-04',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='TBXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'ZZXY','终止协议','11-01-05',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='ZZXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'ZTBGXY','主体变更协议','11-01-06',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='ZTBGXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'CLWXXY','车辆维修协议','11-01-07',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='CLWXXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'SQS','申请书','11-01-08',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='SQS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'CNS','承诺书','11-01-09',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='CNS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'GZZF','工资支付','11-01-10',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='GZZF'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'ZFGJJ','住房公积金','11-01-11',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='ZFGJJ'
  );