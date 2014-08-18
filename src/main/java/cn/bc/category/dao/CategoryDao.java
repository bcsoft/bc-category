package cn.bc.category.dao;

import java.util.List;
import java.util.Map;

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
	 * 通过PID查找
	 * 
	 * @param pid 父类别ID
	 * @return
	 */
	List<Map<String, Object>> findForPid(Integer pid);
	/**
	 * 查找父类的名称和修改者名称
	 * @param id 分类的id
	 * @return
	 */
	public List<Map<String , Object>> find4ParentType(Long id);
}
