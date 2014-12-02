-- 清除资源、角色、岗位配置数据
-- 模板分类
delete from BC_IDENTITY_ROLE_RESOURCE where sid in
	(select id from BC_IDENTITY_RESOURCE where name like '%模板分类%');
delete from BC_IDENTITY_RESOURCE where name like '%模板分类%';
-- 角色
delete from BC_IDENTITY_ROLE_ACTOR where rid in
	(select id from BC_IDENTITY_ROLE where code like 'BC_TEMPLATE_CATEGORY_%');
delete from bc_identity_role_resource where rid in
	(select id from BC_IDENTITY_ROLE where code like 'BC_TEMPLATE_CATEGORY_%');
delete from BC_IDENTITY_ROLE where code like 'BC_TEMPLATE_CATEGORY_%';


--------------------------------------  资源配置  ----------------------------------------------------
-- 插入资源: 模板分类，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS)
	select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800701','模板分类', '/bc/tpl/paging', 'i0308'
	from BC_IDENTITY_RESOURCE m
	where m.name='系统维护' -- 隶属
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='模板分类');

--------------------------------------  角色配置  ----------------------------------------------------
-- 插入角色: 模板分类管理角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME)
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0022', 'BC_TEMPLATE_CATEGORY_MANAGE','模板分类管理'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_TEMPLATE_CATEGORY_MANAGE');

-- 插入角色: 模板分类查阅角色
insert into BC_IDENTITY_ROLE (ID,STATUS_,INNER_,TYPE_,ORDER_,CODE,NAME)
	select NEXTVAL('CORE_SEQUENCE'), 0, false,  0,'0023', 'BC_TEMPLATE_CATEGORY_READ','模板分类查阅'
	from BC_DUAL
	where not exists (select 0 from BC_IDENTITY_ROLE where CODE='BC_TEMPLATE_CATEGORY_READ');

--------------------------------------  角色-资源配置  ----------------------------------------------------
-- 插入角色-资源：模板分类管理角色，模板分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID)
	select r.id,m.id
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m
	where r.CODE='BC_TEMPLATE_CATEGORY_MANAGE'
	and m.NAME='模板分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);

-- 插入角色-资源：模板分类查阅角色，模板分类资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID)
	select r.id,m.id
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m
	where r.CODE='BC_TEMPLATE_CATEGORY_READ'
	and m.NAME='模板分类'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);
