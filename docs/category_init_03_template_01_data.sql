-- 插入模板分类的数据

-- 根节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),null,0,'TPL','模板分类','11',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid is null and c.code='TPL'
  );

-- 模板分类 子节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'JJHT_BY_BUSINESS','经济合同（按合同性质）','01',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='JJHT_BY_BUSINESS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'JJHT_BY_TYPE','经济合同（按类别）','02',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='JJHT_BY_TYPE'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'LDHT','劳动合同','03',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='LDHT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'ARRANGE','编排','04',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='ARRANGE'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'CARTAX','车船税','05',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='CARTAX'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'PMC','配件','06',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='PMC'
  );  

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='TPL'),
    0,'REPORT','统计报表','07',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='TPL') and c.code='REPORT'
  );  

-- 模板分类/经济合同(按合同性质) 子节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'SY6850CBC','首月6850承包车','01',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='SY6850CBC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'SYF6850CBC','首月非6850承包车','02',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='SYF6850CBC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'2012GFC','2012年高峰车','03',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='2012GFC'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'2012XYL_LR','2012年新运力车（两人）','04',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='2012XYL_LR'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'XSYLPRZ','限时运力聘任制','05',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='XSYLPRZ'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'21HPRZ','24小时聘任制','06',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='21HPRZ'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'2014TBCBZ','2014年替班承包制','07',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='2014TBCBZ'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_BUSINESS'),
    0,'GKC','挂靠车','08',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_BUSINESS') and c.code='GKC'
  );

-- 模板分类/经济合同(按类别) 子节点
insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'HT','合同','01',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='HT'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'SFTZ','收费通知','02',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='SFTZ'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'BCXY','补充协议','03',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='BCXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'TBXY','替班协议','04',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='TBXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'ZZXY','终止协议','05',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='ZZXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'ZTBGXY','主体变更协议','06',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='ZTBGXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'CLWXXY','车辆维修协议','07',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='CLWXXY'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'SQS','申请书','08',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='SQS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'CNS','承诺书','09',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='CNS'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'GZZF','工资支付','10',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='GZZF'
  );

insert into BC_CATEGORY (ID,PID,STATUS_,CODE,NAME_,SN,MODIFIED_DATE,MODIFIER_ID)
  select NEXTVAL('CORE_SEQUENCE'),(select id from bc_category where code='JJHT_BY_TYPE'),
    0,'ZFGJJ','住房公积金','11',now(),
    (select id from bc_identity_actor_history where actor_code='admin' and current=true)
  from bc_dual
  where not exists (
    select 0 from BC_CATEGORY c 
    where c.pid=(select id from bc_category where code='JJHT_BY_TYPE') and c.code='ZFGJJ'
  );