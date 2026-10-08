package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmgr.dao.MasterWmGrIntervalsInfoPopDao;

@Service("masterWmGrIntervalsInfoPopService")
public class MasterWmGrIntervalsInfoPopServiceImpl implements MasterWmGrIntervalsInfoPopService {
	
	@Autowired
	private MasterWmGrIntervalsInfoPopDao masterWmGrIntervalsInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmGrIntervalsInfoPopDao.selectList(formData);
	}	
	

}
