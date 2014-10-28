package cn.bc.category.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import cn.bc.category.dao.CategoryDao;
import cn.bc.category.domain.Category;
import cn.bc.category.web.struts2.CategoryViewAction;
import cn.bc.core.service.DefaultCrudService;
import cn.bc.identity.web.SystemContextHolder;
import cn.bc.web.ui.html.tree.TreeNode;

public class CategoryServiceImpl extends DefaultCrudService<Category> implements
		CategoryService {
	private final static Log logger = LogFactory
			.getLog(CategoryViewAction.class);
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

	public List<Map<String, Object>> findSubNodesData(Long pid, String code,
			boolean isReadonly) {
		return this.categoryDao.findSubNodesData(pid, code, isReadonly);
	}

	public List<Map<String, Object>> find4ParentType(Long id) {
		return this.categoryDao.find4ParentType(id);
	}

	public Long getIdByFullCode(String fullCode) {
		return this.categoryDao.getIdByFullCode(fullCode);
	}

	public String getLoadTreeData(boolean isReadonly, Long pid) {
		JSONObject json = new JSONObject();
		try {
			List<Map<String, Object>> data = findSubNodesData(pid,
					SystemContextHolder.get().getUser().getCode(), isReadonly);
			json.put("success", true);
			json.put("subNodesCount", data.size());
			json.put("html", TreeNode.buildSubNodes(CategoryViewAction
					.buildTreeNodes(data)));
		} catch (java.lang.Exception e) {
			logger.error(e.getMessage());
		}
		return json.toString();
	}
}
