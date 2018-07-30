package com.learn.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.learn.crud.bean.Department;
import com.learn.crud.bean.Msg;
import com.learn.crud.service.DepartmentService;

@Controller
public class DepartmentController {

	@Autowired
	DepartmentService departmentService;
	@ResponseBody
	@RequestMapping("/depts")
	public Msg getDeptWithJson() {
		//查出所有的部门信息
		List<Department> department=departmentService.getDepts();
		return Msg.success().add("depts", department);	
	}
}
