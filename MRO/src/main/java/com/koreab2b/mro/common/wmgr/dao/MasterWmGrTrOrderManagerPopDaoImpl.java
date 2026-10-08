package com.koreab2b.mro.common.wmgr.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrStockGrCreDaoImpl;
import com.koreab2b.mro.master.wmgr.dao.MasterWmGrTrGrCreDaoImpl;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmGrTrOrderManagerPopDao")
@Transactional
public class MasterWmGrTrOrderManagerPopDaoImpl implements MasterWmGrTrOrderManagerPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrTrGrCreDaoImpl.class);
	private String _rtnMsg = "";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("common.wmgr.selectMasterWmGrTrOrderManagerPopList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}
	
	// 조회
	public List<Map<String,String>> selectPop(Map<String,String> formData) {
		
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrTrOrderManagerPop", formData);
	}	
}
