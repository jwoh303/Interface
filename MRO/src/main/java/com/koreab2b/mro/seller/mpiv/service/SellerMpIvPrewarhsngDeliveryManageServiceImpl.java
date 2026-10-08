package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvPrewarhsngDeliveryManageDao;

@Service("sellerMpIvPrewarhsngDeliveryManageService")
public class SellerMpIvPrewarhsngDeliveryManageServiceImpl implements SellerMpIvPrewarhsngDeliveryManageService {
	
	@Autowired
	private SellerMpIvPrewarhsngDeliveryManageDao sellerMpIvPrewarhsngDeliveryManageDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvPrewarhsngDeliveryManageDao.selectList(formData);
	}	
	
}
