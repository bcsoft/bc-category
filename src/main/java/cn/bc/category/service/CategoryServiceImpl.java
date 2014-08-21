package cn.bc.category.service;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.bc.category.dao.CategoryDao;
import cn.bc.category.domain.Category;
import cn.bc.core.service.DefaultCrudService;

public class CategoryServiceImpl extends DefaultCrudService<Category> implements CategoryService {
	private CategoryDao categoryDao;
	
	@Autowired
	public void setCategoryDao(CategoryDao categoryDao) {
		this.categoryDao = categoryDao;
		this.setCrudDao(categoryDao);
	}
	public Category find4OneCategory(long id) {		
		return this.categoryDao.find4OneCategory(id);
	}
	public boolean saveCategory(Category category) {
		return this.categoryDao.saveCategory(category);
	}

	public List<Map<String, Object>> findSubNodesData(Long pid) {
		return this.categoryDao.findSubNodesData(pid);
	}

	public Long getIdByFullCode(String fullCode) {
		return this.categoryDao.getIdByFullCode(fullCode);
	}
}
