/**
 * 分类模块通用API
 */
bc.namespace("bc.category");

/**
 * 选择所属分类
 * @option {json} 参数
 * @param {String} namespace [必填] 命名空间
 * @param {function} onOk [可选]回调函数
 * @param {boolean} paging [可选] 是否分页，默认是true,即分页
 * @param {String} status [可选]分类的状态，默认所有状态
 * @param {String} mid [可选] 对话框的id
 * @param {String} title [可选] 对话框的标题
 * @param {JSON} data [可填] 额外的参数
 * @data {boolean} multiple [可选]是否允许多选，默认true
 * @data {Integer} preRoleId [必填] 当前角色的最顶级父类的id，如当前用户最大能管理经济合同及以下的子分类，需要传经济合同的id
 */
bc.category.selectCategory = function(option){
	
	/*if(option.data.preRoleId == null){
		bc.msg.alert("必须配置data的 preRoleId 参数 - bc.category.selectCategory");
		return;
	}*/
	
	//弹出选择对话框
	bc.page.newWin(jQuery.extend({
		url: bc.root + "/bc" + option.namespace + "/selectCategory/" + (option.paging ? "paging" : "list"),
		name: option.wName ? option.wName : "选择所属分类",
		mid: option.mid ? option.mid : "选择所属分类",
		title: option.title ? option.title : "选择所属分类",
		afterClose: function(status){
			if(status && typeof(option.onOk) == "function"){
				option.onOk(status);
			}
		}
	},option));
};
