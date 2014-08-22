/** 分类管理模块视图 计算总数SQL语句模板
 */
-- 递归获取父节点下的后代节点（同级之间按 sn 排序）
with recursive category (id, pid, status_, code, name_, sn, modifier_id, modified_date) as (
	-- 父节点
	select * from bc_category where <#if pid??>pid = ?<#else>pid is null</#if> 
<#if isRoot>
	-- 递归获取子节点
	union all 
	select c.id, c.pid, c.status_, c.code, c.name_, c.sn, c.modifier_id, c.modified_date
		from bc_category c
		inner join category p on p.id = c.pid
</#if>
), category_ (id, status_, name_, code, sn, father, modified) as (
	select id, status_, name_, code, sn, 
		(select ca.name_ from bc_category ca where ca.id = c.pid) as father,
		concat((select h.actor_name from bc_identity_actor_history h where h.id = c.modifier_id), ' ', c.modified_date) as modified
		from category c
)
select count(*) from category_
	-- 条件
	<#if condition??>${condition}</#if>

	-- 分页
	<#if limit??>limit ${limit}<#else>limit 25</#if>
	<#if offset??>offset ${offset}</#if>