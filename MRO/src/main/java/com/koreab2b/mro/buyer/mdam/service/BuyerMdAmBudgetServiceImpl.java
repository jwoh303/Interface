package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDao;

@Service("buyerMdAmBudgetService")
public class BuyerMdAmBudgetServiceImpl implements BuyerMdAmBudgetService {
	
	@Autowired
	private BuyerMdAmBudgetDao buyerMdAmBudgetDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmBudgetDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerMdAmBudgetList_v2(Map<String,Object> formData) {
		return buyerMdAmBudgetDao.getBuyerMdAmBudgetList_v2(formData);
	}
	
	
	// 이력 조회
	public List<Map<String,String>> getHistList(Map<String,String> formData) {
		return buyerMdAmBudgetDao.selectHistList(formData);
	}
	public List<Map<String,String>> excelBuyerMdAmBudgetHistList_v2(Map<String,Object> formData) {
		return buyerMdAmBudgetDao.excelBuyerMdAmBudgetHistList_v2(formData);
	}
	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmBudgetDao.updateSelectedData(formData, gridData);
	}	

}
