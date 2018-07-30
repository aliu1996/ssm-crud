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

//����Ա����ɾ�Ĳ�
@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService;
	//ɾ��Ա��
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmp(@PathVariable("ids")String ids) {
		if (ids.contains("-")) {
			//����ɾ��
			List<Integer> del_ids=new ArrayList<Integer>();
			String[] str_ids = ids.split("-");
			//��װids
			for (String id : str_ids) {
				del_ids.add(Integer.parseInt(id));			
			}
			System.out.println(del_ids);
			employeeService.deleteBatch(del_ids);
			System.out.println("����ɾ���ɹ�");
		} else {		
			//��һɾ��
			employeeService.deleteEmpById(Integer.parseInt(ids));
			System.out.println("��һɾ���ɹ�");
		}
    	return Msg.success();
	}
	//��ѯԱ����Ϣ
	@ResponseBody
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	public Msg getEmp(@PathVariable(value="id") Integer id) {
		Employee employee=employeeService.getEmps(id);
		return Msg.success().add("emp", employee);
	}
	//�����޸ĺ��Ա������
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg saveEmp(Employee employee) {
		System.out.println(employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	//������û���ظ�����Ϣ
	@ResponseBody
	@RequestMapping("/checkUser")
	public Msg checkUser(@RequestParam(value="empName") String empName) {
		//���ж��û��Ƿ��ǺϷ����ʽ
		String regx="(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if (!empName.matches(regx)) {
			return Msg.defeat().add("va_msg", "�û�������2��5λ���Ļ���6-16λӢ�ĺ����ֵ����va_msg");
		}
		boolean b=employeeService.checkUser(empName);
		if (b) {
			return Msg.success();
		}
		return Msg.defeat().add("va_msg", "�û���������");
		
	}
	//Ա�����棬֧��JSR303У�飬�ȵ���hibernate-validator
	@ResponseBody
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if (result.hasErrors()) {
			//У��ʧ�ܣ�Ӧ�÷���ʧ�ܣ���ģ̬������ʾУ��ʧ�ܵ���Ϣ
			Map<String, Object> map=new HashMap<String, Object>();
			List<FieldError> errors=result.getFieldErrors();
			for (FieldError fieldError : errors) {
				System.out.println("������ֶ���"+fieldError.getField());
				System.out.println("������Ϣ"+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.defeat().add("errorFields", map);
		}else {
			employeeService.saveEmps(employee);
			return Msg.success();
		}

		
	}
	
	
	//��json����,Ҫ����jackson��
	
	@ResponseBody
	@RequestMapping("/emps")
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1") Integer pn) {
		//�ⲻ��һ����ҳ��ѯ
		//����PageHelper��ҳ���
		//�ڲ�ѯ֮ǰֻ��Ҫ����PageHelper,����ҳ���Լ�ÿҳ�Ĵ�С
		PageHelper.startPage(pn,5);
		List<Employee> emps=employeeService.getAll();
		//��PageInfo�Խ�����а�װ��ֻ�轫pageinfo����ҳ�������
		//��װ����ϸ�ķ�ҳ��Ϣ,���������ǲ�ѯ����������,����������ʾ��ҳ��
		PageInfo page = new PageInfo(emps,5);
		return Msg.success().add("pageInfo", page);
	}
	
	
	//��ѯԱ������
	@RequestMapping("/emps1")
	public String getEmps(@RequestParam(value="pn",defaultValue="1") Integer pn,Model model) {
		//�ⲻ��һ����ҳ��ѯ
		//����PageHelper��ҳ���
		//�ڲ�ѯ֮ǰֻ��Ҫ����PageHelper,����ҳ���Լ�ÿҳ�Ĵ�С
		PageHelper.startPage(pn,5);
		List<Employee> emps=employeeService.getAll();
		//��PageInfo�Խ�����а�װ��ֻ�轫pageinfo����ҳ�������
		//��װ����ϸ�ķ�ҳ��Ϣ,���������ǲ�ѯ����������,����������ʾ��ҳ��
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		return "list";
	}



}
