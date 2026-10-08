package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoLotteFoodPopDao")
@Transactional
public class BuyerMpSoLotteFoodPopDaoImpl implements BuyerMpSoLotteFoodPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public String  selectDeptName(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectDeptName", formData);
	}
	public String  selectAccountName(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectAccountName", formData);
	}
}
