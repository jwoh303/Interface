package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderAdminProgressDao;

@Service("BuyerMpSoOrderAdminProgressService")
public class BuyerMpSoOrderAdminProgressServiceImpl implements BuyerMpSoOrderAdminProgressService {
	
	@Autowired
	private BuyerMpSoOrderAdminProgressDao BuyerMpSoOrderAdminProgressDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return BuyerMpSoOrderAdminProgressDao.selectList(formData);
	}
	// 조회
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return BuyerMpSoOrderAdminProgressDao.selecExceltList(formData);
	}	
	// 부서별조회
	public List<Map<String,String>> getOrderDepttList(Map<String,String> formData) {
		return BuyerMpSoOrderAdminProgressDao.selectOrderDeptList(formData);
	}		
	// 협력사별
	public List<Map<String,String>> getOrderAgentList(Map<String,String> formData) {
		return BuyerMpSoOrderAdminProgressDao.selectOrderAgentList(formData);
	}		

}
