package com.learn.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.learn.crud.bean.Department;
import com.learn.crud.dao.DepartmentMapper;

@Service
public class DepartmentService {

	@Autowired
	DepartmentMapper departmentMapper;
	public List<Department> getDepts() {
		return departmentMapper.selectByExample(null);
	}
}
