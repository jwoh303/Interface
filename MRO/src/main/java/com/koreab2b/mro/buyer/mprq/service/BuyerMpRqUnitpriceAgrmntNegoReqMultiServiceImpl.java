package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqUnitpriceAgrmntNegoReqMultiDao;

@Service("buyerMpRqUnitpriceAgrmntNegoReqMultiService")
public class BuyerMpRqUnitpriceAgrmntNegoReqMultiServiceImpl implements BuyerMpRqUnitpriceAgrmntNegoReqMultiService {
	
	@Autowired
	private BuyerMpRqUnitpriceAgrmntNegoReqMultiDao buyerMpRqUnitpriceAgrmntNegoReqMultiDao;

	// 조회
	public List<Map<String,String>> getListMulti(Map<String,String> formData) {
		return buyerMpRqUnitpriceAgrmntNegoReqMultiDao.selectListMulti(formData);
	}
	public List<Map<String,String>> getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(Map<String,Object> formData) {
		return buyerMpRqUnitpriceAgrmntNegoReqMultiDao.getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(formData);
	}
	
	// 저장
	public String updateSelectedDataMulti(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqMultiDao.updateSelectedDataMulti(formData, gridData);
	}	
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntMulti(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqMultiDao.saveBuyerMpRqUnitpriceAgrmntMulti(formData, gridData);
	}	
	// 견적종료
	public Map<String,String> saveBuyerMpRqCloseRemarkMulti(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqMultiDao.saveBuyerMpRqCloseRemarkMulti(formData, gridData);
	}	
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPassMulti(Map<String,String> formData, List<Object> gridData) {
		return buyerMpRqUnitpriceAgrmntNegoReqMultiDao.saveBuyerMpRqUnitpriceAgrmntNonPassMulti(formData, gridData);
	}	

}
