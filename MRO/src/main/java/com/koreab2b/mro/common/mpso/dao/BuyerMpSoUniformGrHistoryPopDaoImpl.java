package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoUniformGrHistoryPopDao")
@Transactional
public class BuyerMpSoUniformGrHistoryPopDaoImpl implements BuyerMpSoUniformGrHistoryPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoUniformGrHistoryPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectHdList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoUniformGrHistoryPopHdList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectDtList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoUniformGrHistoryPopDtList", formData);
	}
}
