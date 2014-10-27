------------------------------ 数据表 ------------------------------

-- 删除表
DROP TABLE if exists bc_category;

-- 建表
CREATE TABLE bc_category(
  id integer NOT NULL,
  pid integer, -- 父类别ID
  status_ integer NOT NULL DEFAULT 0, -- 状态，0-正常、1-禁用
  code character varying(100) NOT NULL, -- 编码
  name_ character varying(255) NOT NULL, -- 名称
  sn character varying(100), -- 同级节点间的顺序号
  modifier_id integer NOT NULL, -- 最后修改人ID
  modified_date timestamp without time zone NOT NULL, -- 最后修改时间
  CONSTRAINT bcpk_category PRIMARY KEY (id),
  CONSTRAINT bcfk_category_father FOREIGN KEY (pid)
      REFERENCES bc_category (id)
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT bcfk_category_modifier FOREIGN KEY (modifier_id)
      REFERENCES bc_identity_actor_history (id)
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  --CONSTRAINT bcuk_category_pid_code UNIQUE (pid, code),
  CONSTRAINT bcck_category_code_no_slash CHECK (code !~~ '%/%')
);
COMMENT ON TABLE bc_category IS '分类模块';
COMMENT ON COLUMN bc_category.pid IS '父类别ID';
COMMENT ON COLUMN bc_category.status_ IS '状态: 0-正常,1-禁用';
COMMENT ON COLUMN bc_category.code IS '编码';
COMMENT ON COLUMN bc_category.name_ IS '名称';
COMMENT ON COLUMN bc_category.sn IS '同级节点间的顺序号';
COMMENT ON COLUMN bc_category.modifier_id IS '最后修改人ID';
COMMENT ON COLUMN bc_category.modified_date IS '最后修改时间';

--建立pid和code的唯一性索引
 CREATE UNIQUE INDEX bcuk_category_pid_code ON bc_category ((coalesce(pid,-1)||code));

------------------------------ 存储函数 ------------------------------

-- 删除函数
DROP FUNCTION IF exists category_get_id_by_full_code(text) ;

-- 创建函数
CREATE OR REPLACE FUNCTION category_get_id_by_full_code(full_code text)
  RETURNS integer AS
$BODY$
	/** 获取 full code 的 id
	 *	@param full_code 树节点全编码
	 */
	DECLARE
		_id INT;
		i INT;
		r record;
	BEGIN
		-- 参数为空返回空值
		if $1 is null then 
			return null;
		end if;

		i := 0;
		FOR r IN SELECT unnest(string_to_array($1, '/')) as code from bc_dual
    LOOP
			if i = 0 then
				select c.id into _id from bc_category c where c.pid is null and c.code = r.code;
			else
				select c.id into _id from bc_category c where c.pid = _id and c.code = r.code;
			end if;
			
			-- id 为空返回空值
			if _id is null then 
				return null;
			end if;
			
      i := i + 1;
		END LOOP;
		-- 返回查询到的id
		return _id;
	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE;
  
------------------------------ 存储函数 ------------------------------

-- Function: category_find_offspring_by_pid(integer)

-- DROP FUNCTION category_find_offspring_by_pid(integer);

CREATE OR REPLACE FUNCTION category_find_offspring_by_pid(pid integer)
  RETURNS SETOF integer AS
$BODY$
	/** 获取 category 的后代分类
	 *  @param pid 分类category的id
	 */
	begin
		return query
		with recursive category (id) as (
			-- 父节点
			select id from bc_category bc where bc.pid = $1
			-- 递归获取子节点
			union all 
			select c.id from bc_category c
				inner join category p on p.id = c.pid
		) select * from category;
	end;
$BODY$
  LANGUAGE plpgsql VOLATILE

  ------------------------------ 存储函数 ------------------------------

-- Function: category_get_full_acl_by_id_actorid(integer, text)

-- DROP FUNCTION category_get_full_acl_by_id_actorid(integer, text);

CREATE OR REPLACE FUNCTION category_get_full_acl_by_id_actorid(id integer, actor_code text)
  RETURNS SETOF text AS
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
			select i.id from bc_identity_actor i where code = $2
			union
			select identity_find_actor_ancestor_ids($2)
		),
		-- 递归获取所属分类的ACL配置（包含自己）
		category (id, pid, acl) as (
			-- 当前分类
			select c.id, c.pid,
				-- 查找ACL配置
				(select aa.role from bc_acl_actor aa
					inner join bc_acl_doc ad on aa.pid = ad.id 
					where ad.doc_id = c.id::text
					and aa.aid in (select a.id from actor a))
				from bc_category c
				where c.id = $1
			union all
			-- 所属分类
			select p.id, p.pid,
				-- 查找ACL配置
				(select aa.role from bc_acl_actor aa
					inner join bc_acl_doc ad on aa.pid = ad.id 
					where ad.doc_id = p.id::text
					and aa.aid in (select a.id from actor a))
				from bc_category p
				inner join category c on p.id = c.pid
		) 
		select bit_and(acl::bit(2))::text from category;
	end;
$BODY$
  LANGUAGE plpgsql VOLATILE