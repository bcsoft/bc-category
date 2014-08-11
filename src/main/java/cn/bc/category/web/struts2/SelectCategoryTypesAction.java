package cn.bc.category.web.struts2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import cn.bc.BCConstants;
import cn.bc.core.query.condition.Condition;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.core.query.condition.impl.InCondition;
import cn.bc.core.util.StringUtils;
import cn.bc.db.jdbc.RowMapper;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.web.formater.KeyValueFormater;
import cn.bc.web.struts2.ViewAction;
import cn.bc.web.ui.html.grid.Column;
import cn.bc.web.ui.html.grid.IdColumn4MapKey;
import cn.bc.web.ui.html.grid.TextColumn4MapKey;
import cn.bc.web.ui.html.page.PageOption;
import cn.bc.web.ui.html.toolbar.Toolbar;

/*
 * 选择所属分类视图
 */
public class SelectCategoryTypesAction  extends ViewAction<Map<String, Object>>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public String status;//分类的状态

	@Override
	protected SqlObject<Map<String, Object>> getSqlObject() {
		SqlObject<Map<String, Object>> sqlObject = new SqlObject<Map<String, Object>>();

		// 构建查询语句,where和order by不要包含在sql中(要统一放到condition中)
		StringBuffer sql = new StringBuffer();
		sql.append("select c.id,c.status_,c.code,c.name_,func_get_category_type(c.id) ptype from bc_category as c ");
		sqlObject.setSql(sql.toString());

		// 注入参数
		sqlObject.setArgs(null);

		// 数据映射器
		sqlObject.setRowMapper(new RowMapper<Map<String, Object>>() {
			public Map<String, Object> mapRow(Object[] rs, int rowNum) {
				Map<String, Object> map = new HashMap<String, Object>();
				int i = 0;
				map.put("id", rs[i++]);
				map.put("code", rs[i++]); // 状态
				map.put("name", rs[i++]); // 经营权号
				map.put("ptype", rs[i++]); // 经营权号
				return map;
			}
		});
		return sqlObject;
	}
	
	@Override
	protected List<Column> getGridColumns() {
		List<Column> columns = new ArrayList<Column>();
		columns.add(new IdColumn4MapKey("c.id", "id"));
		columns.add(new TextColumn4MapKey("c.status_", "status",
				getText("category.select.status"), 40).setSortable(true)
				.setValueFormater(new KeyValueFormater(getStatus())));
		columns.add(new TextColumn4MapKey("c.name_", "name",
				getText("category.select.name"), 80).setSortable(true));
		columns.add(new TextColumn4MapKey("c.code", "code",
				getText("category.select.code"), 80).setSortable(true));
		columns.add(new TextColumn4MapKey("", "ptype",
				getText("category.select.type")).setSortable(true)
				.setUseTitleFromLabel(true));;
		return columns;
	}

	@Override
	protected String getGridRowLabelExpression() {
		return null;
	}

	@Override
	protected String[] getGridSearchFields() {
		return new String[] { "c.name_","c.code" };
	}

	
	@Override
	protected Toolbar getHtmlPageToolbar() {	
		Toolbar tb = new Toolbar();		
		// 搜索按钮
		tb.addButton(this.getDefaultSearchToolbarButton());
		return tb;
	}

	@Override
	protected String getFormActionName() {
		return null;
	}
	@Override
	protected PageOption getHtmlPageOption() {
		return super.getHtmlPageOption().setWidth(400).setHeight(450);
	}
	
	@Override
	protected String getHtmlPageJs() {
		return this.getModuleContextPath() + "/select.js";
	}
	
	@Override
	protected Condition getGridSpecalCondition() {
		AndCondition ac=new AndCondition();

		if (status != null && status.length() > 0) {
			String[] ss = status.split(",");
			if (ss.length == 1) {
				ac.add(new EqualsCondition("c.status_", new Integer(
						ss[0])));
			} else {
				ac.add(new InCondition("c.status_",
						StringUtils.stringArray2IntegerArray(ss)));
			}
		}

		return ac.isEmpty()?null:ac;
	}

	
	@Override
	protected String getHtmlPageTitle() {
		return this.getText("category.select.title");
	}

	/**
	 * 状态值转换列表：在案|注销|全部
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

}
