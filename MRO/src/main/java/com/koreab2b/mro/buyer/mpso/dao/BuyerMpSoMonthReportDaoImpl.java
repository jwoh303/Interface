package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoMonthReportDao")
@Transactional
public class BuyerMpSoMonthReportDaoImpl implements BuyerMpSoMonthReportDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoMonthReportList", param);
	}
}
