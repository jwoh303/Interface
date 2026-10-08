package com.koreab2b.mro.buyer.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpds.dao.BuyerMpDsOrderManageDao;

@Service("buyerMpDsOrderManageService")
public class BuyerMpDsOrderManageServiceImpl implements BuyerMpDsOrderManageService {
	
	@Autowired
	private BuyerMpDsOrderManageDao buyerMpDsOrderManageDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsOrderManageDao.selectList(formData);
	}	
	
	//부분입고	
	public String updateSelectedDataGrNextMonth(Map<String,String> formData, List<Object> gridData) {
		return buyerMpDsOrderManageDao.updateSelectedDataGrNextMonth(formData, gridData);
	}	
	
	// 입고취소
	public String updateSelectedDataGrCancelReg(Map<String,String> formData, List<Object> gridData) {
		return buyerMpDsOrderManageDao.updateSelectedDataGrCancelReg(formData, gridData);
	}	
	
	// 입고실적등록
	public String updateSelectedDataGrRegBuyer(Map<String,String> formData, List<Object> gridData) {
		return buyerMpDsOrderManageDao.updateSelectedDataGrRegBuyer(formData, gridData);
	}	

}
