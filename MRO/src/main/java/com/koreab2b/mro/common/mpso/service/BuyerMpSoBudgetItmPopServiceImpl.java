package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoBudgetItmPopDao;

@Service("buyerMpSoBudgetItmPopService")
public class BuyerMpSoBudgetItmPopServiceImpl implements BuyerMpSoBudgetItmPopService {
	
	@Autowired
	private BuyerMpSoBudgetItmPopDao buyerMpSoBudgetItmPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoBudgetItmPopDao.selectList(formData);
	}	
	

}
