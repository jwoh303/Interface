package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("MasterMpStPerformanceDao")
@Transactional
public class MasterMpStPerformanceDaoImpl implements MasterMpStPerformanceDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, String>> masterPerformanceList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.masterPerformanceList", pMap);
	}

	@Override
	public List<Map<String, String>> getAllDeptList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.getAllDeptList", pMap);
	}

}
