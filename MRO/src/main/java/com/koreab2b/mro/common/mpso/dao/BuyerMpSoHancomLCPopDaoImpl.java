package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoHancomLCPopDao")
@Transactional
public class BuyerMpSoHancomLCPopDaoImpl implements BuyerMpSoHancomLCPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String selectText1(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectCOD2Text1", formData);
	}
	
	public String selectAccountText1(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectAccountName", formData);
	}
}
