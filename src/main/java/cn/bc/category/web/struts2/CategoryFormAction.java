package cn.bc.category.web.struts2;

import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.bc.category.domain.Category;
import cn.bc.category.service.CategoryService;
import cn.bc.identity.domain.ActorHistory;
import cn.bc.identity.web.SystemContext;
import cn.bc.web.struts2.EntityAction;

@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
public class CategoryFormAction extends EntityAction<Long,Category> implements
	SessionAware{

	private static final long serialVersionUID = 1L;
	
	public boolean isNew;
	
	public String ptype;
	
	private CategoryService categoryService;
	@Autowired
	public void setCategoryService(CategoryService categoryService){
		this.setCrudService(categoryService);
		this.categoryService = categoryService;
	}
	
	@Override
	public boolean isReadonly() {
		SystemContext context = (SystemContext) this.getContext();		
		return !context.hasAnyRole(
				getText("key.role.bc.category.manage"),getText("key.role.bc.admin"));
	}
	
	public String form () throws Exception{
		getStatusList();
		if(isNew){
			return this.create();
		}else{
			return this.edit();
		}	
	
	}

	@Override
	public String save() throws Exception {
		return super.save();
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
		//等到分类的父级分类
		if(!isNew){
			this.ptype = this.categoryService.find4ParentType(this.getId());
		}
	}
	
	@Override
	public String create() throws Exception {
		return super.create();
	}
	
	public Map<String, String> getStatusList() {
		Map<String, String> map = new LinkedHashMap<String, String>();
		map.put("0", getText("category.status.enabled"));
		map.put("1", getText("category.status.disabled"));
		return map;
	}
	
	/*private static final long serialVersionUID = 1L;
	protected Log logger = LogFactory.getLog(getClass());
	public Map<String,String> statusList = null; //状态列表

	public Category category;
	private CategoryService categoryService;
	public boolean isNew;
	public String id;	
	public String json;
	
	private Map<String, Object> request;
	private Map<String, Object> session;
	
	@Autowired
	public void setCategoryService(CategoryService categoryService){
		this.categoryService = categoryService;
	}
	
	public String form(){
		this.statusList = getStatusList();		
		if(!isNew)
			category = this.categoryService.find4OneCategory(Long.parseLong(String.valueOf(id)));			
		return "form";
	}
	
	public String save() throws JSONException, IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		
		JSONObject jsonObject = new JSONObject();
		//Category category1 =  this.categoryService.find4OneCategory(Long.parseLong(String.valueOf(id)));
		
		Category category = this.categoryService.find4OneCategory(Long.parseLong(String.valueOf(id)));
		
		PropertyUtils.setProperty(category, "code", "haha");
		PropertyUtils.setProperty(category, "name_", "测试名称");
		
		boolean flag = categoryService.saveCategory(category);
		jsonObject.put("seccess", true);
		jsonObject.put("msg", "保存成功");
		this.json = jsonObject.toString();
		return "json";
	}
	
	
	public Map<String, String> getStatusList() {
		Map<String, String> map = new LinkedHashMap<String, String>();
		map.put("0", getText("category.status.enabled"));
		map.put("1", getText("category.status.disabled"));
		return map;
	}*/

	/*public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public void setRequest(Map<String, Object> request) {
		this.request = request;
	}*/

}
