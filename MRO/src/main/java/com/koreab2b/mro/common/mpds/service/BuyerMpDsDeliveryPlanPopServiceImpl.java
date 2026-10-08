package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.BuyerMpDsDeliveryPlanPopDao;

@Service("buyerMpDsDeliveryPlanPopService")
public class BuyerMpDsDeliveryPlanPopServiceImpl implements BuyerMpDsDeliveryPlanPopService {
	
	@Autowired
	private BuyerMpDsDeliveryPlanPopDao buyerMpDsDeliveryPlanPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsDeliveryPlanPopDao.selectList(formData);
	}	
	

}
