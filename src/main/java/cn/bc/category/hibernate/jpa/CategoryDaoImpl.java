package cn.bc.category.hibernate.jpa;

import cn.bc.category.Dao.CategoryDao;
import cn.bc.category.domain.Category;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.orm.hibernate.jpa.HibernateCrudJpaDao;

public class CategoryDaoImpl extends HibernateCrudJpaDao<Category> implements CategoryDao {

	public Category find4OneCategory(long id) {
		return this.createQuery().condition(new AndCondition().add(new EqualsCondition("id", id))).singleResult();
	}

	public boolean saveCategory(Category category) {
		
		return this.save(category) != null;
	}
}
