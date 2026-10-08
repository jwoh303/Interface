package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoCategoryTotalViewPopDao;

@Service("buyerMpSoCategoryTotalViewPopService")
public class BuyerMpSoCategoryTotalViewPopServiceImpl implements BuyerMpSoCategoryTotalViewPopService {
	
	@Autowired
	private BuyerMpSoCategoryTotalViewPopDao buyerMpSoCategoryTotalViewPopDao;

	// 카테고리 합계보기 조회
	public List<Map<String,String>> getCategoryListSelectPop(Map<String,String>  formData){
		return buyerMpSoCategoryTotalViewPopDao.getCategoryListSelectPop(formData);
	}	
	// 예산조회
	public List<Map<String,String>> getBuyerAdminBudgetListSql(Map<String,String>  formData) {
		return buyerMpSoCategoryTotalViewPopDao.getBuyerAdminBudgetListSql(formData);
	}

}
