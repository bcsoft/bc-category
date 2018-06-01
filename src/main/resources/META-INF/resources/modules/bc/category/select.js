bc.namespace("bc.select.category");
bc.select.category = {
  clickOk: function () {
    var $page = $(this);

    // 获取选中的行的id单元格
    var $tds = $page.find(".bc-grid>.data>.left tr.ui-state-highlight>td.id");
    if ($tds.length == 0) {
      bc.msg.slide("请先选择！");
      return false;
    }

    // 是否只能单选
    // if(!$page.data("extras").multiSelect){
    // 	if($tds.length > 1){
    // 		bc.msg.slide("一次只能选择一个！");
    // 		return false;
    // 	}
    // }

    // 获取选中的数据
    var data;
    var $grid = $page.find(".bc-grid");
    data = [];
    var $trs = $grid.find(">.data>.right tr.ui-state-highlight");
    $tds.each(function (i) {
      data.push($.extend({
        id: $(this).attr("data-id"),
        status: $($trs.get(i)).find("td:eq(0)").attr("data-value"),
        name: $($trs.get(i)).find("td:eq(1)").attr("data-value"),
        code: $($trs.get(i)).find("td:eq(2)").attr("data-value"),
      }, $($trs.get(i)).data("hidden")));
    });
    //}
    logger.info($.toJSON(data));

    // 返回
    $page.data("data-status", data);
    $page.dialog("close");
  },
}