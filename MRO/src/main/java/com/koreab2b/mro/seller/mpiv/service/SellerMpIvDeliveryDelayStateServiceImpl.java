package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvDeliveryDelayStateDao;

@Service("sellerMpIvDeliveryDelayStateService")
public class SellerMpIvDeliveryDelayStateServiceImpl implements SellerMpIvDeliveryDelayStateService {
	
	@Autowired
	private SellerMpIvDeliveryDelayStateDao sellerMpIvDeliveryDelayStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return sellerMpIvDeliveryDelayStateDao.selectList(pMap);
	}	
	
	// 저장
	public String updateSellerMpIvDeliveryDelayState(Map<String,String> pMap) {
		return sellerMpIvDeliveryDelayStateDao.updateSellerMpIvDeliveryDelayState(pMap);
	}	

}
