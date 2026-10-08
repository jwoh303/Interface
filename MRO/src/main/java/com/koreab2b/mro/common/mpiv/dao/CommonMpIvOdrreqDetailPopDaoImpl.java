package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvOdrreqDetailPopDao")
@Transactional
public class CommonMpIvOdrreqDetailPopDaoImpl implements CommonMpIvOdrreqDetailPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvOdrreqDetailPopList", formData);
	}
	public List<Map<String,String>> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvOdrreqDetailPopList_v2", formData);
	}
	public List<Map<String,String>> selectBuyerPrDisplayDtListPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.getBuyerPrDisplayDtListPop", formData);
	}
	public List<Map<String,String>> getBuyerPrDisplayDtListPop_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpiv.getBuyerPrDisplayDtListPop_v2", formData);
	}
}
