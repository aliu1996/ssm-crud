package com.learn.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
/*
 * 1������springTestģ��
 * 2��@ContextConfigurationָ��spring�����ļ���λ��
 * 3��ֱ��autowired�������*/
//����dao��Ĺ���

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
//		departmentMapper.insertSelective(new Department(null,"��������"));
//		departmentMapper.insertSelective(new Department(null,"������"));
//		employeeMapper.insertSelective(new Employee(null,"����","��","6666",2));
		EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
		for (int i = 0; i < 1000; i++) {
			String uid=UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null,uid,"M",uid+"@126.com",2));
		}
		System.out.println("�������");
	}
}
