package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoPoMngHistPopDao")
@Transactional
public class MasterMpSoPoMngHistPopDaoImpl implements MasterMpSoPoMngHistPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPoMngHistPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> searchMasterMpSoPoMngHistList(Map<String,Object> param) {
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("common.mpso.selectMasterMpSoPoMngHistList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}


}
