package com.koreab2b.mro.seller.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mdam.dao.SellerMdAmUserInfoDao;

@Service("sellerMdAmUserInfoService")
public class SellerMdAmUserInfoServiceImpl implements SellerMdAmUserInfoService {
	
	@Autowired
	private SellerMdAmUserInfoDao sellerMdAmUserInfoDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMdAmUserInfoDao.selectList(formData);
	}	
	
	// 비밀번호 룰 조회
	public String getPwdValidCheck(Map<String,String> formData) {
		return sellerMdAmUserInfoDao.selectPwdValidCheck(formData);
	}
		
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return sellerMdAmUserInfoDao.updateSelectedData(formData);
	}
	
	// 비밀번호변경
	public String updateSellerMdAmUsePwd(Map<String,String> formData) {
		return sellerMdAmUserInfoDao.updateSellerMdAmUsePwd(formData);
	}

	// 비밀번호변경 v2 (현재 비밀번호와 동일 방지 검증 추가)
	public String updateSellerMdAmUsePwd_v2(Map<String,String> formData) {
		return sellerMdAmUserInfoDao.updateSellerMdAmUsePwd_v2(formData);
	}
}
