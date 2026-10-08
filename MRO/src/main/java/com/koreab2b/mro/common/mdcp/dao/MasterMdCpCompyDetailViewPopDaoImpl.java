package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCpCompyDetailViewPopDao")
@Transactional
public class MasterMdCpCompyDetailViewPopDaoImpl implements MasterMdCpCompyDetailViewPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectUserList(Map<String,String> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("common.mdcp.selectMasterMdCpCompanyUserPopList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
	// 조회
	public List<Map<String,String>> selectCompyList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpCompanyDetailViewPopList", formData);
	}

}
