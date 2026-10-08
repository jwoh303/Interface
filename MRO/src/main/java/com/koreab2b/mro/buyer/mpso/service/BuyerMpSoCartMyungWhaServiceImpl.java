package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartMyungWhaDao;

@Service("buyerMpSoCartMyungWhaService")
public class BuyerMpSoCartMyungWhaServiceImpl implements BuyerMpSoCartMyungWhaService {
	
	@Autowired
	private BuyerMpSoCartMyungWhaDao buyerMpSoCartMyungWhaDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoCartMyungWhaDao.selectList(formData);
	}	
	 

}
