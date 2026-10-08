package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvDeliveryDelayBuyerChoicePopDao;

@Service("sellerMpIvDeliveryDelayBuyerChoicePopService")
public class SellerMpIvDeliveryDelayBuyerChoicePopServiceImpl implements SellerMpIvDeliveryDelayBuyerChoicePopService {
	
	@Autowired
	private SellerMpIvDeliveryDelayBuyerChoicePopDao sellerMpIvDeliveryDelayBuyerChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvDeliveryDelayBuyerChoicePopDao.selectList(formData);
	}	
	

}
