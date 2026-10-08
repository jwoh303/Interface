package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvDeadlineDelayForecastBuyerChoicePopDao;

@Service("masterMpIvDeadlineDelayForecastBuyerChoicePopService")
public class MasterMpIvDeadlineDelayForecastBuyerChoicePopServiceImpl implements MasterMpIvDeadlineDelayForecastBuyerChoicePopService {
	
	@Autowired
	private MasterMpIvDeadlineDelayForecastBuyerChoicePopDao masterMpIvDeadlineDelayForecastBuyerChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvDeadlineDelayForecastBuyerChoicePopDao.selectList(formData);
	}	
	

}
