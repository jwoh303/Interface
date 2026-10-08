package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmCategoryPCODao;

@Service("buyerMdCmCategoryPCOService")
public class BuyerMdCmCategoryPCOServiceImpl implements BuyerMdCmCategoryPCOService {
	
	@Autowired
	private BuyerMdCmCategoryPCODao buyerMdCmCategoryPCODao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmCategoryPCODao.getList(formData);
	}	
	// 조회
	public List<Map<String,String>> getCategoryPathPCO(Map<String,String> formData) {
		return buyerMdCmCategoryPCODao.getCategoryPathPCO(formData);
	}
	// 조회
	public List<Map<String,String>> getRqUserInfo(Map<String,String> formData) {
		return buyerMdCmCategoryPCODao.getRqUserInfo(formData);
	}	
	// 저장
	public String saveBuyerMdCmRqdtTemp(Map<String,String>  formData) {
		return buyerMdCmCategoryPCODao.saveBuyerMdCmRqdtTemp(formData);
	}	
}
