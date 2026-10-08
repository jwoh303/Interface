package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoCategoryTotalViewPopDao")
@Transactional
public class BuyerMpSoCategoryTotalViewPopDaoImpl implements BuyerMpSoCategoryTotalViewPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 카테고리 합계보기 조회
	public List<Map<String,String>> getCategoryListSelectPop(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("common.mpso.getCategoryListSelectPop", formData);
	}
	
	// 예산조회
	public List<Map<String,String>> getBuyerAdminBudgetListSql(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("common.mpso.getBuyerAdminBudgetListSql", formData);
	}
	
}
