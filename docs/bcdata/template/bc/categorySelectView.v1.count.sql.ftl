-- 账号及其隶属的组织（单位、部门或岗位）及这些组织的所有祖先
with recursive actor(id) as (
	select i.id from bc_identity_actor i where code = 'xzc'
	union
	select identity_find_actor_ancestor_ids('xzc')
),
-- 递归获取父节点下的后代节点（同级之间按 sn 排序）
category (id, pid, status_, code, name_ , pname, sn, full_sn, acl) as (
	-- 父节点
	select id, pid, status_, code, name_, 
		(case when id=p.id and code=p.code then '' else p.name_ end), 
		sn, Array[sn::text],
		-- 查找ACL配置
		(
			select aa.role from bc_acl_actor aa
				inner join bc_acl_doc ad on aa.pid = ad.id 
				where ad.doc_id = p.id::text
				and aa.aid in (select a.id from actor a)
		)
		from bc_category p 
		<#if isRoot == true>
			where pid is null --查询所有
		<#else>
			where p.id = ? --根据pid查找
		</#if>
					
	union ALL

	-- 递归获取子节点
	select c.id, c.pid, c.status_, c.code, c.name_ ,p.name_ ,
		c.sn, p.full_sn || c.sn::text,
		-- 查找ACL配置，为空则继承父ACL
		COALESCE(
			(
				select aa.role from bc_acl_actor aa
					inner join bc_acl_doc ad on aa.pid = ad.id 
					where ad.doc_id = c.id::text
					and aa.aid in (select a.id from actor a)
			)
			, p.acl)
		from bc_category c
			INNER JOIN category p ON p.id = c.pid
)
, category_ (id, pid, status_, code, name_ , pname, sn, full_sn, acl) as (
	select * from category c 
	<#if isManager == false>
		-- 不是管理员按acl权限过滤
		where c.acl is not null
	</#if>
)
select count(*)
	from category_ c 

	-- 条件
	<#if condition??>${condition}</#if>

	-- 分页
	<#if limit??>limit ${limit}<#else>limit 25</#if>
	<#if offset??>offset ${offset?c}</#if>