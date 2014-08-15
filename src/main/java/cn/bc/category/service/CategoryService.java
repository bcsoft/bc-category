package cn.bc.category.service;

import java.util.List;
import java.util.Map;

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

	/**
	 * 查找nodeId下的子节点，nodeId的格式为： code:pid
	 * 
	 * @param nodeId 节点ID
	 * @return
	 */
	List<Map<String, Object>> findSubNodesData(String nodeId);

	/**
	 * 查找父类的名称
	 */
	public String find4ParentType(Long id);
}
