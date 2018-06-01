-- 清除资源、角色、岗位配置数据
-- 资源
delete from BC_IDENTITY_ROLE_RESOURCE
where sid in
      (select id
       from BC_IDENTITY_RESOURCE
       where ORDER_ like '800700');
delete from BC_IDENTITY_RESOURCE
where ORDER_ like '800700';
-- 角色
delete from BC_IDENTITY_ROLE_ACTOR
where rid in
      (select id
       from BC_IDENTITY_ROLE
       where code like 'BC_CATEGORY_%');
delete from BC_IDENTITY_ROLE
where code like 'BC_CATEGORY_%';
-- 岗位
delete from BC_IDENTITY_ACTOR_RELATION
where
  FOLLOWER_ID in (select id
                  from BC_IDENTITY_ACTOR
                  where name like '%分类%' and code like '%Category%')
  or MASTER_ID in (select id
                   from BC_IDENTITY_ACTOR
                   where name like '%分类%' and code like '%Category%');
delete from bc_subscribe_actor
where aid in (
  select id
  from BC_IDENTITY_ACTOR
  where name like '%分类%' and code like '%Category%'
);
delete from BC_IDENTITY_ACTOR
where name like '%分类%' and code like '%Category%';
-- 模板
delete from bc_template
where id in
      (select id
       from bc_template
       where code like 'BC-CATEGORY%');
delete from bc_template
where id in
      (select id
       from bc_template
       where code like 'BC-SELECT-CATEGORY%');

--------------------------------------  资源配置  ----------------------------------------------------
-- 插入资源: 分类管理，隶属系统维护
insert into BC_IDENTITY_RESOURCE (ID, STATUS_, INNER_, TYPE_, BELONG, ORDER_, NAME, URL, ICONCLASS)
  select NEXTVAL('CORE_SEQUENCE'), 0, false, 2, m.id, '800700', '分类管理', '/bc/category/paging', 'i0308'
  from BC_IDENTITY_RESOURCE m
  where m.name = '系统维护' -- 隶属
        and not exists(select 0
                       from BC_IDENTITY_RESOURCE
                       where NAME = '分类管理');

--------------------------------------  角色配置  ----------------------------------------------------
-- 插入角色: 分类信息管理角色
insert into BC_IDENTITY_ROLE (ID, STATUS_, INNER_, TYPE_, ORDER_, CODE, NAME)
  select NEXTVAL('CORE_SEQUENCE'), 0, false, 0, '0020', 'BC_CATEGORY_MANAGE', '分类信息管理'
  from BC_DUAL
  where not exists(select 0
                   from BC_IDENTITY_ROLE
                   where CODE = 'BC_CATEGORY_MANAGE');

-- 插入角色: 分类信息查阅角色
insert into BC_IDENTITY_ROLE (ID, STATUS_, INNER_, TYPE_, ORDER_, CODE, NAME)
  select NEXTVAL('CORE_SEQUENCE'), 0, false, 0, '0021', 'BC_CATEGORY_READ', '分类信息查阅'
  from BC_DUAL
  where not exists(select 0
                   from BC_IDENTITY_ROLE
                   where CODE = 'BC_CATEGORY_READ');

--------------------------------------  角色-资源配置  ----------------------------------------------------
-- 插入角色-资源：分类信息管理角色，分类管理资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID, SID)
  select r.id, m.id
  from BC_IDENTITY_ROLE r, BC_IDENTITY_RESOURCE m
  where r.CODE = 'BC_CATEGORY_MANAGE'
        and m.NAME = '分类管理'
        and not exists(select 0
                       from BC_IDENTITY_ROLE_RESOURCE rm
                       where rm.RID = r.id and rm.SID = m.id);

-- 插入角色-资源：分类信息查阅角色，分类管理资源
insert into BC_IDENTITY_ROLE_RESOURCE (RID, SID)
  select r.id, m.id
  from BC_IDENTITY_ROLE r, BC_IDENTITY_RESOURCE m
  where r.CODE = 'BC_CATEGORY_READ'
        and m.NAME = '分类管理'
        and not exists(select 0
                       from BC_IDENTITY_ROLE_RESOURCE rm
                       where rm.RID = r.id and rm.SID = m.id);

--------------------------------------  岗位配置  ----------------------------------------------------
-- 插入岗位：分类管理岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID, UID_, STATUS_, INNER_, TYPE_, CODE, NAME, ORDER_, PCODE, PNAME)
  select NEXTVAL('CORE_SEQUENCE'), 'group.init.' || NEXTVAL('CORE_SEQUENCE'), 0, false, 3, 'CategoryManageGroup',
    '分类信息管理岗', '9920', '[1]baochengzongbu', '宝城'
  from BC_DUAL
  where not exists(select 0
                   from BC_IDENTITY_ACTOR
                   where CODE = 'CategoryManageGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_, MASTER_ID, FOLLOWER_ID)
  select 0, am.id, af.id
  from BC_IDENTITY_ACTOR am, BC_IDENTITY_ACTOR af
  where am.CODE = 'baochengzongbu'
        and af.CODE = 'CategoryManageGroup'
        and not exists(select 0
                       from BC_IDENTITY_ACTOR_RELATION r
                       where r.TYPE_ = 0 and r.MASTER_ID = am.id and r.FOLLOWER_ID = af.id);

-- 插入岗位：分类查阅岗位隶属于宝成
insert into BC_IDENTITY_ACTOR (ID, UID_, STATUS_, INNER_, TYPE_, CODE, NAME, ORDER_, PCODE, PNAME)
  select NEXTVAL('CORE_SEQUENCE'), 'group.init.' || NEXTVAL('CORE_SEQUENCE'), 0, false, 3, 'CategoryReadGroup',
    '分类信息查阅岗', '9921', '[1]baochengzongbu', '宝城'
  from BC_DUAL
  where not exists(select 0
                   from BC_IDENTITY_ACTOR
                   where CODE = 'CategoryReadGroup');
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_, MASTER_ID, FOLLOWER_ID)
  select 0, am.id, af.id
  from BC_IDENTITY_ACTOR am, BC_IDENTITY_ACTOR af
  where am.CODE = 'baochengzongbu'
        and af.CODE = 'CategoryReadGroup'
        and not exists(select 0
                       from BC_IDENTITY_ACTOR_RELATION r
                       where r.TYPE_ = 0 and r.MASTER_ID = am.id and r.FOLLOWER_ID = af.id);

--------------------------------------  岗位-角色配置  ----------------------------------------------------
-- 插入岗位-角色：分类信息管理岗，分类信息管理角色
insert into BC_IDENTITY_ROLE_ACTOR (AID, RID)
  select a.id, r.id
  from BC_IDENTITY_ACTOR a, BC_IDENTITY_ROLE r
  where a.CODE in ('CategoryManageGroup') and r.CODE in ('BC_CATEGORY_MANAGE')
        and not exists(select 0
                       from BC_IDENTITY_ROLE_ACTOR ra
                       where ra.AID = a.id and ra.RID = r.id);

-- 插入岗位-角色：分类信息查阅岗，分类信息查阅角色
insert into BC_IDENTITY_ROLE_ACTOR (AID, RID)
  select a.id, r.id
  from BC_IDENTITY_ACTOR a, BC_IDENTITY_ROLE r
  where a.CODE in ('CategoryReadGroup') and r.CODE in ('BC_CATEGORY_READ')
        and not exists(select 0
                       from BC_IDENTITY_ROLE_ACTOR ra
                       where ra.AID = a.id and ra.RID = r.id);

--------------------------------------  岗位-用户配置  ----------------------------------------------------
-- 插入岗位-用户：分类管理岗-admin
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_, MASTER_ID, FOLLOWER_ID)
  select 0, am.id, af.id
  from BC_IDENTITY_ACTOR am, BC_IDENTITY_ACTOR af
  where am.CODE = 'CategoryManageGroup'
        and af.CODE in ('admin') -- 用户帐号
        and not exists(select 0
                       from BC_IDENTITY_ACTOR_RELATION r
                       where r.TYPE_ = 0 and r.MASTER_ID = am.id and r.FOLLOWER_ID = af.id);

-- 插入岗位-用户：分类查阅岗-dragon
insert into BC_IDENTITY_ACTOR_RELATION (TYPE_, MASTER_ID, FOLLOWER_ID)
  select 0, am.id, af.id
  from BC_IDENTITY_ACTOR am, BC_IDENTITY_ACTOR af
  where am.CODE = 'CategoryManageGroup'
        and af.CODE in ('dragon') -- 用户帐号
        and not exists(select 0
                       from BC_IDENTITY_ACTOR_RELATION r
                       where r.TYPE_ = 0 and r.MASTER_ID = am.id and r.FOLLOWER_ID = af.id);

-- 插入模板

-- 平台/分类管理
insert into bc_template (id, order_, code, content, file_date, author_id, modifier_id, modified_date, subject,
                         path, inner_, desc_, status_, version_, category, type_id, size_, formatted, uid_)
  select nextval('core_sequence'), '5004', 'BC-CATEGORY', null, now(), (select id
                                                                        from bc_identity_actor_history
                                                                        where actor_code = 'admin' and current = true),
    (select id
     from bc_identity_actor_history
     where actor_code = 'admin' and current = true), now(), '分类管理', 'bc/categoryView.v1.sql.ftl', false,
    '分类管理模块SQL查询语句模板', 0, '1.0', '平台/分类管理', (select id
                                             from bc_template_type
                                             where code = 'freemarker'), 0, false, 'Template.category.1'
  from BC_DUAL
  where not exists(select 0
                   from bc_template
                   where code = 'BC-CATEGORY');

-- 平台/分类管理总数
insert into bc_template (id, order_, code, content, file_date, author_id, modifier_id, modified_date, subject,
                         path, inner_, desc_, status_, version_, category, type_id, size_, formatted, uid_)
  select nextval('core_sequence'), '5005', 'BC-CATEGORY-COUNT', null, now(), (select id
                                                                              from bc_identity_actor_history
                                                                              where actor_code = 'admin' and
                                                                                    current = true), (select id
                                                                                                      from
                                                                                                        bc_identity_actor_history
                                                                                                      where actor_code =
                                                                                                            'admin' and
                                                                                                            current =
                                                                                                            true),
    now(), '分类管理', 'bc/categoryView.v1.count.sql.ftl', false, '分类管理模块总行数SQL查询语句模板', 0, '1.0', '平台/分类管理', (select id
                                                                                                          from
                                                                                                            bc_template_type
                                                                                                          where code =
                                                                                                                'freemarker'),
    0, false, 'Template.category.2'
  from BC_DUAL
  where not exists(select 0
                   from bc_template
                   where code = 'BC-CATEGORY-COUNT');

-- 平台/分类管理/选择分类
insert into bc_template (id, order_, code, content, file_date, author_id, modifier_id, modified_date, subject,
                         path, inner_, desc_, status_, version_, category, type_id, size_, formatted, uid_)
  select nextval('core_sequence'), '5006', 'BC-SELECT-CATEGORY', null, now(), (select id
                                                                               from bc_identity_actor_history
                                                                               where actor_code = 'admin' and
                                                                                     current = true), (select id
                                                                                                       from
                                                                                                         bc_identity_actor_history
                                                                                                       where
                                                                                                         actor_code =
                                                                                                         'admin' and
                                                                                                         current =
                                                                                                         true), now(),
    '选择分类', 'bc/categorySelectView.v1.sql.ftl', false, '选择分类视图SQL主模板', 0, '1.0', '平台/分类管理/选择分类', (select id
                                                                                                  from bc_template_type
                                                                                                  where code =
                                                                                                        'freemarker'),
    0, false, 'Template.category.3'
  from BC_DUAL
  where not exists(select 0
                   from bc_template
                   where code = 'BC-SELECT-CATEGORY');

-- 平台/分类管理/选择分类计数
insert into bc_template (id, order_, code, content, file_date, author_id, modifier_id, modified_date, subject,
                         path, inner_, desc_, status_, version_, category, type_id, size_, formatted, uid_)
  select nextval('core_sequence'), '5007', 'BC-SELECT-CATEGORY-COUNT', null, now(), (select id
                                                                                     from bc_identity_actor_history
                                                                                     where actor_code = 'admin' and
                                                                                           current = true), (select id
                                                                                                             from
                                                                                                               bc_identity_actor_history
                                                                                                             where
                                                                                                               actor_code
                                                                                                               = 'admin'
                                                                                                               and
                                                                                                               current =
                                                                                                               true),
    now(), '选择分类计数', 'bc/categorySelectView.v1.count.sql.ftl', false, '选择分类视图SQL计数模板', 0, '1.0', '平台/分类管理/选择分类计数',
    (select id
     from bc_template_type
     where code = 'freemarker'), 0, false, 'Template.category.4'
  from BC_DUAL
  where not exists(select 0
                   from bc_template
                   where code = 'BC-SELECT-CATEGORY-COUNT');
