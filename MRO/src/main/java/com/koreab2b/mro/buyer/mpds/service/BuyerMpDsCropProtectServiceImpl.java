package com.koreab2b.mro.buyer.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpds.dao.BuyerMpDsCropProtectDao;

@Service("buyerMpDsCropProtectService")
public class BuyerMpDsCropProtectServiceImpl implements BuyerMpDsCropProtectService {
	
	@Autowired
	private BuyerMpDsCropProtectDao buyerMpDsCropProtectDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsCropProtectDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpDsCropProtectDao.updateSelectedData(formData, gridData);
	}	

}
