package com.koreab2b.mro.master.mdsr.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdSrSrDetailMainDao")
@Transactional
public class MasterMdSrSrDetailMainDaoImpl implements MasterMdSrSrDetailMainDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrDetailMainDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,String>  param) {
		return sqlSessionTemplate.selectList("master.mdsr.selectMasterMdSrSrDetailMainList", param);
	}

}
