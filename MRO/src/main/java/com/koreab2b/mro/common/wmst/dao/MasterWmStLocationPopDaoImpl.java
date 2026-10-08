package com.koreab2b.mro.common.wmst.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmStLocationPopDao")
@Transactional
public class MasterWmStLocationPopDaoImpl implements MasterWmStLocationPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		
		List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("common.wmst.selectMasterWmStLocationPopList", formData,_resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}
	
}
