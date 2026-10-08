package com.koreab2b.mro.master.clmg.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterClMgCreditCmpyPopDao")
@Transactional
public class MasterClMgCreditCmpyPopDaoImpl implements MasterClMgCreditCmpyPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterClMgCreditCmpyPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.clmg.selectMasterClMgCreditCmpyPop", param);
	}

}
