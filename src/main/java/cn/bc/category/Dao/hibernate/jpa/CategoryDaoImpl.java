package cn.bc.category.dao.hibernate.jpa;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import cn.bc.category.dao.CategoryDao;
import cn.bc.category.domain.Category;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.db.jdbc.RowMapper;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.orm.hibernate.jpa.HibernateCrudJpaDao;
import cn.bc.orm.hibernate.jpa.HibernateJpaNativeQuery;

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

	public List<Map<String, Object>> findForPid(Integer pid) {
		// 构建查询语句
		SqlObject<Map<String,Object>> sqlObject = new SqlObject<Map<String,Object>>();
		StringBuffer sql = new StringBuffer();
		sql.append("select c.id, c.code, c.name_,");
		sql.append(" (select count(*) from bc_category ca where ca.pid=c.id) as sub");
		sql.append(" from bc_category c");
		sql.append(" where ");
		sql.append(pid != null ? "c.pid = " + pid : "c.pid is null");
		sql.append(" order by sn");

		sqlObject.setSql(sql.toString());
		sqlObject.setArgs(null);

		// 数据映射
		sqlObject.setRowMapper(new RowMapper<Map<String,Object>>() {
			public Map<String, Object> mapRow(Object[] rs, int rowNum) {
				Map<String, Object> map = new HashMap<String, Object>();
				int i = 0;
				map.put("id", rs[i++]);
				map.put("code", rs[i++]);
				map.put("name_", rs[i++]);
				map.put("sub", rs[i++]);
				return map;
			}
		});

		// 执行查询
		return new HibernateJpaNativeQuery(this.getJpaTemplate(), 
				sqlObject).list();
	}
	
	public List<Map<String , Object>> find4ParentType(Long id) {
		String sql = "select pbc.name_,iah.actor_name" +
				" from bc_category bc" +
				" left join bc_category pbc on bc.pid = pbc.id" +
				" left join bc_identity_actor_history iah on iah.id= bc.modifier_id where bc.id=?";
		List<Map<String , Object>> list = this.jdbcTemplate.queryForList(sql, id);
		return list;
	}
}
