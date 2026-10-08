package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmUserSearchDao;

@Service("buyerMdAmUserSearchService")
public class BuyerMdAmUserSearchServiceImpl implements BuyerMdAmUserSearchService {
	
	@Autowired
	private BuyerMdAmUserSearchDao buyerMdAmUserSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmUserSearchDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return buyerMdAmUserSearchDao.updateSelectedData(formData);
	}	

}
