-- #### 平台相关sql：插入资源、角色、岗位及其之间的关系 ####

--------------------------------------  资源配置  ----------------------------------------------------
-- 插入资源: 分类管理，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800700','分类管理', '/bc/category/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='分类管理');

-- 插入资源: 模板分类，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800701','模板分类', '/bc/tpl/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='模板分类');

-- 插入资源: 办公用品分类，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800702','办公用品分类', '/bc/officeType/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='办公用品分类');

-- 插入资源: 资产分类，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800703','资产分类', '/bc/asset/paging', 'i0308' 
	from BC_IDENTITY_RESOURCE m 
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='资产分类');

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

-- 插入角色: 模板分类管理角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0022', 'BC_TPL_MANAGE','模板分类管理角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_TPL_MANAGE');

-- 插入角色: 模板分类查阅角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0023', 'BC_TPL_READ','模板分类查阅角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_TPL_READ');

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

-- 插入角色: 资产分类管理角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0026', 'BC_ASSET_TYPE_MANAGE','资产分类管理角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_ASSET_TYPE_MANAGE');

-- 插入角色: 资产分类查阅角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME) 
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0027', 'BC_ASSET_TYPE_READ','资产分类查阅角色'
	from BC_DUAL 
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_ASSET_TYPE_READ');

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

-- 插入角色-资源：模板分类管理角色，模板分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_TPL_MANAGE' 
	and m.NAME='模板分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

-- 插入角色-资源：模板分类查阅角色，模板分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE='BC_TPL_READ' 
	and m.NAME='模板分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

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
	where r.CODE='BC_CATEGORY_READ' 
	and m.NAME='BC_OFFICE_TYPE_READ'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

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

-- 插入岗位：模板分类管理岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'tplManageGroup','模板分类管理岗位', '9922','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='tplManageGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'tplManageGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

-- 插入岗位：模板分类查阅岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'tplReadGroup','模板分类查阅岗位', '9923','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='tplReadGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'tplReadGroup' 
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);

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

-- 插入岗位：资产分类管理岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID,UID_,STATUS_,INNER_,TYPE_,CODE, NAME, ORDER_,PCODE,PNAME) 
	select NEXTVAL('CORE_SEQUENCE'),'group.init.'||NEXTVAL('CORE_SEQUENCE'), 0, false, 3
	, 'assetManageGroup','资产分类管理岗位', '9926','[1]baochengzongbu','宝城'
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
	, 'assetReadGroup','资产分类查阅岗位', '9927','[1]baochengzongbu','宝城'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ACTOR where CODE='assetReadGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='baochengzongbu' 
	and af.CODE = 'assetReadGroup' 
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

-- 插入岗位-角色：模板分类管理岗位，模板分类管理角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('tplManageGroup') and r.CODE in ('BC_TPL_MANAGE')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

-- 插入岗位-角色：模板分类查阅岗位，模板分类查阅角色
insert into BC_IDENTITY_ROLE_ACTOR (AID,RID) 
	select a.id, r.id 
	from BC_IDENTITY_ACTOR a,BC_IDENTITY_ROLE r 
	where a.CODE in ('tplReadGroup') and r.CODE in ('BC_TPL_READ')
	and not exists (select 0 from BC_IDENTITY_ROLE_ACTOR ra where ra.AID=a.id and ra.RID=r.id);

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
-- 插入岗位-用户：某岗位包含某些用户
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_,MASTER_ID,FOLLOWER_ID) 
    select 0,am.id,af.id
    from BC_IDENTITY_ACTOR am,BC_IDENTITY_ACTOR af
    where am.CODE='CategoryManageGroup' 
	and af.CODE in ('admin') -- 用户帐号
	and not exists (select 0 from BC_IDENTITY_ACTOR_RELATION r where r.TYPE_=0 and r.MASTER_ID=am.id and r.FOLLOWER_ID=af.id);