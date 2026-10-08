package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSohahomePopDao")
@Transactional
public class BuyerMpSohahomePopDaoImpl implements BuyerMpSohahomePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String gethahomeCostCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selecthahomeCost", formData);
	}
	
	public String gethahomeAccountCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selecthahomeAccount", formData);
	}
}
