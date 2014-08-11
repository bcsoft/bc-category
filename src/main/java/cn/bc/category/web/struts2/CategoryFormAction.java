package cn.bc.category.web.struts2;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts2.interceptor.SessionAware;

import cn.bc.category.domain.Category;
import cn.bc.web.struts2.EntityAction;

public class CategoryFormAction extends EntityAction<Long, Category> implements
		SessionAware {
	private static final long serialVersionUID = 1L;
	protected Log logger = LogFactory.getLog(getClass());

}
