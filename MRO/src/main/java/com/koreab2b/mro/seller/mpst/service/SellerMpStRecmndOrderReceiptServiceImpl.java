package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpst.dao.SellerMpStRecmndOrderReceiptDao;

@Service("sellerMpStRecmndOrderReceiptService")
public class SellerMpStRecmndOrderReceiptServiceImpl implements SellerMpStRecmndOrderReceiptService {
	
	@Autowired
	private SellerMpStRecmndOrderReceiptDao sellerMpStRecmndOrderReceiptDao;

	// 조회 (기존)
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpStRecmndOrderReceiptDao.selectList(formData);
	}
	
	// 날짜 파라미터 포함 조회 (신규)
	public List<Map<String,String>> getListWithDate(Map<String,String> formData) {
		return sellerMpStRecmndOrderReceiptDao.selectListWithDate(formData);
	}

}
