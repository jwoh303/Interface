package com.koreab2b.mro.common.wmst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmStDailyReleaseListPopDao")
@Transactional
public class MasterWmStDailyReleaseListPopDaoImpl implements MasterWmStDailyReleaseListPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		
		
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("common.wmst.selectMasterWmStDailyReleaseListPopList", formData,_resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getExcelList(Map<String,Object> formData) {
		
		
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("common.wmst.selectExcelMasterWmStDailyReleaseListPopList", formData,_resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}
	
}
