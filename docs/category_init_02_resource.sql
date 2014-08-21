--------------------------------------  资源配置  ----------------------------------------------------
-- 插入资源: 分类管理，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800700','分类管理', '/bc/category/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='分类管理');

--------------------------------------  角色配置  ----------------------------------------------------
-- 插入角色: 分类管理管理角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0020', 'BC_CATEGORY_MANAGE','分类管理管理角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_CATEGORY_MANAGE');

-- 插入角色: 分类管理查阅角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0021', 'BC_CATEGORY_READ','分类管理查阅角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_CATEGORY_READ');

--------------------------------------  角色-资源配置  ----------------------------------------------------
-- 插入角色-资源：分类管理管理角色，分类管理资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_CATEGORY_MANAGE' 
	and m.NAME='分类管理'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

-- 插入角色-资源：分类管理查阅角色，分类管理资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_CATEGORY_READ' 
	and m.NAME='分类管理'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

--------------------------------------  岗位配置  ----------------------------------------------------
-- 插入岗位：分类管理管理岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'CategoryManageGroup','分类管理管理岗位', '9920','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='CategoryManageGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'CategoryManageGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位：分类管理查阅岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'CategoryReadGroup','分类管理查阅岗位', '9921','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='CategoryReadGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'CategoryReadGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

--------------------------------------  岗位-角色配置  ----------------------------------------------------
-- 插入岗位-角色：分类管理管理岗位，分类管理管理角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('CategoryManageGroup') and r.CODE in ('BC_CATEGORY_MANAGE')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

-- 插入岗位-角色：分类管理查阅岗位，分类管理查阅角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('CategoryReadGroup') and r.CODE in ('BC_CATEGORY_READ')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

--------------------------------------  岗位-用户配置  ----------------------------------------------------
-- 插入岗位-用户：分类管理管理岗位-admin
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='CategoryManageGroup' 
	and af.CODE in ('admin') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位-用户：分类管理查阅岗位-dragon
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='CategoryManageGroup' 
	and af.CODE in ('dragon') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);
