<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>员工列表</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- 
       web路径
 不以/开始的相对路径，找资源，以当前资源的路径为基准，经常出问题
 以/开始的相对路径，找资源，以服务器的路径（http://localhost:3306/）为标准
 -->
<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"
	type="text/javascript">
	
</script>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"
	type="text/javascript"></script>
</head>
<body>

	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="exampleModalLabel">员工添加</h4>
				</div>
				<div class="modal-body">
					<form>
						<!-- lastName -->
						<div class="form-group">
							<label for="emp_lastName" class="control-label">lastName:</label> 
							<input type="text" name="empName" class="form-control" id="emp_lastName_input" placeholder="name">
							<span id="helpBlock_name" class="help-block"></span>
						</div>

						<!--  email-->
						<div class="form-group">
							<label for="emp_email" class="control-label">email</label> 
							<input type="email" name="email" class="form-control" id="emp_email_input" placeholder="email@163.com">
							<span id="helpBlock_email" class="help-block"></span>
						</div>

						<!--  gender-->
						<div class="form-group">
							<label for="emp_gender_div" class="control-label">gender:</label>
							<div id="emp_gender_div">
							<label class="radio-inline">
							<input type="radio" name="gender" id="emp_gender_m" value="M" checked="checked">
								男
							</label>
							<label class="radio-inline"> 
							<input type="radio" name="gender" id="emp_gender_w" value="F">
								女
							</label>
							</div>
						</div>

						<!--  department-->
						<div class="form-group">
							<label for="emp_department" class="control-label">department:</label>
							<select class="form-control" name="dId" id="dept_add_select">
							</select>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
				</div>
			</div>
		</div>
	</div>
<!-- 员工添加的模态框 -->


<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">员工修改</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
		  <div class="form-group">
		    <label class="col-sm-2 control-label">empName</label>
		    <div class="col-sm-10">
		      	<p class="form-control-static" id="empName_update_static"></p>
		    </div>
		  </div>
		  <div class="form-group">
		    <label class="col-sm-2 control-label">email</label>
		    <div class="col-sm-10">
		      <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
		      <span class="help-block"></span>
		    </div>
		  </div>
		  <div class="form-group">
		    <label class="col-sm-2 control-label">gender</label>
		    <div class="col-sm-10">
		      <label class="radio-inline">
				  <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
				</label>
				<label class="radio-inline">
				  <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
				</label>
		    </div>
		  </div>
		  <div class="form-group">
		    <label class="col-sm-2 control-label">deptName</label>
		    <div class="col-sm-4">
		    	<!-- 部门提交部门id即可 -->
		      <select class="form-control" name="dId">
		      </select>
		    </div>
		  </div>
		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
      </div>
    </div>
  </div>
</div>
	
	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>ssm-crud</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-primary" id="emp_add_modal_btn"
					data-toggle="modal" data-target="#empAddModal">添加</button>
				<button type="button" class="btn btn-danger" id="emp_del_all_btn">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-bordered table-hover" id="emps_tables">
					<thead>
						<tr>
						    <th>
						       <input type="checkbox" id="check_all" />
						    </th>
							<td>#</td>
							<td>empName</td>
							<td>gender</td>
							<td>email</td>
							<td>deptName</td>
							<td>操作</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<!-- 显示分页信息 -->
		<div class="row">
			<!--分页条信息 -->
			<div class="col-md-6" id="page_info_area"></div>
			<div class="col-md-6" id="page_nav_area">
				<nav aria-label="Page navigation"></nav>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	   var totalRecord,currentPage;
	   
		//1、页面加载完成以后，直接去发送一个ajax请求，要到分页数据
		$(function() {
			//去首页
			to_page(1);
		});
		function to_page(pn) {
			$.ajax({
				url : "${APP_PATH }/emps",
				data : "pn=" + pn,
				type : "GET",
				success : function(result) {
					console.log(result);
					//1、解析并显示员工数据
					build_emps_table(result);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
				}
			});
		}
		function build_emps_table(result) {
			//首先清空表格
			$("#emps_tables tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item) {
				var checkBoxTd = $("<td><input type='checkbox' class='check_item' /></td>");
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == 'M' ? "男" : "女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
				                                    .append($("<span></span>")
				                                    .addClass("glyphicon glyphicon-pencil"))
				                                    .append("编辑");
				//为编辑按钮添加一个自定义的属性，来表示当前员工id
				editBtn.attr("edit-id",item.empId);
				//$("#emp_update_btn").attr("edit-id",item.empId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
				                                   .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
				                                   .append("删除");
				//为删除按钮添加一个自定义的属性，来表示当前员工id
				delBtn.attr("del-id",item.empId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				//append方法执行完成以后还是返回原来的元素
				$("<tr></tr>").append(checkBoxTd)
				              .append(empIdTd)
				              .append(empNameTd)
				              .append(genderTd)
				              .append(emailTd)
				              .append(deptNameTd)
				              .append(btnTd)
				              .appendTo("#emps_tables tbody");

			     });
		}
		//解析显示分页信息
		function build_page_info(result) {
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前" + result.extend.pageInfo.pageNum + "页,总"
							+ result.extend.pageInfo.pages + "页 ,总"
							+ result.extend.pageInfo.total + "条记录");
			totalRecord = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}
		//解析显示分页条 
		function build_page_nav(result) {
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append(
					$("<a></a>").append("首页").attr("href", "#"));
			var prePageLi = $("<li></li>").append(
					$("<a></a>").append("&laquo;").attr("href", "#"));
			if (result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			} else {
				firstPageLi.click(function() {
					to_page(1);
				});
				prePageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}

			var nextPageLi = $("<li></li>").append(
					$("<a></a>").append("&raquo;").attr("href", "#"));
			var lastPageLi = $("<li></li>").append(
					$("<a></a>").append("末页").attr("href", "#"));
			if (result.extend.pageInfo.hasNextPage == false) {
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			} else {
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				});
			}

			//添加首页和前一页的提示
			ul.append(firstPageLi).append(prePageLi);
			$.each(result.extend.pageInfo.navigatepageNums, function(index,item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				numLi.click(function() {
					to_page(item);
				});
				ul.append(numLi);
			});
			//添加末页和下一页的提示
			ul.append(nextPageLi).append(lastPageLi);
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
		//清空表单样式及内容
		function reset_form(ele) {
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}

		//点击新增按钮弹出模态框。
		$("#emp_add_modal_btn").click(function() {
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			reset_form("#empAddModal form");
			getDepts("#dept_add_select");
		});
		//显示部门信息
		function getDepts(ele){
			$(ele).empty();
			$.ajax({
				url : "${APP_PATH}/depts",
				type : "GET",
				success : function(result) {
					console.log(result);
					//$("#dept_add_select").append($("<option></option>").append(result.extend.depts.deptName));
					$.each(result.extend.depts, function() {
						var option = $("<option></option>").append(
								this.deptName).attr("value", this.deptId);
						option.appendTo(ele);
					});
				}
			});
		}
		//校验用户是否可用
		$("#emp_lastName_input").change(
				function() {
					//发送ajax校验用户是否可用
					var empName = this.value;
					$.ajax({
						url : "${APP_PATH}/checkUser",
						type : "POST",
						data : "empName=" + empName,
						success : function(result) {
							if (result.code == 100) {
								show_validate_msg("#emp_lastName_input","success", result.extend.va_msg);
								$("#emp_save_btn").removeClass("disabled");
							} else {
								show_validate_msg("#emp_lastName_input","error", result.extend.va_msg);
								$("#emp_save_btn").addClass("disabled");
							}
						}
					});
				});
		//校验表单数据
		function validate_add_form() {
			//1、拿到要校验的数据，使用正则表达式
			var empName = $("#emp_lastName_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			var empEmail = $("#emp_email_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regName.test(empName)) {
				//alert("name格式不对，请重新输入");
				show_validate_msg("#emp_lastName_input", "error","用户名可以是2-5位中文或者6-16位英文和数字的组合前端校验");
				return false;
			} else {
				//$("#emp_lastName_input").parent().addClass("has-success");
				show_validate_msg("#emp_lastName_input", "success", "");
			}
			if (!regEmail.test(empEmail)) {
				//alert("邮箱格式不对请重新输入");
				show_validate_msg("#emp_email_input", "error", "邮箱格式不正确");
				return false;
			} else {
				show_validate_msg("#emp_email_input", "success", "");
			}
			return true;
		}
		//校验表单显示的信息
		function show_validate_msg(ele, status, msg) {
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if (status == "success") {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}
			if (status == "error") {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		//将模态框的填写的表单数据提交给服务器保存
		$("#emp_save_btn").click(
						function() {
							//先对要提交给服务器的数据进行校验
							if (!validate_add_form()) {
								return false;
							}
							//判断之前的ajax用户名校验是否成功，如果成功则继续
							$.ajax({
									url : "${APP_PATH}/emp",
									type : "POST",
									data : $("#empAddModal form").serialize(),
									success : function(result) {
									//员工保存成功
									alert(result.msg);
									if (result.code == 100) {
											//1、关闭模态框
											$("#empAddModal").modal('hide')
											to_page(totalRecord);
									} else {
											//显示失败信息
											console.log(result);
									if (undefined != result.extend.errorFields.email) {
											//显示邮箱的错误信息
											show_validate_msg("#emp_email_input","error",result.extend.errorFields.email);
												}
									if (undefined != result.extend.errorFields.empName) {
											//显示员工名字的错误信息
											show_validate_msg("#emp_lastName_input","error",result.extend.errorFields.empName);
										}
									}
										//2、来到最后一页，显示刚才保存的数据
										//发送ajax请求显示最后一页数据
										//to_page(result.extend.pageInfo.total);
								  }
								});
						});
		$(document).on("click",".edit_btn",function(){
			//1、显示员工信息
			getEmp($(this).attr("edit-id"));
			//2、显示部门信息
			getDepts("#empUpdateModal select");
			//把员工id
			$("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
			//3、显示修改的模态框
			$("#empUpdateModal").modal({
				backdrop:"static"
			});
		});
		function getEmp(id){
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type : "GET",
				success:function(result){
					var empData=result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_input").val(empData.email);
					$("#empUpdateModal input[name=gender]").val([empData.gender]);
					$("#empUpdateModal select").val([empData.dId]);
				}
			});
		}
		//点击更新按钮，保存修改后的信息
		$("#emp_update_btn").click(function(){
			//1、校验邮箱信息
			var email = $("#email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#email_update_input", "success", "");
			}
			//2、发送ajax请求保存更新的员工数据
			$.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
				type:"PUT",
				data:$("#empUpdateModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					//1、关闭对话框
					$("#empUpdateModal").modal("hide");
					//2、回到本页面
					to_page(currentPage);
				}
				
			});
		});
		//单个删除
		$(document).on("click",".delete_btn",function(){
			//弹出确认删除对话框
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del-id");
			if(confirm("确认删除【"+empName+"】吗?")){
				//确认删除 发出ajax请求删除即可	
				$.ajax({
					url:"${APP_PATH}/emp/"+empId,
					type:"DELETE",
					success:function(result){
						//回到本页
						to_page(currentPage);
					}
			    });
			}
		});
       //完成全选/全不选
       $("#check_all").click(function(){
    	   //attr是获得自定义的属性
    	   $(".check_item").prop("checked",$(this).prop("checked"));
       });
       $(document).on("click",".check_item",function(){
    	   //判断当前选中的元素是不是五个
    	   var flag=$(".check_item:checked").length == $(".check_item").length
    	   $("#check_all").prop("checked",flag);
 
       });
       //点击删除 批量删除
       $("#emp_del_all_btn").click(function(){
    	   var empNames="";
    	   var del_idstr="";
    	   $.each($(".check_item:checked"),function(){
    		   empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
    		   //组装员工id的字符串
    		   del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
    	   });
    	   //删除多余的,
    	   empNames = empNames.substring(0,empNames.length-1);
    	   //删除多余的-
    	   del_idstr = del_idstr.substring(0,del_idstr.length-1);
    	   if(confirm("确认删除【"+empNames+"】吗?")){
   			$.ajax({
				url:"${APP_PATH}/emp/"+del_idstr,
				type:"DELETE",
				success:function(result){
					alert(result.msg)
					//回到本页
					to_page(currentPage);
				}
		    });
    	   }
       });
	</script>
</body>
</html>