package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdcm.dao.BuyerMdCmCartPunchoutSearchDao;

@Service("buyerMdCmCartPunchoutSearchService")
public class BuyerMdCmCartPunchoutSearchServiceImpl implements BuyerMdCmCartPunchoutSearchService {
	
	@Autowired
	private BuyerMdCmCartPunchoutSearchDao buyerMdCmCartPunchoutSearchDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdCmCartPunchoutSearchDao.getList(formData);
	}	
	// 저장
	public String saveBuyerMdCmCartQtyPunchOut(Map<String,String>  formData) {
		return buyerMdCmCartPunchoutSearchDao.saveBuyerMdCmCartQtyPunchOut(formData);
	}	
	// 저장
	public String deleteBuyerMdCmCartListPunchOut(Map<String,String>  formData) {
		return buyerMdCmCartPunchoutSearchDao.deleteBuyerMdCmCartListPunchOut(formData);
	}
}
