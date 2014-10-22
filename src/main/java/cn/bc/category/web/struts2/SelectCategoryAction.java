package cn.bc.category.web.struts2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;

import cn.bc.category.service.CategoryService;
import cn.bc.core.Page;
import cn.bc.core.query.Query;
import cn.bc.core.query.cfg.PagingQueryConfig;
import cn.bc.core.query.condition.Condition;
import cn.bc.core.query.condition.Direction;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.core.query.condition.impl.InCondition;
import cn.bc.core.query.condition.impl.OrderCondition;
import cn.bc.core.util.StringUtils;
import cn.bc.db.jdbc.RowMapper;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.db.jdbc.spring.JdbcTemplatePagingQuery;
import cn.bc.identity.web.SystemContext;
import cn.bc.template.service.TemplateService;
import cn.bc.web.formater.KeyValueFormater;
import cn.bc.web.struts2.AbstractSelectPageAction;
import cn.bc.web.ui.html.grid.Column;
import cn.bc.web.ui.html.grid.IdColumn4MapKey;
import cn.bc.web.ui.html.grid.TextColumn4MapKey;
import cn.bc.web.ui.html.page.PageOption;

/**
 * 选择所属分类视图
 * @author LeeDane
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
public class SelectCategoryAction  extends AbstractSelectPageAction<Map<String, Object>>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public String status;//分类的状态
	
	public String pageTitle; //窗口的标题
	public String manageRole;//对应每个模块的管理者编码，如果没有，就需要进行ACL权限判断了！
	public String rootNode;//等于空表示是最上级的节点！TPL/JJHT
	
	//public String preCode;//当前的节点编号
	//public Long preId;//当前的节点的id
	
	public int preRoleId;//根据pid查找所有的
	public long preId;//当前要编辑的分类的id，如果没有，就是新建，默认是0
	public String multiSelect;//多选
	
	@Autowired
	private TemplateService templateService;
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private CategoryService categoryService;

	/**
	 * SQL分页查询语句及参数配置
	 * 
	 * @return
	 */
	private PagingQueryConfig getPagingQueryConfig() {
		// 是否为根节点
		boolean isRoot = true;
		//TODO 查询的SQL
		String s1 = this.templateService.getContent("BC-SELECT-CATEGORY");
		String s2 = this.templateService.getContent("BC-SELECT-CATEGORY-COUNT");

		//preRoleId = 23122;
		
		List<Object> args = new ArrayList<Object>();
		if(preRoleId != 0 ){
			//Long pid = this.categoryService.findId(rootNode); //当前的权限下的最大分类的id
			//preCode = "SFTZ";//当前编辑/新建时所要处理的分类的code
			//preId = 23090;//当前编辑/新建时所要处理的分类的id
			args.add(preRoleId);//参数id
			isRoot = false;
			//args.add(preCode);//当前的分类Code
			//args.add(preId);//当前的分类id
		}

		args.add(preId);
		cn.bc.core.query.cfg.impl.PagingQueryConfig cfg =
				new cn.bc.core.query.cfg.impl.PagingQueryConfig(s1, s2, args);
		cfg.addTemplateParam("isRoot",isRoot);
		// 分页参数
		Page<Map<String, Object>> p = getPage();
		if (p != null) {
			cfg.setLimit(p.getPageSize());
			cfg.setOffset(p.getFirstResult());
		}

		return cfg;
	}
	
	@Override
    protected void extendGridExtrasData(JSONObject json) throws JSONException {
		super.extendGridExtrasData(json);

		// 状态条件
		if (this.status != null && this.status.trim().length() > 0) {
			json.put("status", status);
		}

		// 父节点条件
		json.put("preRoleId", this.preRoleId);

		// 是否是调用选择文件夹方法
		//json.put("isSelectFolders", isSelectFolders);

		// 分类多选的条件
		if(this.multiSelect != null && this.multiSelect.length() > 0)
			json.put("multiSelect", "yes");
	}

	@Override
	protected Query<Map<String, Object>> getQuery() {
		JdbcTemplatePagingQuery<Map<String, Object>> jdbcQuery =
				new JdbcTemplatePagingQuery<Map<String,Object>>(jdbcTemplate, getPagingQueryConfig(), null);
		jdbcQuery.condition(this.getGridCondition());
		return jdbcQuery;
	}

	@Override
	protected SqlObject<Map<String, Object>> getSqlObject() {
		throw new UnsupportedOperationException();
	}
	
	@Override
	protected List<Column> getGridColumns() {
		List<Column> columns = new ArrayList<Column>();
		columns.add(new IdColumn4MapKey("id", "id"));
		columns.add(new TextColumn4MapKey("status_", "status",
				getText("category.select.status"), 40).setSortable(true)
				.setValueFormater(new KeyValueFormater(getStatus())));
		columns.add(new TextColumn4MapKey("name_", "name_",
				getText("category.select.name"), 160).setSortable(true).setUseTitleFromLabel(true));		
		columns.add(new TextColumn4MapKey("code", "code",
				getText("category.select.code"), 120).setSortable(true).setUseTitleFromLabel(true));
		columns.add(new TextColumn4MapKey("pname", "pname",
				getText("category.select.type")).setSortable(true)
				.setUseTitleFromLabel(true));;
		return columns;
	}
	
	@Override
	public boolean isReadonly() {
		/*SystemContext context = (SystemContext) this.getContext();		
		
		String manage = this.manageRole;
		System.out.println("manage:"+manage);
		if(manageRole != null && !"".equals(manageRole)){//manageRole不为空
			return !context.hasAnyRole(
					manageRole,getText("key.role.bc.admin"));
		}else{
			//判断ACL
			
			//也没有ACL，直接返回true
			return true;
		}*/
		return true;
	}

	@Override
	protected String getGridRowLabelExpression() {
		return "['name']";
	}

	@Override
	protected String[] getGridSearchFields() {
		return new String[] { "c.name_","c.code" };
	}
	
	@Override
	protected String getModuleContextPath() {
		return this.getContextPath();
	}
	
	@Override
    protected String getHtmlPageNamespace() {
		//要写selectCategoryType，不然搜索或刷新找不到这个命名空间
        return getModuleContextPath() + "/bc/category/selectCategory";
    }
	 
	@Override
	protected String getFormActionName() {
		return "selectCategory";
	}
    @Override
    protected String getViewActionName() {
        return "selectCategory";
    }
	@Override
	protected PageOption getHtmlPageOption() {
		return super.getHtmlPageOption().setWidth(400).setHeight(450);
	}
	
	@Override
	protected String getHtmlPageJs() {
		return this.getContextPath()+"/modules/bc/category/select.js";
	}
	
	
	@Override
	protected Condition getGridSpecalCondition() {
		AndCondition ac=new AndCondition();
		/*if (status != null && status.length() > 0) {
			String[] ss = status.split(",");
			if(ss.length == 1){
				ac.add(new EqualsCondition("c.status_", new Integer(ss[0])));
			} else {
				ac.add(new InCondition("c.status_",
						StringUtils.stringArray2IntegerArray(ss)));
			}
		}else{ //一开始打开视图，默认stauts是空的
			ac.add(new EqualsCondition("c.status_",0));
		}*/

		ac.add(new EqualsCondition("c.status_",0));
		return ac.isEmpty()?null:ac;
	}

	@Override
	protected String getClickOkMethod() {
		return "bc.select.category.clickOk";
	}
	
	@Override
	protected String getHtmlPageTitle() {
		return this.getText("category.select.title");
	}
	
	/**
	 * 复写order by方法！
	 */
	@Override
	protected OrderCondition getGridDefaultOrderCondition() {
		return new OrderCondition("full_sn", Direction.Asc);
	}

	/**
	 * 状态值转换列表：正常|禁用|全部
	 * 
	 * @return
	 */
	private Map<String, String> getStatus() {
		Map<String, String> statuses = new LinkedHashMap<String, String>();
		statuses.put("0",
				getText("category.status.enabled"));
		statuses.put("1",
				getText("category.status.disabled"));
		statuses.put("0,1", getText("category.status.all"));
		return statuses;
	}
	
	@Override
	protected boolean canExport() {
		return false;
	}
}
