package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoAccountSelPopDao")
@Transactional
public class BuyerMpSoAccountSelPopDaoImpl implements BuyerMpSoAccountSelPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoAccountSelPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectDeptSelect(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectDeptSelect", formData);
	}
	public List<Map<String,String>> selectAccountDivideList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectAccountDivideList", formData);
	}	
	
}
