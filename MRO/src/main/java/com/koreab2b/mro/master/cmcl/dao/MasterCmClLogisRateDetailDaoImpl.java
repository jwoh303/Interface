package com.koreab2b.mro.master.cmcl.dao;


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

@Repository("masterCmClLogisRateDetailDao")
@Transactional
public class MasterCmClLogisRateDetailDaoImpl implements MasterCmClLogisRateDetailDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClLogisRateDetailDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked") 
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();		
		sqlSessionTemplate.select("master.cmcl.selectMasterLogisRateDetailList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	@SuppressWarnings("unchecked") 
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();		
		sqlSessionTemplate.select("master.cmcl.selectMasterLogisRateDetailList_v2", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	
}
