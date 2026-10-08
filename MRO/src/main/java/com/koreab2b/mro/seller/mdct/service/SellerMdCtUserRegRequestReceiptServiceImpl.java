package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdct.dao.SellerMdCtUserRegRequestReceiptDao;

@Service("sellerMdCtUserRegRequestReceiptService")
public class SellerMdCtUserRegRequestReceiptServiceImpl implements SellerMdCtUserRegRequestReceiptService {
	
	@Autowired
	private SellerMdCtUserRegRequestReceiptDao sellerMdCtUserRegRequestReceiptDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdCtUserRegRequestReceiptDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMdCtUserRegRequestReceiptDao.updateSelectedData(formData);
	}	
}
