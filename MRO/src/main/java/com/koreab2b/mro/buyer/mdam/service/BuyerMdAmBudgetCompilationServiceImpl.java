package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetCompilationDao;

@Service("buyerMdAmBudgetCompilationService")
public class BuyerMdAmBudgetCompilationServiceImpl implements BuyerMdAmBudgetCompilationService {
	
	@Autowired
	private BuyerMdAmBudgetCompilationDao buyerMdAmBudgetCompilationDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmBudgetCompilationDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerMdAmBudgetCompilationList_v2(Map<String,Object> formData) {
		return buyerMdAmBudgetCompilationDao.getBuyerMdAmBudgetCompilationList_v2(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmBudgetCompilationDao.updateSelectedData(formData, gridData);
	}
	public String saveBuyerMdAmBudgetCompilationList_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmBudgetCompilationDao.saveBuyerMdAmBudgetCompilationList_v2(formData, gridData);
	}

	// 삭제
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmBudgetCompilationDao.deleteSelectedData(formData, gridData);
	}	
	public String delBuyerMdAmBudgetCompilationList_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmBudgetCompilationDao.delBuyerMdAmBudgetCompilationList_v2(formData, gridData);
	}	
}
