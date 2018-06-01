package cn.bc.category.service;

import cn.bc.category.domain.Category;
import cn.bc.core.service.CrudService;

import java.util.List;
import java.util.Map;

/**
 * 分类模块业务逻辑处理层接口
 *
 * @author Action
 */
public interface CategoryService extends CrudService<Category> {

  /**
   * 获取一个Category实体
   *
   * @param id
   * @return
   */
  public Category find4OneCategory(long id);

  /**
   * 保存Category实体，返回是否成功
   *
   * @param category
   * @return
   */
  public boolean saveCategory(Category category);

  /**
   * 查找pid下的子类别
   *
   * @param pid 父类别ID
   * @return 一个包含Map的列表，Map key 为：<br>
   * key: id -- bc_category的id <br>
   * key: name -- bc_category的name
   */
  List<Map<String, Object>> findSubNodesData(Long pid, String code,
                                             boolean isReadonly);

  /**
   * 通过节点全编码获得id
   *
   * @param full_code 节点全编码
   * @return 节点的ID
   */
  Long getIdByFullCode(String full_code);

  /**
   * 查找父类的名称和修改者名称
   *
   * @param id 分类的id
   * @return
   */
  public List<Map<String, Object>> find4ParentType(Long id);

  /**
   * 通过 pid 获得子节点
   *
   * @param isReadonly 是否只读
   * @param pid        所属分类Id
   * @return "{'success': true, 'subNodesCount': SIZE, 'html', HTMLElements}"
   */
  String getLoadTreeData(boolean isReadonly, Long pid);
}
