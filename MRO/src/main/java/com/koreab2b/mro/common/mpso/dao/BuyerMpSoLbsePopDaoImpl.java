package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoLbsePopDao")
@Transactional
public class BuyerMpSoLbsePopDaoImpl implements BuyerMpSoLbsePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String getLbseCostCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectLbseCost", formData);
	}
	
	public String getLbseAccountCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectLbseAccount", formData);
	}
}
