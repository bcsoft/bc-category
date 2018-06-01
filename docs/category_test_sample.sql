/** sql 参考 */
select *
from BC_CATEGORY; --order by sn;


-- 递归获取父节点下的后代节点（同级之间按 sn 排序）
with recursive category (id, pid, status_, code, name_, sn, full_sn, nest) as (
  -- 父节点
  select id, pid, status_, code, name_ :: text, sn, array [sn :: text], ''
  from bc_category p
  where pid is null -- 条件

  union all

  -- 递归获取子节点
  select c.id, c.pid, c.status_, c.code, p.nest || '├─' :: text || c.name_ :: text, c.sn, p.full_sn || c.sn :: text,
    p.nest || '├─'
  from bc_category c
  inner join category p on p.id = c.pid
) select *
  from category
  order by full_sn;

-- 递归获取子节点的祖先节点（同级之间按 sn 排序 -- TODO: add full_sn column）
with recursive category (id, pid, status_, code, name_, sn, full_sn) as (
  -- 子节点
  select id, pid, status_, code, name_, sn, array [sn :: text]
  from bc_category c
  where code in ('SFTZ', 'ZC') -- 条件

  union all

  -- 递归获取父节点
  select p.id, p.pid, p.status_, p.code, p.name_, p.sn, p.sn :: text || c.full_sn
  from bc_category p
  inner join category c on c.pid = p.id
) select *
  from category
  order by full_sn;
