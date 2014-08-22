-- 清除资源、角色、岗位配置数据
-- 资产分类
delete from BC_IDENTITY_ROLE_RESOURCE where sid in 
	(select id from BC_IDENTITY_RESOURCE where ORDER_ like '800703');
delete from BC_IDENTITY_RESOURCE where ORDER_ like '800703';
-- 角色
delete from BC_IDENTITY_ROLE_ACTOR where rid in 
	(select id from BC_IDENTITY_ROLE where code like 'BC_ASSET_TYPE_%');
delete from bc_identity_role_resource where rid in
	(select id from BC_IDENTITY_ROLE where code like 'BC_ASSET_TYPE_%');
delete from BC_IDENTITY_ROLE where code like 'BC_ASSET_TYPE_%';
-- 岗位
delete from BC_IDENTITY_ACTOR_RELATION where 
	FOLLOWER_ID in (select id from BC_IDENTITY_ACTOR where name like '%资产分类%')
	or MASTER_ID in (select id from BC_IDENTITY_ACTOR where name like '%资产分类%');
delete from bc_subscribe_actor where aid in (
	select id from BC_IDENTITY_ACTOR where name like '%资产分类%'
);
delete from BC_IDENTITY_ACTOR where name like '%资产分类%';


--------------------------------------  资源配置  ----------------------------------------------------
-- 插入资源: 资产分类，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800703','资产分类', '/bc/asset/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='资产分类');

--------------------------------------  角色配置  ----------------------------------------------------
-- 插入角色: 资产分类管理角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0026', 'BC_ASSET_TYPE_MANAGE','资产分类管理'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_ASSET_TYPE_MANAGE');

-- 插入角色: 资产分类查阅角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0027', 'BC_ASSET_TYPE_READ','资产分类查阅'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_ASSET_TYPE_READ');

--------------------------------------  角色-资源配置  ----------------------------------------------------
-- 插入角色-资源：资产分类管理角色，资产分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_ASSET_TYPE_MANAGE' 
	and m.NAME='资产分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

-- 插入角色-资源：资产分类查阅角色，资产分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_ASSET_TYPE_READ' 
	and m.NAME='资产分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

--------------------------------------  岗位配置  ----------------------------------------------------
-- 插入岗位：资产分类管理岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'assetManageGroup','资产分类管理岗', '9926','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='assetManageGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'assetManageGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位：资产分类查阅岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'assetReadGroup','资产分类查阅岗', '9927','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='assetReadGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'assetReadGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

--------------------------------------  岗位-角色配置  ----------------------------------------------------
-- 插入岗位-角色：资产分类管理岗位，资产分类管理角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('assetManageGroup') and r.CODE in ('BC_ASSET_TYPE_MANAGE')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

-- 插入岗位-角色：资产分类查阅岗位，资产分类查阅角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('assetReadGroup') and r.CODE in ('BC_ASSET_TYPE_READ')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

--------------------------------------  岗位-用户配置  ----------------------------------------------------
-- 插入岗位-用户：资产分类管理岗位-admin
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='assetManageGroup' 
	and af.CODE in ('admin') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位-用户：资产分类查阅岗位-dragon
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='assetReadGroup' 
	and af.CODE in ('dragon') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

