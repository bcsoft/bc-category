-- 清除资源、角色、岗位配置数据
-- 办公用品分类
delete from BC_IDENTITY_ROLE_RESOURCE where sid in 
	(select id from BC_IDENTITY_RESOURCE where ORDER_ like '800702');
delete from BC_IDENTITY_RESOURCE where ORDER_ like '800702';
-- 角色
delete from BC_IDENTITY_ROLE_ACTOR where rid in 
	(select id from BC_IDENTITY_ROLE where code like 'BC_OFFICE_TYPE_%');
delete from bc_identity_role_resource where rid in
	(select id from BC_IDENTITY_ROLE where code like 'BC_OFFICE_TYPE_%');
delete from BC_IDENTITY_ROLE where code like 'BC_OFFICE_TYPE_%';
-- 岗位
delete from BC_IDENTITY_ACTOR_RELATION where 
	FOLLOWER_ID in (select id from BC_IDENTITY_ACTOR where name like '%办公用品分类%')
	or MASTER_ID in (select id from BC_IDENTITY_ACTOR where name like '%办公用品分类%');
delete from bc_subscribe_actor where aid in (
	select id from BC_IDENTITY_ACTOR where name like '%办公用品分类%'
);
delete from BC_IDENTITY_ACTOR where name like '%办公用品分类%';

--------------------------------------  资源配置  ----------------------------------------------------
-- 插入资源: 办公用品分类，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800702','办公用品分类', '/bc/officeType/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='办公用品分类');

--------------------------------------  角色配置  ----------------------------------------------------
-- 插入角色: 办公用品分类管理角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0024', 'BC_OFFICE_TYPE_MANAGE','办公用品分类管理角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_OFFICE_TYPE_MANAGE');

-- 插入角色: 办公用品分类查阅角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0025', 'BC_OFFICE_TYPE_READ','办公用品分类查阅角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_OFFICE_TYPE_READ');

--------------------------------------  角色-资源配置  ----------------------------------------------------
-- 插入角色-资源：办公用品分类管理角色，办公用品分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_OFFICE_TYPE_MANAGE' 
	and m.NAME='办公用品分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

-- 插入角色-资源：办公用品分类查阅角色，办公用品分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_OFFICE_TYPE_READ' 
	and m.NAME='办公用品分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

--------------------------------------  岗位配置  ----------------------------------------------------
-- 插入岗位：办公用品分类管理岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'officeManageGroup','办公用品分类管理岗位', '9924','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='officeManageGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'officeManageGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位：办公用品分类查阅岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'officeReadGroup','办公用品分类查阅岗位', '9925','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='officeReadGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'officeReadGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

--------------------------------------  岗位-角色配置  ----------------------------------------------------
-- 插入岗位-角色：办公用品分类管理岗位，办公用品分类管理角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('officeManageGroup') and r.CODE in ('BC_OFFICE_TYPE_MANAGE')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

-- 插入岗位-角色：办公用品分类查阅岗位，办公用品分类查阅角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('officeReadGroup') and r.CODE in ('BC_OFFICE_TYPE_READ')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

--------------------------------------  岗位-用户配置  ----------------------------------------------------
-- 插入岗位-用户：办公用品分类管理岗位-admin
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='officeManageGroup' 
	and af.CODE in ('admin') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位-用户：办公用品分类查阅岗位-dragon
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='officeReadGroup' 
	and af.CODE in ('dragon') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

