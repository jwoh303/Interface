package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmUserInfoDao;

@Service("buyerMdAmUserInfoService")
public class BuyerMdAmUserInfoServiceImpl implements BuyerMdAmUserInfoService {
	
	@Autowired
	private BuyerMdAmUserInfoDao buyerMdAmUserInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmUserInfoDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getApprovedList(Map<String,String> formData) {
		return buyerMdAmUserInfoDao.selectApprovedList(formData);
	}
		
	// 조회
	public List<Map<String,String>> getReferList(Map<String,String> formData) {
		return buyerMdAmUserInfoDao.selectReferList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getAgreeList(Map<String,String> formData) {
		return buyerMdAmUserInfoDao.selectAgreeList(formData);
	}
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return buyerMdAmUserInfoDao.selectPwdValidCheck(formData);
	}
		
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return buyerMdAmUserInfoDao.updateSelectedData(formData);
	}

}
