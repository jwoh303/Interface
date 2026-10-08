package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStReleaseDirectionsDao;

@Service("buyerMpStReleaseDirectionsService")
public class BuyerMpStReleaseDirectionsServiceImpl implements BuyerMpStReleaseDirectionsService {
	
	@Autowired
	private BuyerMpStReleaseDirectionsDao buyerMpStReleaseDirectionsDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpStReleaseDirectionsDao.selectList(formData);
	}	
	
	// 사용자 조회
	public List<Map<String,String>> getUserList(Map<String,String> formData) {
		return buyerMpStReleaseDirectionsDao.selectUserList(formData);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return buyerMpStReleaseDirectionsDao.updateSelectedData(formData, gridData);
	}	

}
