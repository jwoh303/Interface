package com.koreab2b.mro.seller.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.none.dao.SellerNoNePopupDao;

@Service("sellerNoNePopupeService")
public class SellerNoNePopupServiceImpl implements SellerNoNePopupService {
	
	@Autowired
	private SellerNoNePopupDao sellerNoNePopupDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerNoNePopupDao.selectList(formData);
	}

	// 읽음 저장
	public String saveSellerNoNePopupRead(Map<String, String> formData) {
		return sellerNoNePopupDao.insertSellerNoNePopupRead(formData);
	}
	


}
