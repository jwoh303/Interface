package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdAmAdminAgentSearchDao")
@Transactional
public class BuyerMdAmAdminAgentSearchDaoImpl implements BuyerMdAmAdminAgentSearchDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmAdminAgentSearchList", formData);
	}
	// 신규협력사조회
	public List<Map<String,String>> selectNewAgentList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmAdminNewAgentSearchList", formData);
	}	
	// 엑셀다운
	public List<Map<String,String>> selectExcelList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmAdminAgentSearchExcel", formData);
	}
	//협력사정보조회
	public List<Map<String,String>> selectAgentInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmAgentInfo", formData);
	}
	//발주조회
	public List<Map<String,String>> selectAgentPoInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmAgentPoInfo", formData);
	}
	//납품서정보조회
	public List<Map<String,String>> selectAgentDlvryInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmAgentDlvryInfo", formData);
	}
}
