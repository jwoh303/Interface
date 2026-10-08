package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClClosingInfoDao;

@Service("sellerMpClClosingInfoService")
public class SellerMpClClosingInfoServiceImpl implements SellerMpClClosingInfoService {
	
	@Autowired
	private SellerMpClClosingInfoDao sellerMpClClosingInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClClosingInfoDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getAgentClosingInfoDown(Map<String,String> formData) {
		return sellerMpClClosingInfoDao.getAgentClosingInfoDown(formData);
	}	
	

}
