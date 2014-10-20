package cn.bc.category.dao.hibernate.jpa;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import cn.bc.category.dao.CategoryDao;
import cn.bc.category.domain.Category;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.orm.hibernate.jpa.HibernateCrudJpaDao;

public class CategoryDaoImpl extends HibernateCrudJpaDao<Category> implements CategoryDao {
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	public Category find4OneCategory(long id) {
		return this.createQuery().condition(new AndCondition().add(new EqualsCondition("id", id))).singleResult();
	}

	public boolean saveCategory(Category category) {
		return this.save(category) != null;
	}

	public List<Map<String, Object>> findSubNodesData(Long pid, String code) {
//		String sql = "select id, name_ as name from bc_category";
//		if(pid == null){
//			sql += " where pid is null";
//			sql += " order by pid desc, sn asc";
//			return this.jdbcTemplate.queryForList(sql);
//		}else{
//			sql += " where pid = ?";
//			sql += " order by pid desc, sn asc";
//			return this.jdbcTemplate.queryForList(sql, pid);
//		}
		String sql = "with recursive actor(id) as (";
		sql += " select id from bc_identity_actor where code = ?";
		sql += " union";
		sql += " select identity_find_actor_ancestor_ids(?))";
		sql += " , category (id, full_sn) as (";
		sql += " select id, array[sn::text]";
		sql += " from bc_category c";
		if(pid == null)
			sql += " where pid is null";
		else
			sql += " where pid = ?";
		sql += " and not exists (";
		sql += " select 0 from bc_acl_actor aa";
		sql += " inner join bc_acl_doc ad on aa.pid = ad.id";
		sql += " where ad.doc_type = 'Category' and ad.doc_id = c.id::text";
		sql += " and ((aa.role = '00' and aa.aid in (select id from actor))";
		sql += " or (aa.role in ('11', '01') and aa.aid not in (select id from actor)))))";
		sql += " select oc.id as id, oc.name_ as name from category c";
		sql += " inner join bc_category oc on oc.id = c.id";
		if(pid == null)
			return this.jdbcTemplate.queryForList(sql, code, code);
		else
			return this.jdbcTemplate.queryForList(sql, code, code, pid);
	}

	public Long getIdByFullCode(String fullCode) {
		Long id = this.jdbcTemplate.queryForLong("select category_get_id_by_full_code(?)", fullCode);
		id = (id == null || id == 0 ? null : id);
		return id;
	}

	public List<Map<String, Object>> find4ParentType(Long id) {
		String sql = "select pbc.name_,iah.actor_name" +
				" from bc_category bc" +
				" left join bc_category pbc on bc.pid = pbc.id" +
				" left join bc_identity_actor_history iah on iah.id= bc.modifier_id where bc.id=?";
		List<Map<String , Object>> list = this.jdbcTemplate.queryForList(sql, id);
		return list;
	}
}
