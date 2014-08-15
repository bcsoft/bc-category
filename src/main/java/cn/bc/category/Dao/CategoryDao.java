package cn.bc.category.dao;

import cn.bc.category.domain.Category;
import cn.bc.core.dao.CrudDao;
/**
 * 分类模块Dao
 * @author LeeDane
 *
 */
public interface CategoryDao extends CrudDao<Category>{

	/**
	 * 获取一个Category实体
	 * @param id
	 * @return
	 */
	public Category find4OneCategory(long id);
	
	/**
	 * 保存Category实体，返回是否成功
	 * @param category
	 * @return
	 */
	public boolean saveCategory(Category category);
	
	/**
	 * 查找父类的名称
	 */
	public String find4ParentType(Long id);
}
