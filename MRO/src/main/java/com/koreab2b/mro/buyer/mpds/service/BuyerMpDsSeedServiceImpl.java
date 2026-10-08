package com.koreab2b.mro.buyer.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpds.dao.BuyerMpDsSeedDao;

@Service("buyerMpDsSeedService")
public class BuyerMpDsSeedServiceImpl implements BuyerMpDsSeedService {
	
	@Autowired
	private BuyerMpDsSeedDao buyerMpDsSeedDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsSeedDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpDsSeedDao.updateSelectedData(formData, gridData);
	}	

}
