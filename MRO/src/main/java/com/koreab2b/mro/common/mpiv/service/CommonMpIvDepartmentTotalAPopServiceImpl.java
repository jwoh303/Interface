package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvDepartmentTotalAPopDao;

@Service("commonMpIvDepartmentTotalAPopService")
public class CommonMpIvDepartmentTotalAPopServiceImpl implements CommonMpIvDepartmentTotalAPopService {
	
	@Autowired
	private CommonMpIvDepartmentTotalAPopDao commonMpIvDepartmentTotalAPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvDepartmentTotalAPopDao.selectList(formData);
	}	
	

}
