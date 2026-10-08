package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoUniformStockDao")
@Transactional
public class BuyerMpSoUniformStockDaoImpl implements BuyerMpSoUniformStockDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoUniformStockDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		
		resultList = sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoUniformStockList", param);
		
		return resultList;
	}
}
