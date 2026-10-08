package com.koreab2b.mro.seller.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.none.dao.SellerNoNeNoticeDao;

@Service("sellerNoNeNoticeService")
public class SellerNoNeNoticeServiceImpl implements SellerNoNeNoticeService {
	
	@Autowired
	private SellerNoNeNoticeDao sellerNoNeNoticeDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerNoNeNoticeDao.selectList(formData);
	}
	
	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData){
		return sellerNoNeNoticeDao.selectDetail(formData);
	}

}
