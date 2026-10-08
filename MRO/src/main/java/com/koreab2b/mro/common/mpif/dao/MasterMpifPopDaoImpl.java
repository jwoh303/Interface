package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpifPopDao")
@Transactional
public class MasterMpifPopDaoImpl implements MasterMpifPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpifPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectMasterMpifMessagePop(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectMasterMpifMessagePop", pMap);
	}
}