<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<div title='<s:text name="categoryForm.title"/>' data-type='form' class="bc-page"
	data-saveUrl='<s:url value="/bc/category/save" />'
	data-js='<s:url value="/modules/bc/category/api.js" />,<s:url value="/modules/bc/category/form.js" />'
	data-initMethod='bc.categoryForm.init'
	data-option='<s:property value="formPageOption"/>' 
	style="overflow-y:auto;">
	<s:form name="categoryForm" theme="simple" >
		<div class="ui-widget-header title" style="position:relative;border-width:0!important;">
				<span class="text" >基本信息:</span>
		</div>

		<div class="formFields ui-widget-content" id="formEditorDiv" style="width:600px;">
			<table class="formFields ui-widget-content" cellspacing="2" cellpadding="0">
				<tr class="widthMarker">
					<td style="width: 80px;">&nbsp;</td>
					<td style="width: 220px;">&nbsp;</td>
					<td style="width: 100px;">&nbsp;</td>
					<td style="width: 220px;">&nbsp;</td>
					<td >&nbsp;</td>
				</tr>
				<tr>
					<td class="label">*<s:text name="category.name_"/>:</td>
					<td class="value">
						<s:textfield name="e.name_" cssStyle="width:200px;" cssClass="ui-widget-content" data-validate="required"/>
					</td>	
					<td class="label">*<s:text name="category.pname"/>:</td>
					<td class="value relative">
						<s:textfield name="pname" cssStyle="width:210px;" cssClass="ui-widget-content" data-validate="required" readonly="true"/>
						<ul class="inputIcons">
							<li class="inputIcon ui-icon ui-icon-circle-plus" id="selectCategoryType"
								title='<s:text name="title.click2select"/>'></li>
							<li class="inputIcon ui-icon ui-icon-circle-close" id="clearSelectCategoryType"
								title='<s:text name="title.click2clear"/>'></li>
						</ul>
					</td>									
				</tr>	
				<tr>
					<td class="label">*<s:text name="category.code"/>:</td>
					<td class="value">
						<s:textfield name="e.code" cssStyle="width:200px;" cssClass="ui-widget-content" data-validate="required" />
					</td>	
					<td class="label"><s:text name="category.sn"/>:</td>
					<td class="value">
						<s:textfield name="e.sn" cssStyle="width:210px;" cssClass="ui-widget-content" readonly="false"/>
					</td>	
				</tr>
				
				<tr>
					<td class="label">*<s:text name="category.status_"/>:</td>
					<td class="value">
						<s:radio name="e.status_" list="statusList" cssStyle="width:auto;"></s:radio>
					</td>
					<td colspan="4">
						<div class="formTopInfo">
							<s:if test="%{e.modifier_id != null}">
							最后更新：<s:property value="actor_name" />(<s:date name="e.modified_date" format="yyyy-MM-dd HH:mm"/>)
							</s:if>
						</div>
					</td>			
				</tr>	
			</table>
		</div>	

		<s:hidden name="e.id" />
		<s:hidden name="e.pid"/>
		<s:hidden name="rootId"/>
		<s:hidden name="namespace"/>
	</s:form>
</div>