package com.learn.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.learn.crud.bean.Employee;
import com.learn.crud.bean.EmployeeExample;
import com.learn.crud.bean.EmployeeExample.Criteria;
import com.learn.crud.dao.EmployeeMapper;
@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;
	public List<Employee> getAll() {
		// TODO Auto-generated method stub
		return employeeMapper.selectByExampleWithDept(null);
	}
	public void saveEmps(Employee employee) {
		System.out.println(employee.getGender());
		// TODO Auto-generated method stub
		employeeMapper.insertSelective(employee);
		System.out.println("插入成功");
	}
	//检验用户名是否可用
	public boolean checkUser(String name) {
		// TODO Auto-generated method stub
		EmployeeExample example=new EmployeeExample();
		Criteria criteria=example.createCriteria();
		criteria.andEmpNameEqualTo(name);
		long count=employeeMapper.countByExample(example);
		return count == 0;
	}
	//按照员工id查询
	public Employee getEmps(int empId) {
		// TODO Auto-generated method stub
		Employee employee=(Employee) employeeMapper.selectByPrimaryKey(empId);
		return employee;
	}
	public void updateEmp(Employee employee) {
		// TODO Auto-generated method stub

		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	//员工删除
	public void deleteEmpById(Integer id) {
		// TODO Auto-generated method stub
		employeeMapper.deleteByPrimaryKey(id);
	}
	public void deleteBatch(List<Integer> ids) {
		// TODO Auto-generated method stub
		EmployeeExample example=new EmployeeExample();
		Criteria criteria=example.createCriteria();
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}

	
}
