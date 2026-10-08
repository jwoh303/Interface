package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("masterMpStAgingGrDao")
public class MasterMpStAgingGrDaoImpl implements MasterMpStAgingGrDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpStAgingGrDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 재고에이징(입고) 조회
	@Override
	public List<Map<String, String>> getAgingGrList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectAgingGrList", pMap);
	}
	
	// 장기재고 증감현황 조회
	@Override
	public List<Map<String, String>> getLongTermStckIncrList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectLongTermStckIncrList", pMap);
	}
	
	// 재고에이징(입고) 상세 조회
	@Override
	public List<Map<String, String>> getAgingGrDtList(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpst.selectAgingGrDtList", pMap);
	}
}
