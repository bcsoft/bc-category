bc.namespace("bc.categoryForm");
bc.categoryForm = {
	init:function(){
		var $form = $(this);
		
		var preId = $form.find("input[name='e.id']").val();
		var prePId = $form.find("input[name='e.pid']").val();
		var rootId = $form.find("input[name='rootId']").val();
		var namespace = $form.find("input[name='namespace']").val();
		//alert($form.find("input[name='pid']").val());
		//var preCode = $form.find("input[name='e.code']").val();
		//点击所属分类
		$form.find("#selectCategoryType").click(function(){
			var option = {
					namespace: namespace,
					data: {preRoleId: rootId,preId: preId,multiple: false},
					onOk : function(status){
						if(status!=null){
							var value = status[0].name;
							var ids = status[0].id;	
							if(preId == ids){
								bc.msg.slide("不能添加自己为父类，请重新选择！");
							}else{
								$form.find("input[name='e.pid']").val(ids);
								$form.find("input[name='pname']").val(value);
							}
							
						}
					},
					paging: "paging"};
			bc.category.selectCategory(option);
		});
		//清除所属分类
		$form.find("#clearSelectCategoryType").click(function(){
			$form.find("input[name='pname']").val("");
			$form.find("input[name='e.pid']").val("");
		});
	},
	save:function(){
		var $page = $(this);
		var $form = $("form", $page);
		if (!bc.validator.validate($form)) { //如果验证失败
			return false;		
		}
		
		//var preId = $form.find("input[name='e.id']").val();
		//调用标准的方法执行保存
		bc.page.save.call(this,{callback: function(json){
			if(json.success){
				bc.msg.alert(json.msg);
			}else{
				/*bc.msg.slide(json.msg);
				
				//var $tree = $page.closest("#desktop").find(".bc-tree");

				
				bc.ajax({
					url: bc.root + "/bc/category/loadTreeData",
					data:
				});
				
				var $page = $tree.closest(".bc-page");
				logger.info("clickTreeNode: id=" + node.id + ",name=" + node.name);
				var data = $page.data("extras");
				data.pid = node.id;*/
				//var option={url:bc.root + "/bc/category/loadTreeData",data:{pid:"ddd:"+preId,status:1}};
				//bc.grid.reloadData($tree,option);
			}
			
		}});
	},
}