bc.namespace("bc.category.view");
bc.category.view = {
	init : function(){},
	/** ACL权限配置 */
	aclConfig : function(args){
		//初始化ACL窗口
		bc.acl.config(args);
	},
	/** 点击树节点的处理 */
	clickTreeNode : function(node) {
		var $tree = $(this);
		var $page = $tree.closest(".bc-page");

		// 判断是否在loading
		if ($page.data("loading")) 
			return;
		
		var startTime = new Date().getTime();
		$page.data("loading", true);
		$page.data("extras").pid = node.id;
		bc.grid.reloadData($page, {callback: function(){
			var now = new Date().getTime() - startTime;
			if(now > 500){
				$page.removeData("loading");
			}else{
				setTimeout(function(){
					$page.removeData("loading");
				}, 500 - now);
			}
		}});
	},
	delete_ : function(){	
		var $page;
		var $tr_r;
		if($(this).is('li')) {
			$page = $(this).parents("div.bc-page");
			$tr_r = $(this).parents("tr");
		} else {
			$page = $(this);
			$tr_r = $page.find("div.data>.right tr.ui-state-highlight");
			// 确定选中的行
			if($tr_r.size()==0){
				bc.msg.slide("请选择需要删除的分类！");
				return;
			}else if($tr_r.size()>1){
				bc.msg.slide("一次只能选择一个分类！");
				return;
			}
		}
		
		// 取得隐藏列数据
		var $hidden=$tr_r.data("hidden");
		var option = {id : $hidden.id};
		bc.msg.confirm("确定要删除选定的 <b>"+$hidden.name_+"</b>吗？",function(){
			bc.ajax({
				url: bc.root + "/bc/category/delete",
				data: option,
				dateType:'json',
				success:function(jsonData){
					var json = JSON.parse(jsonData);
					if(json.success){
						bc.grid.reloadData($page);
					}else{
						bc.msg.slide(json.msg);
					}				
				}
			});
		});
	},
	create : function(){
		var $page;
		var $tr_r;
		if($(this).is('li')) {// 新建Icon
			$page = $(this).parents("div.bc-page");
			$tr_r = $(this).parents("tr");
		} else {// 新建按钮
			$page = $(this);
			// 选中行新建
			if($page.find("div.data>.right tr.ui-state-highlight"))
				$tr_r = $page.find("div.data>.right tr.ui-state-highlight");
		}
		var option = {isNew : true ,page : $page, tr_r: $tr_r};
		bc.category.view.form(option);
	},
	edit : function(){
		var $page;
		var $tr_r;
		if($(this).is('li')) {
			$page = $(this).parents("div.bc-page");
			$tr_r = $(this).parents("tr");
		} else {
			$page = $(this);
			$tr_r = $page.find("div.data>.right tr.ui-state-highlight");
			// 确定选中的行
			if($tr_r.size()==0){
				bc.msg.slide("请选择需要编辑的分类！");
				return;
			}else if($tr_r.size()>1){
				bc.msg.slide("一次只能选择一个分类！");
				return;
			}
		}
		var option = {isNew : false , page : $page, tr_r: $tr_r};
		bc.category.view.form(option);
	},
	option : function(){
		//var option = {isNew : false , page : $(this),isReadonly : true};
		//bc.category.view.form(option);
	},
	form : function(option_){
		var $page = option_.page;
		var rootId = $page.data("extras").rootId;
		var namespace = $page.data("extras").namespace;
		
		if(typeof(rootId) == "undefined"){
			rootId = 0;
		}

		// 选中的右边行
		var $tr_r = option_.tr_r;
		// 取得隐藏列数据
		var $hidden=$tr_r.data("hidden");

		var option = {};
		var name_;

		option['isNew'] = option_.isNew;
		option['rootId'] = rootId;
		
		if(option_.isNew){
			name_ = "新建分类";
			if(option_.tr_r[0]) {// 有选中行新建
				option['pname'] = option_.tr_r.find("td[data-column = 'name_']").text();
				option['fullAcl'] = $hidden.full_acl;
				option['e.pid'] = $hidden.id;// 选中行的ID作为表单的所属分类ID
			}
		}else{
			option['id'] = $hidden.id;
			option['fullAcl'] = $hidden.full_acl;
			name_ = $hidden.name_;
		}
		
		// 弹出渲染窗口
		bc.page.newWin({
			url: bc.root + "/bc" + namespace + "/form",
			data: option,
			mid: option.id+name_+"表单",
			title: name_+"-表单",
			name: name_,
			afterClose:function(status){
				if(status=="saved"){
					bc.grid.reloadData($page);
				}
			}
		});		
	}
};