package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoKleannaraPopDao")
@Transactional
public class BuyerMpSoKleannaraPopDaoImpl implements BuyerMpSoKleannaraPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String getKleannaraCostCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectKleannaraCost", formData);
	}
	
	public String getKleannaraAccountCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("common.mpso.selectKleannaraAccount", formData);
	}
}
