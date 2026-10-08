package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpst.dao.BuyerMpStGiReleaseDirectionsDao;

@Service("buyerMpStGiReleaseDirectionsService")
public class BuyerMpStGiReleaseDirectionsServiceImpl implements BuyerMpStGiReleaseDirectionsService {

	@Autowired
	private BuyerMpStGiReleaseDirectionsDao buyerMpStGiReleaseDirectionsDao;
	
	@Transactional
	public List<Map<String, String>> getBuyerMpStGiReleaseDirectionsList(Map<String, Object> pParam) {
		return buyerMpStGiReleaseDirectionsDao.selectList(pParam);
	}

	@Transactional
	public String updateSelectedGiData(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		return buyerMpStGiReleaseDirectionsDao.updateSelectedGiData(pFormData, pGridData);
	}

	@Transactional
	public String updateSelectedGiCancelData(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		return buyerMpStGiReleaseDirectionsDao.updateSelectedGiCancelData(pFormData, pGridData);
	}

	@Transactional
	public String updateSelectedGiCompleteData(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		return buyerMpStGiReleaseDirectionsDao.updateSelectedGiCompleteData(pFormData, pGridData);
	}
	
}
