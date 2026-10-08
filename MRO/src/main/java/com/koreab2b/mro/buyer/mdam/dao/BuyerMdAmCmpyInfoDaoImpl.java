package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdAmCmpyInfoDao")
@Transactional
public class BuyerMdAmCmpyInfoDaoImpl implements BuyerMdAmCmpyInfoDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmCmpyInfoList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectPassList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmCmpyInfoIcogPass", formData);
	}
}
