/** 分类管理视图 SQL
 */

select count(*)
	from bc_category c
	-- 条件
	<#if condition??>${condition}</#if>

	-- 分页
	<#if limit??>limit ${limit}<#else>limit 25</#if>
	<#if offset??>offset ${offset?c}</#if>