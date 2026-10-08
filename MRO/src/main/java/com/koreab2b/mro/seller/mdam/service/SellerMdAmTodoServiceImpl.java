package com.koreab2b.mro.seller.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdam.dao.SellerMdAmTodoDao;

@Service("sellerMdAmTodoService")
public class SellerMdAmTodoServiceImpl implements SellerMdAmTodoService {
	
	@Autowired
	private SellerMdAmTodoDao sellerMdAmTodoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdAmTodoDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMdAmTodoDao.updateSelectedData(formData, gridData);
	}	

}
