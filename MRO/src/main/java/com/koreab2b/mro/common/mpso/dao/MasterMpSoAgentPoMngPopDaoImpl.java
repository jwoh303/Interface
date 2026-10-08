package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoAgentPoMngPopDao")
@Transactional
public class MasterMpSoAgentPoMngPopDaoImpl implements MasterMpSoAgentPoMngPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> selectAgentPoMngList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoAgentPoMngList", param);
	}
}
