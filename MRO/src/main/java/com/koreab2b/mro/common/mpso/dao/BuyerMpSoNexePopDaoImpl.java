package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoNexePopDao")
@Transactional
public class BuyerMpSoNexePopDaoImpl implements BuyerMpSoNexePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoNexePopList", formData);
	}

	@Override
	public List<Map<String, String>> getRefNoList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoNexeRefNoList", formData);
	}	
	
}
