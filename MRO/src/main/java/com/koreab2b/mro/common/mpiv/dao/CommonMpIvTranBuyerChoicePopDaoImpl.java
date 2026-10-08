package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonMpIvTranBuyerChoicePopDao")
@Transactional
public class CommonMpIvTranBuyerChoicePopDaoImpl implements CommonMpIvTranBuyerChoicePopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvTranBuyerChoicePopList", pMap);
	}
	public List<Map<String,String>> getCommonMpIvTranBuyerChoicePopList(Map<String,Object> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvTranBuyerChoicePopList", pMap);
	}
	
	// 조회
	public List<Map<String,String>> selecBptList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectCommonMpIvBpTranBuyerChoicePopList", pMap);
	}	
}
