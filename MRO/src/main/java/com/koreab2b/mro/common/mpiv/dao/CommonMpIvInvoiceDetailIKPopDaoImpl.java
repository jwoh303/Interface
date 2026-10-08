package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvInvoiceDetailIKPopDao")
@Transactional
public class CommonMpIvInvoiceDetailIKPopDaoImpl implements CommonMpIvInvoiceDetailIKPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Map<String,String> selectInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvInvoiceDetailIKPopInfo", formData);
	}
	public Map<String,String> selectInfo_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpiv.selectCommonMpIvInvoiceDetailIKPopInfo_v2", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvInvoiceDetailIKPopList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvInvoiceDetailIKPopList_v2", formData);
	}
	
}
