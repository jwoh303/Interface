package com.koreab2b.mro.common.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdam.dao.BuyerMdAmBudgetUploadPopDao;

@Service("buyerMdAmBudgetUploadPopService")
public class BuyerMdAmBudgetUploadPopServiceImpl implements BuyerMdAmBudgetUploadPopService {
	
	@Autowired
	private BuyerMdAmBudgetUploadPopDao buyerMdAmBudgetUploadPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return buyerMdAmBudgetUploadPopDao.selectList(formData);
	}
	public List<Map<String,String>> getBuyerMdAmBudgetUploadPop_v2(Map<String,Object> formData) {
		return buyerMdAmBudgetUploadPopDao.getBuyerMdAmBudgetUploadPop_v2(formData);
	}
	
	// 업로드
	@Transactional
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMdAmBudgetUploadPopDao.uploadSelectedData(formData, gridData);
	}
	@Transactional
	public String saveBuyerMdAmExcelUpload_v2(Map<String,String>  formData, List<Object> gridData) {
		return buyerMdAmBudgetUploadPopDao.saveBuyerMdAmExcelUpload_v2(formData, gridData);
	}
	
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return buyerMdAmBudgetUploadPopDao.updateSelectedData(formData, gridData);
	}
	@Transactional
	public String saveBuyerMdAmBudgetUpload_v2(Map<String,String>  formData, List<Object> gridData) {
		return buyerMdAmBudgetUploadPopDao.saveBuyerMdAmBudgetUpload_v2(formData, gridData);
	}
	
}
