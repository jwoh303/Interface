package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpRqCatalogRegYnPopDao")
@Transactional
public class BuyerMpRqCatalogRegYnPopDaoImpl implements BuyerMpRqCatalogRegYnPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectBuyerMpRqCatalogRegYnPopList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mprq.selectBuyerMpRqCatalogRegYnPopList_v2", formData);
	}
	
}
