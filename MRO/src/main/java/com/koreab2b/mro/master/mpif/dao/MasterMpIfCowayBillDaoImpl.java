package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpIfCowayBillDao")
@Transactional
public class MasterMpIfCowayBillDaoImpl implements MasterMpIfCowayBillDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfCowayBillDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectMasterMpIfCowayBillList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfCowayBillList", pMap);
	}

}
