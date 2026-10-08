package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmPromotionMarketCatalogSelPopDao;

@Service("masterMdCmPromotionMarketCatalogSelPopService")
public class MasterMdCmPromotionMarketCatalogSelPopServiceImpl implements MasterMdCmPromotionMarketCatalogSelPopService {
	
	@Autowired
	private MasterMdCmPromotionMarketCatalogSelPopDao masterMdCmPromotionMarketCatalogSelPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getCategorySelPop(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getSgInfo(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getSgInfo(formData);
	}
	// 조회
	public List<Map<String,String>> getCategInfo(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getCategInfo(formData);
	}
	// 고객사예외 조회
	public List<Map<String,String>> getBuyerSgInfo(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getBuyerSgInfo(formData);
	}
	// 조회
	public List<Map<String,String>> getNewUserInfo(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getNewUserInfo(formData);
	}
	// 주문불가능자리스트조회
	public List<Map<String,String>> getOrderUserInfo(Map<String,String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getOrderUserInfo(formData);
	}

	// SMART팀 SG담당자 조회
	public Map<String, String> getSmartSgInfo(Map<String, String> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getSmartSgInfo(formData);
	}

	// SMART팀 SG담당자 조회(ID리스트)
	public List<String> getSmartSgIdInfo(Map<String, Object> formData) {
		return masterMdCmPromotionMarketCatalogSelPopDao.getSmartSgIdInfo(formData);
	}
}
