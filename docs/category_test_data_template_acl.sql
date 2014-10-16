/* 
delete from bc_acl_doc where id in (11, 12);
select count(*) from bc_category c;

-- 分类树（排好序的）
with recursive category (id, full_sn, deep) as (
	-- 指定节点的一级子节点
	select id, array[sn::text], 0 from bc_category c 
		where pid is null
		--where pid = (select r.id from bc_category r where r.code = 'TPL')
	-- 递归获取后代节点
	union all 
	select c.id, p.full_sn || c.sn::text, p.deep + 1
		from bc_category c inner join category p on p.id = c.pid
)select oc.id, oc.pid, oc.status_, repeat(' ', c.deep * 2) || oc.code, repeat(' ', c.deep * 2) || oc.name_, c.full_sn
	from category c inner join bc_category oc on oc.id = c.id order by c.full_sn;

-- 分类的ACL
select ad.doc_name, a.name, aa.role, a.id, ad.doc_type, ad.doc_id, a.code from bc_acl_actor aa
	inner join bc_acl_doc ad on aa.pid = ad.id
	inner join bc_IDENTITY_ACTOR a on a.id = aa.aid
	where doc_type = 'Category'
	order by ad.doc_name;
*/

-- ACL: 模板
INSERT INTO bc_acl_doc(id, doc_id, doc_type, doc_name, file_date, author_id, modified_date, modifier_id)
	select 11, (select id from bc_category where code = 'TPL')
	, 'Category', '模板'
	, now(), (select id from bc_identity_actor_history where actor_code = 'admin' and current = true)
	, now(), (select id from bc_identity_actor_history where actor_code = 'admin' and current = true)
	from bc_dual where not exists (select 0 from bc_acl_doc where id = 11);
---- admin 可查阅、编辑
INSERT INTO bc_acl_actor(pid, aid, role, order_)
	select 11, (select id from bc_identity_actor where code = 'admin'), '11', 1
	from bc_dual where not exists (
		select 0 from bc_acl_actor 
		where pid = 11 and aid = (select id from bc_identity_actor where code = 'admin')
	);
---- dragon 禁止查阅
INSERT INTO bc_acl_actor(pid, aid, role, order_)
	select 11, (select id from bc_identity_actor where code = 'dragon'), '00', 2
	from bc_dual where not exists (
		select 0 from bc_acl_actor 
		where pid = 11 and aid = (select id from bc_identity_actor where code = 'dragon')
	);


-- ACL: 模板/经济合同（按合同性质）
INSERT INTO bc_acl_doc(id, doc_id, doc_type, doc_name, file_date, author_id, modified_date, modifier_id)
	select 12, (select id from bc_category where code = 'JJHT_BY_BUSINESS')
	, 'Category', '经济合同（按合同性质）'
	, now(), (select id from bc_identity_actor_history where actor_code = 'admin' and current = true)
	, now(), (select id from bc_identity_actor_history where actor_code = 'admin' and current = true)
	from bc_dual where not exists (select 0 from bc_acl_doc where id = 12);
---- admin 可查阅、编辑
INSERT INTO bc_acl_actor(pid, aid, role, order_)
	select 12, (select id from bc_identity_actor where code = 'admin'), '11', 1
	from bc_dual where not exists (
		select 0 from bc_acl_actor 
		where pid = 12 and aid = (select id from bc_identity_actor where code = 'admin')
	);
---- dragon 禁止查阅
INSERT INTO bc_acl_actor(pid, aid, role, order_)
	select 12, (select id from bc_identity_actor where code = 'dragon'), '00', 2
	from bc_dual where not exists (
		select 0 from bc_acl_actor 
		where pid = 12 and aid = (select id from bc_identity_actor where code = 'dragon')
	);

