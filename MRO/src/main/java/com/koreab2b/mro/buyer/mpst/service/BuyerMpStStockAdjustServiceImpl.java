package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStStockAdjustDao;

@Service("buyerMpStStockAdjustService")
public class BuyerMpStStockAdjustServiceImpl implements BuyerMpStStockAdjustService {
	
	@Autowired
	private BuyerMpStStockAdjustDao buyerMpStStockAdjustDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpStStockAdjustDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpStStockAdjustDao.updateSelectedData(formData, gridData);
	}	

}
