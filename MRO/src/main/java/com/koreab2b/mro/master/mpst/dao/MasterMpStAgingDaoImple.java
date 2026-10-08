package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("masterMpStAgingDao")
public class MasterMpStAgingDaoImple implements MasterMpStAgingDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpStAgingDaoImple.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> getAgingList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectAgingList", pMap);
	}

	@Override
	public List<Map<String, String>> getAgingDetail(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectAgingDetail", pMap);
	}

	@Override
	public List<Map<String, String>> getAgingItemMaster(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectAgingItemMaster", pMap);
	}

}
