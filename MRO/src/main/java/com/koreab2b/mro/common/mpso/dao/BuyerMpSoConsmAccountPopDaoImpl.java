package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoConsmAccountPopDao")
@Transactional
public class BuyerMpSoConsmAccountPopDaoImpl implements BuyerMpSoConsmAccountPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoConsmAccountPopList", formData);
	}
	
}
