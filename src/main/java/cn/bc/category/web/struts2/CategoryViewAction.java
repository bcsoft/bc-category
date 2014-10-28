package cn.bc.category.web.struts2;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
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
import cn.bc.core.query.condition.Direction;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.core.query.condition.impl.OrderCondition;
import cn.bc.core.util.DateUtils;
import cn.bc.core.util.JsonUtils;
import cn.bc.core.util.StringUtils;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.db.jdbc.spring.JdbcTemplatePagingQuery;
import cn.bc.identity.web.SystemContext;
import cn.bc.identity.web.SystemContextHolder;
import cn.bc.template.service.TemplateService;
import cn.bc.web.formater.AbstractFormater;
import cn.bc.web.formater.EntityStatusFormater;
import cn.bc.web.formater.Icon;
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
	private final static Log logger = LogFactory
			.getLog(CategoryViewAction.class);

	@Autowired
	private TemplateService templateService;
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private CategoryService categoryService;

	/** 窗口标题 */
	public String pageTitle;
	/** 命名空间 */
	public String namespace;
	/** 管理角色编码 */
	public String manageRole;
	/** 根节点全编码 */
	public String rootNode;
	/** 当前节点所属分类ID */
	private Long pid;
	/** 点击树节点的回调函数 */
	public String callback;
	/** 状态：正常|禁用|全部 */
	public String status = String.valueOf(0);
	private SystemContext systemContext;

	public Long getPid() {
		if (this.pid == null) {
			return this.categoryService.getIdByFullCode(this.rootNode);
		} else {
			return this.pid;
		}
	}

	public void setPid(Long pid) {
		this.pid = pid;
	}

	@Override
	public boolean isReadonly() {
		// 判断当前用户是否只读，拥有manageRole角色
		this.systemContext = this.getSystemContext();
		return !systemContext.hasAnyRole(manageRole,
				getText("key.role.bc.admin"));
	}

	/**
	 * 是否为树的根节点
	 * 
	 * @return
	 */
	public boolean isRootNode() {
		// 树根节点ID
		Long rootId = this.categoryService.getIdByFullCode(this.rootNode);
		// 树节点ID
		Long pid = this.getPid();
		return rootId == pid
				|| (rootId != null && pid != null && rootId.equals(pid));
	}

	@Override
	protected Condition getGridSpecalCondition() {
		Condition statusCondition = null;
		if (status != null && status.length() > 0) {
			String[] ss = status.split(",");
			if (ss.length == 1) {
				statusCondition = new EqualsCondition("oc.status_",
						new Integer(ss[0]));
			}
		}

		// 合并多个条件
		return ConditionUtils.mix2AndCondition(statusCondition);
	}

	@Override
	protected OrderCondition getGridDefaultOrderCondition() {
		return new OrderCondition("oc.status_", Direction.Asc).add("c.full_sn",
				Direction.Asc);
	}

	/**
	 * SQL分页查询语句及参数配置
	 * 
	 * @return
	 * @throws java.lang.Exception
	 */
	private PagingQueryConfig getPagingQueryConfig() {
		// 加载模板，获得查询SQL
		String querySql = this.templateService.getContent("BC-CATEGORY");
		String countSql = this.templateService.getContent("BC-CATEGORY-COUNT");
		// 查询参数
		List<Object> params = null;
		Long pid = this.getPid();

		// 是否为顶级节点
		if (pid != null) {
			params = new ArrayList<Object>();
			params.add(pid);
		}

		// 查询对象
		cn.bc.core.query.cfg.impl.PagingQueryConfig cfg = new cn.bc.core.query.cfg.impl.PagingQueryConfig(
				querySql, countSql, params);
		if (pid != null)
			cfg.addTemplateParam("pid", pid);
		cfg.addTemplateParam("father", pid);
		cfg.addTemplateParam("isRoot", this.isRootNode());
		cfg.addTemplateParam("code", this.getSystemContext().getUser()
				.getCode());
		if (!isReadonly())
			cfg.addTemplateParam("isManager", true);

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
		JdbcTemplatePagingQuery<Map<String, Object>> jdbcQuery = new JdbcTemplatePagingQuery<Map<String, Object>>(
				jdbcTemplate, getPagingQueryConfig(), null);
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
		return new String[] { "poc.name_", "oc.name_", "oc.code" };
	}

	@Override
	protected PageOption getHtmlPageOption() {
		return super.getHtmlPageOption().setWidth(880).setMinWidth(600)
				.setHeight(480).setMinHeight(350);
	}

	@Override
	protected String getHtmlPageTitle() {
		return this.pageTitle;
	}

	@Override
	protected Toolbar getHtmlPageToolbar() {
		Toolbar toolbar = new Toolbar();
		if (!this.isReadonly()) {
			// 新建
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb")
					.setText("新建").setClick("bc.category.view.create"));
			// 编辑
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb")
					.setText("编辑").setClick("bc.category.view.edit"));
			// 删除
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb")
					.setText("删除").setClick("bc.category.view.delete_"));
			// 状态
			toolbar.addButton(Toolbar.getDefaultToolbarRadioGroup(
					this.getStatues(), "status", 0,
					getText("title.click2changeSearchStatus")));
		} else {
			// 查看
			toolbar.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb")
					.setText("查看").setClick("bc.category.view.edit"));
		}
		// 搜索按钮
		toolbar.addButton(this.getDefaultSearchToolbarButton());
		return toolbar;
	}

	@Override
	protected List<Column> getGridColumns() {
		List<Column> columns = new ArrayList<Column>();
		// id列
		columns.add(new IdColumn().setId("id").setValueExpression(
				"['pid'] + ',' + ['code']"));
		// 状态
		columns.add(new TextColumn4MapKey("status", "status_",
				getText("category.status"), 35).setSortable(true)
				.setValueFormater(new EntityStatusFormater(getStatues())));
		// 所属分类
		columns.add(new TextColumn4MapKey("father", "father",
				getText("category.father"), 120).setSortable(true)
				.setUseTitleFromLabel(true));
		// 名称
		columns.add(new TextColumn4MapKey("name_", "name_",
				getText("category.name")).setSortable(true)
				.setValueFormater(new AbstractFormater<String>() {
					@SuppressWarnings("unchecked")
					@Override
					public String format(Object context, Object value) {
						Map<String, Object> map = (Map<String, Object>) context;
						return !isReadonly() ? StringUtils.toString(map
								.get("name_")) : buildColumnIcon(map,
								createIcon(), editIcon(), delIcon())
								+ StringUtils.toString(map.get("name_"));
					}

					@Override
					public String getExportText(Object context, Object value) {
						@SuppressWarnings("unchecked")
						Map<String, Object> map = (Map<String, Object>) context;
						return (String) map.get("name_");
					}
				}).setUseTitleFromLabel(true));
		// 编码
		columns.add(new TextColumn4MapKey("code", "code",
				getText("category.code"), 150).setSortable(true)
				.setUseTitleFromLabel(true));
		// 排序号
		columns.add(new TextColumn4MapKey("sn", "sn",
				getText("category.order"), 60).setSortable(true));
		// 权限配置
		columns.add(new TextColumn4MapKey("acls", "acls",
				getText("category.permiss"), 120).setValueFormater(
				new AbstractFormater<Object>() {
					@SuppressWarnings("unchecked")
					@Override
					public Object format(Object context, Object value) {
						Map<String, Object> map = (Map<String, Object>) context;
						return buildColumnIcon(map, aclIcon(map))
								+ formatACLConfig(map);
					}

					@Override
					public String getExportText(Object context, Object value) {
						@SuppressWarnings("unchecked")
						Map<String, Object> map = (Map<String, Object>) context;
						return formatACLConfig(map);
					}
				}).setUseTitleFromLabel(true));
		// 最后修改
		columns.add(new TextColumn4MapKey("modified_date", "modified_date",
				getText("category.modified"), 210).setSortable(true)
				.setValueFormater(new AbstractFormater<Object>() {
					@Override
					public Object format(Object context, Object value) {
						if (value == null || "".equals(value.toString()))
							return null;
						@SuppressWarnings("unchecked")
						Map<String, Object> map = (Map<String, Object>) context;
						return map.get("modifier") + " ("
								+ DateUtils.formatDateTime2Minute((Date) value)
								+ "）";
					}
				}));
		// 隐藏列
		columns.add(new HiddenColumn4MapKey("id", "id"));
		columns.add(new HiddenColumn4MapKey("pid", "pid"));
		columns.add(new HiddenColumn4MapKey("name_", "name_"));
		columns.add(new HiddenColumn4MapKey("full_acl", "full_acl"));
		return columns;
	}

	/**
	 * 构建视图列的图标
	 * 
	 * @param m
	 *            查询返回的map
	 * @return
	 */
	private String buildColumnIcon(Map<String, Object> m, Icon... icons) {
		String fullAcl = StringUtils.toString(m.get("full_acl"));
		if (isReadonly() && fullAcl.indexOf("10") == -1
				&& fullAcl.indexOf("11") == -1)
			return "";

		// 返回自定义图标
		String icon = "";
		for (Icon i : icons)
			icon += i.wrap();

		return icon;
	}

	/**
	 * 新建图标
	 * 
	 * @return
	 */
	private Icon createIcon() {
		Icon icon = new Icon();
		icon.setClazz("ui-icon ui-icon-plusthick");
		icon.setTitle("新建");// 鼠标提示信息
		icon.setClick("bc.category.view.create");// 点击函数
		return icon;
	}

	/**
	 * 编辑图标
	 * 
	 * @return
	 */
	private Icon editIcon() {
		Icon icon = new Icon();
		icon.setClazz("ui-icon ui-icon-pencil");
		icon.setTitle("编辑");// 鼠标提示信息
		icon.setClick("bc.category.view.edit");// 点击函数
		return icon;
	}

	/**
	 * 删除图标
	 * 
	 * @return
	 */
	private Icon delIcon() {
		Icon icon = new Icon();
		icon.setClazz("ui-icon ui-icon-close");
		icon.setTitle("删除");// 鼠标提示信息
		icon.setClick("bc.category.view.delete_");// 点击函数
		return icon;
	}

	/**
	 * ACL 扳手Icon
	 * 
	 * @param m
	 * @return
	 */
	private Icon aclIcon(Map<String, Object> m) {
		String fullAcl = StringUtils.toString(m.get("full_acl"));
		// 小图标: 查看所有ACL配置信息
		Icon icon = new Icon();
		icon.setClazz("ui-icon ui-icon-wrench");
		icon.setTitle(getText("category.permiss.seeAll"));// 鼠标提示信息
		icon.setClick("bc.category.view.aclConfig");// 点击函数
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("docId", m.get("id"));
		args.put("docType", "Category");
		args.put("docName", m.get("name_"));
		if (fullAcl.indexOf("10") != -1)
			args.put("bit", "10");// 当前用户的ACL
		else if (fullAcl.indexOf("11") != -1 || !isReadonly())
			args.put("bit", "11");
		icon.setClickArguments(JsonUtils.toJson(args));
		return icon;
	}

	/**
	 * 格式化数据库返回的ACL配置信息
	 * 
	 * @param m
	 *            {"acls":"name,role::name,role..."}
	 * @return "name（编辑||查阅）,name（编辑||查阅）..."
	 */
	private String formatACLConfig(Map<String, Object> m) {
		Object aclsObj = m.get("acls");
		if (aclsObj == null)
			return "";
		String acls = StringUtils.toString(aclsObj);
		String[] aclArr = acls.split("::");
		String aclConfig = "";
		for (int i = 0; i < aclArr.length; i++) {
			String[] acl = aclArr[i].split(",");
			aclConfig += acl[0];
			if (acl[1].equals("11"))
				aclConfig += "（编辑，查阅）";
			if (acl[1].equals("10"))
				aclConfig += "（编辑）";
			else if (acl[1].equals("01"))
				aclConfig += "（查阅）";
			else if (acl[1].equals("00"))
				aclConfig += "（无权限）";
			// 如果不是最后一次循环
			if (!(i >= aclArr.length - 1))
				aclConfig += "，";
		}
		return aclConfig;
	}

	/**
	 * 获得分类导航树菜单
	 * 
	 * @param rootNode
	 *            树的顶级节点
	 * @param isReadonly
	 *            是否只读
	 * @param userCode
	 *            用户编码 Code
	 * @param url
	 *            点击展开子节点图标的URL
	 * @param callback
	 *            点击树节点的回调函数
	 * @param categoryService
	 *            分类模块业务逻辑接口
	 * @return 树菜单
	 */
	public static Tree getCategoryTree(Long pid, boolean isReadonly,
			String userCode, String url, String callback,
			CategoryService categoryService) {
		String rootPid = (pid != null ? pid.toString() : "");

		Tree tree = new Tree(rootPid, "全部");
		tree.setShowRoot(true);

		// 点击展开子节点图标的URL
		tree.setUrl(url);

		// 树的参数配置
		Json cfg = new Json();
		// 点击节点的回调函数
		cfg.put("clickNode", callback);
		tree.setCfg(cfg);

		// 树的数据
		List<Map<String, Object>> treeData;

		// 构建树的子节点
		Collection<TreeNode> treeNodes;
		try {
			treeData = categoryService.findSubNodesData(pid, userCode,
					isReadonly);
			treeNodes = buildTreeNodes(treeData);
			for (TreeNode treeNode : treeNodes)
				tree.addSubNode(treeNode);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		return tree;
	}

	@Override
	protected Tree getHtmlPageTree() {
		return CategoryViewAction.getCategoryTree(this.getPid(),
				this.isReadonly(), SystemContextHolder.get().getUser()
						.getCode(), this.getHtmlPageNamespace()
						+ "/loadTreeData", this.callback, this.categoryService);
	}

	/**
	 * 构建树节点
	 * 
	 * @param treeData
	 *            树节点数据
	 * @return
	 */
	public static Collection<TreeNode> buildTreeNodes(
			List<Map<String, Object>> treeData) throws Exception {
		List<TreeNode> treeNodes = new ArrayList<TreeNode>();
		for (Map<String, Object> data : treeData) {
			TreeNode node = null;
			node = new TreeNode(String.valueOf(data.get("id")),
					String.valueOf(data.get("name")));
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
		this.json = this.categoryService.getLoadTreeData(this.isReadonly(),
				this.getPid());
		return "json";
	}

	@Override
	protected void extendGridExtrasData(JSONObject json) throws JSONException {
		super.extendGridExtrasData(json);
		// 状态条件
		if (this.status != null && this.status.trim().length() > 0) {
			json.put("status", status);
		}

		// 父节点条件
		json.put("pid", this.getPid());
		json.put("rootNode", this.rootNode);
		json.put("rootId", this.getPid());
	}

	@Override
	protected Integer getTreeWith() {
		return 220;
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
		return getModuleContextPath() + this.namespace;
	}

	@Override
	protected String getHtmlPageJs() {
		return this.getContextPath() + "/modules/bc/category/view.js,"
		// 加载ACL的API
				+ this.getContextPath() + "/bc/acl/api.js";
	}

	// 视图双击的方法
	@Override
	protected String getGridDblRowMethod() {
		return "bc.category.view.edit";
	}

	@Override
	protected String getFormActionName() {
		return "category";
	}

	/**
	 * 获取系统上下文
	 * 
	 * @return
	 */
	private SystemContext getSystemContext() {
		if (this.systemContext != null)
			return this.systemContext;
		return (SystemContext) this.getContext();
	}

}
