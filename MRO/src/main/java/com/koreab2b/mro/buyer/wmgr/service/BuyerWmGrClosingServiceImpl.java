package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.wmgr.dao.BuyerWmGrClosingDao;

@Service("buyerWmGrClosingService")
public class BuyerWmGrClosingServiceImpl implements BuyerWmGrClosingService {
	
	@Autowired
	private BuyerWmGrClosingDao buyerWmGrClosingDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerWmGrClosingDao.selectList(formData);
	}
	public List<Map<String,String>> getList_v2(Map<String,Object> formData) {
		return buyerWmGrClosingDao.selectList_v2(formData);
	}

	// [v2] AR 요약 목록
	public List<Map<String,String>> getArSummaryList(Map<String,String> formData) {
		return buyerWmGrClosingDao.selectArSummaryList(formData);
	}

	// [v2] AR 상세 내역 (팝업)
	public List<Map<String,String>> getArDetailList(Map<String,String> formData) {
		return buyerWmGrClosingDao.selectArDetailList(formData);
	}

	// [v2] AR 헤더 정보 (팝업 상단)
	public Map<String,String> getArHeaderInfo(Map<String,String> formData) {
		return buyerWmGrClosingDao.selectArHeaderInfo(formData);
	}

}
