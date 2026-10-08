package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvDeliveryDelayReasonPopDao;

@Service("sellerMpIvDeliveryDelayReasonPopService")
public class SellerMpIvDeliveryDelayReasonPopServiceImpl implements SellerMpIvDeliveryDelayReasonPopService {
	
	@Autowired
	private SellerMpIvDeliveryDelayReasonPopDao sellerMpIvDeliveryDelayReasonPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpIvDeliveryDelayReasonPopDao.selectList(formData);
	}	
	

}
