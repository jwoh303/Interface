package com.koreab2b.mro.master.mpst.service;

import java.util.List;


import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpst.dao.MasterMpStPriceAdjustmentDao;

@Service("masterMpStPriceAdjustmentService")
public class MasterMpStPriceAdjustmentServiceImpl implements MasterMpStPriceAdjustmentService {
	@Autowired
	private MasterMpStPriceAdjustmentDao masterMpStPriceAdjustmentDao;

	// 견적 최저가 예외 현황
	public List<Map<String,String>> getMasterMpStQuotExceptionList(Map<String,Object> param) {
		return masterMpStPriceAdjustmentDao.getMasterMpStQuotExceptionList(param);
	}
	
	// 견적 최저가 예외 상세
	public List<Map<String,String>> getMasterMpStQuotExceptionDetailList(Map<String,Object> param) {
		return masterMpStPriceAdjustmentDao.getMasterMpStQuotExceptionDetailList(param);
	}
	
	// 주문 단가조정 현황
	public List<Map<String,String>> getMasterMpStPoPriceAdjustList(Map<String,Object> param) {
		return masterMpStPriceAdjustmentDao.getMasterMpStPoPriceAdjustList(param);
	}
	
	// 주문 단가조정 상세
	public List<Map<String,String>> getMasterMpStPoPriceAdjustDetailList(Map<String,Object> param) {
		return masterMpStPriceAdjustmentDao.getMasterMpStPoPriceAdjustDetailList(param);
	}
}
