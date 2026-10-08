package com.koreab2b.mro.master.mpsm.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSmClosingStatsDao")
@Transactional
public class MasterMpSmClosingStatsDaoImpl implements MasterMpSmClosingStatsDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectClosingStatsList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpsm.selectClosingStatsList", param);
	}
	
	// 차트용 리스트 조회
	public List<Map<String,String>> selectClosingStatsList1(Map<String,Object> param) {
		// 항상 백만원 단위로 표시
		param.put("st_money_unit", "1000000");
		
		return sqlSessionTemplate.selectList("master.mpsm.selectClosingStatsList1", param);
	}
}
