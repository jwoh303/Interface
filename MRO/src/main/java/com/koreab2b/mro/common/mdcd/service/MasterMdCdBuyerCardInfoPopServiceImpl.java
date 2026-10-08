package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcd.dao.MasterMdCdBuyerCardInfoPopDao;

@Service("masterMdCdBuyerCardInfoPopService")
public class MasterMdCdBuyerCardInfoPopServiceImpl implements MasterMdCdBuyerCardInfoPopService {
	
	@Autowired
	private MasterMdCdBuyerCardInfoPopDao masterMdCdBuyerCardInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCdBuyerCardInfoPopDao.selectList(formData);
	}
	
	// 거래금액 조회
	public List<Map<String,String>> getAcountList(Map<String,String> formData) {
		return masterMdCdBuyerCardInfoPopDao.selectAcountList(formData);
	}
	
	// 거래금액 조회
	public List<Map<String,String>> getVisitList(Map<String, Object> formData) {
		return masterMdCdBuyerCardInfoPopDao.selectVisitList(formData);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdCdBuyerCardInfoPopDao.updateSelectedData(formData);
	}
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCdBuyerCardInfoPopDao.deleteSelectedData(formData, gridData);
	}
}
