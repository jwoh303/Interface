package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.BuyerMpRqDepartmentTotalPopDao;

@Service("buyerMpRqDepartmentTotalPopService")
public class BuyerMpRqDepartmentTotalPopServiceImpl implements BuyerMpRqDepartmentTotalPopService {
	
	@Autowired
	private BuyerMpRqDepartmentTotalPopDao buyerMpRqDepartmentTotalPopDao;

	// 조회
	public Map<String,String> getHdForm(Map<String,String>  formData) {
		return buyerMpRqDepartmentTotalPopDao.getHdForm(formData);
	}	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpRqDepartmentTotalPopDao.selectList(formData);
	}	
	

}
