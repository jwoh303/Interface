package com.koreab2b.mro.common.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpst.dao.SellerMpStClosingBuyerPopDao;

@Service("sellerMpStClosingBuyerPopServiceImpl")
public class SellerMpStClosingBuyerPopServiceImpl implements SellerMpStClosingBuyerPopService {
	@Autowired
	private SellerMpStClosingBuyerPopDao sellerMpStClosingBuyerPopDao;

	// 조회
	public List<Map<String,String>> getSellerMpStClosingBuyerPop(Map<String,Object> formData) {
		return sellerMpStClosingBuyerPopDao.selectList(formData);
	}
	
}
