package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmDepartmentAccountDao;

@Service("buyerMdAmDepartmentAccountService")
public class BuyerMdAmDepartmentAccountServiceImpl implements BuyerMdAmDepartmentAccountService {
	
	@Autowired
	private BuyerMdAmDepartmentAccountDao buyerMdAmDepartmentAccountDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmDepartmentAccountDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerMdAmDepartmentAccountList_v2(Map<String,Object> formData) {
		return buyerMdAmDepartmentAccountDao.getBuyerMdAmDepartmentAccountList_v2(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmDepartmentAccountDao.updateSelectedData(formData, gridData);
	}	
	public String saveBuyerMdAmBudgetDepartmentAccountListPop_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmDepartmentAccountDao.saveBuyerMdAmBudgetDepartmentAccountListPop_v2(formData, gridData);
	}	

	public String delBuyerMdAmBudgetDepartmentAccountList_v2(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmDepartmentAccountDao.delBuyerMdAmBudgetDepartmentAccountList_v2(formData, gridData);
	}	
}
