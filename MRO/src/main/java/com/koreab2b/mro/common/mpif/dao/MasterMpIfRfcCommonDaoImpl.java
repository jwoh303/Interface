package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpIfRfcCommonDao")
@Transactional
public class MasterMpIfRfcCommonDaoImpl implements MasterMpIfRfcCommonDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfRfcCommonDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, String>> getRFCYPProperties(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("common.mpif.selectRfcYPProperties", pMap);
	}
}
