package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDepartmentDao;

@Service("buyerMdAmBudgetDepartmentService")
public class BuyerMdAmBudgetDepartmentServiceImpl implements BuyerMdAmBudgetDepartmentService {
	
	@Autowired
	private BuyerMdAmBudgetDepartmentDao buyerMdAmBudgetDepartmentDao;

	public List<Map<String,String>> getBuyerMdAmBudgetDepartmentListAll_v2(Map<String,Object> formData) {
		return buyerMdAmBudgetDepartmentDao.getBuyerMdAmBudgetDepartmentListAll_v2(formData);
	}
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmBudgetDepartmentDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerMdAmBudgetDepartmentList_v2(Map<String,Object> formData) {
		return buyerMdAmBudgetDepartmentDao.getBuyerMdAmBudgetDepartmentList_v2(formData);
	}	
	
	//삭제
	public String delBuyerMdAmBudgetDepartmentList_v2(Map<String,String>  formData, List<Object> gridData){
		return buyerMdAmBudgetDepartmentDao.delBuyerMdAmBudgetDepartmentList_v2(formData,gridData);
	}
	
	//저장
	public String saveBuyerMdAmBudgetDepartmentList_v2(Map<String,String>  formData, List<Object> gridData){
		return buyerMdAmBudgetDepartmentDao.saveBuyerMdAmBudgetDepartmentList_v2(formData,gridData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmBudgetDepartmentDao.updateSelectedData(formData, gridData);
	}	
	
	public String saveBuyerMdAmDepartmentListPop_v2(Map<String,String>  formData, List<Object> gridData){
		return buyerMdAmBudgetDepartmentDao.saveBuyerMdAmDepartmentListPop_v2(formData,gridData);
	}
	
	public String saveBuyerMdAmBudgetDepartmentListPop_v2(Map<String,String>  formData, List<Object> gridData){
		return buyerMdAmBudgetDepartmentDao.saveBuyerMdAmBudgetDepartmentListPop_v2(formData,gridData);
	}
	
	public String delBuyerMdAmBudgetDepartmentConList_v2(Map<String,String>  formData, List<Object> gridData){
		return buyerMdAmBudgetDepartmentDao.delBuyerMdAmBudgetDepartmentConList_v2(formData,gridData);
	}
}
