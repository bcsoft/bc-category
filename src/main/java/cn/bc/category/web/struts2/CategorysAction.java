package cn.bc.category.web.struts2;

import java.util.List;

import cn.bc.category.domain.Category;
import cn.bc.db.jdbc.SqlObject;
import cn.bc.web.struts2.ViewAction;
import cn.bc.web.ui.html.grid.Column;

public class CategorysAction extends ViewAction<Category> {

	@Override
	protected SqlObject<Category> getSqlObject() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected String getGridRowLabelExpression() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected String[] getGridSearchFields() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected List<Column> getGridColumns() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected String getFormActionName() {
		// TODO Auto-generated method stub
		return null;
	}

}
