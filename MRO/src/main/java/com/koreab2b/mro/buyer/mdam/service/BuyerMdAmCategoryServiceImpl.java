package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmCategoryDao;

@Service("buyerMdAmCategoryService")
public class BuyerMdAmCategoryServiceImpl implements BuyerMdAmCategoryService {
	
	@Autowired
	private BuyerMdAmCategoryDao buyerMdAmCategoryDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmCategoryDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMdAmCategoryDao.updateSelectedData(formData, gridData);
	}	

}
