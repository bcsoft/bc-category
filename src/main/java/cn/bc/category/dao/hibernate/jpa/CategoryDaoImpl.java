package cn.bc.category.dao.hibernate.jpa;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import cn.bc.category.dao.CategoryDao;
import cn.bc.category.domain.Category;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.orm.hibernate.jpa.HibernateCrudJpaDao;

public class CategoryDaoImpl extends HibernateCrudJpaDao<Category> implements CategoryDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public Category find4OneCategory(long id) {
		return this.createQuery().condition(new AndCondition().add(new EqualsCondition("id", id))).singleResult();
	}

	public boolean saveCategory(Category category) {
		return this.save(category) != null;
	}

	public List<Map<String, Object>> findSubNodesData(Long pid) {
		String sql = "select id, name_ as name from bc_category";
		if(pid == null){
			sql += " where pid is null";
			sql += " order by pid desc, sn asc";
			return this.jdbcTemplate.queryForList(sql);
		}else{
			sql += " where pid = ?";
			sql += " order by pid desc, sn asc";
			return this.jdbcTemplate.queryForList(sql, pid);
		}
	}

	public Long getIdByFullCode(String fullCode) {
		Long id = this.jdbcTemplate.queryForLong("select category_get_id_by_full_code(?)", fullCode);
		id = (id == null || id == 0 ? null : id);
		return id;
	}
}
