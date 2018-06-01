------------------------------ 数据表 ------------------------------

-- 删除表
drop table if exists bc_category;

-- 建表
create table bc_category (
  id            integer                     not null,
  pid           integer, -- 父类别ID
  status_       integer                     not null default 0, -- 状态，0-正常、1-禁用
  code          character varying(100)      not null, -- 编码
  name_         character varying(255)      not null, -- 名称
  sn            character varying(100), -- 同级节点间的顺序号
  modifier_id   integer                     not null, -- 最后修改人ID
  modified_date timestamp without time zone not null, -- 最后修改时间
  constraint bcpk_category primary key (id),
  constraint bcfk_category_father foreign key (pid)
  references bc_category (id)
  on update no action on delete no action,
  constraint bcfk_category_modifier foreign key (modifier_id)
  references bc_identity_actor_history (id)
  on update no action on delete no action,
  --CONSTRAINT bcuk_category_pid_code UNIQUE (pid, code),
  constraint bcck_category_code_no_slash check (code !~~ '%/%')
);
comment on table bc_category is '分类模块';
comment on column bc_category.pid is '父类别ID';
comment on column bc_category.status_ is '状态: 0-正常,1-禁用';
comment on column bc_category.code is '编码';
comment on column bc_category.name_ is '名称';
comment on column bc_category.sn is '同级节点间的顺序号';
comment on column bc_category.modifier_id is '最后修改人ID';
comment on column bc_category.modified_date is '最后修改时间';

--建立pid和code的唯一性索引
create unique index bcuk_category_pid_code on bc_category ((coalesce(pid, -1) || code));

------------------------------ 存储函数 ------------------------------

-- 删除函数
drop function if exists category_get_id_by_full_code( text );

-- 创建函数
create or replace function category_get_id_by_full_code(full_code text)
  returns integer as
$BODY$
/** 获取 full code 的 id
 *	@param full_code 树节点全编码
 */
declare
  _id int;
  i   int;
  r   record;
begin
  -- 参数为空返回空值
  if $1 is null
  then
    return null;
  end if;

  i := 0;
  for r in select unnest(string_to_array($1, '/')) as code
           from bc_dual
  loop
    if i = 0
    then
      select c.id into _id
      from bc_category c
      where c.pid is null and c.code = r.code;
    else
      select c.id into _id
      from bc_category c
      where c.pid = _id and c.code = r.code;
    end if;

    -- id 为空返回空值
    if _id is null
    then
      return null;
    end if;

    i := i + 1;
  end loop;
  -- 返回查询到的id
  return _id;
end;
$BODY$
language plpgsql volatile;

------------------------------ 存储函数 ------------------------------

-- Function: category_find_offspring_by_pid(integer)

drop function if exists category_find_offspring_by_pid( integer );

create or replace function category_find_offspring_by_pid(pid integer)
  returns setof integer as
$BODY$
/** 获取 category 的后代分类
 *  @param pid 分类category的id
 */
begin
  return query
  with recursive category (id) as (
    -- 父节点
    select id
    from bc_category bc
    where bc.pid = $1
    -- 递归获取子节点
    union all
    select c.id
    from bc_category c
    inner join category p on p.id = c.pid
  ) select *
    from category;
end;
$BODY$
language plpgsql volatile;

------------------------------ 存储函数 ------------------------------

-- Function: category_get_full_acl_by_id_actorid(integer, text)

drop function if exists category_get_full_acl_by_id_actorid( integer, text );

create or replace function category_get_full_acl_by_id_actorid(id integer, actor_code text)
  returns setof text as
$BODY$
/** 获取参与者的当前分类(bc_category)的 ACL 信息
 *  @param id 当前分类ID
 *  @param actor_code 参与者code
 *  return 分类从祖先分类继承下来的ACL配置，没有配置为null
 */
begin
  return query
  -- 账号及其隶属的组织（单位、部门或岗位）及这些组织的所有祖先
  with recursive actor(id) as (
    select i.id
    from bc_identity_actor i
    where code = $2
    union
    select identity_find_actor_ancestor_ids($2)
  ),
    -- 递归获取所属分类的ACL配置（包含自己）
      category (id, pid, acl) as (
      -- 当前分类
      select c.id, c.pid, -- 查找ACL配置
        (select aa.role
         from bc_acl_actor aa
         inner join bc_acl_doc ad on aa.pid = ad.id
         where ad.doc_id = c.id :: text
               and aa.aid in (select a.id
                              from actor a))
      from bc_category c
      where c.id = $1
      union all
      -- 所属分类
      select p.id, p.pid, -- 查找ACL配置
        (select aa.role
         from bc_acl_actor aa
         inner join bc_acl_doc ad on aa.pid = ad.id
         where ad.doc_id = p.id :: text
               and aa.aid in (select a.id
                              from actor a))
      from bc_category p
      inner join category c on p.id = c.pid
    )
  select bit_and(acl :: bit(2)) :: text
  from category;
end;
$BODY$
language plpgsql volatile;