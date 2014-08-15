package cn.bc.category.web.struts2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.bc.core.query.condition.Condition;
import cn.bc.core.query.condition.impl.AndCondition;
import cn.bc.core.query.condition.impl.EqualsCondition;
import cn.bc.core.query.condition.impl.InCondition;
import cn.bc.core.util.StringUtils;
import cn.bc.db.jdbc.RowMapper;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.web.formater.KeyValueFormater;
import cn.bc.web.struts2.AbstractSelectPageAction;
import cn.bc.web.struts2.ViewAction;
import cn.bc.web.ui.html.grid.Column;
import cn.bc.web.ui.html.grid.IdColumn4MapKey;
import cn.bc.web.ui.html.grid.TextColumn4MapKey;
import cn.bc.web.ui.html.page.PageOption;
import cn.bc.web.ui.html.toolbar.Toolbar;

/*
 * 选择所属分类视图
 */
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
public class SelectCategoryTypesAction  extends AbstractSelectPageAction<Map<String, Object>>{

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
				map.put("status", rs[i++]);
				map.put("code", rs[i++]); 
				map.put("name", rs[i++]); 
				map.put("ptype", rs[i++]);
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
		columns.add(new TextColumn4MapKey("c.code", "code",
				getText("category.select.code"), 80).setSortable(true));
		columns.add(new TextColumn4MapKey("c.name_", "name",
				getText("category.select.name"), 80).setSortable(true));		
		columns.add(new TextColumn4MapKey("", "ptype",
				getText("category.select.type")).setSortable(true)
				.setUseTitleFromLabel(true));;
		return columns;
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
        return getModuleContextPath() + "/bc/category";
    }
	 
	@Override
	protected String getFormActionName() {
		return "selectCategoryType";
	}
    @Override
    protected String getViewActionName() {
        return "selectCategoryType";
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
	protected String getClickOkMethod() {
		return "bc.select.category.clickOk";
	}
	
	@Override
	protected String getHtmlPageTitle() {
		return this.getText("category.select.title");
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
}
