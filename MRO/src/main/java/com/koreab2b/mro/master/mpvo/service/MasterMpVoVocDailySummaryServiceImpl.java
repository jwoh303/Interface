package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoVocDailySummaryDao;

@Service("masterMpVoVocDailySummaryService")
public class MasterMpVoVocDailySummaryServiceImpl implements MasterMpVoVocDailySummaryService {
	
	@Autowired
	private MasterMpVoVocDailySummaryDao masterMpVoVocDailySummaryDao;

	// 리스트 조회
	public List<Map<String,String>> selectListWeek(Map<String,String> param) {
		return masterMpVoVocDailySummaryDao.selectListWeek(param);
	}	
	
	// 리스트 조회
	public List<Map<String,String>> selectListToday(Map<String,String> param) {
		return masterMpVoVocDailySummaryDao.selectListToday(param);
	}	

}
