package com.koreab2b.mro.master.mpif.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpifExternDao")
@Transactional
public class MasterMpifExternDaoImpl implements MasterMpifExternDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpifExternDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public java.util.List<Map<String, String>> selectBuyerIfDbInfo(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectBuyerIfDbInfo", pMap);
	}
}
