package cn.bc.category.web.struts2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.bc.core.query.condition.Direction;
import cn.bc.core.query.condition.impl.OrderCondition;
import cn.bc.db.jdbc.RowMapper;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.web.struts2.ViewAction;
import cn.bc.web.ui.html.grid.Column;
import cn.bc.web.ui.html.grid.HiddenColumn;
import cn.bc.web.ui.html.grid.HiddenColumn4MapKey;
import cn.bc.web.ui.html.grid.IdColumn4MapKey;
import cn.bc.web.ui.html.grid.TextColumn4MapKey;
import cn.bc.web.ui.html.page.PageOption;
import cn.bc.web.ui.html.toolbar.Toolbar;
import cn.bc.web.ui.html.toolbar.ToolbarButton;

@Scope(BeanDefinition.SCOPE_PROTOTYPE)
@Controller
public class CategoryViewAction extends ViewAction<Map<String, Object>> {
	private static final long serialVersionUID = 1L;

	@Override
	public boolean isReadonly() {
		return false;
	}

	@Override
	protected String getModuleContextPath() {
		return this.getContextPath() + "/bc";
	}

	@Override
	protected String getFormActionName() {
		return "category";
	}

	@Override
	protected String getHtmlPageJs() {
		return "/bs/modules/bc/category/view.js";
	}

	/** 页面加载后调用的js初始化方法 */
	@Override
	protected String getHtmlPageInitMethod() {
		return "bc.category.init";
	}

	@Override
	protected SqlObject<Map<String, Object>> getSqlObject() {
		SqlObject<Map<String, Object>> sqlObject = new SqlObject<Map<String, Object>>();

		// 构建查询语句,where和order by不要包含在sql中(要统一放到condition中)
		StringBuffer sql = new StringBuffer();
		sql.append("select c.id,c.code as code,c.name_ as name");
		sql.append(" from bc_category c");
		sqlObject.setSql(sql.toString());
		// 注入参数
		sqlObject.setArgs(null);

		// 数据映射器
		sqlObject.setRowMapper(new RowMapper<Map<String, Object>>() {
			public Map<String, Object> mapRow(Object[] rs, int rowNum) {
				Map<String, Object> map = new HashMap<String, Object>();
				int i = 0;
				map.put("id", rs[i++]);
				map.put("code",rs[i++]);
				map.put("name", rs[i++]);
				return map;
			}
		});
		return sqlObject;
	}

	@Override
	protected List<Column> getGridColumns() {
		
		List<Column> columns = new ArrayList<Column>();
		columns.add(new IdColumn4MapKey("c.id", "id"));
		// 编码
		columns.add(new TextColumn4MapKey("c.code", "code",
				getText("category.code"),100).setSortable(true));
		
		// 名称
		columns.add(new TextColumn4MapKey("ct.name", "name",
				getText("category.name_")).setSortable(true));

		columns.add(new HiddenColumn4MapKey("id","id"));
		return columns;
	}

	@Override
	protected String getHtmlPageTitle() {
		return this.getText("category.title");
	}

	@Override
	protected PageOption getHtmlPageOption() {
		return super.getHtmlPageOption().setWidth(600).setMinWidth(500)
				.setHeight(400).setMinHeight(200);
	}

	@Override
	protected Toolbar getHtmlPageToolbar() {
		/*SystemContext context = (SystemContext) this.getContext();*/
	
		Toolbar tb = new Toolbar();
		
		// 新建按钮
		tb.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb").setText("新建").setClick("bc.category.create"));

		// 编辑按钮
		tb.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb").setText("编辑").setClick("bc.category.edit"));

		// 删除按钮
		tb.addButton(new ToolbarButton().setIcon("ui-icon-lightbulb").setText("删除").setClick("bc.category.delete"));
		
		// 搜索按钮
		tb.addButton(this.getDefaultSearchToolbarButton());
			
		return tb;
	}

	@Override
	protected OrderCondition getGridDefaultOrderCondition() {
		return new OrderCondition("c.name_", Direction.Asc);
	}

	@Override
	protected String getGridRowLabelExpression() {
		return "['name']";
	}

	@Override
	protected String[] getGridSearchFields() {
		return new String[] { "c.name","c.code"};
	}
	
	@Override
	protected String getGridDblRowMethod() {
		return "bc.category.edit";
	}


}
