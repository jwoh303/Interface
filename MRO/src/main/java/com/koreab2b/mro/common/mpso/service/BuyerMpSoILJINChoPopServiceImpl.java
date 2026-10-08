package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoILJINChoPopDao;

@Service("buyerMpSoILJINChoPopService")
public class BuyerMpSoILJINChoPopServiceImpl implements BuyerMpSoILJINChoPopService {
	
	@Autowired
	private BuyerMpSoILJINChoPopDao buyerMpSoILJINChoPopDao;

	// 조회 
	public List<Map<String,String>> getLegacyUserId(Map<String,String>  formData){
		return buyerMpSoILJINChoPopDao.selectLegacyUserIdList(formData);
	}

	public List<Map<String,String>> getIljinProject(Map<String,String>  pMap){
		return buyerMpSoILJINChoPopDao.selectIljinProject(pMap);
	}
	
	@Override
	public Map<String, String> getILJINItemInfo(Map<String, String> pMap) {
		return buyerMpSoILJINChoPopDao.selectItemItemInfo(pMap);
	}
}
