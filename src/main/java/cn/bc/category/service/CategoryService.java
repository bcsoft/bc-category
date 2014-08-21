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
	 * @param pid 父节点ID
	 * @return
	 */
	List<Map<String, Object>> findSubNodesData(Long pid);

	/**
	 * 通过full_code获得id
	 * 
	 * @param full_code
	 * @return
	 */
	Long getIdByFullCode(String full_code);
}
