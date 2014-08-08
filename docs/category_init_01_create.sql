-- 建表

-- Table: bc_category

-- DROP TABLE bc_category;

CREATE TABLE bc_category
(
  id integer NOT NULL,
  pid integer, -- 父类别ID
  status_ integer NOT NULL DEFAULT 0, -- 状态，0-正常、1-禁用
  code character varying(100) NOT NULL, -- 编码
  name_ character varying(255) NOT NULL, -- 名称
  sn character varying(100), -- 同级节点间的顺序号
  modifier_id integer NOT NULL, -- 最后修改人ID
  modified_date timestamp without time zone NOT NULL, -- 最后修改时间
  CONSTRAINT pk_bc_category PRIMARY KEY (id),
  CONSTRAINT bsfk_category_father FOREIGN KEY (pid)
      REFERENCES bc_category (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT bsfk_category_modified FOREIGN KEY (modifier_id)
      REFERENCES bc_identity_actor_history (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT bc_category_pid_code_key UNIQUE (pid, code),
  CONSTRAINT bc_category_code_check CHECK (code::text !~~ '%/%'::text)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bc_category
  OWNER TO bcsystem;
GRANT ALL ON TABLE bc_category TO bcsystem;
COMMENT ON TABLE bc_category
  IS '分类模块';
COMMENT ON COLUMN bc_category.pid IS '父类别ID';
COMMENT ON COLUMN bc_category.status_ IS '状态，0-正常、1-禁用';
COMMENT ON COLUMN bc_category.code IS '编码';
COMMENT ON COLUMN bc_category.name_ IS '名称';
COMMENT ON COLUMN bc_category.sn IS '同级节点间的顺序号';
COMMENT ON COLUMN bc_category.modifier_id IS '最后修改人ID';
COMMENT ON COLUMN bc_category.modified_date IS '最后修改时间';