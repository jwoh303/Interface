package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpst.dao.SellerMpStStockStateDao;

@Service("sellerMpStStockStateService")
public class SellerMpStStockStateServiceImpl implements SellerMpStStockStateService {
	
	@Autowired
	private SellerMpStStockStateDao sellerMpStStockStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpStStockStateDao.selectList(formData);
	}	
	
	// 저장
//	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
//		return sellerMpStStockStateDao.updateSelectedData(formData, gridData);
//	}	

}
