package com.koreab2b.mro.common.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpst.dao.SellerMpStToolStockStatePopDao;

@Service("sellerMpStToolStockStatePopServiceImpl")
public class SellerMpStToolStockStatePopServiceImpl implements SellerMpStToolStockStatePopService {
	@Autowired
	private SellerMpStToolStockStatePopDao sellerMpStToolStockStatePopDao;

	// 조회
	public List<Map<String,String>> getSellerMpStToolStockStatePop(Map<String,Object> formData) {
		return sellerMpStToolStockStatePopDao.selectList(formData);
	}
	
}
