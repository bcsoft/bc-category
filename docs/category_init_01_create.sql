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

/**
 * 根据pid获得对应的上级分类名称的字符串，如：合同的所属分类   格式："模板/经济合同"
 */
CREATE or replace FUNCTION func_get_category_type(in in_id int4, out o_type text)  AS 
$$ 
DECLARE
   v_rec_record RECORD;
BEGIN
  o_type = '';
  FOR v_rec_record IN (WITH RECURSIVE r AS (SELECT *
                           FROM bc_category
                          WHERE id = in_id
                         union ALL
                         SELECT bc_category.*
                           FROM bc_category, r
                          WHERE bc_category.id = r.pid)SELECT name_
                         FROM r where r.id != in_id
                        ORDER BY id) LOOP
	if o_type ='' then
		o_type := v_rec_record.name_;
	else
		o_type := o_type|| '/' || v_rec_record.name_;
  	end if; 
  
  END LOOP;
  return;
END; 
$$
LANGUAGE 'plpgsql';
