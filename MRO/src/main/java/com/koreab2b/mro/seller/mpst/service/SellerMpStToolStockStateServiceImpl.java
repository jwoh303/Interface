package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpst.dao.SellerMpStToolStockStateDao;

@Service("sellerMpStToolStockStateService")
public class SellerMpStToolStockStateServiceImpl implements SellerMpStToolStockStateService {
	
	@Autowired
	private SellerMpStToolStockStateDao sellerMpStToolStockStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpStToolStockStateDao.selectList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMpStToolStockStateDao.updateSelectedData(formData, gridData);
	}	
	
	// 삭제
	public String delSelectedData(Map<String,String> formData, List<Object> gridData) {
		return sellerMpStToolStockStateDao.deleteSelectedData(formData, gridData);
	}	

}
