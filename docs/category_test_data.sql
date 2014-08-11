-- 插入数据

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'TPL','模板','0000',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=0 and c.code='TPL'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'BGYP','办公用品','0001',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=0 and c.code='BGYP'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'ZC','资产','0002',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=0 and c.code='ZC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'JJHT','经济合同','0000',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='JJHT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'LDHT','劳动合同','0001',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='LDHT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'ARRANGE','编排','0002',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='ARRANGE'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'CARTAX','车船税','0003',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='CARTAX'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'PMC','配件','0004',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='PMC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'REPORT','统计报表','0005',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='REPORT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'HT','合同','0000',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='HT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'SFTZ','收费通知','0001',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='SFTZ'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'BCXY','补充协议','0002',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='BCXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'TBXY','替班协议','0003',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='TBXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'ZZXY','终止协议','0004',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='ZZXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'ZTBGXY','主体变更协议','0005',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='ZTBGXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'CLWXXY','车辆维修协议','0006',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='CLWXXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'SQS','申请书','0007',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='SQS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'CNS','承诺书','0008',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='CNS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'GZZF','工资支付','0009',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='GZZF'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT'),
    0,'ZFGJJ','住房公积金','0010',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT') and c.code='ZFGJJ'
  );
