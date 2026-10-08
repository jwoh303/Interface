package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoDelayDlvyStateDao")
@Transactional
public class BuyerMpSoDelayDlvyStateDaoImpl implements BuyerMpSoDelayDlvyStateDao { 

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회 getBuyerPrDelayListCSql
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoDelayDlvyStateList", formData);
	}
	
	// 저장 
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return null;
		
	}
	
}
