package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpStBuyerResultDao")
@Transactional
public class MasterMpStBuyerResultDaoImpl implements MasterMpStBuyerResultDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpStBuyerResultDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStBuyerResultList", param);
	}
	// 고객사 SG별 실적조회
	public List<Map<String,String>> selectBuyerSgList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStBuyerSgResultList", param);
	}
	// 협력사 SG별 실적조회
	public List<Map<String,String>> selectAgentSgList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpst.selectMasterMpStAgentSgResultList", param);
	}

	
}
