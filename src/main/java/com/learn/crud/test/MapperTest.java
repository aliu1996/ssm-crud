package com.learn.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
/*
 * 1、导入springTest模块
 * 2、@ContextConfiguration指定spring配置文件的位置
 * 3、直接autowired组件即可*/
//测试dao层的工作

import com.learn.crud.bean.Department;
import com.learn.crud.bean.Employee;
import com.learn.crud.dao.DepartmentMapper;
import com.learn.crud.dao.EmployeeMapper;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {

	@Autowired
	DepartmentMapper departmentMapper;
	@Autowired
	EmployeeMapper employeeMapper;
	@Autowired
	SqlSession sqlSession;
	@Test
	public void testCRUD() {
//		System.out.println("5555");
//		System.out.println(departmentMapper+"123");
//		departmentMapper.insertSelective(new Department(null,"开发部门"));
//		departmentMapper.insertSelective(new Department(null,"管理部门"));
//		employeeMapper.insertSelective(new Employee(null,"张三","男","6666",2));
		EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
		for (int i = 0; i < 1000; i++) {
			String uid=UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null,uid,"M",uid+"@126.com",2));
		}
		System.out.println("批量完成");
	}
}
