package com.learn.crud.controller;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.learn.crud.bean.Employee;
import com.learn.crud.bean.Msg;
import com.learn.crud.service.EmployeeService;

//处理员工增删改查
@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService;
	//删除员工
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmp(@PathVariable("ids")String ids) {
		if (ids.contains("-")) {
			//批量删除
			List<Integer> del_ids=new ArrayList<Integer>();
			String[] str_ids = ids.split("-");
			//组装ids
			for (String id : str_ids) {
				del_ids.add(Integer.parseInt(id));			
			}
			System.out.println(del_ids);
			employeeService.deleteBatch(del_ids);
			System.out.println("批量删除成功");
		} else {		
			//单一删除
			employeeService.deleteEmpById(Integer.parseInt(ids));
			System.out.println("单一删除成功");
		}
    	return Msg.success();
	}
	//查询员工信息
	@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	public Msg getEmp(@PathVariable(value="id") Integer id) {
		Employee employee=employeeService.getEmps(id);
		return Msg.success().add("emp", employee);
	}
	//保存修改后的员工数据
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg saveEmp(Employee employee) {
		System.out.println(employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	//检验有没有重复的信息
	@ResponseBody
	@RequestMapping("/checkUser")
	public Msg checkUser(@RequestParam(value="empName") String empName) {
		//先判断用户是否是合法表达式
		String regx="(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if (!empName.matches(regx)) {
			return Msg.defeat().add("va_msg", "用户必须是2到5位中文或者6-16位英文和数字的组合va_msg");
		}
		boolean b=employeeService.checkUser(empName);
		if (b) {
			return Msg.success();
		}
		return Msg.defeat().add("va_msg", "用户名不可用");
		
	}
	//员工保存，支持JSR303校验，先导入hibernate-validator
	@ResponseBody
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if (result.hasErrors()) {
			//校验失败，应该返回失败，在模态框中显示校验失败的信息
			Map<String, Object> map=new HashMap<String, Object>();
			List<FieldError> errors=result.getFieldErrors();
			for (FieldError fieldError : errors) {
				System.out.println("错误的字段名"+fieldError.getField());
				System.out.println("错误信息"+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.defeat().add("errorFields", map);
		}else {
			employeeService.saveEmps(employee);
			return Msg.success();
		}

		
	}
	
	
	//用json传输,要导入jackson包
	
	@ResponseBody
	@RequestMapping("/emps")
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1") Integer pn) {
		//这不是一个分页查询
		//引入PageHelper分页插件
		//在查询之前只需要调用PageHelper,传入页码以及每页的大小
		PageHelper.startPage(pn,5);
		List<Employee> emps=employeeService.getAll();
		//用PageInfo对结果进行包装，只需将pageinfo交给页面就行了
		//封装了详细的分页信息,包括有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps,5);
		return Msg.success().add("pageInfo", page);
	}
	
	
	//查询员工数据
	@RequestMapping("/emps1")
	public String getEmps(@RequestParam(value="pn",defaultValue="1") Integer pn,Model model) {
		//这不是一个分页查询
		//引入PageHelper分页插件
		//在查询之前只需要调用PageHelper,传入页码以及每页的大小
		PageHelper.startPage(pn,5);
		List<Employee> emps=employeeService.getAll();
		//用PageInfo对结果进行包装，只需将pageinfo交给页面就行了
		//封装了详细的分页信息,包括有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		return "list";
	}



}
