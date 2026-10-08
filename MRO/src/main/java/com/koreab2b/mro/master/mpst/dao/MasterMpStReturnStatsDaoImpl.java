package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("masterMpStReturnStatsDao")
public class MasterMpStReturnStatsDaoImpl implements MasterMpStReturnStatsDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpStReturnStatsDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 반품통계 전체 조회
	public List<Map<String, String>> getReturnStatsList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectReturnStatsList", pMap);
	}
	
	// 반품통계 고객사 조회
	public List<Map<String, String>> getReturnStatsBuyerList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectReturnStatsBuyerList", pMap);
	}
	
	// 반품통계 협력사 조회
	public List<Map<String, String>> getReturnStatsAgentList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectReturnStatsAgentList", pMap);
	}
}
