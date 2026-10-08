package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStStockGoodsDao;

@Service("buyerMpStStockGoodsService")
public class BuyerMpStStockGoodsServiceImpl implements BuyerMpStStockGoodsService {
	
	@Autowired
	private BuyerMpStStockGoodsDao buyerMpStStockGoodsDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpStStockGoodsDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpStStockGoodsDao.updateSelectedData(formData, gridData);
	}	

}
