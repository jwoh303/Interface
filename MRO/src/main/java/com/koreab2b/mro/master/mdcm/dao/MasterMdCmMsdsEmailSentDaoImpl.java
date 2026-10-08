package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmMsdsEmailSentDao")
@Transactional
public class MasterMdCmMsdsEmailSentDaoImpl implements MasterMdCmMsdsEmailSentDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList = sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmMsdsEmailSentList", param);
		
		return resultList;
	}
}
