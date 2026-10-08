package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCmContractSelPopDao")
@Transactional
public class MasterMdCmContractSelPopDaoImpl implements MasterMdCmContractSelPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getMasterMdCmContractSelPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmContractSelPopList", formData);
	}

}
