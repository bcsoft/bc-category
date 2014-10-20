-- 账号及其隶属的组织（单位、部门或岗位）及这些组织的所有祖先
with recursive actor(id) as (
	select id from bc_identity_actor where code = '${code}'
	union
	select identity_find_actor_ancestor_ids('${code}')
)
-- 后代节点
, category (id, full_sn, deep) as (
	-- 指定节点的一级子节点（含ACL控制）
	select id, array[sn::text], 0
		from bc_category c
		-- 一级子节点
		where <#if pid??>pid = ?<#else>pid is null</#if> 
		-- 管理员则不进行 ACL 控制
		<#if !isManager??>
		--  ACL 控制
		and not exists (
			select 0 from bc_acl_actor aa
				inner join bc_acl_doc ad on aa.pid = ad.id
				where ad.doc_type = 'Category' and ad.doc_id = c.id::text
				and (
					-- 禁止查阅的控制
					(aa.role = '00' and aa.aid in (select id from actor))
					or
					-- 限定只能别人查阅的控制
					(aa.role in ('11', '01') and aa.aid not in (select id from actor))
				)
		)
		</#if>
	
<#if isRoot>
	-- 递归获取后代节点
	union all 
	select c.id, p.full_sn || c.sn::text, p.deep + 1
		from bc_category c
		inner join category p on p.id = c.pid
		-- 管理员则不进行 ACL 控制
		<#if !isManager??>
		--  ACL 控制
		and not exists (
			select 0 from bc_acl_actor aa
				inner join bc_acl_doc ad on aa.pid = ad.id
				where ad.doc_type = 'Category' and ad.doc_id = c.id::text
				and (
					-- 禁止查阅的控制
					(aa.role = '00' and aa.aid in (select id from actor))
					or
					-- 限定只能别人查阅的控制
					(aa.role in ('11', '01') and aa.aid not in (select id from actor))
				)
		)
		</#if>
</#if>
)
select count(*)
	from category c
	inner join bc_category oc on oc.id = c.id

	-- 条件
	<#if condition??>${condition}</#if>

	-- 分页
	<#if limit??>limit ${limit}<#else>limit 25</#if>
	<#if offset??>offset ${offset}</#if>