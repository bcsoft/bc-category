package cn.bc.category.service;

import cn.bc.category.domain.Category;
import cn.bc.core.service.CrudService;

public interface CategoryService extends CrudService<Category>{

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
}
