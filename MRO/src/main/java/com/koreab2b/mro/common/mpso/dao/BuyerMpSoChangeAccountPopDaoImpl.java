package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoChangeAccountPopDao")
@Transactional
public class BuyerMpSoChangeAccountPopDaoImpl implements BuyerMpSoChangeAccountPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoChangeAccountPopList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectBuyerMpSoChangeAccountPopList_v2", formData);
	}
	
	// 저장
	public String saveBuyerMpSoChangeAccountPop(Map<String,String>  formData) {
		_rtnMsg = "OK";
		try {
			sqlSessionTemplate.insert("common.mpso.saveBuyerMpSoChangeAccountPop", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
}
