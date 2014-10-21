/**
 * 
 */
package cn.bc.category.domain;

import java.util.Calendar;

import javax.persistence.Entity;
import javax.persistence.Table;

import cn.bc.core.EntityImpl;

/**
 * 分类
 * 
 * @author Action
 * 
 */
@Entity
@Table(name = "BC_CATEGORY")
public class Category extends EntityImpl {
	private static final long serialVersionUID = 1L;

	private long pid;// 父类别ID
	private int status_;// 状态
	private String code;// 编码
	private String name_;// 名称
	private String sn;// 同级节点间的顺序号
	private Integer modifier_id;// 最后修改人ID
	private Calendar modified_date;// 最后修改时间

	public long getPid() {
		return pid;
	}

	public void setPid(long pid) {
		this.pid = pid;
	}

	public int getStatus_() {
		return status_;
	}

	public void setStatus_(int status_) {
		this.status_ = status_;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName_() {
		return name_;
	}

	public void setName_(String name_) {
		this.name_ = name_;
	}

	public String getSn() {
		return sn;
	}

	public void setSn(String sn) {
		this.sn = sn;
	}

	public Integer getModifier_id() {
		return modifier_id;
	}

	public void setModifier_id(Integer modifier_id) {
		this.modifier_id = modifier_id;
	}

	public Calendar getModified_date() {
		return modified_date;
	}

	public void setModified_date(Calendar modified_date) {
		this.modified_date = modified_date;
	}
}
