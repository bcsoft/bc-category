-- 账号及其隶属的组织（单位、部门或岗位）及这些组织的所有祖先
with recursive actor(id) as (
	select id from bc_identity_actor where code = '${code}'
	union
	select identity_find_actor_ancestor_ids('${code}')
)
-- 后代节点
, category (id, full_sn) as (
	-- 指定节点的一级子节点（含ACL控制）
	select id, array[sn::text]
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
					(
						-- 别人能看的
						(aa.role in ('11', '01') and aa.aid not in (select id from actor))
						and
						ad.doc_id not in (
							-- 我能看的
							select my_ad.doc_id from bc_acl_actor my_aa
								inner join bc_acl_doc my_ad on my_aa.pid = my_ad.id
								where my_ad.doc_type = 'Category' and my_ad.doc_id = c.id::text
								and my_aa.role in ('11', '10', '01') 
								and my_aa.aid in (select id from actor)
						)
					)
				)
		)
		</#if>
	
<#if isRoot>
	-- 递归获取后代节点
	union all 
	select c.id, p.full_sn || c.sn::text
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
					(
						-- 别人能看的
						(aa.role in ('11', '01') and aa.aid not in (select id from actor))
						and
						ad.doc_id not in (
							-- 我能看的
							select my_ad.doc_id from bc_acl_actor my_aa
								inner join bc_acl_doc my_ad on my_aa.pid = my_ad.id
								where my_ad.doc_type = 'Category' and my_ad.doc_id = c.id::text
								and my_aa.role in ('11', '10', '01') 
								and my_aa.aid in (select id from actor)
						)
					)
				)
		)
		</#if>
</#if>
)
select t.*
	-- 分类继承下来的ACL权限
	,category_get_full_acl_by_id_actorid(t.id, '${code}') as full_acl 
	from (
		select oc.id as id, poc.id as pid, poc.name_ as father, oc.name_ as name_, oc.status_ as status_,
			oc.code as code, oc.sn as sn, ia.name as modifier, oc.modified_date as modified_date,
			-- 分类的所有用户 ACL 配置信息
			(select string_agg(ida.name||','||aa.role, '::') from bc_acl_actor aa
				inner join bc_acl_doc ad on ad.id = aa.pid
				inner join bc_identity_actor ida on ida.id = aa.aid
				where ad.doc_id = c.id::text 
				and ad.doc_type = 'Category') as acls
			from category c
			inner join bc_category oc on oc.id = c.id
			left join bc_category poc on poc.id = oc.pid
			inner join bc_identity_actor_history ah on ah.id = oc.modifier_id
			inner join bc_identity_actor ia on ia.id = ah.actor_id

			-- 条件
			<#if condition??>${condition}</#if>

			-- 分页
			<#if limit??>limit ${limit}<#else>limit 25</#if>
			<#if offset??>offset ${offset}</#if>

) t
