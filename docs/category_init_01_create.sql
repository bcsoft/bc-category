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
  CONSTRAINT bcuk_category_pid_code UNIQUE (pid, code),
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