package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvDeadlineDelayForecastManagePopDao;

@Service("masterMpIvDeadlineDelayForecastManagePopService")
public class MasterMpIvDeadlineDelayForecastManagePopServiceImpl implements MasterMpIvDeadlineDelayForecastManagePopService {
	
	@Autowired
	private MasterMpIvDeadlineDelayForecastManagePopDao masterMpIvDeadlineDelayForecastManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvDeadlineDelayForecastManagePopDao.selectList(formData);
	}	
	

}
