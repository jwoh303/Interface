package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoSolbPopDao")
@Transactional
public class BuyerMpSoSolbPopDaoImpl implements BuyerMpSoSolbPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String getSolbCostCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectSolbCost", formData);
	}
	
	public String getSolbAccountCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectSolbAccount", formData);
	}
	
	public String getSolbPlantCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectSolbPlant", formData);
	}	
}
