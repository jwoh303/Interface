package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpVoVocDailySummaryDao")
@Transactional
public class MasterMpVoVocDailySummaryDaoImpl implements MasterMpVoVocDailySummaryDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectListWeek(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mpvo.selectMasterMpVoVocDailySummaryWeekList", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectListToday(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.mpvo.selectMasterMpVoVocDailySummaryTodayList", param);
	}

}
