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
	 * 查找pid下的子类别
	 * 
	 * @param pid 父类别ID
	 * @return 一个包含Map的列表，Map key 为：
	 * <p>key: id -- bc_category的id</p>
	 * <p>key: name -- bc_category的name</p>
	 */
	List<Map<String, Object>> findSubNodesData(Long pid);

	/**
	 * 通过节点全编码获得id
	 * 
	 * @param full_code 节点全编码
	 * @return 节点的ID
	 */
	Long getIdByFullCode(String full_code);
}
