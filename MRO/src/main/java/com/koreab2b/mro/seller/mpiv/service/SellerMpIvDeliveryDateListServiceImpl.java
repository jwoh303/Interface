package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvDeliveryDateListDao;

@Service("sellerMpIvDeliveryDateListService")
public class SellerMpIvDeliveryDateListServiceImpl implements SellerMpIvDeliveryDateListService {
	
	@Autowired
	private SellerMpIvDeliveryDateListDao sellerMpIvDeliveryDateListDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvDeliveryDateListDao.selectList(formData);
	}	
	// 저장
	public String updateSellerMpIvDeliveryDateReg(Map<String,String> pMap) {
		return sellerMpIvDeliveryDateListDao.updateSellerMpIvDeliveryDateReg(pMap);
	}	
}
