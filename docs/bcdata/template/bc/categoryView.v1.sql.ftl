/** 分类管理视图 SQL
 */

select c.status_,c.name_, c.code, c.sn, 
	(select bc.name_ from bc_category bc where c.pid = bc.id) as father, 
	(select name from bc_identity_actor a inner join bc_acl_actor acl on acl.aid = a.id where acl.pid = c.id ) as acl,
	CONCAT ((select h.actor_name from bc_identity_actor_history h where h.id = c.modifier_id),' ',c.modified_date) as modified
	from bc_category c
	-- 条件
	<#if condition??>${condition}</#if>

	-- 分页
	<#if limit??>limit ${limit}<#else>limit 25</#if>
	<#if offset??>offset ${offset?c}</#if>