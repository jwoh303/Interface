package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvObtnodrMultiReceiptDao;

@Service("sellerMpIvObtnodrMultiReceiptService")
public class SellerMpIvObtnodrMultiReceiptServiceImpl implements SellerMpIvObtnodrMultiReceiptService {
	
	@Autowired
	private SellerMpIvObtnodrMultiReceiptDao sellerMpIvObtnodrMultiReceiptDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvObtnodrMultiReceiptDao.selectList(formData);
	}
	
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return sellerMpIvObtnodrMultiReceiptDao.selectExcelList(formData);
	}	
	//수주접수 저장
	public String saveSellerMpIvObtnodrMultiReceiptList(Map<String, String> pMap, List<Object> pList){
		return sellerMpIvObtnodrMultiReceiptDao.saveSellerMpIvObtnodrMultiReceiptList(pMap, pList);
	}
	
}
