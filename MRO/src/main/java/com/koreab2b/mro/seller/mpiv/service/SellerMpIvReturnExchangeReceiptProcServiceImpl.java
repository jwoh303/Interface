package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvReturnExchangeReceiptProcDao;

@Service("sellerMpIvReturnExchangeReceiptProcService")
public class SellerMpIvReturnExchangeReceiptProcServiceImpl implements SellerMpIvReturnExchangeReceiptProcService {
	
	@Autowired
	private SellerMpIvReturnExchangeReceiptProcDao sellerMpIvReturnExchangeReceiptProcDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvReturnExchangeReceiptProcDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMpIvReturnExchangeReceiptProcDao.updateSelectedData(formData, gridData);
	}	

}
