package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvObtnodrReceiptDao;

@Service("sellerMpIvObtnodrReceiptService")
public class SellerMpIvObtnodrReceiptServiceImpl implements SellerMpIvObtnodrReceiptService {
	
	@Autowired
	private SellerMpIvObtnodrReceiptDao sellerMpIvObtnodrReceiptDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvObtnodrReceiptDao.selectList(formData);
	}
	
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return sellerMpIvObtnodrReceiptDao.selectExcelList(formData);
	}	
	
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptList_v2(Map<String,Object> formData) {
		return sellerMpIvObtnodrReceiptDao.getSellerMpIvObtnodrReceiptList_v2(formData);
	}
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptMultiList_v2(Map<String,Object> formData) {
		return sellerMpIvObtnodrReceiptDao.getSellerMpIvObtnodrReceiptMultiList_v2(formData);
	}
	
	
}
