package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoNameCardInfoPopDao;

@Service("buyerMpSoNameCardInfoPopService")
public class BuyerMpSoNameCardInfoPopServiceImpl implements BuyerMpSoNameCardInfoPopService {
	
	@Autowired
	private BuyerMpSoNameCardInfoPopDao buyerMpSoNameCardInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoNameCardInfoPopDao.selectList(formData);
	}
	
	// 회원정보 조회
	public Map<String,String> getUserInfoList(Map<String,String> formData) {
		return buyerMpSoNameCardInfoPopDao.selectUserInfoList(formData);
	}
	
	// 명함 컬럼명 조회
	public Map<String,Object> getCardColumnInfoList(Map<String,Object> formData) {
		return buyerMpSoNameCardInfoPopDao.selectColumnInfoList(formData);
	}
	
	@Transactional
	public String saveBuyerMpSoCartRemarkNameCard(Map<String,String>  formData) {
		return buyerMpSoNameCardInfoPopDao.saveBuyerMpSoCartRemarkNameCard(formData);
	}
}
