package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpst.dao.SellerMpStClosingDao;

@Service("sellerMpStClosingService")
public class SellerMpStClosingServiceImpl implements SellerMpStClosingService {
	
	@Autowired
	private SellerMpStClosingDao sellerMpStClosingDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpStClosingDao.selectList(formData);
	}	
	
	// 저장
//	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
//		return sellerMpStClosingDao.updateSelectedData(formData, gridData);
//	}	

}
