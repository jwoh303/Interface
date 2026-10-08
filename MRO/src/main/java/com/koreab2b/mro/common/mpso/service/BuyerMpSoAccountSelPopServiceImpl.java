package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoAccountSelPopDao;

@Service("buyerMpSoAccountSelPopService")
public class BuyerMpSoAccountSelPopServiceImpl implements BuyerMpSoAccountSelPopService {
	
	@Autowired
	private BuyerMpSoAccountSelPopDao buyerMpSoAccountSelPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoAccountSelPopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getDeptSelect(Map<String,String> formData) {
		return buyerMpSoAccountSelPopDao.selectDeptSelect(formData);
	}	
	public List<Map<String,String>> getAccountDivideList(Map<String,String> formData) {
		return buyerMpSoAccountSelPopDao.selectAccountDivideList(formData);
	}	
}
