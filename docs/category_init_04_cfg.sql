-- 插入模板

-- 平台/分类管理
insert into bc_template (id,order_,code,content,file_date,author_id,modifier_id,modified_date,subject,
	path,inner_,desc_,status_,version_,category,type_id,size_,formatted,uid_)
	select nextval('core_sequence'),'5004','BC-CATEGORY',null,now(),
		(select id from bc_identity_actor_history where actor_code='admin' and current=true),
		(select id from bc_identity_actor_history where actor_code='admin' and current=true),now(),
		'分类管理','bc/categoryView.v1.sql.ftl',false,'分类管理模块SQL查询语句模板',0,'1.0','平台/分类管理',
		(select id from bc_template_type where code='freemarker'),
		0,false,'Template.category.1'
	from BC_DUAL 
	where not exists (select 0 from bc_template where code='BC-CATEGORY');

-- 平台/分类管理总数
insert into bc_template (id,order_,code,content,file_date,author_id,modifier_id,modified_date,subject,
	path,inner_,desc_,status_,version_,category,type_id,size_,formatted,uid_)
	select nextval('core_sequence'),'5005','BC-CATEGORY-COUNT',null,now(),
		(select id from bc_identity_actor_history where actor_code='admin' and current=true),
		(select id from bc_identity_actor_history where actor_code='admin' and current=true),now(),
		'分类管理','bc/categoryView.v1.countSql.ftl',false,'分类管理模块总行数SQL查询语句模板',0,'1.0','平台/分类管理',
		(select id from bc_template_type where code='freemarker'),
		0,false,'Template.category.2'
	from BC_DUAL 
	where not exists (select 0 from bc_template where code='BC-CATEGORY-COUNT');