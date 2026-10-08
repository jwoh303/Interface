package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmAdminAgentSearchDao;

@Service("buyerMdAmAdminAgentSearchService")
public class BuyerMdAmAdminAgentSearchServiceImpl implements BuyerMdAmAdminAgentSearchService {
	
	@Autowired
	private BuyerMdAmAdminAgentSearchDao buyerMdAmAdminAgentSearchDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMdAmAdminAgentSearchDao.selectList(formData);
	}	
	public List<Map<String,String>> getNewAgentList(Map<String,String> formData) {
		return buyerMdAmAdminAgentSearchDao.selectNewAgentList(formData);
	}
	public List<Map<String,String>> getExcelList(Map<String,String> formData) {
		return buyerMdAmAdminAgentSearchDao.selectExcelList(formData);
	}	
	public List<Map<String,String>> getAgentInfo(Map<String,String> formData) {
		return buyerMdAmAdminAgentSearchDao.selectAgentInfo(formData);
	}
	public List<Map<String,String>> getAgentPoInfo(Map<String,String> formData) {
		return buyerMdAmAdminAgentSearchDao.selectAgentPoInfo(formData);
	}
	public List<Map<String,String>> getAgentDlvryInfo(Map<String,String> formData) {
		return buyerMdAmAdminAgentSearchDao.selectAgentDlvryInfo(formData);
	}
}
