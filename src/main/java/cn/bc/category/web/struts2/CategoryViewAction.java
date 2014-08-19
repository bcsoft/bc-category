package cn.bc.category.web.struts2;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;

import cn.bc.BCConstants;
import cn.bc.category.service.CategoryService;
import cn.bc.core.Page;
import cn.bc.core.query.Query;
import cn.bc.core.query.cfg.PagingQueryConfig;
import cn.bc.core.query.condition.Condition;
import cn.bc.core.query.condition.ConditionUtils;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.db.jdbc.spring.JdbcTemplatePagingQuery;
import cn.bc.identity.web.SystemContext;
import cn.bc.template.service.TemplateService;
import cn.bc.web.formater.EntityStatusFormater;
import cn.bc.web.struts2.TreeViewAction;
import cn.bc.web.ui.html.grid.Column;
import cn.bc.web.ui.html.grid.HiddenColumn4MapKey;
import cn.bc.web.ui.html.grid.IdColumn;
import cn.bc.web.ui.html.grid.TextColumn4MapKey;
import cn.bc.web.ui.html.page.PageOption;
import cn.bc.web.ui.html.toolbar.Toolbar;
import cn.bc.web.ui.html.toolbar.ToolbarButton;
import cn.bc.web.ui.html.tree.Tree;
import cn.bc.web.ui.html.tree.TreeNode;
import cn.bc.web.ui.json.Json;

import com.sun.star.uno.Exception;

/**
 * 分类视图Action
 * 
 * @author Action
 *
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
public class CategoryViewAction extends TreeViewAction<Map<String, Object>> {
	private static final long serialVersionUID = 1L;
	private final static Log logger = LogFactory.getLog(CategoryViewAction.class);

	@Autowired
	private TemplateService templateService;
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private CategoryService categoryService;

	/** 窗口标题 */
	public String pageTitle;
	/** 管理角色编码 */
	public String manageRole;
	/** 根节点全编码 */
	public String rootNode;
	/** 树节点 */
	public String pid = "node:";
	/** 状态：正常|禁用|全部 */
	public String status = String.valueOf(0);
	/** 父类别ID */
	public Long pid_;

	@Override
	public boolean isReadonly() {
		// 判断当前用户是否只读，拥有manageRole角色即不用判断ACL权限
		SystemContext context = (SystemContext) this.getContext();
		boolean isReadonly = true;
		if (manageRole != null && manageRole.length() != 0) 
			isReadonly = !context.hasAnyRole(manageRole);
		else if (!isReadonly) 
			return isReadonly;

		//TODO 不拥有角色，判断ACL权限
		return isReadonly;
	}

	@Override
	protected Condition getGridSpecalCondition() {
		Condition statusCondition = null;
		if (status != null && status.length() > 0) {
			String[] ss = status.split(",");
			if (ss.length == 1) {
				statusCondition = new EqualsCondition("status_",
						new Integer(ss[0]));
			}
		}

		// 合并多个条件
		return ConditionUtils.mix2AndCondition(statusCondition);
	}

	/**
	 * SQL分页查询语句及参数配置
	 * 
	 * @return
	 * @throws java.lang.Exception 
	 */
	private PagingQueryConfig getPagingQueryConfig() {
		// 是否为根节点
		boolean isRoot = (rootNode == null || rootNode.length() == 0);
		pid_ = this.categoryService.findId(this.rootNode);
		// 加载模板，获得查询SQL
		String querySql = this.templateService.getContent("BC-CATEGORY");
		String countSql = this.templateService.getContent("BC-CATEGORY-COUNT");
		// 查询参数
		List<Object> params = null;

		if (!isRoot && pid_ != null && pid_ > 0) {
			params = new ArrayList<Object>();
			params.add(pid_);
		}

		// 查询对象
		cn.bc.core.query.cfg.impl.PagingQueryConfig cfg = 
				new cn.bc.core.query.cfg.impl.PagingQueryConfig(querySql, countSql, params);
		cfg.addTemplateParam("isRoot", isRoot);

		// 分页参数
		Page<Map<String, Object>> p = getPage();
		if (p != null) {
			cfg.setLimit(p.getPageSize());
			cfg.setOffset(p.getFirstResult());
		}
		return cfg;
	}

	@Override
	protected Query<Map<String, Object>> getQuery() {
		JdbcTemplatePagingQuery<Map<String, Object>> jdbcQuery = null;
		
		jdbcQuery = new JdbcTemplatePagingQuery<Map<String,Object>>(jdbcTemplate, getPagingQueryConfig(), null);
		
		jdbcQuery.condition(this.getGridCondition());
		return jdbcQuery;
	}

	@Override
	protected SqlObject<Map<String, Object>> getSqlObject() {
		throw new UnsupportedOperationException();
	}

	@Override
	protected String getGridRowLabelExpression() {
		return "['pid'] + ['code']";
	}

	@Override
	protected String[] getGridSearchFields() {
		//TODO 查询条件中要匹配的域 要什么域
		return new String[]{"father，c.name_，c.code"};
	}

	@Override
	protected PageOption getHtmlPageOption() {
		return super.getHtmlPageOption().setWidth(850).setMinWidth(600)
				.setHeight(450).setMinHeight(350);
	}

	@Override
	protected String getHtmlPageTitle() {
		// TODO 根据根节点来自动改变窗口标题
		return this.pageTitle;
	}

	@Override
	protected Toolbar getHtmlPageToolbar() {
		// 页面的标题 管理权限可以看到此工具条，只读用户则不能
		// TODO 只读情况下，视图显示不正常
		Toolbar toolbar = new Toolbar();
		if (!this.isReadonly()) {
			// 新建
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb").setText("新建")
					.setClick("bc.category.view.create"));
			// 编辑
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb").setText("编辑")
					.setClick("bc.category.view.edit"));
			// 删除
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb").setText("删除")
					.setClick("bc.category.view.delete_"));
			// 状态
			toolbar.addButton(Toolbar.getDefaultToolbarRadioGroup(
					this.getStatues(), "status", 0, 
					getText("title.click2changeSearchStatus")));
		}
		// 搜索按钮
		toolbar.addButton(this.getDefaultSearchToolbarButton());
		return toolbar;
	}

	@Override
	protected List<Column> getGridColumns() {
		List<Column> columns = new ArrayList<Column>();
		// id列
		columns.add(new IdColumn().setId("id").setValueExpression("['pid'] + ',' + ['code']"));
		// 状态
		columns.add(new TextColumn4MapKey("status", "status_",
				getText("category.status"), 35).setSortable(true)
				.setValueFormater(new EntityStatusFormater(getStatues())));
		// 所属分类
		columns.add(new TextColumn4MapKey("father", "father",
				getText("category.father"), 80).setSortable(true));
		// 名称
		columns.add(new TextColumn4MapKey("name", "name_",
				getText("category.name"), 80).setSortable(true));
		// 编码
		columns.add(new TextColumn4MapKey("code", "code",
				getText("category.code"), 80).setSortable(true));
		// 排序号
		columns.add(new TextColumn4MapKey("sn", "sn",
				getText("category.order"), 60).setSortable(true));
		//TODO 权限配置
		columns.add(new TextColumn4MapKey("acl", "acl",
				getText("category.permiss")).setSortable(true));
		// 最后修改
		columns.add(new TextColumn4MapKey("modified", "modified",
				getText("category.modified"), 240).setSortable(true));
		// 隐藏列
		columns.add(new HiddenColumn4MapKey("id", "id"));
		columns.add(new HiddenColumn4MapKey("name_", "name_"));
		return columns;
	}

	@Override
	protected Tree getHtmlPageTree() {
		String RootNode = pid_ != null ? pid + pid_ : pid;
		Tree tree = new Tree(RootNode, "全部");
		tree.setShowRoot(true);

		// 点击展开子节点图标的URL
		tree.setUrl(this.getHtmlPageNamespace() + "/loadTreeData");

		// 树的参数配置
		Json cfg = new Json();
		// TODO 点击节点的回调函数
		cfg.put("clickNode", "bc.category.view.clickTreeNode");
		tree.setCfg(cfg);

		// 树的数据 
		List<Map<String, Object>> treeData;

		// 构建树的子节点
		Collection<TreeNode> treeNodes;
		try {
			// TODO 查询可能抛异常异常
			treeData = this.categoryService.findSubNodesData(RootNode);
			treeNodes = this.buildTreeNodes(treeData);
			for (TreeNode treeNode : treeNodes) 
				tree.addSubNode(treeNode);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return tree;
	}

	/**
	 * 构建树节点
	 * 
	 * @param treeData 树节点数据
	 * @return
	 */
	private Collection<TreeNode> buildTreeNodes(List<Map<String, Object>> treeData)
			throws Exception {
		List<TreeNode> treeNodes = new ArrayList<TreeNode>();
		for (Map<String, Object> data : treeData) {
			TreeNode node = null;
			node = new TreeNode(
				String.valueOf(data.get("code")) + ":" + String.valueOf(data.get("id")),
				String.valueOf(data.get("name_")),
				!(Integer.parseInt(String.valueOf(data.get("sub"))) > 0));

			treeNodes.add(node);
		}
		return treeNodes;
	}

	/**
	 * 展开树形菜单的子节点
	 * 
	 * @return
	 */
	public String loadTreeData() {
		JSONObject json = new JSONObject();
		try {
			List<Map<String, Object>> data = 
					this.categoryService.findSubNodesData(this.pid);
			json.put("success", true);
			json.put("subNodesCount", data.size());
			json.put("html", TreeNode.buildSubNodes(this.buildTreeNodes(data)));
		} catch (java.lang.Exception e) {
			e.printStackTrace();
		}

		this.json = json.toString();
		return "json";
	}

	@Override
	protected Integer getTreeWith() {
		return 140;
	}

	/**
	 * 状态值转换列表：正常|禁用|全部
	 * 
	 * @return
	 */
	protected Map<String, String> getStatues() {
		Map<String, String> statues = new LinkedHashMap<String, String>();
		statues.put(String.valueOf(BCConstants.STATUS_ENABLED), 
				getText("bc.status.enabled"));
		statues.put(String.valueOf(BCConstants.STATUS_DISABLED), 
				getText("bc.status.disabled"));
		statues.put("", getText("bc.status.all"));
		return statues;
	}

	@Override
	protected String getHtmlPageNamespace() {
		return getModuleContextPath() + "/category";
	}

	@Override
	protected String getHtmlPageJs() {
		return this.getContextPath()
				+ "/modules/bc/category/view.js";
	}
	
	//视图双击的方法
	@Override
	protected String getGridDblRowMethod() {
		return "bc.category.view.edit";
	}

	@Override
	protected String getGridDblRowMethod() {
		return "bc.category.view.edit";
	}

	@Override
	protected String getFormActionName() {
		// TODO 获取表单action的简易名称
		return null;
	}

}
