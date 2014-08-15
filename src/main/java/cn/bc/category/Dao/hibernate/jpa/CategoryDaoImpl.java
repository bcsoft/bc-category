package cn.bc.category.dao.hibernate.jpa;

import java.util.ArrayList;
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

	public String find4ParentType(Long id) {
		String sql = "select pbc.name_ from bc_category bc left join bc_category pbc on bc.pid = pbc.id where bc.id=?";
		List<Map<String , Object>> list = this.jdbcTemplate.queryForList(sql, id);
		
		if(list.size() > 0) 
			if(list.get(0).get("name_")==null)
				return null;
			else
				return list.get(0).get("name_").toString();
		else 
			return null;
	}
}
