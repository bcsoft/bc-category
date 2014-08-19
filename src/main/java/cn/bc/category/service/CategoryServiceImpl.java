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

	public List<Map<String, Object>> findSubNodesData(String nodeId) {
		// 格式化参数nodeId，获得PID
		String[] param = nodeId.trim().split(":");
		String pid = param.length > 1 ? param[1] : null;

		// 调用DAO层查找数据
		return pid == null ? this.categoryDao.findByPid(null)
				: this.categoryDao.findByPid(Integer.parseInt(pid));
	}

	public Long findId(String full_code) {
		Long id = this.categoryDao.findByFullCode(full_code);
		return id;
	}
}
