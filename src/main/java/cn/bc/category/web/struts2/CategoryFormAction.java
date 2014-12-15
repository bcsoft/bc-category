package cn.bc.category.web.struts2;

import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.bc.category.domain.Category;
import cn.bc.category.service.CategoryService;
import cn.bc.core.util.StringUtils;
import cn.bc.identity.domain.ActorHistory;
import cn.bc.identity.web.SystemContext;
import cn.bc.web.struts2.EntityAction;
import cn.bc.web.ui.html.page.ButtonOption;
import cn.bc.web.ui.html.page.PageOption;
import cn.bc.web.ui.json.Json;

/**
 * 分类模块表单
 * 
 * @author LeeDane
 * 
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
public class CategoryFormAction extends EntityAction<Long, Category> implements
		SessionAware {

	private static final long serialVersionUID = 1L;

	public boolean isNew;

	public String pname;// 父类别名
	public String actor_name;

	public String manageRole;// 对应每个模块的管理者编码，如果没有，就需要进行ACL权限判断了！
	public String rootNode;// 等于空表示是最上级的节点！

	public long rootId;// 根节点ID
	public String fullAcl;// 根节点累计下来的ACL role

	/** 命名空间 */
	public String namespace;

	private CategoryService categoryService;

	@Autowired
	public void setCategoryService(CategoryService categoryService) {
		this.setCrudService(categoryService);
		this.categoryService = categoryService;
	}

	@Override
	public boolean isReadonly() {// 拥有管理员的角色和分类管理的角色
		SystemContext context = (SystemContext) this.getContext();

		if (manageRole != null && !"".equals(manageRole)) // manageRole不为空
			// 包含管理角色
			if (context.hasAnyRole(manageRole, getText("key.role.bc.admin")))
				return false;

		// 不包含管理角色，判断ACL
		if (fullAcl != null)
			return fullAcl.indexOf("10") == -1 && fullAcl.indexOf("11") == -1;

		// 没有管理角色也没有ACL编辑权限
		return true;
	}

	public String form() throws Exception {
		getStatusList();
		if (isReadonly()) {
			return this.open();
		} else {
			if (isNew) {
				return this.create();
			} else {
				return this.edit();
			}
		}

	}

	@Override
	protected Category createEntity() {
		Category c = super.createEntity();
		c.setPid(this.getE().getPid());
		return c;
	}

	@Override
	protected void beforeSave(Category entity) {
		ActorHistory actor = getContext().getAttr("userHistory");
		entity.setModifier_id(Integer.parseInt(String.valueOf(actor.getId())));
		entity.setModified_date(Calendar.getInstance());
		super.beforeSave(entity);
	}

	@Override
	protected void initForm(boolean editable) throws Exception {
		// 得到分类的父级分类
		if (!isNew) {
			List<Map<String, Object>> lists = this.categoryService
					.find4ParentType(this.getId());
			if (lists.size() > 0) {
				if (lists.get(0).get("name_") != null)
					pname = String.valueOf(lists.get(0).get("name_"));
				if (lists.get(0).get("actor_name") != null)
					actor_name = String.valueOf(lists.get(0).get("actor_name"));
			}
		} else {
			ActorHistory actor = getContext().getAttr("userHistory");
			actor_name = actor.getName();
		}

		super.initForm(editable);
	}

	public Map<String, String> getStatusList() {
		Map<String, String> map = new LinkedHashMap<String, String>();
		map.put("0", getText("category.status.enabled"));
		map.put("1", getText("category.status.disabled"));
		return map;
	}

	// 表单的大小
	@Override
	protected PageOption buildFormPageOption(boolean editable) {
		return super.buildFormPageOption(editable).setWidth(620).setHeight(210)
				.setMinHeight(200).setMinWidth(600);
	}

	@Override
	protected void buildFormPageButtons(PageOption pageOption, boolean editable) {
		if (!isReadonly()) {
			// 保存按钮
			ButtonOption saveButtonOption = new ButtonOption("保存", null,
					"bc.categoryForm.save");
			pageOption.addButton(saveButtonOption);
		}
	}

	@Override
	public String save() throws Exception {
		try {
			return super.save();
		} catch (Exception e) {
			Json js = new Json();
			js.put("success", false);
			js.put("msg", "这个编码在该分类下已经存在");
			this.json = js.toString();
			return "json";
		}

	}

	// 不使用打印功能
	@Override
	protected boolean useFormPrint() {
		return false;
	}

	/*
	 * private static final long serialVersionUID = 1L; protected Log logger =
	 * LogFactory.getLog(getClass()); public Map<String,String> statusList =
	 * null; //状态列表
	 * 
	 * public Category category; private CategoryService categoryService; public
	 * boolean isNew; public String id; public String json;
	 * 
	 * private Map<String, Object> request; private Map<String, Object> session;
	 * 
	 * @Autowired public void setCategoryService(CategoryService
	 * categoryService){ this.categoryService = categoryService; }
	 * 
	 * public String form(){ this.statusList = getStatusList(); if(!isNew)
	 * category =
	 * this.categoryService.find4OneCategory(Long.parseLong(String.valueOf
	 * (id))); return "form"; }
	 * 
	 * public String save() throws JSONException, IllegalAccessException,
	 * InvocationTargetException, NoSuchMethodException {
	 * 
	 * JSONObject jsonObject = new JSONObject(); //Category category1 =
	 * this.categoryService
	 * .find4OneCategory(Long.parseLong(String.valueOf(id)));
	 * 
	 * Category category =
	 * this.categoryService.find4OneCategory(Long.parseLong(String
	 * .valueOf(id)));
	 * 
	 * PropertyUtils.setProperty(category, "code", "haha");
	 * PropertyUtils.setProperty(category, "name_", "测试名称");
	 * 
	 * boolean flag = categoryService.saveCategory(category);
	 * jsonObject.put("seccess", true); jsonObject.put("msg", "保存成功"); this.json
	 * = jsonObject.toString(); return "json"; }
	 * 
	 * 
	 * public Map<String, String> getStatusList() { Map<String, String> map =
	 * new LinkedHashMap<String, String>(); map.put("0",
	 * getText("category.status.enabled")); map.put("1",
	 * getText("category.status.disabled")); return map; }
	 */

	/*
	 * public void setSession(Map<String, Object> session) { this.session =
	 * session; }
	 * 
	 * public void setRequest(Map<String, Object> request) { this.request =
	 * request; }
	 */

}
