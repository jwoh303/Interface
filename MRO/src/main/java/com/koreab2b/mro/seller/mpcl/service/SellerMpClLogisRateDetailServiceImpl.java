package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClLogisRateDetailDao;

@Service("sellerMpClLogisRateDetailService")
public class SellerMpClLogisRateDetailServiceImpl implements SellerMpClLogisRateDetailService {
	
	@Autowired
	private SellerMpClLogisRateDetailDao sellerMpClLogisRateDetailDao;

	// 리스트 조회 (레거시)
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMpClLogisRateDetailDao.selectList(param);
	}

	// 리스트 조회 (리뉴얼)
	public List<Map<String,String>> getList_v2(Map<String,Object> param) {
		return sellerMpClLogisRateDetailDao.selectList_v2(param);
	}
	public List<Map<String,String>> getList_v3(Map<String,Object> param) {
		return sellerMpClLogisRateDetailDao.selectList_v3(param);
	}
}
