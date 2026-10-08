package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartHongikDao;

@Service("buyerMpSoCartHongikService")
public class BuyerMpSoCartHongikServiceImpl implements BuyerMpSoCartHongikService {
	
	@Autowired
	private BuyerMpSoCartHongikDao buyerMpSoCartHongikDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoCartHongikDao.selectList(formData);
	}	
	 

}
