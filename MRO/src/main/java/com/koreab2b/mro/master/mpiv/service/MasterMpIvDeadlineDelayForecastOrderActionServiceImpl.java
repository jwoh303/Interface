package com.koreab2b.mro.master.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpiv.dao.MasterMpIvDeadlineDelayForecastOrderActionDao;

@Service("masterMpIvDeadlineDelayForecastOrderActionService")
public class MasterMpIvDeadlineDelayForecastOrderActionServiceImpl implements MasterMpIvDeadlineDelayForecastOrderActionService {
	
	@Autowired
	private MasterMpIvDeadlineDelayForecastOrderActionDao masterMpIvDeadlineDelayForecastOrderActionDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIvDeadlineDelayForecastOrderActionDao.selectList(param);
	}	

}
